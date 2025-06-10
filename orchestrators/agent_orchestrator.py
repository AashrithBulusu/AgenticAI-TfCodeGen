import os
import asyncio
import logging
from dotenv import load_dotenv

from agents.resource_extraction_agent import ResourceExtractionAgent
from agents.module_discovery_agent import ModuleDiscoveryAgent
from agents.code_generation_agent import CodeGenerationAgent
from agents.tfvars_generator_agent import TFVarsGeneratorAgent
from agents.validation_agent import ValidationAgent
from agents.llm_validation_agent import LLMValidationAgent

LOG_DIR = os.path.join(os.path.dirname(__file__), '..', '.log')
os.makedirs(LOG_DIR, exist_ok=True)
LOG_FILE = os.path.join(LOG_DIR, 'pipeline.log')
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(name)s: %(message)s',
    handlers=[logging.FileHandler(LOG_FILE), logging.StreamHandler()]
)
logger = logging.getLogger(__name__)

load_dotenv()

class AgentOrchestrator:
    def __init__(self, md_file, output_dir, max_iterations=5):
        self.md_file = md_file
        self.output_dir = output_dir
        self.max_iterations = max_iterations
        logger.info(f"[Init] Initializing AgentOrchestrator with md_file={md_file}, output_dir={output_dir}, max_iterations={max_iterations}")
        self.resource_agent = ResourceExtractionAgent()
        self.module_agent = ModuleDiscoveryAgent()
        self.codegen_agent = CodeGenerationAgent()
        self.tfvars_agent = TFVarsGeneratorAgent()
        self.validation_agent = ValidationAgent()
        self.llm_validation_agent = LLMValidationAgent()
        os.makedirs(self.output_dir, exist_ok=True)

    async def run(self):
        logger.info(f"[Orchestrator] Starting pipeline")
        try:
            resources = self.resource_agent.extract(self.md_file)
            logger.info(f"[Orchestrator] Extracted resources: {resources}")
        except Exception as e:
            logger.error(f"[Orchestrator] Failed to extract resources: {e}")
            raise

        variables_tf_path = os.path.join(self.output_dir, 'variables.tf')

        main_tf, variables_tf, outputs_tf = "", "", ""

        for res in resources:
            logger.info(f"[Orchestrator] Processing resource: {res}")
            try:
                module = self.module_agent.find_module(res)
            except Exception as e:
                logger.error(f"[Orchestrator] Failed to discover module for {res}: {e}")
                continue

            main_code = self.codegen_agent.generate_main_tf(res)
            var_code = self.codegen_agent.generate_variables_tf(res)
            out_code = self.codegen_agent.generate_outputs_tf(res)

            main_tf += main_code + "\n"
            variables_tf += var_code + "\n"
            outputs_tf += out_code + "\n"

        # Write main, variables, outputs files
        with open(os.path.join(self.output_dir, 'main.tf'), 'w') as f:
            f.write(main_tf)
        with open(os.path.join(self.output_dir, 'variables.tf'), 'w') as f:
            f.write(variables_tf)
        with open(os.path.join(self.output_dir, 'outputs.tf'), 'w') as f:
            f.write(outputs_tf)

        # Generate terraform.tfvars using full variables.tf content
        await self.tfvars_agent.generate_tfvars_file(
            self.tfvars_agent,
            variables_tf_path,
            os.path.join(self.output_dir, 'terraform.tfvars')
        )

        logger.info("Terraform files generated successfully.")

        try:
            validation_result = self.validation_agent.validate_code(self.output_dir)
            logger.info(f"Terraform - Linting Result: {validation_result}")
            print(f"Terraform - Linting Result: {validation_result}")
        except Exception as e:
            validation_result = "Validation failed - see logs for details."
            logger.error(f"Terraform - Linting failed: {e}")

        try:
            llm_validation_result = self.llm_validation_agent.validate_code(self.output_dir, validation_result)
            logger.info(f"LLM Validation Result: {llm_validation_result}")
            print(f"LLM Validation Result: {llm_validation_result}")
            validations_dir = os.path.join(self.output_dir, "validations")
            os.makedirs(validations_dir, exist_ok=True)
            llm_review_path = os.path.join(validations_dir, "AI Review and Summary.md")
            with open(llm_review_path, "w") as f:
                f.write(f"# AI Review and Summary\n\n{llm_validation_result}\n")
            logger.info(f"LLM validation result written to {llm_review_path}")
        except Exception as e:
            logger.error(f"LLM validation failed: {e}")


if __name__ == "__main__":
    orchestrator = AgentOrchestrator(md_file="./resources.md", output_dir="./generated_tf")
    asyncio.run(orchestrator.run())
