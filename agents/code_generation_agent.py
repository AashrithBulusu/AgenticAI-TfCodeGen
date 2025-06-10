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
- Do NOT include any markdown, comments, explanations, or notes. Do NOT use triple backticks or any other formatting.
- Do NOT include any heredoc descriptions, markdown, explanations, or notes. Do NOT use triple backticks or any other formatting.
- Output ONLY the Terraform code for the variable block.
- Do NOT add any blank lines between attributes or blocks. The output should be compact.
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
- Do NOT include any markdown, comments, explanations, or notes. Do NOT use triple backticks or any other formatting.
- Do NOT include any heredoc descriptions, markdown, explanations, or notes. Do NOT use triple backticks or any other formatting.
- Output ONLY the Terraform code for the variable block.
- Do NOT add any blank lines between attributes or blocks. The output should be compact.
- Only refer to the variables from the module Code to build the module block, do not include any other variables or resources.
- Do not keep any variables in this output, only the module block.

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
        max_retries = 12
        code = ""
        for attempt in range(max_retries):
            if attempt == 0:
                prompt = f"""
You are a Terraform expert. For the given Azure resource module, generate a variables.tf block that:
- Defines a single object variable named {resource_name}_config.
- The object type should include all required and optional input variables for the module, with correct types.
- For EACH attribute in the object (including nested and map/object attributes), add a comment on the same line (using #) that explains:
    - What the attribute does (purpose)
    - Its type
    - Whether it is required or optional
    - Any default value or valid values, if applicable
- The comment must be placed immediately after the attribute definition, on the same line.
- For nested objects or maps, describe their structure and all their attributes in detail, using inline comments for each nested attribute as well.
- After the object type, add a single-line description for the variable (e.g., description = "Configuration object for the Azure {resource_name} resource.").
- Do NOT include any heredoc descriptions, markdown, explanations, or notes. Do NOT use triple backticks or any other formatting.
- Output ONLY the Terraform code for the variable block.
- Do NOT add any blank lines between attributes or blocks. The output should be compact.
- When generating code, always place any inline comment (description) immediately after the code on the same line.
- Do not split comments or descriptions across multiple lines. If a comment is too long, keep it concise and ensure it fits on a single line.
    - correct: `attribute = value # This is a comment`
    - incorrect: `attribute = value \n # This is a comment`
    - incorrect: `attribute = value # This is a very long comment 
    that should be concise and fit on one line`
- Never use the backtick character (`) anywhere in the output. Do not use triple backticks or any other markdown formatting.
- Only output valid Terraform code. Do not use any markdown, code block markers, or special formatting characters.

Resource Name: {resource_name}
Module: {module}
Module Code:
{module_code}
"""
            else:
                prompt = f"""
The following variable block is incomplete and cut off. Continue generating ONLY the remaining content to complete the block, starting exactly where it left off. Do not repeat any previous lines. Output ONLY the Terraform code, no markdown or comments. Do NOT add any blank lines between attributes or blocks.

Current incomplete variable block:
{code}
"""
            messages = [
                {"role": "system", "content": "You are a Terraform and Azure infrastructure expert. Always generate a FULL, non-truncated variable block with inline comments for every attribute and a single-line description at the end. If the block is cut off, CONTINUE generating until the block is closed."},
                {"role": "user", "content": prompt}
            ]
            new_code = self.llm.chat(messages)
            new_code = new_code.strip()
            if attempt == 0:
                code = new_code
            else:
                code += "\n" + new_code

            # Remove any markdown code block markers (``` or ```hcl) from the output
            lines = code.splitlines()
            cleaned_lines = [line for line in lines if not line.strip() in ("```", "```hcl")]
            code = "\n".join(cleaned_lines).strip()

            # Heuristic: check if all braces are closed and block ends with }
            open_braces = code.count('{')
            close_braces = code.count('}')
            if open_braces == close_braces and code.strip().endswith('}'):
                break

        # --- Deduplicate variable blocks and descriptions ---
        import re
        var_blocks = re.findall(r'(variable\s+"[^"]+"\s*{[\s\S]+?^})', code, flags=re.MULTILINE)
        if var_blocks:
            seen = set()
            deduped = []
            for block in var_blocks:
                m = re.match(r'variable\s+"([^"]+)"', block)
                if m:
                    varname = m.group(1)
                    if varname not in seen:
                        deduped.append(block.strip())
                        seen.add(varname)
            code = "\n".join(deduped)
        else:
            code = code.strip()

        # Remove repeated description lines
        lines = code.splitlines()
        desc_seen = set()
        final_lines = []
        for line in lines:
            if line.strip().startswith("# Description:"):
                if line.strip() in desc_seen:
                    continue
                desc_seen.add(line.strip())
            # Remove consecutive blank lines and all blank lines between attributes
            if line.strip() == "":
                continue
            final_lines.append(line)
        code = "\n".join(final_lines)

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