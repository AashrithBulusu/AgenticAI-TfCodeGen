"""
tfcodegen_new.py

A robust, modular, and secure Terraform code generator for Azure using AVM modules, MCP servers, and Semantic Kernel.
References:
- MCP servers: https://github.com/modelcontextprotocol/servers
- Semantic Kernel Python samples: https://github.com/microsoft/semantic-kernel/tree/main/python/samples

Author: [Your Name]
Date: [Today's Date]
"""

import os
import re
import logging
import datetime
import asyncio
import requests
import tempfile
import subprocess
from typing import List, Dict, Any, Optional

# --- Load .env for secrets (if present) ---
try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass



# Semantic Kernel >=1.0 imports (pydantic >=2 compatible)
from semantic_kernel.kernel import Kernel
from semantic_kernel.connectors.ai.open_ai import AzureChatCompletion
from semantic_kernel.connectors.ai.open_ai import AzureOpenAIConfig
from semantic_kernel.kernel_builder import KernelBuilder
from semantic_kernel.functions.kernel_function_decorator import kernel_function

# --- Terraform Skill Functions for SK 1.x ---
import asyncio
from plugins.generate_variables_tf import generate_variables_tf
from plugins.generate_outputs_tf import generate_outputs_tf
from plugins.fix_terraform_code import fix_terraform_code

# --- Logging Setup ---
def setup_logging():
    log_filename = f'tfcodegen_log.log'
    logging.basicConfig(
        filename=log_filename,
        filemode='w',
        level=logging.INFO,
        format='%(asctime)s %(levelname)s %(message)s'
    )
    console = logging.StreamHandler()
    console.setLevel(logging.INFO)
    formatter = logging.Formatter('%(asctime)s %(levelname)s %(message)s')
    console.setFormatter(formatter)
    logging.getLogger('').addHandler(console)

setup_logging()

# --- Utility Functions ---
def get_env_var(name: str, required: bool = True) -> str:
    value = os.environ.get(name)
    if required and not value:
        logging.error(f"Missing required environment variable: {name}")
        raise EnvironmentError(f"Missing required environment variable: {name}")
    return value

# --- Agents ---

class ResourceExtractionAgent:
    """Extracts Azure resources from a Markdown file."""
    def extract(self, md_path: str) -> List[str]:
        resources = []
        try:
            with open(md_path, 'r') as f:
                for line in f:
                    match = re.match(r'- ([a-zA-Z0-9_\-]+)', line.strip())
                    if match:
                        resources.append(match.group(1))
        except Exception as e:
            logging.error(f"Failed to extract resources: {e}")
        return resources

class AVMModuleCatalogFetcher:
    """Fetches and parses AVM Terraform modules from the public index."""
    TERRAFORM_URL = "https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/"

    @staticmethod
    def fetch_html(url: str) -> str:
        try:
            resp = requests.get(url, timeout=30)
            resp.raise_for_status()
            return resp.text
        except Exception as e:
            logging.error(f"Error fetching {url}: {e}")
            return ""

    @classmethod
    def get_terraform_modules(cls) -> dict:
        html = cls.fetch_html(cls.TERRAFORM_URL)
        rows = html.split('<tr')
        modules = {}
        for row in rows:
            if '<td style=text-align:right>' not in row or '<a href=' not in row:
                continue
            url_match = re.search(r'<a\s+href=([^>]+)>([^<]+)</a>', row)
            if not url_match:
                continue
            registry_url = url_match.group(1)
            module_name = url_match.group(2)
            if not module_name.startswith('avm-res-'):
                continue
            source_url_match = re.search(r'<td\s+style=text-align:center><a\s+href=([^"\s]+)', row)
            source_url = source_url_match.group(1) if source_url_match else ""
            display_name_match = re.search(r'<b>([^<]+)</b>', row)
            display_name = display_name_match.group(1) if display_name_match else module_name
            version_match = re.search(r'Available%20%f0%9f%9f%a2-([0-9\.]+)-purple', row)
            if version_match:
                version = version_match.group(1)
                if module_name not in modules:
                    modules[module_name] = {
                        'name': module_name,
                        'display_name': display_name,
                        'version': version,
                        'registry': registry_url,
                        'source': source_url,
                        'status': 'Available'
                    }
        return modules

