# --- MCP Orchestrator ---

import time
import traceback
import asyncio

class MCPTerraformOrchestrator:
    async def generate_main_tf(self, filtered_resources, module_vars_meta, tfvars_obj):
        tf_code = ''
        for res in filtered_resources:
            module = self.module_agent.find_module(res)
            if not module:
                print(f"No AVM module found for resource: {res}")
                continue
            repo_url = module.get('source', '').strip()
            if not repo_url or not repo_url.startswith('http'):
                print(f"No valid source repo for {res}, skipping git clone.")
                variables_meta = await self.code_agent.extract_variables_meta(module)
            else:
                mod_name = module['name'].replace('/', '_')
                local_path = os.path.join(self._clonedir, mod_name)
                if not os.path.exists(local_path):
                    print(f"Cloning {repo_url} to {local_path} ...")
                    try:
                        subprocess.run(['git', 'clone', '--depth', '1', repo_url, local_path], check=True)
                    except Exception as e:
                        print(f"Failed to clone {repo_url}: {e}")
                        variables_meta = await self.code_agent.extract_variables_meta(module)
                        tfvars_obj[res] = variables_meta
                        module_vars_meta[res] = variables_meta
                        code = self.code_agent.generate(module, res, variables_meta)
                        tf_code += code + '\n'
                        continue
                variables_meta = self.code_agent.extract_variables_meta_from_source(local_path)
            tfvars_obj[res] = variables_meta
            module_vars_meta[res] = variables_meta
            code = self.code_agent.generate(module, res, variables_meta)
            tf_code += code + '\n'
        main_tf_path = os.path.join(self.output_dir, 'main.tf')
        with open(main_tf_path, 'w') as f:
            f.write(tf_code)
        return tf_code

    async def generate_variables_tf(self, module_vars_meta):
        variables_tf_path = os.path.join(self.output_dir, 'variables.tf')
        with open(variables_tf_path, 'w') as f:
            for res, vars_meta in module_vars_meta.items():
                module = self.module_agent.find_module(res)
                repo_url = module.get('source', '').strip() if module else ''
                mod_name = module['name'].replace('/', '_') if module and 'name' in module else res
                local_path = os.path.join(self._clonedir, mod_name)
                variables_tf_content = None
                if os.path.exists(local_path):
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
                    # Fallback to old logic if AI fails or repo not cloned
                    f.write(f'variable "{res}_vars" {{\n  description = "Variables for {res} module"\n  type = object({{\n')
                    for var in vars_meta:
                        if isinstance(var, dict):
                            vname = var["name"]
                            vtype = var["type"]
                            vdefault = var.get("default")
                            def format_tf_default(val):
                                if val is None or (isinstance(val, str) and val.strip().lower() == 'null'):
                                    return 'null'
                                elif isinstance(val, bool):
                                    return 'true' if val else 'false'
                                elif isinstance(val, (int, float)):
                                    return str(val)
                                elif isinstance(val, str):
                                    sval = val.strip().strip('"').strip("'")
                                    sval_nospace = sval.replace(' ', '').lower()
                                    empty_map_synonyms = {'{', '{}', 'map()', 'map{}', 'map', 'empty_map', 'emptydict', 'dict()', 'dict{}', 'dict', 'emptyobject', 'object()', 'object{}', 'object'}
                                    empty_list_synonyms = {'[', '[]', 'list()', 'list[]', 'empty_list', 'emptylist', 'tuple()', 'tuple[]', 'tuple', 'set()', 'set[]', 'set{}', 'empty_set', 'emptyset'}
                                    if sval_nospace in empty_map_synonyms or sval_nospace == '':
                                        return '{}'
                                    if sval_nospace in empty_list_synonyms:
                                        return '[]'
                                    if sval_nospace == 'true':
                                        return 'true'
                                    if sval_nospace == 'false':
                                        return 'false'
                                    if sval_nospace == 'null':
                                        return 'null'
                                    return f'"{sval}"'
                                elif isinstance(val, (list, tuple)):
                                    if len(val) == 0:
                                        return '[]'
                                    return '[' + ', '.join(format_tf_default(x) for x in val) + ']'
                                elif isinstance(val, dict):
                                    if len(val) == 0:
                                        return '{}'
                                    return '{ ' + ', '.join(f'{k} = {format_tf_default(v)}' for k, v in val.items()) + ' }'
                                return str(val)
                            if vdefault is not None:
                                f.write(f'    {vname} = optional({vtype}, {format_tf_default(vdefault)})\n')
                            else:
                                f.write(f'    {vname} = {vtype}\n')
                        else:
                            f.write(f'    {var} = string\n')
                    f.write('  })\n}\n')

    def generate_outputs_tf(self, filtered_resources):
        outputs_tf_path = os.path.join(self.output_dir, 'outputs.tf')
        with open(outputs_tf_path, 'w') as f:
            for res in filtered_resources:
                f.write(f'output "{res}_id" {{\n  value = module.{res}["{res}"].id if contains(module.{res}, "{res}") else module.{res}.id\n}}\n')

    def generate_providers_tf(self):
        providers_tf_path = os.path.join(self.output_dir, 'providers.tf')
        with open(providers_tf_path, 'w') as f:
            f.write('terraform {\n  required_providers {\n    azurerm = {\n      source = "hashicorp/azurerm"\n      version = ">= 3.0.0"\n    }\n  }\n}\n\nprovider "azurerm" {\n  features {}\n}\n')

    def generate_tfvars(self, module_vars_meta):
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
    def __init__(self, md_file, avm_md_file, output_dir, max_iterations=5):
        self.md_file = md_file
        self.avm_md_file = avm_md_file
        self.output_dir = output_dir
        self.max_iterations = max_iterations
        self.resource_agent = ResourceExtractionAgent()
        self.module_agent = ModuleDiscoveryAgent(avm_md_file)
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
        # Track subnet and vnet relationships for special handling
        subnets = []
        vnets = []
        nsgs = []
        private_endpoints = []
        dns_zones = []
        # Preprocess resources for special handling
        for res in resources:
            if 'subnet' in res.lower():
                subnets.append(res)
            elif 'virtualnetwork' in res.lower() or 'vnet' in res.lower():
                vnets.append(res)
            elif 'networksecuritygroup' in res.lower() or 'nsg' in res.lower():
                nsgs.append(res)
            elif 'privateendpoint' in res.lower():
                private_endpoints.append(res)
            elif 'dnszone' in res.lower():
                dns_zones.append(res)
        while iteration < self.max_iterations:
            if not os.path.exists(self.output_dir):
                os.makedirs(self.output_dir, exist_ok=True)
            print(f"\n--- MCP Iteration {iteration+1} ---")
            tf_code = ''
            tfvars_obj.clear()
            module_vars_meta.clear()
            # 1. Remove explicit DNS record resources if private endpoints exist
            filtered_resources = [r for r in resources if not (('dnsrecord' in r.lower() or 'dns_' in r.lower()) and private_endpoints)]
            # 2. For each resource, replace with AVM module if available, else keep as resource
            for res in filtered_resources:
                module = self.module_agent.find_module(res)
                if not module:
                    print(f"No AVM module found for resource: {res}")
                    continue
                repo_url = module.get('source', '').strip()
                if not repo_url or not repo_url.startswith('http'):
                    print(f"No valid source repo for {res}, skipping git clone.")
                    variables_meta = await self.code_agent.extract_variables_meta(module)
                else:
                    mod_name = module['name'].replace('/', '_')
                    local_path = os.path.join(self._clonedir, mod_name)
                    if not os.path.exists(local_path):
                        print(f"Cloning {repo_url} to {local_path} ...")
                        try:
                            subprocess.run(['git', 'clone', '--depth', '1', repo_url, local_path], check=True)
                        except Exception as e:
                            print(f"Failed to clone {repo_url}: {e}")
                            variables_meta = await self.code_agent.extract_variables_meta(module)
                            tfvars_obj[res] = variables_meta
                            module_vars_meta[res] = variables_meta
                            code = self.code_agent.generate(module, res, variables_meta)
                            tf_code += code + '\n'
                            continue
                    variables_meta = self.code_agent.extract_variables_meta_from_source(local_path)
                # 3. Parameterize all hardcoded values, especially for NSG rules, site_config, app_settings, and resource references
                #    (Handled by code_agent.generate and variables_meta)
                # 4. Prefix and suffix resource names
                #    (Handled by code_agent.generate)
                tfvars_obj[res] = variables_meta
                module_vars_meta[res] = variables_meta
                code = self.code_agent.generate(module, res, variables_meta)
                tf_code += code + '\n'
            # 5. Move subnets into vnet module if both exist
            #    (This is a simplification: in a real implementation, you'd parse the vnet module's variables and inject subnets)
            #    Here, we just print a message for user awareness
            if vnets and subnets:
                print("[INFO] Subnets will be moved into the virtual network module call. Ensure subnets reference the appropriate NSG.")
            # 6. For each private endpoint, create a private DNS zone and link to vnet
            if private_endpoints:
                print("[INFO] For each private endpoint, ensure a private DNS zone is created and linked to the VNet.")
            # 7. Write main.tf
            main_tf_path = os.path.join(self.output_dir, 'main.tf')
            with open(main_tf_path, 'w') as f:
                f.write(tf_code)
            # 8. Write variables.tf
            variables_tf_path = os.path.join(self.output_dir, 'variables.tf')
            with open(variables_tf_path, 'w') as f:
                for res, vars_meta in module_vars_meta.items():
                    module = self.module_agent.find_module(res)
                    repo_url = module.get('source', '').strip() if module else ''
                    mod_name = module['name'].replace('/', '_') if module and 'name' in module else res
                    local_path = os.path.join(self._clonedir, mod_name)
                    variables_tf_content = None
                    if os.path.exists(local_path):
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
                        # Fallback to old logic if AI fails or repo not cloned
                        f.write(f'variable "{res}_vars" {{\n  description = "Variables for {res} module"\n  type = object({{\n')
                        for var in vars_meta:
                            if isinstance(var, dict):
                                vname = var["name"]
                                vtype = var["type"]
                                vdefault = var.get("default")
                                def format_tf_default(val):
                                    if val is None or (isinstance(val, str) and val.strip().lower() == 'null'):
                                        return 'null'
                                    elif isinstance(val, bool):
                                        return 'true' if val else 'false'
                                    elif isinstance(val, (int, float)):
                                        return str(val)
                                    elif isinstance(val, str):
                                        sval = val.strip().strip('"').strip("'")
                                        sval_nospace = sval.replace(' ', '').lower()
                                        empty_map_synonyms = {'{', '{}', 'map()', 'map{}', 'map', 'empty_map', 'emptydict', 'dict()', 'dict{}', 'dict', 'emptyobject', 'object()', 'object{}', 'object'}
                                        empty_list_synonyms = {'[', '[]', 'list()', 'list[]', 'empty_list', 'emptylist', 'tuple()', 'tuple[]', 'tuple', 'set()', 'set[]', 'set{}', 'empty_set', 'emptyset'}
                                        if sval_nospace in empty_map_synonyms or sval_nospace == '':
                                            return '{}'
                                        if sval_nospace in empty_list_synonyms:
                                            return '[]'
                                        if sval_nospace == 'true':
                                            return 'true'
                                        if sval_nospace == 'false':
                                            return 'false'
                                        if sval_nospace == 'null':
                                            return 'null'
                                        return f'"{sval}"'
                                    elif isinstance(val, (list, tuple)):
                                        if len(val) == 0:
                                            return '[]'
                                        return '[' + ', '.join(format_tf_default(x) for x in val) + ']'
                                    elif isinstance(val, dict):
                                        if len(val) == 0:
                                            return '{}'
                                        return '{ ' + ', '.join(f'{k} = {format_tf_default(v)}' for k, v in val.items()) + ' }'
                                    return str(val)
                                if vdefault is not None:
                                    f.write(f'    {vname} = optional({vtype}, {format_tf_default(vdefault)})\n')
                                else:
                                    f.write(f'    {vname} = {vtype}\n')
                            else:
                                f.write(f'    {var} = string\n')
                        f.write('  })\n}\n')
            # 9. Write outputs.tf
            outputs_tf_path = os.path.join(self.output_dir, 'outputs.tf')
            with open(outputs_tf_path, 'w') as f:
                for res in filtered_resources:
                    f.write(f'output "{res}_id" {{\n  value = module.{res}["{res}"].id if contains(module.{res}, "{res}") else module.{res}.id\n}}\n')
            # 10. Write providers.tf
            providers_tf_path = os.path.join(self.output_dir, 'providers.tf')
            with open(providers_tf_path, 'w') as f:
                f.write('terraform {\n  required_providers {\n    azurerm = {\n      source = "hashicorp/azurerm"\n      version = ">= 3.0.0"\n    }\n  }\n}\n\nprovider "azurerm" {\n  features {}\n}\n')
            # 11. Write terraform.tfvars
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
            # 12. Validate and iterate up to 5 times
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

