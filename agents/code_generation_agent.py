from utils.llm_utils import AzureOpenAIChat
from agents.module_discovery_agent import ModuleDiscoveryAgent

class CodeGenerationAgent:
    def __init__(self):
        self.llm = AzureOpenAIChat()
        self.module_discovery = ModuleDiscoveryAgent()

    def fix_code_with_validation(self, resource_name: str, validation_output: str, main_code: str, var_code: str, out_code: str) -> tuple:
        """
        Use LLM to fix the generated code based on validation errors.
        Returns (main_code, var_code, out_code) after attempted fix.
        """
        prompt = f"""
You are a Terraform and Azure expert. The following Terraform code for resource '{resource_name}' has validation errors. Your job is to fix the code so that it passes validation. Only output the corrected code blocks, no explanations or markdown.

Validation errors:
{validation_output}

Current main.tf block:
{main_code}

Current variables.tf block:
{var_code}

Current outputs.tf block:
{out_code}
"""
        messages = [
            {"role": "system", "content": "You are a Terraform and Azure infrastructure expert."},
            {"role": "user", "content": prompt}
        ]
        code = self.llm.chat(messages, max_tokens=2048)
        # Try to split the code into main, var, and output blocks by simple heuristics
        main, var, out = main_code, var_code, out_code
        # Heuristic: look for 'module', 'variable', 'output' keywords
        import re
        blocks = re.split(r'(?=^module\s+|^variable\s+|^output\s+)', code, flags=re.MULTILINE)
        for block in blocks:
            if block.strip().startswith('module '):
                main = block.strip()
            elif block.strip().startswith('variable '):
                var = block.strip()
            elif block.strip().startswith('output '):
                out = out.strip() + '\n' + block.strip()
        return main, var, out

    def generate_main_tf(self, resource_name: str) -> str:
        module = self.module_discovery.find_module(resource_name)
        if not module:
            print(f"[generate_main_tf] No module found for resource: {resource_name}, skipping.")
            return ""
        module_code = self.get_module_code(module)
        prompt = f"""
You are a Terraform expert. For the given Azure resource module, generate a main.tf block that:
- Uses a single object variable (e.g., {resource_name}_config) for all module inputs.
- Maps each module input to the corresponding attribute in the config object (e.g., name = var.{resource_name}_config.name).
- Uses the correct module source and version from the provided module dict.
- Output ONLY the Terraform code for the module block. Do NOT include any markdown, comments, explanations, or notes. Do NOT use triple backticks or any other formatting.

Resource Name: {resource_name}
Module: {module}
Module Code:\n{module_code}
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

    def generate_variables_tf(self, resource_name: str) -> str:
        module = self.module_discovery.find_module(resource_name)
        if not module:
            print(f"[generate_variables_tf] No module found for resource: {resource_name}, skipping.")
            return ""
        module_code = self.get_module_code(module)
        prompt = f"""
You are a Terraform expert. For the given Azure resource module, generate a variables.tf block that:
- Defines a single object variable named {resource_name}_config.
- The object type should include all required and optional input variables for the module, with correct types.
- The variable MUST have a heredoc description (using <<DESCRIPTION ... DESCRIPTION) that lists and explains EVERY attribute in the object, including whether it is required or optional, its type, and its purpose. Do NOT use a one-line description.
- The heredoc description MUST mention EVERY attribute in the object, in the same order as in the object type.
- The heredoc description MUST always be closed with a line containing only DESCRIPTION (no other characters or brackets on that line). 
- Never start a new variable block until the heredoc description is closed.
- The variable block must then be closed after the heredoc is closed with a closing curly bracket on the next line.
- Output ONLY the Terraform code for the variable block. Do NOT include any markdown, comments, explanations, or notes. Do NOT use triple backticks or any other formatting.

