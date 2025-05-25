# --- MCP Orchestrator ---


import time
import traceback
import asyncio
import requests
import re

class MCPTerraformOrchestrator:
    def __init__(self, md_file, output_dir, max_iterations=5):
        self.md_file = md_file
        self.output_dir = output_dir
        self.max_iterations = max_iterations
        self.resource_agent = ResourceExtractionAgent()
        self.module_agent = ModuleDiscoveryAgent()
        self.code_agent = TerraformCodeGenerationAgent()
        self.validate_agent = ValidationAgent()
        self.tfvars_agent = TFVarsGeneratorAgent()


    async def run(self):
        import shutil, tempfile
        resources = self.resource_agent.extract(self.md_file)
        iteration = 0
        if not hasattr(self, '_clonedir'):
            self._clonedir = tempfile.mkdtemp(prefix='avm_mods_')
        tfvars_obj = {}
        module_vars_meta = {}

        # --- Clone all modules only once before iterations ---
        module_clone_paths = {}
        for res in resources:
            module = self.module_agent.find_module(res)
            if not module:
                print(f"No AVM module found for resource: {res}")
                continue
            repo_url = module.get('source', '').strip()
            if not repo_url or not repo_url.startswith('http'):
                print(f"No valid source repo for {res}, skipping git clone.")
                module_clone_paths[res] = None
            else:
                mod_name = module['name'].replace('/', '_')
                local_path = os.path.join(self._clonedir, mod_name)
                module_clone_paths[res] = local_path
                if not os.path.exists(local_path):
                    print(f"Started clone {mod_name} in directory {local_path}")
                    try:
                        subprocess.run(
                            ['git', 'clone', '--quiet', '--depth', '1', repo_url, local_path],
                            check=True,
                            stdout=subprocess.DEVNULL,
                            stderr=subprocess.DEVNULL
                        )
                    except Exception as e:
                        print(f"Failed to clone {repo_url}: {e}")
                        module_clone_paths[res] = None

        # --- End of one-time clone ---

        # --- Extract variables meta for all modules only once ---
        for res in resources:
            module = self.module_agent.find_module(res)
            if not module:
                continue
            local_path = module_clone_paths.get(res)
            if local_path and os.path.exists(local_path):
                variables_meta = self.code_agent.extract_variables_meta_from_source(local_path)
            else:
                variables_meta = await self.code_agent.extract_variables_meta(module)
            tfvars_obj[res] = variables_meta
            module_vars_meta[res] = variables_meta
        # --- End of one-time variable extraction ---

        while iteration < self.max_iterations:
            if not os.path.exists(self.output_dir):
                os.makedirs(self.output_dir, exist_ok=True)
            print(f"\n--- MCP Iteration {iteration+1} ---")
            tf_code = ''
            # No need to clear tfvars_obj/module_vars_meta, as they are static per run

            for res in resources:
                module = self.module_agent.find_module(res)
                if not module:
                    continue
                variables_meta = module_vars_meta[res]
                code = self.code_agent.generate(module, res, variables_meta)
                tf_code += code + '\n'

            main_tf_path = os.path.join(self.output_dir, 'main.tf')
            with open(main_tf_path, 'w') as f:
                f.write(tf_code)

            variables_tf_path = os.path.join(self.output_dir, 'variables.tf')
            with open(variables_tf_path, 'w') as f:
                for res, vars_meta in module_vars_meta.items():
                    module = self.module_agent.find_module(res)
                    mod_name = module['name'].replace('/', '_') if module and 'name' in module else res
                    local_path = module_clone_paths.get(res)
                    variables_tf_content = None
                    if local_path and os.path.exists(local_path):
                        tf_files = []
                        for fname in ['variables.tf', 'main.tf', 'inputs.tf']:
                            fpath = os.path.join(local_path, fname)
                            if os.path.exists(fpath):
                                with open(fpath, 'r') as tf_f:
                                    tf_files.append(tf_f.read())
                        module_code = '\n'.join(tf_files)
                        if module_code.strip():
                            prompt = f'''
You are an expert Terraform developer. Given the following Terraform module source code:
---
{module_code}
---
Generate a valid variables.tf file for this module, using correct HCL syntax, types, and default values. Ensure all variables are defined with the correct type and default (if any), and use optional() where appropriate. Output only the variables.tf file content.
'''
                            try:
                                result = await self.code_agent.kernel.invoke(prompt)
                                if hasattr(result, 'content'):
                                    variables_tf_content = result.content
                                else:
                                    variables_tf_content = result
                            except Exception as e:
                                print(f"AI variables.tf generation failed for {res}: {e}")
                                traceback.print_exc()
                    if variables_tf_content and isinstance(variables_tf_content, str) and variables_tf_content.strip():
                        f.write(variables_tf_content.strip() + '\n')
                    else:
                        f.write(f'# [WARNING] AI could not generate variables.tf for {res}. Please review manually.\n')

            outputs_tf_path = os.path.join(self.output_dir, 'outputs.tf')
            with open(outputs_tf_path, 'w') as f:
                for res in resources:
                    module = self.module_agent.find_module(res)
                    mod_name = module['name'].replace('/', '_') if module and 'name' in module else res
                    local_path = module_clone_paths.get(res)
                    output_blocks = None
                    if local_path and os.path.exists(local_path):
                        import glob
                        tf_files = []
                        for fname in glob.glob(os.path.join(local_path, '**', '*.tf'), recursive=True):
                            try:
                                with open(fname, 'r') as tf_f:
                                    tf_files.append(tf_f.read())
                            except Exception:
                                continue
                        module_code = '\n'.join(tf_files)
                        if module_code.strip():
                            prompt = f'''
You are an expert Terraform developer. Given the following Terraform module source code:
---
{module_code}
---
Extract all output blocks from this module. For each output, rewrite it so that the value references the output from the module block in the root module, assuming the module is named \"{res}\". For example, if the module output is \"foo\", generate:
output \"{res}_foo\" {{
  value = module.{res}.foo
}}
Output only the outputs.tf file content, with all outputs found in the module.
'''
                            try:
                                result = await self.code_agent.kernel.invoke(prompt)
                                if hasattr(result, 'content'):
                                    output_blocks = result.content
                                else:
                                    output_blocks = result
                            except Exception as e:
                                print(f"AI outputs.tf generation failed for {res}: {e}")
                                traceback.print_exc()
                    if output_blocks and isinstance(output_blocks, str) and output_blocks.strip():
                        f.write(output_blocks.strip() + '\n')
                    else:
                        f.write(f'# [WARNING] AI could not generate outputs for {res}. Please review manually.\n')

            providers_tf_path = os.path.join(self.output_dir, 'providers.tf')
            with open(providers_tf_path, 'w') as f:
                f.write('terraform {\n  required_providers {\n    azurerm = {\n      source = "hashicorp/azurerm"\n      version = ">= 3.0.0"\n    }\n  }\n}\n\nprovider "azurerm" {\n  features {}\n}\n')

            tfvars_path = os.path.join(self.output_dir, 'terraform.tfvars')
            with open(tfvars_path, 'w') as f:
                for res, vars_meta in module_vars_meta.items():
                    f.write(f'{res}_vars = {{\n')
                    for var in vars_meta:
                        if isinstance(var, dict) and var.get("default") is not None:
                            continue
                        if isinstance(var, dict):
                            f.write(f'  {var["name"]} = "<value>"\n')
                        else:
                            f.write(f'  {var} = "<value>"\n')
                    f.write('}\n')

            valid, error_output = self.validate_agent.validate_with_errors(self.output_dir)
            if valid:
                print("Terraform code is valid.\n")
                return True
            else:
                print("Terraform code is not valid. Attempting to fix errors using AI...")
                await self._fix_code_with_errors(error_output, main_tf_path, variables_tf_path)
                time.sleep(1)
            iteration += 1
        print("Max iterations reached. Please review errors manually.")
        return False

    async def _fix_code_with_errors(self, error_output, main_tf_path, variables_tf_path):
        for tf_file in [main_tf_path, variables_tf_path]:
            with open(tf_file, 'r') as f:
                code = f.read()
            prompt = f'''
You are an expert Terraform developer. The following Terraform code has validation errors:
---
{code}
---
The error message from 'terraform validate' is:
{error_output}
Suggest a corrected version of the code, fixing the errors. Return only the corrected code.
'''
            try:
                result = await self.code_agent.kernel.invoke(prompt)
                # Handle both string and object responses
                if hasattr(result, 'content'):
                    result_text = result.content
                else:
                    result_text = result
                if result_text and isinstance(result_text, str) and len(result_text.strip()) > 0:
                    with open(tf_file, 'w') as f:
                        f.write(result_text.strip())
            except Exception as e:
                print(f"AI code fix failed for {tf_file}: {e}")

