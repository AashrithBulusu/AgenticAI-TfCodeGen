import subprocess
from semantic_kernel.functions import kernel_function

class ValidationAgent:
    @kernel_function(name="validate_code", description="Validates Terraform configuration")
    def validate_code(self, directory: str) -> str:
        result = subprocess.run(['terraform', 'validate'], cwd=directory, capture_output=True, text=True)
        return "Valid" if result.returncode == 0 else result.stderr
