# --- Logging Setup ---
import logging
import datetime

# --- Semantic Kernel Imports ---
import asyncio
import os
from semantic_kernel import Kernel
from semantic_kernel.connectors.ai.open_ai import AzureChatCompletion
from semantic_kernel.functions import kernel_function
from semantic_kernel.contents.chat_history import ChatHistory
from semantic_kernel.connectors.ai.open_ai.prompt_execution_settings.azure_chat_prompt_execution_settings import AzureChatPromptExecutionSettings
from semantic_kernel.connectors.ai.function_choice_behavior import FunctionChoiceBehavior

# --- Logging Setup ---
log_ts = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
log_filename = f'tfcodegen_log_{log_ts}.log'
logging.basicConfig(
    filename=log_filename,
    filemode='w',
    level=logging.INFO,
    format='%(asctime)s %(levelname)s %(message)s'
)
console = logging.StreamHandler()
console.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
console.setFormatter(formatter)
logging.getLogger('').addHandler(console)

# --- Robust KernelServiceNotFoundError import (global scope) ---
KernelServiceNotFoundError = None
try:
    from semantic_kernel.kernel_service import KernelServiceNotFoundError as KSNFE
    KernelServiceNotFoundError = KSNFE
except ImportError:
    try:
        from semantic_kernel.services.kernel_service import KernelServiceNotFoundError as KSNFE
        KernelServiceNotFoundError = KSNFE
    except ImportError:
        try:
            from semantic_kernel.exceptions.kernel_exceptions import KernelServiceNotFoundError as KSNFE
            KernelServiceNotFoundError = KSNFE
        except ImportError:
            pass
