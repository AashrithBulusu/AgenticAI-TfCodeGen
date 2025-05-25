
from semantic_kernel.functions import kernel_function
import logging

logger = logging.getLogger(__name__)

class TerraformCodeGenerationAgent:
    @kernel_function(name="generate_code", description="Generates main.tf code block for module")
    def generate_code(self, resource_name: str, module: dict, variables: list) -> str:
        logger.info(f"Generating main.tf code for resource: {resource_name}, module: {module}")
        registry = module.get("registry", "")
        version = module.get("version", "")
        version_line = f'  version = "{version}"' if version else ""

        source = ""
        if "registry.terraform.io" in registry:
            parts = registry.replace("https://registry.terraform.io/modules/", "").split("/")
            if len(parts) >= 3:
                # Convert to correct format: Azure/module-name/provider
                source = f'{parts[0]}/{parts[1]}/{parts[2]}'

        source_line = f'  source = "{source}"' if source else ""

        var_lines = "\n".join([f'  {v["name"]} = var.{resource_name}_vars.{v["name"]}' for v in variables])

        code = f'module "{resource_name}" {{\n{source_line}\n{version_line}\n{var_lines}\n}}'
        logger.info(f"Generated code for {resource_name}:\n{code}")
        return code
