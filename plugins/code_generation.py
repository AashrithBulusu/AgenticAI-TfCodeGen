

from semantic_kernel.functions import kernel_function

import os
import requests
import subprocess
import socket
import time


class TerraformCodeGenerationAgent:
    @staticmethod
    def mcp_git_clone(repo_url, local_path):
        """
        Clone a git repo using MCP server (via Docker) or fallback to direct git clone.
        Returns (success: bool, error: str or None)
        If the repo_url is a Terraform Registry module URL, this will fail; caller should pass a real git repo URL.
        """
        mcp_url = os.environ.get("MCP_GIT_SERVER_URL", "http://localhost:5001/invoke")
        def is_port_open(host, port):
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                s.settimeout(1)
                try:
                    s.connect((host, port))
                    return True
                except Exception:
                    return False
        mcp_host = "localhost"
        mcp_port = 5001
        if not is_port_open(mcp_host, mcp_port):
            print("[INFO] MCP server not running, attempting to start MCP server via Docker...")
            try:
                # Remove any existing container using the same port/name to avoid exit status 125
                subprocess.run([
                    "docker", "rm", "-f", "mcp-server-git"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            except Exception:
                pass  # Ignore errors if container does not exist
            try:
                subprocess.run([
                    "docker", "run", "-d", "--name", "mcp-server-git", "-p", "5001:5001", "ghcr.io/modelcontextprotocol/mcp-server-git:main"
                ], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                for _ in range(10):
                    if is_port_open(mcp_host, mcp_port):
                        print("[INFO] MCP server started via Docker.")
                        break
                    time.sleep(1)
                else:
                    print("[WARN] MCP server did not start in time, will try direct git clone.")
            except Exception as docker_e:
                print(f"[WARN] Failed to start MCP server via Docker: {docker_e}")
        payload = {
            "function": "git.clone",
            "parameters": {
                "repo_url": repo_url,
                "dest": local_path,
                "depth": 1,
                "quiet": True
            }
        }
        try:
            resp = requests.post(mcp_url, json=payload, timeout=60)
            resp.raise_for_status()
            result = resp.json()
            return result.get("status") == "ok", result.get("error", "")
        except Exception as e:
            print(f"[WARN] MCP server unavailable, falling back to direct git clone: {e}")
            try:
                subprocess.run([
                    "git", "clone", "--depth", "1", repo_url, local_path
                ], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                return True, None
            except Exception as git_e:
                return False, f"MCP error: {e}; git error: {git_e}"

    @kernel_function(name="generate_main_tf", description="Generates main.tf code block for module or resource, clones modules, analyzes variables, and generates blocks with variable assignments.")
    def generate_main_tf(self, resource_name: str, module: dict, variables: list) -> str:
        """
        For each resource:
        - If module: clone the module using mcp_git_clone, parse variables from the module's code, and generate a module block with all variables assigned.
        - If not a module: generate a resource block, and assign all possible inputs as variables.
        """
        import glob
        import json
        import re
        print(f"[INFO] Generating main.tf code for resource: {resource_name}, module: {module}")
        code = ""
        # Helper to parse variables from all *.tf files in a Terraform module folder
        def parse_module_variables(module_path):
            tf_files = glob.glob(os.path.join(module_path, "*.tf"))
            var_blocks = []
            for tf_file in tf_files:
                with open(tf_file, "r") as f:
                    content = f.read()
                    # Remove commented lines and commented variable blocks
                    # Remove lines starting with #
                    lines = content.splitlines()
                    uncommented_lines = []
                    in_commented_block = False
                    for line in lines:
                        stripped = line.lstrip()
                        # Detect start of a commented variable block
                        if stripped.startswith('# variable "'):
                            in_commented_block = True
                        if in_commented_block:
                            # End block on closing }
                            if stripped.startswith('#') and '}' in stripped:
                                in_commented_block = False
                            continue
                        if stripped.startswith('#'):
                            continue
                        uncommented_lines.append(line)
                    uncommented_content = '\n'.join(uncommented_lines)
                    var_blocks += re.findall(r'variable\s+"([^"]+)"', uncommented_content)
            return [{"name": v} for v in set(var_blocks)]


        # Helper to fetch and parse argument list from Terraform Registry docs
        def fetch_registry_args(resource_type):
            import requests
            import re
            # Map resource_type to registry doc URL
            # e.g. azurerm_subnet -> https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
            if not resource_type.startswith("azurerm_"):
                return []
            slug = resource_type[len("azurerm_"):]
            url = f"https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/{slug}"
            try:
                resp = requests.get(url, timeout=20)
                resp.raise_for_status()
                html = resp.text
            except Exception as e:
                print(f"[WARN] Could not fetch registry doc for {resource_type}: {e}")
                return []
            # Find the Argument Reference section
            arg_section = ""
            m = re.search(r'<h2.*?>Argument Reference</h2>(.*?)<h2', html, re.DOTALL)
            if m:
                arg_section = m.group(1)
            else:
                # fallback: try to find <ul> after Argument Reference
                m = re.search(r'Argument Reference</h2>(.*?)</ul>', html, re.DOTALL)
                if m:
                    arg_section = m.group(1)
            if not arg_section:
                print(f"[WARN] Could not find Argument Reference for {resource_type}")
                return []
            # Find all argument names: <code>name</code> - (Required|Optional)
            arg_matches = re.findall(r'<li>\s*<code>([\w_]+)</code>\s*-\s*\((Required|Optional)', arg_section)
            args = []
            for name, req in arg_matches:
                args.append({"name": name, "required": req == "Required"})
            return args

        def parse_resource_inputs(module, resource_type=None):
            # If module has 'inputs' key, use it; else fallback to variables param
            if "inputs" in module and isinstance(module["inputs"], list):
                return [{"name": v} if isinstance(v, str) else v for v in module["inputs"]]
            # If resource_type is provided, fetch from registry
            if resource_type:
                return fetch_registry_args(resource_type)
            return variables if variables else []

        # Determine if this is a module or a resource (module if registry is not a resource type)
        registry_url = module.get("registry", "")
        is_module = not module.get("type") and bool(registry_url)

        if is_module:
            # Always use the 'source' field for cloning, never the registry URL
            import tempfile
            repo_url = module.get("source")
            if not repo_url:
                print(f"[WARN] No source field found for module {resource_name}")
                return f"# No source field found for module {resource_name}\n"
            with tempfile.TemporaryDirectory() as tmpdir:
                success, error = self.mcp_git_clone(repo_url, tmpdir)
                if not success:
                    print(f"[WARN] Failed to clone module {repo_url}: {error}")
                    return f"# Failed to clone module {repo_url}: {error}\n"
                module_vars = parse_module_variables(tmpdir)
                # Fix source: convert registry url to short source string
                registry_url = module.get("registry", "")
                source = registry_url
                if registry_url.startswith("https://registry.terraform.io/modules/"):
                    # Remove prefix and possible /latest or /x.y.z suffix
                    source = registry_url[len("https://registry.terraform.io/modules/"):]
                    # Remove trailing /latest or /<version>
                    source = source.rsplit("/", 1)[0] if source.endswith("/latest") or source.split("/")[-1].replace('.', '').isdigit() else source
                version = module.get("version", "")
                version_line = f'  version = "{version}"' if version else ""
                # Use var.<resource_name>_vars.<varname> for each variable
                var_lines = "\n".join([
                    f'  {v["name"]} = var.{resource_name}_vars.{v["name"]}' for v in module_vars if "name" in v
                ])
                source_line = f'  source = "{source}"' if source else ""
                code = f'module "{resource_name}" {{\n{source_line}\n{version_line}\n{var_lines}\n}}\n'
                print(f"[INFO] Generated module block for {resource_name}:\n{code}")
                return code
        else:
            # Not a module, generate resource block
            resource_type = module.get("type", "")
            if not resource_type:
                # Try to infer resource type from resource_name (e.g., subnet -> azurerm_subnet)
                inferred_type = f"azurerm_{resource_name}"
                # Fetch argument schema from Terraform Registry dynamically
                resource_inputs = parse_resource_inputs(module, resource_type=inferred_type)
                if not resource_inputs:
                    # fallback to minimal
                    resource_inputs = [{"name": "name"}, {"name": "resource_group_name"}, {"name": "location"}]
                var_lines = "\n".join([
                    f'  {v["name"]} = var.{resource_name}_vars.{v["name"]}' for v in resource_inputs if "name" in v
                ])
                code = f'resource "{inferred_type}" "{resource_name}" {{\n{var_lines}\n}}\n'
                print(f"[INFO] Generated resource block for {resource_name} (inferred {inferred_type}):\n{code}")
                return code
            # Get all possible inputs for the resource
            resource_inputs = parse_resource_inputs(module, resource_type=resource_type)
            var_lines = "\n".join([
                f'  {v["name"]} = var.{v["name"]}' for v in resource_inputs if "name" in v
            ])
            code = f'resource "{resource_type}" "{resource_name}" {{\n{var_lines}\n}}\n'
            print(f"[INFO] Generated resource block for {resource_name}:\n{code}")
            return code

    @kernel_function(name="generate_variables_tf", description="Generates variables.tf block for a module")
    def generate_variables_tf(self, resource_name: str, variables: list) -> str:
        """
        Generates variables.tf content for a module.
        """
        print(f"[INFO] Generating variables.tf for resource: {resource_name}")
        if not variables or not isinstance(variables, list):
            return ""
        blocks = []
        for v in variables:
            if isinstance(v, dict) and "name" in v:
                blocks.append(f'variable "{v["name"]}" {{\n  type = string\n}}')
        code = "\n\n".join(blocks)
        print(f"[INFO] Generated variables.tf for {resource_name}:\n{code}")
        return code

    @kernel_function(name="generate_outputs_tf", description="Generates outputs.tf block for a module")
    def generate_outputs_tf(self, resource_name: str, outputs: list) -> str:
        """
        Generates outputs.tf content for a module.
        """
        print(f"[INFO] Generating outputs.tf for resource: {resource_name}")
        if not outputs or not isinstance(outputs, list):
            return ""
        blocks = []
        for o in outputs:
            if isinstance(o, dict) and "name" in o:
                blocks.append(f'output "{o["name"]}" {{\n  value = module.{resource_name}.{o["name"]}\n}}')
        code = "\n\n".join(blocks)
        print(f"[INFO] Generated outputs.tf for {resource_name}:\n{code}")
        return code