class ModuleDiscoveryAgent:
    """Maps resources to AVM Terraform modules using the live AVM catalog."""
    def __init__(self):
        self.module_map = AVMModuleCatalogFetcher.get_terraform_modules()

    def find_module(self, resource: str) -> Optional[Dict[str, str]]:
        resource_key = resource.replace('_', '').replace('-', '').lower()
        for mod in self.module_map.values():
            mod_key = mod['name'].replace('avm-res-', '').replace('-', '').replace('_', '').lower()
            if resource_key == mod_key:
                return mod
        for mod in self.module_map.values():
            mod_key = mod['name'].replace('avm-res-', '').replace('-', '').replace('_', '').lower()
            if resource_key in mod_key or mod_key in resource_key:
                return mod
        return None


class ValidationAgent:
    """Validates Terraform code using 'terraform validate'."""
    def validate_with_errors(self, tf_dir: str) -> tuple:
        try:
            result = subprocess.run(['terraform', 'validate'], cwd=tf_dir, capture_output=True, text=True)
            return result.returncode == 0, result.stderr
        except Exception as e:
            logging.error(f"Validation error: {e}")
            return False, str(e)

# --- Orchestrator ---


class MCPTerraformOrchestrator:
    def __init__(self, md_file: str, output_dir: str, max_iterations: int = 3):
        self.md_file = md_file
        self.output_dir = output_dir
        self.max_iterations = max_iterations
        self.resource_agent = ResourceExtractionAgent()
        self.module_agent = ModuleDiscoveryAgent()
        deployment_name = get_env_var("AZURE_OPENAI_DEPLOYMENT_NAME")
        api_key = get_env_var("AZURE_OPENAI_API_KEY")
        base_url = get_env_var("AZURE_OPENAI_ENDPOINT")

        # Build kernel using KernelBuilder (Semantic Kernel >=1.0)
        builder = KernelBuilder()
        azure_config = AzureOpenAIConfig(
            deployment_name=deployment_name,
            api_key=api_key,
            endpoint=base_url
        )
        builder.add_service(AzureChatCompletion(azure_config))
        self.kernel = builder.build()

        # Register Terraform skill functions as kernel functions
        self.kernel.add_function("generate_variables_tf", generate_variables_tf)
        self.kernel.add_function("generate_outputs_tf", generate_outputs_tf)
        self.kernel.add_function("fix_terraform_code", fix_terraform_code)
        self.validate_agent = ValidationAgent()

    async def run(self):
        import shutil
        resources = self.resource_agent.extract(self.md_file)
        if not resources:
            logging.error("No resources found in the input file.")
            return False

        if not os.path.exists(self.output_dir):
            os.makedirs(self.output_dir, exist_ok=True)

        # Clone and prepare modules (MCP server reference: https://github.com/modelcontextprotocol/servers)
        module_clone_paths = {}
        async def mcp_git_clone(repo_url, local_path):
            """
            Clone a git repo using MCP server (via Docker) or fallback to direct git clone.
            If MCP server is not running, this will start it using Docker.
            """
            import socket
            import time
            mcp_url = os.environ.get("MCP_GIT_SERVER_URL", "http://localhost:5001/invoke")
            # Check if MCP server is running
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
                logging.info("MCP server not running, starting MCP server via Docker...")
                try:
                    subprocess.run([
                        "docker", "run", "-d", "-p", "5001:5001", "ghcr.io/modelcontextprotocol/mcp-server-git:main"
                    ], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                    # Wait for MCP server to be up
                    for _ in range(10):
                        if is_port_open(mcp_host, mcp_port):
                            logging.info("MCP server started via Docker.")
                            break
                        time.sleep(1)
                    else:
                        logging.warning("MCP server did not start in time, will try direct git clone.")
                except Exception as docker_e:
                    logging.warning(f"Failed to start MCP server via Docker: {docker_e}")
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
                logging.warning(f"MCP server unavailable, falling back to direct git clone: {e}")
                # Fallback: try direct git clone
                try:
                    subprocess.run([
                        "git", "clone", "--depth", "1", repo_url, local_path
                    ], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                    return True, None
                except Exception as git_e:
                    return False, f"MCP error: {e}; git error: {git_e}"

        for res in resources:
            module = self.module_agent.find_module(res)
            if not module:
                logging.warning(f"No AVM module found for resource: {res}")
                continue
            repo_url = module.get('source', '').strip()
            if not repo_url or not repo_url.startswith('http'):
                logging.warning(f"No valid source repo for {res}, skipping git clone.")
                module_clone_paths[res] = None
            else:
                mod_name = module['name'].replace('/', '_')
                local_path = os.path.join(tempfile.gettempdir(), mod_name)
                module_clone_paths[res] = local_path
                if not os.path.exists(local_path):
                    logging.info(f"Cloning module {mod_name} into {local_path} using MCP server")
                    success, err = await mcp_git_clone(repo_url, local_path)
                    if success:
                        logging.info(f"SUCCESS: Cloned {mod_name}")
                    else:
                        logging.error(f"Failed to clone {repo_url}: {err}")
                        module_clone_paths[res] = None

        # Generate Terraform files (main.tf, variables.tf, outputs.tf)
        for iteration in range(self.max_iterations):
            logging.info(f"--- MCP Iteration {iteration+1} ---")
            tf_code = ''
            variables_blocks = []
            outputs_blocks = []
            for res in resources:
                module = self.module_agent.find_module(res)
                if not module:
                    logging.warning(f"Skipping code generation for missing module: {res}")
                    continue
                tf_code += f'# Module for {res}\n'
                tf_code += f'module "{res}" {{\n  source = "{module["registry"]}"\n}}\n\n'

                # Try to get module source code for variable/output extraction
                module_path = None
                if hasattr(module, 'get'):
                    module_path = module.get('local_path')
                if not module_path:
                    # Try to use the cloned path if available
                    module_path = None
                # Fallback: skip if no code
                module_code = None
                # Try to read main.tf from cloned module if available
                if module_path and os.path.exists(module_path):
                    main_tf_file = os.path.join(module_path, 'main.tf')
                    if os.path.exists(main_tf_file):
                        with open(main_tf_file, 'r') as mf:
                            module_code = mf.read()
                if not module_code:
                    # Fallback: use the module block as a stub
                    module_code = f'module "{res}" {{\n  source = "{module["registry"]}"\n}}'

                # Generate variables.tf content


                try:
                    variables_content = await self.kernel.invoke_function(
                        "generate_variables_tf", module_code=module_code
                    )
                    if variables_content and isinstance(variables_content, str):
                        variables_blocks.append(variables_content.strip())
                        logging.info(f"Extracted variables from AI for {res}")
                except Exception as e:
                    logging.warning(f"Failed to generate variables.tf for {res}: {e}")

                # Generate outputs.tf content
                try:
                    outputs_content = await self.kernel.invoke_function(
                        "generate_outputs_tf", module_code=module_code, resource_name=res
                    )
                    if outputs_content and isinstance(outputs_content, str):
                        outputs_blocks.append(outputs_content.strip())
                        logging.info(f"Extracted outputs from AI for {res}")
                except Exception as e:
                    logging.warning(f"Failed to generate outputs.tf for {res}: {e}")

            # Write main.tf
            main_tf_path = os.path.join(self.output_dir, 'main.tf')
            with open(main_tf_path, 'w') as f:
                f.write(tf_code)
            logging.info(f"main.tf written to {main_tf_path}")

            # Write variables.tf
            variables_tf_path = os.path.join(self.output_dir, 'variables.tf')
            with open(variables_tf_path, 'w') as f:
                f.write('\n\n'.join(variables_blocks))
            logging.info(f"variables.tf written to {variables_tf_path}")

            # Write outputs.tf
            outputs_tf_path = os.path.join(self.output_dir, 'outputs.tf')
            with open(outputs_tf_path, 'w') as f:
                f.write('\n\n'.join(outputs_blocks))
            logging.info(f"outputs.tf written to {outputs_tf_path}")

            # Validate
            valid, error_output = self.validate_agent.validate_with_errors(self.output_dir)
            if valid:
                logging.info("SUCCESS: Terraform code is valid.")
                return True
            else:
                logging.error("Terraform code is not valid. Please review errors.")
        return False

# --- Usage Example ---

if __name__ == "__main__":
    import sys
    md_file = sys.argv[1] if len(sys.argv) > 1 else "resources.md"
    output_dir = sys.argv[2] if len(sys.argv) > 2 else "generated_tf"
    orchestrator = MCPTerraformOrchestrator(md_file=md_file, output_dir=output_dir)
    asyncio.run(orchestrator.run())
