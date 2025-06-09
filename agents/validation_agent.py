import subprocess
import os
from datetime import datetime
import re

class ValidationAgent:
    def _clean_output(self, text: str) -> str:
        # Remove non-ASCII characters for cleaner output
        return re.sub(r'[^\x00-\x7F]+', '', text)

    def validate_code(self, directory: str) -> str:
        # Ensure validations directory exists (at workspace root)
        workspace_root = os.path.abspath(os.path.join(directory, '..'))
        validations_dir = os.path.join(workspace_root, 'validations')
        os.makedirs(validations_dir, exist_ok=True)
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')

        # Terraform fmt
        fmt_result = subprocess.run(['terraform', 'fmt', '-check', '-recursive'], cwd=directory, capture_output=True, text=True)
        fmt_output = self._clean_output(fmt_result.stdout + fmt_result.stderr)
        fmt_file = os.path.join(validations_dir, f'tffmt_{timestamp}.txt')
        with open(fmt_file, 'w', encoding='utf-8') as f:
            f.write(fmt_output)

        # tflint
        tflint_result = subprocess.run(['tflint'], cwd=directory, capture_output=True, text=True)
        tflint_output = self._clean_output(tflint_result.stdout + tflint_result.stderr)
        tflint_file = os.path.join(validations_dir, f'tflint_{timestamp}.txt')
        with open(tflint_file, 'w', encoding='utf-8') as f:
            f.write(tflint_output)

        # tfsec
        tfsec_result = subprocess.run(['tfsec', '--no-color'], cwd=directory, capture_output=True, text=True)
        tfsec_output = self._clean_output(tfsec_result.stdout + tfsec_result.stderr)
        tfsec_file = os.path.join(validations_dir, f'tfsec_{timestamp}.txt')
        with open(tfsec_file, 'w', encoding='utf-8') as f:
            f.write(tfsec_output)

        # Terraform validate
        validate_result = subprocess.run(['terraform', 'validate'], cwd=directory, capture_output=True, text=True)
        validate_output = self._clean_output(validate_result.stdout + validate_result.stderr)
        validate_file = os.path.join(validations_dir, f'validate_{timestamp}.txt')
        with open(validate_file, 'w', encoding='utf-8') as f:
            f.write(validate_output)

        # Combine all results into a single string variable
        results = (
            f"--- Terraform fmt ---\n{fmt_output}\n\n"
            f"--- tflint ---\n{tflint_output}\n\n"
            f"--- tfsec ---\n{tfsec_output}\n\n"
            f"--- terraform validate ---\n{validate_output}\n"
        )

        summary = (
            f"Terraform fmt output saved to: {fmt_file}\n"
            f"Terraform validate output saved to: {validate_file}\n"
            f"tflint output saved to: {tflint_file}\n"
            f"tfsec output saved to: {tfsec_file}\n"
        )
        print(summary)
        return results
