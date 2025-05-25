import subprocess

class ValidationAgent:
    def validate_code(self, directory: str) -> str:
        result = subprocess.run(['terraform', 'validate'], cwd=directory, capture_output=True, text=True)
        if result.returncode == 0:
            return "Valid"
        else:
            return result.stderr
