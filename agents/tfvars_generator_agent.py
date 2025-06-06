import re
import asyncio
import logging
from utils.llm_utils import AzureOpenAIChat

logger = logging.getLogger(__name__)

class TFVarsGeneratorAgent:
    def __init__(self):
        self.llm = AzureOpenAIChat()

    @staticmethod
    def extract_object_type_block(var_block: str) -> str:
        """
        Extracts the object type definition from a Terraform variable block.
        """
        match = re.search(r'type\s*=\s*object\s*\((\{.*\})\)', var_block, re.DOTALL)
        if match:
            return match.group(1).strip()
        return ""

    async def generate_tfvars(self, resource_name: str, object_type: str) -> str:
        prompt = f"""
You are a Terraform expert. Given the following object type schema for {resource_name}_config, generate a terraform.tfvars assignment with realistic example values for each attribute. Output ONLY the tfvars assignment (e.g., {resource_name}_config = {{ ... }}), no markdown or comments.

Object type schema:
{object_type}
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

    @staticmethod
    def extract_resource_variables(resource_name: str, variables_tf_content: str) -> str:
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
            var_block = TFVarsGeneratorAgent.extract_schema(name, variables_tf_content)
            if not var_block:
                continue
            object_type = TFVarsGeneratorAgent.extract_object_type_block(var_block)
            if not object_type:
                logger.warning(f"Could not extract object type for {name}")
                continue
            tfvars_block = await agent.generate_tfvars(name, object_type)
            tfvars_blocks.append(tfvars_block)
        with open(tfvars_path, "w", encoding="utf-8") as f:
            f.write("\n\n".join(tfvars_blocks))
        print(f"terraform.tfvars generated at {tfvars_path}")
