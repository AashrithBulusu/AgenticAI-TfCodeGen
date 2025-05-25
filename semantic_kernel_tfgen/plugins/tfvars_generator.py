from semantic_kernel.functions import kernel_function

class TFVarsGeneratorAgent:
    @kernel_function(name="generate_tfvars", description="Generates terraform.tfvars for all modules")
    async def generate_tfvars(self, resource_name: str, variables: list) -> str:
        """
        Generates terraform.tfvars content for a resource given its variables.
        """
        lines = [f'{resource_name}_vars = {{']
        for var in variables:
            var_name = var.get("name", "")
            lines.append(f'  {var_name} = "<value>"')
        lines.append('}\n')
        return "\n".join(lines)
