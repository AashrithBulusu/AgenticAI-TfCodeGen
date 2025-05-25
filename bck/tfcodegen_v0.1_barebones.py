
# Multi-Agent Terraform Code Generator for Azure using AVM Modules
# Skeleton for Semantic Kernel integration
import os
import re
import subprocess
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
    def __init__(self, avm_md_path: str):
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
    """Generates variablized Terraform code for a resource/module."""
    def generate(self, module: Dict[str, str], resource_name: str) -> str:
        # Placeholder: In production, use LLM or template engine
        code = f'''module "{resource_name}" {{
  source  = "{module['registry']}"
  # TODO: Add required variables
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
        # Placeholder: In production, extract variables from module spec
        tfvars.append(f'{res}_example_var')

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
    # Example usage
    main(
        md_file="resources.md",  # or your input MD file
        avm_md_file="avm-resource-modules-terraform.md",
        output_dir="generated_tf"
    )