# Always define fallback if still None
if KernelServiceNotFoundError is None:
    class KernelServiceNotFoundError(Exception):
        pass
    KernelServiceNotFoundError = KernelServiceNotFoundError

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
        # Semantic Kernel setup
        self.kernel = Kernel()
        deployment_name = os.environ.get("AZURE_OPENAI_DEPLOYMENT_NAME")
        api_key = os.environ.get("AZURE_OPENAI_API_KEY")
        base_url = os.environ.get("AZURE_OPENAI_ENDPOINT")
        self.kernel.add_service(AzureChatCompletion(
            deployment_name=deployment_name,
            api_key=api_key,
            base_url=base_url
        ))
        self.kernel.add_plugin(TerraformPlugin(), plugin_name="Terraform")
        self.terraform_plugin = self.kernel.get_plugin("Terraform")
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
        async def mcp_git_clone(repo_url, local_path):
            """Use MCP server for git clone (mcp-server-git)."""
            # See: https://github.com/modelcontextprotocol/mcp-server-git
            # Assumes mcp-server-git is running at localhost:5001 (default)
            mcp_url = os.environ.get("MCP_GIT_SERVER_URL", "http://localhost:5001/invoke")
            payload = {
                "function": "git.clone",
                "parameters": {
                    "repo_url": repo_url,
                    "dest": local_path,
                    "depth": 1,
                    "quiet": True
                }
            }
            try:
                resp = requests.post(mcp_url, json=payload, timeout=60)
                resp.raise_for_status()
                result = resp.json()
                if result.get("status") == "ok":
                    return True, None
                else:
                    return False, result.get("error", "Unknown MCP error")
            except Exception as e:
                return False, str(e)

        for res in resources:
            module = self.module_agent.find_module(res)
            if not module:
                logging.error(f"No AVM module found for resource: {res}")
                continue
            repo_url = module.get('source', '').strip()
            if not repo_url or not repo_url.startswith('http'):
                logging.warning(f"No valid source repo for {res}, skipping git clone.")
                module_clone_paths[res] = None
            else:
                mod_name = module['name'].replace('/', '_')
                local_path = os.path.join(self._clonedir, mod_name)
                module_clone_paths[res] = local_path
                if not os.path.exists(local_path):
                    logging.info(f"Cloning module {mod_name} into {local_path} using MCP (subprocess fallback)")
                    success, err = await mcp_git_clone(repo_url, local_path)
                    if success:
                        logging.info(f"SUCCESS: Cloned {mod_name}")
                    else:
                        logging.error(f"Failed to clone {repo_url}: {err}")
                        module_clone_paths[res] = None

        # --- End of one-time clone ---

        # --- Extract variables meta for all modules only once ---
        logging.info("Extracting variables meta for all modules...")
        for res in resources:
            module = self.module_agent.find_module(res)
            if not module:
                logging.warning(f"Skipping variable extraction for missing module: {res}")
                continue
            local_path = module_clone_paths.get(res)
            variables_meta = []
            if local_path and os.path.exists(local_path):
                # Parse variables from source files (keep as is for now)
                variables_meta = []  # TODO: implement parsing if needed
                logging.info(f"Extracted variables from source for {res}")
            else:
                # Use LLM to extract variables (optional, not implemented here)
                variables_meta = []
                logging.info(f"Extracted variables from AI for {res}")
            tfvars_obj[res] = variables_meta
            module_vars_meta[res] = variables_meta
        # --- End of one-time variable extraction ---

        while iteration < self.max_iterations:
            if not os.path.exists(self.output_dir):
                os.makedirs(self.output_dir, exist_ok=True)
            logging.info(f"--- MCP Iteration {iteration+1} ---")
            tf_code = ''

            for res in resources:
                # Only print warnings, not [find_module] debug output here
                module = self.module_agent.find_module(res)
                if not module:
                    logging.warning(f"Skipping code generation for missing module: {res}")
                    continue
                variables_meta = module_vars_meta[res]
                code = self.code_agent.generate(module, res, variables_meta)
                tf_code += code + '\n'

            main_tf_path = os.path.join(self.output_dir, 'main.tf')
            with open(main_tf_path, 'w') as f:
                f.write(tf_code)
            logging.info(f"main.tf written to {main_tf_path}")


            variables_tf_path = os.path.join(self.output_dir, 'variables.tf')
            with open(variables_tf_path, 'w') as f:
                for res, vars_meta in module_vars_meta.items():
                    module = self.module_agent.find_module(res)
                    mod_name = module['name'].replace('/', '_') if module and 'name' in module else res
                    local_path = module_clone_paths.get(res)
                    module_code = ''
                    if local_path and os.path.exists(local_path):
                        tf_files = []
                        for fname in ['variables.tf', 'main.tf', 'inputs.tf']:
                            fpath = os.path.join(local_path, fname)
                            if os.path.exists(fpath):
                                with open(fpath, 'r') as tf_f:
                                    tf_files.append(tf_f.read())
                        module_code = '\n'.join(tf_files)
                    if module_code and module_code.strip():
                        # Use Semantic Kernel plugin to generate variables.tf
                        history = ChatHistory()
                        prompt = self.terraform_plugin.generate_variables_tf(module_code)
                        history.add_user_message(prompt)
                        execution_settings = AzureChatPromptExecutionSettings()
                        execution_settings.function_choice_behavior = FunctionChoiceBehavior.Auto()
                        chat_completion = self.kernel.get_service(type=AzureChatCompletion)
                        result = await chat_completion.get_chat_message_content(
                            chat_history=history,
                            settings=execution_settings,
                            kernel=self.kernel
                        )
                        variables_tf_content = str(result)
                    else:
                        variables_tf_content = None
                    if variables_tf_content and isinstance(variables_tf_content, str) and variables_tf_content.strip():
                        f.write(variables_tf_content.strip() + '\n')
                        logging.info(f"variables.tf generated for {res}")
                    else:
                        f.write(f'# [WARNING] AI could not generate variables.tf for {res}. Please review manually.\n')
                        logging.warning(f"AI could not generate variables.tf for {res}")



            outputs_tf_path = os.path.join(self.output_dir, 'outputs.tf')
            with open(outputs_tf_path, 'w') as f:
                for res in resources:
                    module = self.module_agent.find_module(res)
                    mod_name = module['name'].replace('/', '_') if module and 'name' in module else res
                    local_path = module_clone_paths.get(res)
                    module_code = ''
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
                    if module_code and module_code.strip():
                        # Use Semantic Kernel plugin to generate outputs.tf
                        history = ChatHistory()
                        prompt = self.terraform_plugin.generate_outputs_tf(module_code, res)
                        history.add_user_message(prompt)
                        execution_settings = AzureChatPromptExecutionSettings()
                        execution_settings.function_choice_behavior = FunctionChoiceBehavior.Auto()
                        chat_completion = self.kernel.get_service(type=AzureChatCompletion)
                        result = await chat_completion.get_chat_message_content(
                            chat_history=history,
                            settings=execution_settings,
                            kernel=self.kernel
                        )
                        output_blocks = str(result)
                    else:
                        output_blocks = None
                    if output_blocks and isinstance(output_blocks, str) and output_blocks.strip():
                        f.write(output_blocks.strip() + '\n')
                        logging.info(f"outputs.tf generated for {res}")
                    else:
                        f.write(f'# [WARNING] AI could not generate outputs for {res}. Please review manually.\n')
                        logging.warning(f"AI could not generate outputs for {res}")

            providers_tf_path = os.path.join(self.output_dir, 'providers.tf')
            with open(providers_tf_path, 'w') as f:
                f.write('terraform {\n  required_providers {\n    azurerm = {\n      source = "hashicorp/azurerm"\n      version = ">= 3.0.0"\n    }\n  }\n}\n\nprovider "azurerm" {\n  features {}\n}\n')
            logging.info(f"providers.tf written to {providers_tf_path}")

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
            logging.info(f"terraform.tfvars written to {tfvars_path}")

            valid, error_output = self.validate_agent.validate_with_errors(self.output_dir)
            if valid:
                logging.info("SUCCESS: Terraform code is valid.")
                return True
            else:
                logging.error("Terraform code is not valid. Attempting to fix errors using AI...")
                await self._fix_code_with_errors(error_output, main_tf_path, variables_tf_path)
                time.sleep(1)
            iteration += 1
        logging.fatal("Max iterations reached. Please review errors manually.")
        return False

    async def _fix_code_with_errors(self, error_output, main_tf_path, variables_tf_path):
        for tf_file in [main_tf_path, variables_tf_path]:
            with open(tf_file, 'r') as f:
                code = f.read()
            # Use Semantic Kernel plugin to fix code
            history = ChatHistory()
            prompt = self.terraform_plugin.fix_terraform_code(code, error_output)
            history.add_user_message(prompt)
            execution_settings = AzureChatPromptExecutionSettings()
            execution_settings.function_choice_behavior = FunctionChoiceBehavior.Auto()
            chat_completion = self.kernel.get_service(type=AzureChatCompletion)
            result = await chat_completion.get_chat_message_content(
                chat_history=history,
                settings=execution_settings,
                kernel=self.kernel
            )
            result_text = str(result)
            if result_text and isinstance(result_text, str) and len(result_text.strip()) > 0:
                with open(tf_file, 'w') as f:
                    f.write(result_text.strip())
                logging.info(f"AI code fix applied for {tf_file}")
            else:
                logging.warning(f"AI code fix returned no changes for {tf_file}")

