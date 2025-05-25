# --- MCP Orchestrator ---

import time

class MCPTerraformOrchestrator:
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

    def run(self):
        resources = self.resource_agent.extract(self.md_file)
        iteration = 0
        errors = None
        while iteration < self.max_iterations:
            # Ensure output directory exists
            if not os.path.exists(self.output_dir):
                os.makedirs(self.output_dir, exist_ok=True)
            print(f"\n--- MCP Iteration {iteration+1} ---")
            tf_code = ''
            tfvars_obj = {}
            import shutil
            import tempfile
            for res in resources:
                module = self.module_agent.find_module(res)
                if not module:
                    print(f"No AVM module found for resource: {res}")
                    continue
                # --- MCP: Clone the module repo if not already cloned ---
                repo_url = module.get('source', '').strip()
                if not repo_url or not repo_url.startswith('http'):
                    print(f"No valid source repo for {res}, skipping git clone.")
                    variables = self.code_agent.extract_variables(module)
                else:
                    # Use a temp dir for all clones in this run
                    if not hasattr(self, '_clonedir'):
                        self._clonedir = tempfile.mkdtemp(prefix='avm_mods_')
                    mod_name = module['name'].replace('/', '_')
                    local_path = os.path.join(self._clonedir, mod_name)
                    if not os.path.exists(local_path):
                        print(f"Cloning {repo_url} to {local_path} ...")
                        try:
                            subprocess.run(['git', 'clone', '--depth', '1', repo_url, local_path], check=True)
                        except Exception as e:
                            print(f"Failed to clone {repo_url}: {e}")
                            variables = self.code_agent.extract_variables(module)
                            tfvars_obj[res] = variables
                            code = self.code_agent.generate(module, res, variables)
                            tf_code += code + '\n'
                            continue
                    # --- Analyze the module source code for variables ---
                    variables = self.code_agent.extract_variables_from_source(local_path)
                tfvars_obj[res] = variables
                code = self.code_agent.generate(module, res, variables)
                tf_code += code + '\n'
            # Write main.tf
            main_tf_path = os.path.join(self.output_dir, 'main.tf')
            with open(main_tf_path, 'w') as f:
                f.write(tf_code)

            # Write variables.tf as an object for each module
            variables_tf_path = os.path.join(self.output_dir, 'variables.tf')
            with open(variables_tf_path, 'w') as f:
                for res, vars in tfvars_obj.items():
                    f.write(f'variable "{res}_vars" {{\n  description = "Variables for {res} module"\n  type = object({{\n')
                    for var in vars:
                        f.write(f'    {var} = string\n')
                    f.write('  })\n}\n')

            # Write outputs.tf (basic placeholder, can be improved)
            outputs_tf_path = os.path.join(self.output_dir, 'outputs.tf')
            with open(outputs_tf_path, 'w') as f:
                for res in resources:
                    f.write(f'output "{res}_id" {{\n  value = module.{res}["{res}"].id if contains(module.{res}, "{res}") else module.{res}.id\n}}\n')

            # Write providers.tf (basic Azure provider)
            providers_tf_path = os.path.join(self.output_dir, 'providers.tf')
            with open(providers_tf_path, 'w') as f:
                f.write('terraform {\n  required_providers {\n    azurerm = {\n      source = "hashicorp/azurerm"\n      version = ">= 3.0.0"\n    }\n  }\n}\n\nprovider "azurerm" {\n  features {}\n}\n')

            # Write terraform.tfvars as an object for each module
            tfvars_path = os.path.join(self.output_dir, 'terraform.tfvars')
            with open(tfvars_path, 'w') as f:
                for res, vars in tfvars_obj.items():
                    f.write(f'{res}_vars = {{\n')
                    for var in vars:
                        f.write(f'  {var} = "<value>"\n')
                    f.write('}\n')
            # Validate
            valid = self.validate_agent.validate(self.output_dir)
            if valid:
                print("Terraform code is valid.\n")
                return True
            else:
                print("Terraform code is not valid. Attempting to fix errors using AI...")
                # Use AI to analyze and fix errors (stub: in production, use LLM to suggest fixes)
                # For now, just sleep and retry (simulate fix)
                time.sleep(2)
            iteration += 1
        print("Max iterations reached. Please review errors manually.")
        return False

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
        # Simple mapping: match resource name in module name
        for mod in self.module_map.values():
            if resource.replace('_', '').lower() in mod['name'].replace('avm-res-', '').replace('-', '').lower():
                return mod
        return {}

class TerraformCodeGenerationAgent:
    def extract_variables_from_source(self, repo_path: str) -> list:
        """Parse all variables required by the module from its source code (variables.tf, main.tf, etc)."""
        import glob
        import re
        variables = set()
        # Look for variables.tf and any .tf files
        tf_files = glob.glob(os.path.join(repo_path, '**', '*.tf'), recursive=True)
        var_pattern = re.compile(r'variable\s+"([^"]+)"')
        for tf_file in tf_files:
            try:
                with open(tf_file, 'r') as f:
                    content = f.read()
                # Find all variable blocks
                for match in var_pattern.finditer(content):
                    variables.add(match.group(1))
            except Exception:
                continue
        # Try to filter only required variables (those without default)
        required_vars = set()
        for tf_file in tf_files:
            try:
                with open(tf_file, 'r') as f:
                    lines = f.readlines()
                var_name = None
                has_default = False
                for line in lines:
                    if line.strip().startswith('variable'):
                        m = re.match(r'variable\s+"([^"]+)"', line.strip())
                        if m:
                            var_name = m.group(1)
                            has_default = False
                    elif var_name and 'default' in line:
                        has_default = True
                    elif var_name and line.strip() == '}':
                        if not has_default:
                            required_vars.add(var_name)
                        var_name = None
                        has_default = False
            except Exception:
                continue
        # If we found required vars, use them, else all found
        return list(required_vars) if required_vars else list(variables)
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
List the required input variables for this module as a Python list of strings. Only include variable names, no descriptions.
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
        # Pass variables as an object
        code = f'''module "{resource_name}" {{
  source  = "{module['registry']}"
  for_each = {{ "{resource_name}" = var.{resource_name}_vars }}
  # Pass all variables as an object
  # Example: ... = each.value.<var>
}}
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
            max_iterations=5
        )
        orchestrator.run()
    else:
        main(
            md_file="resources.md",  # or your input MD file
            avm_md_file="avm-resource-modules-terraform.md",
            output_dir="generated_tf"
        )
