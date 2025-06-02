import logging
from utils.llm_utils import AzureOpenAIChat
from agents.module_discovery_agent import ModuleDiscoveryAgent
from agents.module_discovery_agent import ModuleGitCloner
class CodeGenerationAgent:
    def _log(self, message, level="info"):
        logger = logging.getLogger("CodeGenerationAgent")
        if level == "debug":
            logger.debug(message)
        elif level == "warning":
            logger.warning(message)
        elif level == "error":
            logger.error(message)
        else:
            logger.info(message)
    def __init__(self):
        logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(name)s: %(message)s')
        self.llm = AzureOpenAIChat()
        self.module_discovery = ModuleDiscoveryAgent()
        self._log("Initialized CodeGenerationAgent and created AzureOpenAIChat and ModuleDiscoveryAgent instances.")

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
        self._log(f"[fix_code_with_validation] Sending validation errors for resource '{resource_name}' to LLM.")
        messages = [
            {"role": "system", "content": "You are a Terraform and Azure infrastructure expert."},
            {"role": "user", "content": prompt}
        ]
        code = self.llm.chat(messages, max_tokens=2048)
        self._log(f"[fix_code_with_validation] Received response from LLM for resource '{resource_name}'.", "debug")
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
        self._log(f"[fix_code_with_validation] Finished splitting LLM output for resource '{resource_name}'.", "debug")
        return main, var, out

    def generate_main_tf(self, resource_name: str) -> str:
        module = self.module_discovery.find_module(resource_name)
        if not module:
            self._log(f"[generate_main_tf] No module found for resource: {resource_name}, skipping.", "warning")
            return ""
        self._log(f"[generate_main_tf] Found module for resource '{resource_name}': {module}")
        self._log(f"[generate_main_tf] Asking ModuleGitCloner to fetch Terraform files for module '{module}'.")
        module_git_cloner = ModuleGitCloner(module=module)
        module_tf_content = module_git_cloner.fetch_tf_files_content()
        prompt = f"""
You are a Terraform expert. For the given Azure resource module, generate a main.tf block that:
- Uses a single object variable (e.g., {resource_name}_config) for all module inputs.
- Maps each module input to the corresponding attribute in the config object (e.g., name = var.{resource_name}_config.name).
- Uses the correct module source and version from the provided module dict.
- Output ONLY the Terraform code for the module block. Do NOT include any markdown, comments, explanations, or notes. Do NOT use triple backticks or any other formatting.
- Use the variables mentioned in the Module variable Terraform Code block below to define the module inputs in the module block.

Resource Name: {resource_name}
Module variable Terraform Code: {module_tf_content}
"""
        messages = [
            {"role": "system", "content": "You are a Terraform and Azure infrastructure expert."},
            {"role": "user", "content": prompt}
        ]
        self._log(f"[generate_main_tf] Sending prompt to LLM for resource '{resource_name}'.")
        code = self.llm.chat(messages)
        self._log(f"[generate_main_tf] Received response from LLM for resource '{resource_name}'.", "debug")
        code = code.strip()
        if code.startswith('```'):
            code = code.strip('`').replace('hcl', '').strip()
        code = '\n'.join([line for line in code.splitlines() if not line.strip().startswith('#') and 'Notes:' not in line and '<module-source>' not in line and '<module-version>' not in line])
        return code.strip()

    def generate_variables_tf(self, resource_name: str) -> str:
        module = self.module_discovery.find_module(resource_name)
        if not module:
            self._log(f"[generate_variables_tf] No module found for resource: {resource_name}, skipping.", "warning")
            return ""
        self._log(f"[generate_variables_tf] Found module for resource '{resource_name}': {module}")
        self._log(f"[generate_variables_tf] Asking ModuleGitCloner to fetch Terraform files for module '{module}'.")
        module_git_cloner = ModuleGitCloner(module=module)
        module_tf_content = module_git_cloner.fetch_tf_files_content()
        prompt = f"""
You are a Terraform expert. For the given Azure resource module, generate a variables.tf block that:
- Defines a single object variable named {resource_name}_config.
- The object type should include all required and optional input variables for the module, with correct types and a description.
- Output ONLY the Terraform code for the variable block. Do NOT include any markdown, comments, explanations, or notes. Do NOT use triple backticks or any other formatting.
- Use the variables mentioned in the Module variable Terraform Code block below to define the the variable block.

Resource Name: {resource_name}
Module variable Terraform Code: {module_tf_content}
"""
        messages = [
            {"role": "system", "content": "You are a Terraform and Azure infrastructure expert."},
            {"role": "user", "content": prompt}
        ]
        self._log(f"[generate_variables_tf] Sending prompt to LLM for resource '{resource_name}'.")
        code = self.llm.chat(messages)
        self._log(f"[generate_variables_tf] Received response from LLM for resource '{resource_name}'.", "debug")
        code = code.strip()
        if code.startswith('```'):
            code = code.strip('`').replace('hcl', '').strip()
        code = '\n'.join([line for line in code.splitlines() if not line.strip().startswith('#') and 'Notes:' not in line])
        return code.strip()

    def generate_outputs_tf(self, resource_name: str) -> str:
        module = self.module_discovery.find_module(resource_name)
        if not module:
            self._log(f"[generate_outputs_tf] No module found for resource: {resource_name}, skipping.", "warning")
            return ""
        self._log(f"[generate_outputs_tf] Found module for resource '{resource_name}': {module}")
        prompt = f"""
You are a Terraform expert. For the given Azure resource module, generate an outputs.tf block that:
- Exposes all outputs provided by the module, referencing them from the module block (e.g., value = module.{resource_name}.<output_name>).
- For each output, use the naming convention: output \"<module_name>_<output_name>\" (e.g., output \"network_security_group_id\" for module.network_security_group.id).
- Output ONLY the Terraform code for the outputs. Do NOT include any markdown, comments, explanations, or notes. Do NOT use triple backticks or any other formatting.

Resource Name: {resource_name}
Module: {module}
"""
        messages = [
            {"role": "system", "content": "You are a Terraform and Azure infrastructure expert."},
            {"role": "user", "content": prompt}
        ]
        self._log(f"[generate_outputs_tf] Sending prompt to LLM for resource '{resource_name}'.")
        code = self.llm.chat(messages)
        self._log(f"[generate_outputs_tf] Received response from LLM for resource '{resource_name}'.", "debug")
        code = code.strip()
        if code.startswith('```'):
            code = code.strip('`').replace('hcl', '').strip()
        # Post-process: rename outputs to module_name_output_name if not already
        lines = code.splitlines()
        new_lines = []
        for line in lines:
            if line.strip().startswith('output "'):
                import re
                m = re.match(r'output\s+"([^"]+)"', line.strip())
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