# Multi-Agent Terraform Code Generator for Azure using AVM Modules
# Skeleton for Semantic Kernel integration
import os
import re
import subprocess
import semantic_kernel as sk
from semantic_kernel.connectors.ai.open_ai import AzureChatCompletion
try:
    from dotenv import load_dotenv
except ImportError:
    load_dotenv = None
if load_dotenv:
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
    Fetches and parses Azure Verified Modules (AVM) for Terraform from the public index.
    Only Terraform support (no Bicep).
    """
    TERRAFORM_URL = "https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/"

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


# --- Semantic Kernel Plugin for Terraform Code Generation ---
class TerraformPlugin:
    @kernel_function(
        name="generate_variables_tf",
        description="Generate variables.tf content from module code"
    )
    def generate_variables_tf(self, module_code: str) -> str:
        return f"""
You are an expert Terraform developer. Given the following Terraform module source code:
---
{module_code}
---
Generate a valid variables.tf file for this module, using correct HCL syntax, types, and default values. Ensure all variables are defined with the correct type and default (if any), and use optional() where appropriate. Output only the variables.tf file content.
"""

    @kernel_function(
        name="generate_outputs_tf",
        description="Generate outputs.tf content from module code"
    )
    def generate_outputs_tf(self, module_code: str, resource_name: str) -> str:
        return f"""
You are an expert Terraform developer. Given the following Terraform module source code:
---
{module_code}
---
Extract all output blocks from this module. For each output, rewrite it so that the value references the output from the module block in the root module, assuming the module is named \"{resource_name}\". For example, if the module output is \"foo\", generate:
output \"{resource_name}_foo\" {{
  value = module.{resource_name}.foo
}}
Output only the outputs.tf file content, with all outputs found in the module.
"""

    @kernel_function(
        name="fix_terraform_code",
        description="Fix Terraform code based on validation errors"
    )
    def fix_terraform_code(self, code: str, error_output: str) -> str:
        return f"""
You are an expert Terraform developer. The following Terraform code has validation errors:
---
{code}
---
The error message from 'terraform validate' is:
{error_output}
Suggest a corrected version of the code, fixing the errors. Return only the corrected code.
"""

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

    def validate_with_errors(self, tf_dir: str) -> tuple:
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
    # Legacy main() is deprecated. Use MCPTerraformOrchestrator instead.
    logging.warning("[DEPRECATED] The main() function is no longer used. Please use MCPTerraformOrchestrator.")
    pass

if __name__ == "__main__":
    orchestrator = MCPTerraformOrchestrator(
        md_file="resources.md",
        output_dir="generated_tf",
        max_iterations=1
    )
    asyncio.run(orchestrator.run())