# Multi-Agent Terraform Code Generator for Azure using AVM Modules
# Skeleton for Semantic Kernel integration
import os
import re
import subprocess
import semantic_kernel as sk
from semantic_kernel.connectors.ai.open_ai import AzureChatCompletion
from dotenv import load_dotenv
load_dotenv()
from typing import List, Dict, Any

# --- Agent Definitions ---

class ResourceExtractionAgent:
    """Extracts Azure resources from a Markdown file."""
    def extract(self, md_path: str) -> List[str]:
        resources = []
        with open(md_path, 'r') as f:
            for line in f:
                match = re.match(r'- ([a-zA-Z0-9_\-]+)', line.strip())
                if match:
                    resources.append(match.group(1))
        return resources

class AVMModuleCatalogFetcher:
    """
        try:
            resp = requests.get(url, timeout=30)
            resp.raise_for_status()
            logging.info(f"Fetched {url} ({len(resp.content)//1024} KB)")
            return resp.text
        except requests.exceptions.RequestException as e:
            logging.error(f"Failed to fetch {url}: {e}")
            return ""

    @staticmethod
    def fetch_html(url: str) -> str:
        try:
            resp = requests.get(url, timeout=30)
            resp.raise_for_status()
            print(f"Fetched {url} ({len(resp.content)//1024} KB)")
            return resp.text
        except Exception as e:
            print(f"Error fetching {url}: {e}")
            return ""

    @classmethod
    def get_terraform_modules(cls) -> dict:
        html = cls.fetch_html(cls.TERRAFORM_URL)
        rows = html.split('<tr')
        modules = {}
        for row in rows:
            if '<td style=text-align:right>' not in row or '<a href=' not in row:
                continue
            url_match = re.search(r'<a\s+href=([^>]+)>([^<]+)</a>', row)
            if not url_match:
                continue
            registry_url = url_match.group(1)
            module_name = url_match.group(2)
            if not module_name.startswith('avm-res-'):
                continue
            source_url_match = re.search(r'<td\s+style=text-align:center><a\s+href=([^"\s]+)', row)
            source_url = source_url_match.group(1) if source_url_match else ""
            display_name_match = re.search(r'<b>([^<]+)</b>', row)
            display_name = display_name_match.group(1) if display_name_match else module_name
            version_match = re.search(r'Available%20%f0%9f%9f%a2-([0-9\.]+)-purple', row)
            if version_match:
                version = version_match.group(1)
                if module_name not in modules:
                    modules[module_name] = {
                        'name': module_name,
                        'display_name': display_name,
                        'version': version,
                        'registry': registry_url,
                        'source': source_url,
                        'status': 'Available'
                    }
        return modules

class ModuleDiscoveryAgent:
    """Maps resources to AVM Terraform modules using the live AVM catalog (no MD file)."""
    def __init__(self):
        print("Fetching AVM Terraform module catalog from public index ...")
        self.module_map = AVMModuleCatalogFetcher.get_terraform_modules()

    def find_module(self, resource: str) -> Dict[str, str]:
        # Robust mapping: try exact, partial, fuzzy, synonym, and display name matches
        resource_key = resource.replace('_', '').replace('-', '').lower()
        # 1. Exact match (ignoring avm-res- prefix and dashes/underscores)
        for mod in self.module_map.values():
            mod_key = mod['name'].replace('avm-res-', '').replace('-', '').replace('_', '').lower()
            if resource_key == mod_key:
                print(f"[find_module] Exact match: {resource} -> {mod['name']}")
                return mod
        # 2. Partial match (resource is substring of module name)
        for mod in self.module_map.values():
            mod_key = mod['name'].replace('avm-res-', '').replace('-', '').replace('_', '').lower()
            if resource_key in mod_key or mod_key in resource_key:
                print(f"[find_module] Partial match: {resource} -> {mod['name']}")
                return mod
        # 3. Fuzzy match: allow for plural/singular, common Azure synonyms
        synonyms = {
            'subnet': ['virtualnetworksubnet', 'subnets'],
            'manageddisk': ['disk', 'manageddisks'],
            'appserviceplan': ['serviceplan', 'appserviceplans'],
            'appservice': ['webapp', 'appservices', 'webapps'],
            'sqldatabase': ['sql', 'database', 'sqldatabases'],
            'monitoringdiagnostics': ['diagnosticsetting', 'diagnosticsettings'],
            'loganalyticsworkspace': ['loganalytics', 'workspace', 'loganalyticsworkspaces'],
            'appinsights': ['applicationinsights', 'insights'],
            'recoveryservicesvault': ['recoveryvault', 'vault', 'recoveryservicesvaults'],
            'backuppolicy': ['backup', 'policy', 'backuppolicies'],
            'trafficmanager': ['traffic', 'manager', 'trafficmanagers'],
            'rediscache': ['redis', 'cache', 'rediscaches'],
            'functionapp': ['function', 'functions', 'functionapps'],
            # Additional Azure resource synonyms for robustness
            'storageaccount': ['storage', 'storageaccounts'],
            'virtualmachine': ['vm', 'virtualmachines'],
            'networkinterface': ['nic', 'networkinterfaces'],
            'publicip': ['publicipaddress', 'publicipaddresses'],
            'keyvault': ['vault', 'keyvaults'],
            'aks': ['kubernetes', 'kubernetescluster', 'kubernetesclusters'],
            'vnet': ['virtualnetwork', 'vnets', 'virtualnetworks'],
            'nsg': ['networksecuritygroup', 'networksecuritygroups'],
            'lb': ['loadbalancer', 'loadbalancers'],
            'route': ['routetable', 'routetables'],
            'dnszone': ['dns', 'dnszones'],
            'eventhub': ['eventhubs', 'eventhubnamespace', 'eventhubnamespaces'],
            'cosmosdb': ['cosmos', 'cosmosdbs'],
            'servicebus': ['servicebuses', 'servicebusnamespace', 'servicebusnamespaces'],
            'containerregistry': ['acr', 'containerregistries'],
            'containerapp': ['containerapps'],
        }
        for syn, mod_names in synonyms.items():
            if resource_key == syn or resource_key in mod_names:
                for mod in self.module_map.values():
                    mod_key = mod['name'].replace('avm-res-', '').replace('-', '').replace('_', '').lower()
                    if any(mn in mod_key for mn in [syn] + mod_names):
                        print(f"[find_module] Synonym/fuzzy match: {resource} -> {mod['name']}")
                        return mod
        # 4. Last resort: try if resource is in display_name (case-insensitive, ignore spaces)
        for mod in self.module_map.values():
            display_name = mod.get('display_name', '').replace(' ', '').lower()
            if resource_key in display_name or resource.lower() in display_name:
                print(f"[find_module] Display name match: {resource} -> {mod['name']}")
                return mod
        # 5. Fallback: try case-insensitive match on all fields
        for mod in self.module_map.values():
            if resource.lower() in str(mod).lower():
                print(f"[find_module] Fallback case-insensitive match: {resource} -> {mod['name']}")
                return mod
        print(f"[find_module] No match found for resource: {resource}")
        return {}

class TerraformCodeGenerationAgent:
    async def extract_variables_meta(self, module: dict) -> list:
        """
        Use AI to extract variable meta (name, type, default) for a module.
        """
        prompt = f"""
