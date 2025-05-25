
import subprocess
import logging
from semantic_kernel.functions import kernel_function

logger = logging.getLogger(__name__)

class ValidationAgent:
    @kernel_function(name="validate_code", description="Validates Terraform configuration")
    def validate_code(self, directory: str) -> str:
        logger.info(f"Validating Terraform configuration in directory: {directory}")
        result = subprocess.run(['terraform', 'validate'], cwd=directory, capture_output=True, text=True)
        if result.returncode == 0:
            logger.info("Terraform validation successful.")
            return "Valid"
        else:
            logger.error(f"Terraform validation failed: {result.stderr}")
            return result.stderr
