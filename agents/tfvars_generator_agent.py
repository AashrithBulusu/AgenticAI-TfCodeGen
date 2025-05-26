from utils.llm_utils import AzureOpenAIChat


class TFVarsGeneratorAgent:
    def __init__(self):
        self.llm = AzureOpenAIChat()

    async def generate_tfvars(self, resource_name: str, variables: list) -> str:
        prompt = f"""
You are a Terraform expert. Given the following variable schema for {resource_name}_config, generate a terraform.tfvars block with realistic example values for each attribute. Output only the tfvars content, no markdown or comments.

Variable schema:
{variables}
"""
        messages = [
            {"role": "system", "content": "You are a Terraform and Azure infrastructure expert."},
            {"role": "user", "content": prompt}
        ]
        code = self.llm.chat(messages)
        return code.strip()

    @staticmethod
    def extract_schema(var_name: str, tf_content: str) -> str:
        import re
        # Find the variable block for the given var_name
        pattern = rf'variable\\s+"{var_name}"\\s*{{(.*?)^}}'  # non-greedy match
        match = re.search(pattern, tf_content, re.DOTALL | re.MULTILINE)
        if match:
            return f'variable "{var_name}" {{{match.group(1)}}}'
        return ""

    async def extract_schema_llm(self, var_name: str, tf_content: str) -> str:
        prompt = f"""
You are a Terraform expert. Given the following variables.tf file content, extract and return ONLY the full variable block for the variable named \"{var_name}\". Do not include any explanations, markdown, or extra text.

variables.tf content:
{tf_content}
"""
        messages = [
            {"role": "system", "content": "You are a Terraform and Azure infrastructure expert."},
            {"role": "user", "content": prompt}
        ]
        code = self.llm.chat(messages)
        return code.strip()

    @staticmethod
    async def generate_tfvars_file(agent, variables_tf_path: str, tfvars_path: str, config_names: list):
        # Read the variables.tf file
        with open(variables_tf_path, "r", encoding="utf-8") as f:
            variables_tf_content = f.read()
        tfvars_blocks = []
        for name in config_names:
            schema = TFVarsGeneratorAgent.extract_schema(name, variables_tf_content)
            if not schema:
                continue
            tfvars_block = await agent.generate_tfvars(name, schema)
            tfvars_blocks.append(tfvars_block)
        # Write the combined tfvars to file
        with open(tfvars_path, "w", encoding="utf-8") as f:
            f.write("\n\n".join(tfvars_blocks))
        print(f"terraform.tfvars generated at {tfvars_path}")

    @staticmethod
    async def generate_tfvars_file_llm(agent, variables_tf_content: str, tfvars_path: str, config_names: list):
        tfvars_blocks = []
        for name in config_names:
            schema = await agent.extract_schema_llm(name, variables_tf_content)
            if not schema:
                continue
            tfvars_block = await agent.generate_tfvars(name, schema)
            tfvars_blocks.append(tfvars_block)
        with open(tfvars_path, "w", encoding="utf-8") as f:
            f.write("\n\n".join(tfvars_blocks))
        print(f"terraform.tfvars generated at {tfvars_path}")
