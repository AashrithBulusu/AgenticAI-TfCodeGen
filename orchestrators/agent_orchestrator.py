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
        self.module_agent = ModuleDiscoveryAgent()
        self.codegen_agent = CodeGenerationAgent()
        self.tfvars_agent = TFVarsGeneratorAgent()
        self.validation_agent = ValidationAgent()
        self.llm_validation_agent = LLMValidationAgent()
        os.makedirs(self.output_dir, exist_ok=True)


    async def run(self):
        logger.info(f"[Orchestrator] Starting agent chat pipeline with md_file={self.md_file}, output_dir={self.output_dir}")
        try:
            resources = self.resource_agent.extract(self.md_file)
            logger.info(f"[Orchestrator] Extracted resources: {resources}")
        except Exception as e:
            logger.error(f"[Orchestrator] Failed to extract resources: {e}")
            raise

        max_iterations = 3
        # Store per-resource code blocks for healing
        resource_blocks = {}
        for res in resources:
            resource_blocks[res] = {
                'main': '',
                'var': '',
                'out': ''
            }

        for attempt in range(1, max_iterations + 1):
            logger.info(f"[Orchestrator] Code generation/validation attempt {attempt}")
            main_tf, variables_tf, outputs_tf, tfvars = "", "", "", ""
            for res in resources:
                logger.info(f"[Orchestrator] Processing resource: {res}")
                try:
                    module = self.module_agent.find_module(res)
                    logger.info(f"[Orchestrator] Discovered module for {res}: {module}")
                except Exception as e:
                    logger.error(f"[Orchestrator] Failed to discover module for {res}: {e}")
                    continue
                # Use previous code if not first attempt
                if attempt == 1 or not resource_blocks[res]['main']:
                    main_code = self.codegen_agent.generate_main_tf(res, module, None)
                    var_code = self.codegen_agent.generate_variables_tf(res, module)
                    out_code = self.codegen_agent.generate_outputs_tf(res, module)
                else:
                    main_code = resource_blocks[res]['main']
                    var_code = resource_blocks[res]['var']
                    out_code = resource_blocks[res]['out']
                main_tf += main_code + "\n"
                variables_tf += var_code + "\n"
                outputs_tf += out_code + "\n"
                tfvars_block = f'# Fill in values for {res}_config in terraform.tfvars\n{res}_config = {{\n  # ...\n}}\n\n'
                tfvars += tfvars_block
                # Save for next iteration
                resource_blocks[res]['main'] = main_code
                resource_blocks[res]['var'] = var_code
                resource_blocks[res]['out'] = out_code

            try:
                with open(os.path.join(self.output_dir, 'main.tf'), 'w') as f:
                    f.write(main_tf)
                with open(os.path.join(self.output_dir, 'variables.tf'), 'w') as f:
                    f.write(variables_tf)
                with open(os.path.join(self.output_dir, 'outputs.tf'), 'w') as f:
                    f.write(outputs_tf)
                with open(os.path.join(self.output_dir, 'terraform.tfvars'), 'w') as f:
                    f.write(tfvars)
            except Exception as e:
                logger.error(f"[Orchestrator] Failed to write output files: {e}")
                raise

            try:
                validation_result = self.validation_agent.validate_code(self.output_dir)
                logger.info(f"[Orchestrator] Terraform CLI Validation Result: {validation_result}")
                print(f"Terraform CLI Validation Result: {validation_result}")
            except Exception as e:
                logger.error(f"[Orchestrator] Terraform CLI validation failed: {e}")
                validation_result = str(e)

            if validation_result.strip() == "Valid":
                logger.info(f"[Orchestrator] Code is valid after {attempt} attempt(s). Stopping auto-heal loop.")
                break
            else:
                logger.warning(f"[Orchestrator] Code is not valid on attempt {attempt}. Will retry if attempts remain.")
                # For each resource, try to fix code using validation output
                for res in resources:
                    module = self.module_agent.find_module(res)
                    main_code = resource_blocks[res]['main']
                    var_code = resource_blocks[res]['var']
                    out_code = resource_blocks[res]['out']
                    fixed_main, fixed_var, fixed_out = self.codegen_agent.fix_code_with_validation(
                        res, module, validation_result, main_code, var_code, out_code
                    )
                    resource_blocks[res]['main'] = fixed_main
                    resource_blocks[res]['var'] = fixed_var
                    resource_blocks[res]['out'] = fixed_out

        try:
            llm_validation_result = self.llm_validation_agent.validate_code(self.output_dir)
            logger.info(f"[Orchestrator] LLM Validation Result: {llm_validation_result}")
            print(f"LLM Validation Result: {llm_validation_result}")
        except Exception as e:
            logger.error(f"[Orchestrator] LLM validation failed: {e}")

if __name__ == "__main__":
    orchestrator = AgentOrchestrator(md_file="./resources.md", output_dir="./generated_tf")
    asyncio.run(orchestrator.run())
