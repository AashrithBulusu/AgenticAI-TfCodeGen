from utils.llm_utils import AzureOpenAIChat
import os

class LLMValidationAgent:
    def __init__(self):
        self.llm = AzureOpenAIChat()

    def validate_code(self, directory: str, validation_str: str) -> str:
        tf_files = [f for f in os.listdir(directory) if f.endswith('.tf') or f.endswith('.tfvars')]
        code_blocks = []
        for fname in tf_files:
            with open(os.path.join(directory, fname), 'r') as f:
                code_blocks.append(f"File: {fname}\n" + f.read())
        code_str = '\n\n'.join(code_blocks)
        prompt = f"""
You are a Terraform expert. Review the following Terraform configuration files for errors, best practices, and completeness. 
If there are issues, explain them. If valid, say 'Valid'.

- Add different sections to the result, 
  - AI Review
    - Errors
    - Best Practices: Suggest improvements based on Terraform best practices.
    - Completeness: Check if all necessary resources and configurations are present.
  - AI Explanation of Linting Issues and how to Fix.
    - Provide a detailed summary of each linting issue found, including how to fix it.

- Return the result in markdown format with appropriate headings. DO not Use ```markdown blocks.

source code : {code_str}

Validation Output : {validation_str}
"""
        messages = [
            {"role": "system", "content": "You are a Terraform and Azure infrastructure expert."},
            {"role": "user", "content": prompt}
        ]
        result = self.llm.chat(messages, max_tokens=1024)
        return result.strip()
