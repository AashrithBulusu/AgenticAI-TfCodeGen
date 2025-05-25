

import subprocess
from semantic_kernel.functions import kernel_function


class ValidationAgent:
    @kernel_function(name="validate_code", description="Validates Terraform configuration")
    def validate_code(self, directory: str) -> str:
        print(f"[INFO] Validating Terraform configuration in directory: {directory}")
        result = subprocess.run(['terraform', 'validate'], cwd=directory, capture_output=True, text=True)
        if result.returncode == 0:
            print("[INFO] Terraform validation successful.")
            return "Valid"
        else:
            print(f"[ERROR] Terraform validation failed: {result.stderr}")
            return result.stderr
