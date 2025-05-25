class TFVarsGeneratorAgent:
    async def generate_tfvars(self, resource_name: str, variables: list) -> str:
        lines = [f'{resource_name}_vars = {{']
        for var in variables:
            var_name = var.get("name", "")
            lines.append(f'  {var_name} = "<value>"')
        lines.append('}\n')
        return "\n".join(lines)
