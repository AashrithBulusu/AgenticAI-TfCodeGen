import re
import asyncio
from utils.llm_utils import AzureOpenAIChat


class TFVarsGeneratorAgent:
    def __init__(self):
        self.llm = AzureOpenAIChat()

    @staticmethod
    def extract_variable_blocks(variables_tf_content: str):
        # Robustly extract each variable block, handling nested braces
        blocks = []
        lines = variables_tf_content.splitlines()
        inside = False
        brace_count = 0
        current_block = []
        for line in lines:
            if line.strip().startswith('variable '):
                inside = True
                brace_count = 0
                current_block = [line]
                # Count braces on the first line
                brace_count += line.count('{') - line.count('}')
                continue
            if inside:
                current_block.append(line)
                brace_count += line.count('{') - line.count('}')
                if brace_count == 0:
                    blocks.append('\n'.join(current_block))
                    inside = False
        return blocks

    async def generate_tfvars_for_block(self, var_block: str) -> str:
        max_retries = 5
        code = ""
        for attempt in range(max_retries):
            if attempt == 0:
                prompt = f"""
You are a Terraform expert. Given the following Terraform variable block, generate a tfvars assignment with realistic example values for EVERY attribute (required and optional, including all nested and map/object attributes). Output ONLY the tfvars assignment, no markdown or comments. The assignment MUST be syntactically complete and close all braces.

Variable block:
{var_block}
"""
            else:
                # Ask the LLM to continue from the last incomplete output
                prompt = f"""
The following tfvars assignment is incomplete and cut off. Continue generating ONLY the remaining content to complete the assignment, starting exactly where it left off. Do not repeat any previous lines. Output ONLY the tfvars content, no markdown or comments.

Current incomplete tfvars assignment:
{code}
"""
            messages = [
                {"role": "system", "content": "You are a Terraform and Azure infrastructure expert."},
                {"role": "user", "content": prompt}
            ]
            new_code = await asyncio.to_thread(self.llm.chat, messages, max_tokens=2048)
            new_code = new_code.strip()
            if attempt == 0:
                code = new_code
            else:
                # Append only the new content
                code += "\n" + new_code

            open_braces = code.count('{')
            close_braces = code.count('}')
            if open_braces == close_braces and code.endswith('}'):
                return code
        # Return the last attempt even if incomplete
        return code

    @staticmethod
    async def generate_tfvars_file(agent, variables_tf_path: str, tfvars_path: str):
        with open(variables_tf_path, "r", encoding="utf-8") as f:
            variables_tf_content = f.read()

        var_blocks = TFVarsGeneratorAgent.extract_variable_blocks(variables_tf_content)
        tfvars_blocks = []
        for block in var_blocks:
            tfvars_block = await agent.generate_tfvars_for_block(block)
            tfvars_blocks.append(tfvars_block)

        with open(tfvars_path, "w", encoding="utf-8") as f:
            f.write("\n\n".join(tfvars_blocks))

        print(f"terraform.tfvars generated at {tfvars_path}")