You are an expert in Terraform and Azure. Given the following AVM Terraform module registry URL:
{module['registry']}
and source repo:
{module['source']}
List the required input variables for this module as a Python list of dicts, each with keys 'name', 'type', and 'default' (use None if no default). Example: [{{'name': 'foo', 'type': 'string', 'default': None}}, ...]
"""
        result = await self.kernel.invoke(prompt)
        try:
            variables = eval(result)
            if isinstance(variables, list):
                return variables
        except Exception:
            pass
        # fallback
        return [
            {'name': f"{module['name']}_name", 'type': 'string', 'default': None},
            {'name': f"{module['name']}_location", 'type': 'string', 'default': None}
        ]

    def extract_variables_from_source(self, repo_path: str) -> list:
        """
        Parse all variables required by the module from its source code (variables.tf, main.tf, etc).
        Returns a list of dicts: [{name, type, default}]
        """
        import glob
        import re
        variables = []
        tf_files = glob.glob(os.path.join(repo_path, '**', '*.tf'), recursive=True)
        var_block_pattern = re.compile(r'variable\s+"([^"]+)"\s*{([^}]*)}', re.DOTALL)
        type_pattern = re.compile(r'type\s*=\s*([\w\[\]{}"]+)')
        default_pattern = re.compile(r'default\s*=\s*([^\n]+)')
        for tf_file in tf_files:
            try:
                with open(tf_file, 'r') as f:
                    content = f.read()
                for match in var_block_pattern.finditer(content):
                    name = match.group(1)
                    block = match.group(2)
                    vtype = 'string'
                    default = None
                    tmatch = type_pattern.search(block)
                    if tmatch:
                        vtype = tmatch.group(1).strip().replace('"', '')
                    dmatch = default_pattern.search(block)
                    if dmatch:
                        default_val = dmatch.group(1).strip()
                        try:
                            import ast
                            default = ast.literal_eval(default_val)
                        except Exception:
                            default = default_val
                    variables.append({'name': name, 'type': vtype, 'default': default})
            except Exception:
                continue
        seen = set()
        unique_vars = []
        for v in variables:
            if v['name'] not in seen:
                unique_vars.append(v)
                seen.add(v['name'])
        return unique_vars

    def extract_variables_meta_from_source(self, repo_path: str) -> list:
        return self.extract_variables_from_source(repo_path)

    """Generates variablized Terraform code for a resource/module."""
    def __init__(self, kernel=None):
        if kernel is None:
            self.kernel = sk.Kernel()
            self.kernel.add_service(
                AzureChatCompletion(
                    deployment_name=os.environ.get("AZURE_OPENAI_DEPLOYMENT_NAME"),
                    endpoint=os.environ.get("AZURE_OPENAI_ENDPOINT"),
                    api_key=os.environ.get("AZURE_OPENAI_API_KEY")
                )
            )
        else:
            self.kernel = kernel

    def extract_variables(self, module: Dict[str, str]) -> list:
        prompt = f"""
