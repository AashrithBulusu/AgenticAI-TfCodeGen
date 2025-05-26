import os
from semantic_kernel.functions import kernel_function
from mcpxchainlit.mcp_client import MCPClient
from mcpxchainlit.schemas import GenerateRequest

class TerraformCodeGenerationAgent:

    def __init__(self, output_dir="generated_tf"):
        self.output_dir = output_dir
        os.makedirs(self.output_dir, exist_ok=True)
        self.mcp = MCPClient(base_url="http://localhost:8080")  # Adjust if your MCP server runs on another port

    @kernel_function(name="generate_code", description="Generates Terraform code using MCPX and saves .tf files")
    def generate_code(self, resource_name: str, module: dict, variables: list) -> str:
        # Construct source and version lines
        registry = module.get("registry", "")
        version = module.get("version", "")
        version_line = f'  version = "{version}"' if version else ""

        source = ""
        if "registry.terraform.io" in registry:
            parts = registry.replace("https://registry.terraform.io/modules/", "").split("/")
            if len(parts) >= 3:
                source = f'{parts[0]}/{parts[1]}/{parts[2]}'

        source_line = f'  source = "{source}"' if source else ""

        # Generate module block
        var_lines = "\n".join(
            [f'  {v["name"]} = var.{resource_name}_vars.{v["name"]}' for v in variables]
        )
        main_tf = f'module "{resource_name}" {{\n{source_line}\n{version_line}\n{var_lines}\n}}\n'

        # Create variables.tf
        variables_tf = "\n".join(
            [f'variable "{resource_name}_vars" {{\n  type = object({{ {", ".join([f"{v["name"]} = string" for v in variables])} }})\n}}\n']
        )

        # Create terraform.tfvars
        tfvars = f'{resource_name}_vars = {{\n' + "\n".join(
            [f'  {v["name"]} = "{v.get("default", "")}"' for v in variables]
        ) + "\n}\n"

        # Example provider block
        providers_tf = '''
provider "azurerm" {
  features {}
}
'''

        # Placeholder output block
        outputs_tf = f'''
output "{resource_name}_output" {{
  value = module.{resource_name}
}}
'''

        # Send request to MCP server to process (optional enhancement)
        try:
            request = GenerateRequest(input=main_tf)
            response = self.mcp.generate(request)
            generated_code = response.output
        except Exception as e:
            generated_code = f"Error from MCP server: {str(e)}"

        # Save all files
        files = {
            "main.tf": main_tf,
            "variables.tf": variables_tf,
            "terraform.tfvars": tfvars,
            "providers.tf": providers_tf,
            "outputs.tf": outputs_tf
        }

        for filename, content in files.items():
            with open(os.path.join(self.output_dir, filename), "w") as f:
                f.write(content)

        return f"Terraform files saved in '{self.output_dir}' directory.\nMCP Output: {generated_code}"