Resource Name: {resource_name}
Module: {module}
Module Code:\n{module_code}
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
        # Ensure heredoc is closed before the variable block ends
        if '<<DESCRIPTION' in code:
            heredoc_starts = [i for i, line in enumerate(code.splitlines()) if '<<DESCRIPTION' in line]
            heredoc_ends = [i for i, line in enumerate(code.splitlines()) if line.strip() == 'DESCRIPTION']
            if len(heredoc_ends) < len(heredoc_starts):
                code += '\nDESCRIPTION'
        # Remove DESCRIPTION lines that appear after a closing curly brace
        import re
        code = re.sub(r'\}\s*\nDESCRIPTION', '}', code)
        # Ensure every DESCRIPTION is followed by a closing }
        lines = code.splitlines()
        fixed_lines = []
        for i, line in enumerate(lines):
            fixed_lines.append(line)
            if line.strip() == 'DESCRIPTION':
                # If next non-empty line is not '}', insert it
                j = i + 1
                while j < len(lines) and lines[j].strip() == '':
                    j += 1
                if j >= len(lines) or lines[j].strip() != '}':
                    fixed_lines.append('}')
        code = '\n'.join(fixed_lines)
        return code.strip()

    def generate_outputs_tf(self, resource_name: str) -> str:
        module = self.module_discovery.find_module(resource_name)
        if not module:
            print(f"[generate_outputs_tf] No module found for resource: {resource_name}, skipping.")
            return ""
        module_code = self.get_module_code(module)
        prompt = f"""
You are a Terraform expert. For the given Azure resource module, generate an outputs.tf block that:
- Exposes all outputs provided by the module, referencing them from the module block (e.g., value = module.{resource_name}.<output_name>).
- For each output, use the naming convention: output \"<module_name>_<output_name>\" (e.g., output \"network_security_group_id\" for module.network_security_group.id).
- Output ONLY the Terraform code for the outputs. Do NOT include any markdown, comments, explanations, or notes. Do NOT use triple backticks or any other formatting.

Resource Name: {resource_name}
Module: {module}
Module Code:\n{module_code}
"""
        messages = [
            {"role": "system", "content": "You are a Terraform and Azure infrastructure expert."},
            {"role": "user", "content": prompt}
        ]
        code = self.llm.chat(messages)
        code = code.strip()
        if code.startswith('```'):
            code = code.strip('`').replace('hcl', '').strip()
        # Post-process: rename outputs to module_name_output_name if not already
        lines = code.splitlines()
        new_lines = []
        for line in lines:
            if line.strip().startswith('output "'):
                import re
                m = re.match(r'output\\s+\"([^\"]+)\"', line.strip())
                if m:
                    orig_name = m.group(1)
                    if orig_name.startswith(f"{resource_name}_"):
                        new_lines.append(line)
                    else:
                        new_lines.append(line.replace(f'output "{orig_name}"', f'output "{resource_name}_{orig_name}"'))
                else:
                    new_lines.append(line)
            else:
                new_lines.append(line)
        code = '\n'.join([line for line in new_lines if not line.strip().startswith('#') and 'Notes:' not in line])
        return code.strip()

    def get_module_code(self, module: dict) -> str:
        """
        Clone the module repo (if not already cloned), combine all .tf files into a single string, and return it.
        """
        import os
        import tempfile
        import shutil
        import glob
        import git

        repo_url = module.get('source')
        if not repo_url:
            print(f"[get_module_code] No source repo found for module: {module.get('name')}")
            return ""
        # Use a temp dir for cloning
        temp_dir = tempfile.mkdtemp(prefix="avm_module_")
        try:
            print(f"[get_module_code] Cloning {repo_url} to {temp_dir}")
            git.Repo.clone_from(repo_url, temp_dir, depth=1)
            # Only look for main.tf, variables.tf, outputs.tf in the top-level directory
            tf_files = []
            for fname in ["main.tf", "variables.tf", "outputs.tf"]:
                fpath = os.path.join(temp_dir, fname)
                if os.path.isfile(fpath):
                    tf_files.append(fpath)
            tf_code = ""
            for tf_file in tf_files:
                with open(tf_file, "r", encoding="utf-8") as f:
                    tf_code += f.read() + "\n"
            return tf_code
        except Exception as e:
            print(f"[get_module_code] Error cloning or reading module: {e}")
            return ""
        finally:
            shutil.rmtree(temp_dir, ignore_errors=True)