class ModuleDiscoveryAgent:
    """Maps resources to AVM Terraform modules using the local catalog."""
    def __init__(self, avm_md_path: str, ps_script_path: str = "avm-resource-modules-prepare.ps1"):
        # Run the PowerShell script to generate the AVM modules markdown file
        print(f"Running PowerShell script to generate {avm_md_path} ...")
        try:
            import subprocess
            ps_cmd = ["pwsh", "-File", ps_script_path]
            result = subprocess.run(ps_cmd, capture_output=True, text=True)
            if result.returncode != 0:
                print(f"PowerShell script error: {result.stderr}")
            else:
                print(f"PowerShell script completed: {result.stdout}")
        except FileNotFoundError:
            print("PowerShell (pwsh) not found. Please ensure PowerShell Core is installed.")
        except Exception as e:
            print(f"Error running PowerShell script: {e}")
        self.module_map = self._parse_avm_md(avm_md_path)

    def _parse_avm_md(self, path: str) -> Dict[str, Dict[str, str]]:
        modules = {}
        with open(path, 'r') as f:
            for line in f:
                if line.startswith('|') and 'avm-res-' in line:
                    parts = [x.strip() for x in line.split('|')]
                    if len(parts) > 5:
                        modules[parts[2]] = {
                            'name': parts[2],
                            'display_name': parts[3],
                            'version': parts[4],
                            'registry': parts[5],
                            'source': parts[6] if len(parts) > 6 else ''
                        }
        return modules

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
                var_lines += f'  {v["name"]} = try(each.value.{v["name"]}, null)\n'
            else:
                var_lines += f'  {v} = try(each.value.{v}, null)\n'
        code = f'''module "{resource_name}" {{
  source  = "{source_str}"
{version_str}
  for_each = {{ "{resource_name}" = var.{resource_name}_vars }}
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

def main(md_file: str, avm_md_file: str, output_dir: str):
    os.makedirs(output_dir, exist_ok=True)
    resource_agent = ResourceExtractionAgent()
    module_agent = ModuleDiscoveryAgent(avm_md_file)
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
        # Use AI to extract variables for tfvars
        variables = code_agent.extract_variables(module)
        tfvars.extend(variables)

    # Write main.tf
    main_tf_path = os.path.join(output_dir, 'main.tf')
    with open(main_tf_path, 'w') as f:
        f.write(tf_code)

    # Write terraform.tfvars
    tfvars_path = os.path.join(output_dir, 'terraform.tfvars')
    with open(tfvars_path, 'w') as f:
        f.write(tfvars_agent.generate(tfvars))

    # Validate
    valid = validate_agent.validate(output_dir)
    if not valid:
        print("Terraform code is not valid. Please review and fix errors.")
    else:
        print("Terraform code is valid.")


if __name__ == "__main__":
    # To use MCP Orchestrator, set use_mcp = True
    use_mcp = True
    if use_mcp:
        orchestrator = MCPTerraformOrchestrator(
            md_file="resources.md",
            avm_md_file="avm-resource-modules-terraform.md",
            output_dir="generated_tf",
            max_iterations=1
        )
        asyncio.run(orchestrator.run())
    else:
        main(
            md_file="resources.md",  # or your input MD file
            avm_md_file="avm-resource-modules-terraform.md",
            output_dir="generated_tf"
        )
