from utils.llm_utils import AzureOpenAIChat

class CodeGenerationAgent:
    def __init__(self):
        self.llm = AzureOpenAIChat()

    def generate_main_tf(self, resource_name: str, module: dict, variables: list) -> str:
        prompt = f"""
You are a Terraform expert. For the given Azure resource module, generate a main.tf block that:
- Uses a single object variable (e.g., {resource_name}_config) for all module inputs.
- Maps each module input to the corresponding attribute in the config object (e.g., name = var.{resource_name}_config.name).
- Uses the correct module source and version from the provided module dict.
- Output ONLY the Terraform code for the module block. Do NOT include any markdown, comments, explanations, or notes. Do NOT use triple backticks or any other formatting.

Resource Name: {resource_name}
Module: {module}
"""
        messages = [
            {"role": "system", "content": "You are a Terraform and Azure infrastructure expert."},
            {"role": "user", "content": prompt}
        ]
        code = self.llm.chat(messages)
        code = code.strip()
        if code.startswith('```'):
            code = code.strip('`').replace('hcl', '').strip()
        code = '\n'.join([line for line in code.splitlines() if not line.strip().startswith('#') and 'Notes:' not in line and '<module-source>' not in line and '<module-version>' not in line])
        return code.strip()

    def generate_variables_tf(self, resource_name: str, module: dict) -> str:
        prompt = f"""
You are a Terraform expert. For the given Azure resource module, generate a variables.tf block that:
- Defines a single object variable named {resource_name}_config.
- The object type should include all required and optional input variables for the module, with correct types and a description.
- Output ONLY the Terraform code for the variable block. Do NOT include any markdown, comments, explanations, or notes. Do NOT use triple backticks or any other formatting.

Resource Name: {resource_name}
Module: {module}
"""
        messages = [
            {"role": "system", "content": "You are a Terraform and Azure infrastructure expert."},
            {"role": "user", "content": prompt}
        ]
        code = self.llm.chat(messages)
        code = code.strip()
        if code.startswith('```'):
            code = code.strip('`').replace('hcl', '').strip()
        code = '\n'.join([line for line in code.splitlines() if not line.strip().startswith('#') and 'Notes:' not in line])
        return code.strip()

    def generate_outputs_tf(self, resource_name: str, module: dict) -> str:
        prompt = f"""
You are a Terraform expert. For the given Azure resource module, generate an outputs.tf block that:
- Exposes all outputs provided by the module, referencing them from the module block (e.g., value = module.{resource_name}.<output_name>).
- Output ONLY the Terraform code for the outputs. Do NOT include any markdown, comments, explanations, or notes. Do NOT use triple backticks or any other formatting.

Resource Name: {resource_name}
Module: {module}
"""
        messages = [
            {"role": "system", "content": "You are a Terraform and Azure infrastructure expert."},
            {"role": "user", "content": prompt}
        ]
        code = self.llm.chat(messages)
        code = code.strip()
        if code.startswith('```'):
            code = code.strip('`').replace('hcl', '').strip()
        code = '\n'.join([line for line in code.splitlines() if not line.strip().startswith('#') and 'Notes:' not in line])
        return code.strip()
