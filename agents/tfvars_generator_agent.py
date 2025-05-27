import re
import asyncio
import logging
from utils.llm_utils import AzureOpenAIChat

logger = logging.getLogger(__name__)

class TFVarsGeneratorAgent:
    def __init__(self):
        self.llm = AzureOpenAIChat()

    async def generate_tfvars(self, resource_name: str, variables: str) -> str:
        prompt = f"""
You are a Terraform expert. Given the following variable schema for {resource_name}_config, generate a terraform.tfvars block with realistic example values for each attribute. Output ONLY the tfvars content with no markdown or comments.

Variable schema:
{variables}
"""
        messages = [
            {"role": "system", "content": "You are a Terraform and Azure infrastructure expert."},
            {"role": "user", "content": prompt}
        ]

        code = await asyncio.to_thread(self.llm.chat, messages)
        return code.strip()

    @staticmethod
    def extract_schema(var_name: str, tf_content: str) -> str:
        pattern = rf'variable\s+"{var_name}"\s*{{.*?^\s*}}'
        match = re.search(pattern, tf_content, re.DOTALL | re.MULTILINE)
        if match:
            return match.group(0).strip()
        logger.warning(f"Variable '{var_name}' not found in variables.tf")
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

        code = await asyncio.to_thread(self.llm.chat, messages)
        return code.strip()

    @staticmethod
    def extract_resource_variables(resource_name: str, variables_tf_content: str) -> str:
        """
        Extracts all variable blocks relevant to a given resource from the variables.tf content.

        Args:
            resource_name (str): The name of the resource (e.g., 'network_security_group').
            variables_tf_content (str): The content of the variables.tf file.

        Returns:
            str: Combined string of variable blocks relevant to the resource.
        """
        pattern = rf'variable\s+"({resource_name}_[^"]+)"\s*{{.*?^\s*}}'
        matches = re.findall(pattern, variables_tf_content, re.DOTALL | re.MULTILINE)
        blocks = []
        for var_name in matches:
            block = TFVarsGeneratorAgent.extract_schema(var_name, variables_tf_content)
            if block:
                blocks.append(block)
        if not blocks:
            logger.warning(f"No matching variables found for resource '{resource_name}' in variables.tf")
        return "\n\n".join(blocks)

    @staticmethod
    async def generate_tfvars_file(agent, variables_tf_path: str, tfvars_path: str, config_names: list):
        with open(variables_tf_path, "r", encoding="utf-8") as f:
            variables_tf_content = f.read()
        tfvars_blocks = []
        for name in config_names:
            schema = TFVarsGeneratorAgent.extract_schema(name, variables_tf_content)
            if not schema:
                continue
            tfvars_block = await agent.generate_tfvars(name, schema)
            tfvars_blocks.append(tfvars_block)
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
