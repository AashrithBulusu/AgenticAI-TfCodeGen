from utils.llm_utils import AzureOpenAIChat
import os

class LLMValidationAgent:
    def __init__(self):
        self.llm = AzureOpenAIChat()

    def validate_code(self, directory: str) -> str:
        tf_files = [f for f in os.listdir(directory) if f.endswith('.tf') or f.endswith('.tfvars')]
        code_blocks = []
        for fname in tf_files:
            with open(os.path.join(directory, fname), 'r') as f:
                code_blocks.append(f"File: {fname}\n" + f.read())
        code_str = '\n\n'.join(code_blocks)
        prompt = f"""
You are a Terraform expert. Review the following Terraform configuration files for errors, best practices, and completeness. If there are issues, explain them. If valid, say 'Valid'.

{code_str}
"""
        messages = [
            {"role": "system", "content": "You are a Terraform and Azure infrastructure expert."},
            {"role": "user", "content": prompt}
        ]
        result = self.llm.chat(messages, max_tokens=1024)
        return result.strip()