You are an expert in Terraform and Azure. Given the following AVM Terraform module registry URL:
{module['registry']}
and source repo:
{module['source']}
List the required input variables for this module as a Python list of strings. Only include variable names and descriptions.
"""
        result = self.kernel.invoke(prompt)
        try:
            variables = eval(result)
            if isinstance(variables, list):
                return variables
        except Exception:
            pass
        return [f"{module['name']}_name", f"{module['name']}_location"]

    def generate(self, module: Dict[str, str], resource_name: str, variables: list) -> str:
        # Extract the correct source string for the module (remove registry URL prefix if present)
        registry = module.get('registry', '')
        if registry.startswith('https://registry.terraform.io/modules/'):
            source_str = registry.replace('https://registry.terraform.io/modules/', '')
        else:
            source_str = registry
        version_str = f'  version = "{module["version"]}"' if module.get('version') else ''
        var_lines = ''
        for v in variables:
            if isinstance(v, dict):
                var_lines += f'  {v["name"]} = var.{resource_name}_vars.{v["name"]}\n'
            else:
                var_lines += f'  {v} = var.{resource_name}_vars.{v}\n'
        code = f'''module "{resource_name}" {{
  source  = "{source_str}"
{version_str}
{var_lines}}}
'''
        return code

class ValidationAgent:
    """Validates Terraform code using 'terraform validate'."""
    def validate(self, tf_dir: str) -> bool:
        try:
            result = subprocess.run(['terraform', 'validate'], cwd=tf_dir, capture_output=True, text=True)
            print(result.stdout)
            return result.returncode == 0
        except Exception as e:
            print(f"Validation error: {e}")
            return False

    def validate_with_errors(self, tf_dir: str) -> (bool, str):
        try:
            result = subprocess.run(['terraform', 'validate'], cwd=tf_dir, capture_output=True, text=True)
            print(result.stdout)
            return result.returncode == 0, result.stderr
        except Exception as e:
            print(f"Validation error: {e}")
            return False, str(e)

class TFVarsGeneratorAgent:
    """Generates a sample terraform.tfvars file."""
    def generate(self, variables: List[str]) -> str:
        return '\n'.join([f'{var} = "<value>"' for var in variables])

# --- Orchestration ---

def main(md_file: str, output_dir: str):
    os.makedirs(output_dir, exist_ok=True)
    resource_agent = ResourceExtractionAgent()
    module_agent = ModuleDiscoveryAgent()
    code_agent = TerraformCodeGenerationAgent()
    validate_agent = ValidationAgent()
    tfvars_agent = TFVarsGeneratorAgent()

    resources = resource_agent.extract(md_file)
    tf_code = ''
    tfvars = []
    for res in resources:
        module = module_agent.find_module(res)
        if not module:
            print(f"No AVM module found for resource: {res}")
            continue
        code = code_agent.generate(module, res)
        tf_code += code + '\n'
        variables = code_agent.extract_variables(module)
        tfvars.extend(variables)

    main_tf_path = os.path.join(output_dir, 'main.tf')
    with open(main_tf_path, 'w') as f:
        f.write(tf_code)

    tfvars_path = os.path.join(output_dir, 'terraform.tfvars')
    with open(tfvars_path, 'w') as f:
        f.write(tfvars_agent.generate(tfvars))

    valid = validate_agent.validate(output_dir)
    if not valid:
        print("Terraform code is not valid. Please review and fix errors.")
    else:
        print("Terraform code is valid.")

if __name__ == "__main__":
    use_mcp = True
    if use_mcp:
        orchestrator = MCPTerraformOrchestrator(
            md_file="resources.md",
            output_dir="generated_tf",
            max_iterations=2
        )
        asyncio.run(orchestrator.run())
    else:
        main(
            md_file="resources.md",
            output_dir="generated_tf"
        )
