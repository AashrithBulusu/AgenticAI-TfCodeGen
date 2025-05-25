
from semantic_kernel.functions import kernel_function
import logging

logger = logging.getLogger(__name__)

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
            logger.info("MCP server not running, starting MCP server via Docker...")
            try:
                subprocess.run([
                    "docker", "run", "-d", "-p", "5001:5001", "ghcr.io/modelcontextprotocol/mcp-server-git:main"
                ], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                for _ in range(10):
                    if is_port_open(mcp_host, mcp_port):
                        logger.info("MCP server started via Docker.")
                        break
                    time.sleep(1)
                else:
                    logger.warning("MCP server did not start in time, will try direct git clone.")
            except Exception as docker_e:
                logger.warning(f"Failed to start MCP server via Docker: {docker_e}")
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
            logger.warning(f"MCP server unavailable, falling back to direct git clone: {e}")
            try:
                subprocess.run([
                    "git", "clone", "--depth", "1", repo_url, local_path
                ], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                return True, None
            except Exception as git_e:
                return False, f"MCP error: {e}; git error: {git_e}"

    @kernel_function(name="generate_main_tf", description="Generates main.tf code block for module using AVM logic")
    def generate_main_tf(self, resource_name: str, module: dict, variables: list) -> str:
        """
        Generates a module block for main.tf using AVM module logic, similar to tfcodegen_new.py.
        - Uses the 'registry' field for the source.
        - Only includes version if present.
        - Variables are passed as direct assignments (var.<name>).
        """
        logger.info(f"Generating main.tf code for resource: {resource_name}, module: {module}")
        source = module.get("registry", "")
        version = module.get("version", "")
        version_line = f'  version = "{version}"' if version else ""
        source_line = f'  source = "{source}"' if source else ""
        var_lines = ""
        if variables and isinstance(variables, list):
            var_lines = "\n".join([
                f'  {v["name"]} = var.{v["name"]}' if isinstance(v, dict) and "name" in v else "" for v in variables
            ])
        code = f'module "{resource_name}" {{\n{source_line}\n{version_line}\n{var_lines}\n}}\n'
        logger.info(f"Generated code for {resource_name}:\n{code}")
        return code

    @kernel_function(name="generate_variables_tf", description="Generates variables.tf block for a module")
    def generate_variables_tf(self, resource_name: str, variables: list) -> str:
        """
        Generates variables.tf content for a module.
        """
        logger.info(f"Generating variables.tf for resource: {resource_name}")
        if not variables or not isinstance(variables, list):
            return ""
        blocks = []
        for v in variables:
            if isinstance(v, dict) and "name" in v:
                blocks.append(f'variable "{v["name"]}" {{\n  type = string\n}}')
        code = "\n\n".join(blocks)
        logger.info(f"Generated variables.tf for {resource_name}:\n{code}")
        return code

    @kernel_function(name="generate_outputs_tf", description="Generates outputs.tf block for a module")
    def generate_outputs_tf(self, resource_name: str, outputs: list) -> str:
        """
        Generates outputs.tf content for a module.
        """
        logger.info(f"Generating outputs.tf for resource: {resource_name}")
        if not outputs or not isinstance(outputs, list):
            return ""
        blocks = []
        for o in outputs:
            if isinstance(o, dict) and "name" in o:
                blocks.append(f'output "{o["name"]}" {{\n  value = module.{resource_name}.{o["name"]}\n}}')
        code = "\n\n".join(blocks)
        logger.info(f"Generated outputs.tf for {resource_name}:\n{code}")
        return code
