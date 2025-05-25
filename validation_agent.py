import subprocess

class ValidationAgent:
    def validate_code(self, directory: str) -> str:
        print(f"[ValidationAgent] Validating Terraform configuration in directory: {directory}")
        result = subprocess.run(['terraform', 'validate'], cwd=directory, capture_output=True, text=True)
        if result.returncode == 0:
            print("[ValidationAgent] Terraform validation successful.")
            return "Valid"
        else:
            print(f"[ValidationAgent] Terraform validation failed: {result.stderr}")
            return result.stderr
