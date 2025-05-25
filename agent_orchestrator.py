"""
Agent Orchestrator: Coordinates a chat-like workflow between agents for resource extraction, module discovery, code generation, tfvars generation, and validation.
Inspired by: https://github.com/john-carroll-sw/semantic-kernel-agent-code-execution
"""
import os
import asyncio
import logging
from dotenv import load_dotenv

from resource_extraction_agent import ResourceExtractionAgent
from module_discovery_agent import ModuleDiscoveryAgent
from code_generation_agent import CodeGenerationAgent
from tfvars_generator_agent import TFVarsGeneratorAgent

from validation_agent import ValidationAgent
from llm_validation_agent import LLMValidationAgent

# Setup logging
LOG_DIR = os.path.join(os.path.dirname(__file__), '..', '.log')
os.makedirs(LOG_DIR, exist_ok=True)
LOG_FILE = os.path.join(LOG_DIR, 'pipeline_new_approach.log')
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(name)s: %(message)s',
    handlers=[logging.FileHandler(LOG_FILE), logging.StreamHandler()]
)
logger = logging.getLogger(__name__)

load_dotenv()

class AgentOrchestrator:
    def __init__(self, md_file, output_dir):
        self.md_file = md_file
        self.output_dir = output_dir
        logger.info(f"[Init] Initializing AgentOrchestrator with md_file={md_file}, output_dir={output_dir}")
        self.resource_agent = ResourceExtractionAgent()
        logger.info("[Init] ResourceExtractionAgent initialized.")
        self.module_agent = ModuleDiscoveryAgent()
        logger.info("[Init] ModuleDiscoveryAgent initialized.")
        self.codegen_agent = CodeGenerationAgent()
        logger.info("[Init] CodeGenerationAgent initialized.")
        self.tfvars_agent = TFVarsGeneratorAgent()
        logger.info("[Init] TFVarsGeneratorAgent initialized.")
        self.validation_agent = ValidationAgent()
        logger.info("[Init] ValidationAgent initialized.")
        self.llm_validation_agent = LLMValidationAgent()
        logger.info("[Init] LLMValidationAgent initialized.")
        os.makedirs(self.output_dir, exist_ok=True)
        logger.info(f"[Init] Output directory ensured at {self.output_dir}")

    async def run(self):
        logger.info(f"[Orchestrator] Starting agent chat pipeline with md_file={self.md_file}, output_dir={self.output_dir}")
        # Step 1: Extract resources
        try:
            resources = self.resource_agent.extract(self.md_file)
            logger.info(f"[Orchestrator] Extracted resources: {resources}")
        except Exception as e:
            logger.error(f"[Orchestrator] Failed to extract resources: {e}")
            raise

        main_tf, variables_tf, outputs_tf, tfvars = "", "", "", ""
        for res in resources:
            logger.info(f"[Orchestrator] Processing resource: {res}")
            try:
                module = self.module_agent.find_module(res)
                logger.info(f"[Orchestrator] Discovered module for {res}: {module}")
            except Exception as e:
                logger.error(f"[Orchestrator] Failed to discover module for {res}: {e}")
                continue
            try:
                main_code = self.codegen_agent.generate_main_tf(res, module, None)
                logger.info(f"[Orchestrator] Generated main.tf block for {res}.")
                main_tf += main_code + "\n"
            except Exception as e:
                logger.error(f"[Orchestrator] Failed to generate main.tf for {res}: {e}")
            try:
                var_code = self.codegen_agent.generate_variables_tf(res, module)
                logger.info(f"[Orchestrator] Generated variables.tf block for {res}.")
                variables_tf += var_code + "\n"
            except Exception as e:
                logger.error(f"[Orchestrator] Failed to generate variables.tf for {res}: {e}")
            try:
                out_code = self.codegen_agent.generate_outputs_tf(res, module)
                logger.info(f"[Orchestrator] Generated outputs.tf block for {res}.")
                outputs_tf += out_code + "\n"
            except Exception as e:
                logger.error(f"[Orchestrator] Failed to generate outputs.tf for {res}: {e}")
            tfvars_block = f'# Fill in values for {res}_config in terraform.tfvars\n{res}_config = {{\n  # ...\n}}\n\n'
            logger.info(f"[Orchestrator] Generated tfvars block for {res}.")
            tfvars += tfvars_block

        # Write files
        try:
            with open(os.path.join(self.output_dir, 'main.tf'), 'w') as f:
                f.write(main_tf)
            logger.info(f"[Orchestrator] main.tf written to {self.output_dir}")
            with open(os.path.join(self.output_dir, 'variables.tf'), 'w') as f:
                f.write(variables_tf)
            logger.info(f"[Orchestrator] variables.tf written to {self.output_dir}")
            with open(os.path.join(self.output_dir, 'outputs.tf'), 'w') as f:
                f.write(outputs_tf)
            logger.info(f"[Orchestrator] outputs.tf written to {self.output_dir}")
            with open(os.path.join(self.output_dir, 'terraform.tfvars'), 'w') as f:
                f.write(tfvars)
            logger.info(f"[Orchestrator] terraform.tfvars written to {self.output_dir}")
        except Exception as e:
            logger.error(f"[Orchestrator] Failed to write output files: {e}")
            raise

        # Validate
        try:
            validation_result = self.validation_agent.validate_code(self.output_dir)
            logger.info(f"[Orchestrator] Terraform CLI Validation Result: {validation_result}")
            print(f"Terraform CLI Validation Result: {validation_result}")
        except Exception as e:
            logger.error(f"[Orchestrator] Terraform CLI validation failed: {e}")

        try:
            llm_validation_result = self.llm_validation_agent.validate_code(self.output_dir)
            logger.info(f"[Orchestrator] LLM Validation Result: {llm_validation_result}")
            print(f"LLM Validation Result: {llm_validation_result}")
        except Exception as e:
            logger.error(f"[Orchestrator] LLM validation failed: {e}")

if __name__ == "__main__":
    orchestrator = AgentOrchestrator(md_file="./resources.md", output_dir="./generated_tf")
    asyncio.run(orchestrator.run())
