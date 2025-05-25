
import os
import asyncio
import logging
from dotenv import load_dotenv
from semantic_kernel import Kernel
from semantic_kernel.connectors.ai.open_ai import AzureChatCompletion
from semantic_kernel.functions.kernel_arguments import KernelArguments


from plugins.resource_extraction import ResourceExtractionAgent
from plugins.module_discovery import ModuleDiscoveryAgent
from plugins.code_generation import TerraformCodeGenerationAgent
from plugins.tfvars_generator import TFVarsGeneratorAgent
from plugins.validation import ValidationAgent



# Ensure .log directory exists
LOG_DIR = os.path.join(os.path.dirname(__file__), '..', '.log')
os.makedirs(LOG_DIR, exist_ok=True)
LOG_FILE = os.path.join(LOG_DIR, 'pipeline.log')

# Configure logging to file and console
file_handler = logging.FileHandler(LOG_FILE)
file_handler.setLevel(logging.INFO)
file_handler.setFormatter(logging.Formatter('%(asctime)s [%(levelname)s] %(name)s: %(message)s'))

console_handler = logging.StreamHandler()
console_handler.setLevel(logging.WARNING)  # Only show WARNING+ on stdout
console_handler.setFormatter(logging.Formatter('%(asctime)s [%(levelname)s] %(name)s: %(message)s'))

logging.basicConfig(level=logging.INFO, handlers=[file_handler, console_handler])
logger = logging.getLogger(__name__)

# Load environment variables from .env
load_dotenv()


async def run_pipeline(md_file: str, output_dir: str):

    print(f"[INFO] Starting pipeline with md_file={md_file}, output_dir={output_dir}")
    logger.info(f"Starting pipeline with md_file={md_file}, output_dir={output_dir}")
    os.makedirs(output_dir, exist_ok=True)

    kernel = Kernel()
    print("[INFO] Adding AzureChatCompletion service to kernel")
    logger.info("Adding AzureChatCompletion service to kernel")
    kernel.add_service(AzureChatCompletion(
        deployment_name=os.environ["AZURE_OPENAI_DEPLOYMENT_NAME"],
        api_key=os.environ["AZURE_OPENAI_API_KEY"],
        base_url=os.environ["AZURE_OPENAI_ENDPOINT"],
        service_id="chat_completion"
    ))

    # Add plugins
    print("[INFO] Adding plugins to kernel")
    logger.info("Adding plugins to kernel")
    kernel.add_plugin(ResourceExtractionAgent(), "ResourceExtractor")
    kernel.add_plugin(ModuleDiscoveryAgent(), "ModuleDiscoverer")
    kernel.add_plugin(TerraformCodeGenerationAgent(), "CodeGenerator")
    kernel.add_plugin(ValidationAgent(), "Validator")
    kernel.add_plugin(TFVarsGeneratorAgent(), "TFVarsGen")

    # Extract resource names from the markdown file
    print(f"[INFO] Extracting resources from markdown file: {md_file}")
    logger.info(f"Extracting resources from markdown file: {md_file}")
    extract_result = await kernel.invoke(
        plugin_name="ResourceExtractor",
        function_name="extract",
        arguments=KernelArguments(md_path=md_file)
    )
    resources = extract_result.value
    print(f"[INFO] Extracted resources: {resources}")
    logger.info(f"Extracted resources: {resources}")


    main_tf = ""
    variables_tf = ""
    outputs_tf = ""
    tfvars = ""

    for res in resources:
        print(f"[INFO] Processing resource: {res}")
        logger.info(f"Processing resource: {res}")
        # Find AVM module for each resource
        module_result = await kernel.invoke(
            plugin_name="ModuleDiscoverer",
            function_name="find_module",
            arguments=KernelArguments(resource=res)
        )
        module = module_result.value
        print(f"[INFO] Discovered module for {res}: {module}")
        logger.info(f"Discovered module for {res}: {module}")

        variables = [{"name": "name"}, {"name": "location"}]  # Stubbed, customize as needed
        outputs = [{"name": "id"}]  # Stubbed, customize as needed

        # Generate main.tf code
        main_tf_result = await kernel.invoke(
            plugin_name="CodeGenerator",
            function_name="generate_main_tf",
            arguments=KernelArguments(resource_name=res, module=module, variables=variables)
        )
        logger.info(f"Generated main.tf code for {res}")
        main_tf += main_tf_result.value + "\n"

        # Generate variables.tf
        variables_tf_result = await kernel.invoke(
            plugin_name="CodeGenerator",
            function_name="generate_variables_tf",
            arguments=KernelArguments(resource_name=res, variables=variables)
        )
        logger.info(f"Generated variables.tf for {res}")
        variables_tf += variables_tf_result.value + "\n"

        # Generate outputs.tf
        outputs_tf_result = await kernel.invoke(
            plugin_name="CodeGenerator",
            function_name="generate_outputs_tf",
            arguments=KernelArguments(resource_name=res, outputs=outputs)
        )
        logger.info(f"Generated outputs.tf for {res}")
        outputs_tf += outputs_tf_result.value + "\n"

        # Generate terraform.tfvars
        tfvars_result = await kernel.invoke(
            plugin_name="TFVarsGen",
            function_name="generate_tfvars",
            arguments=KernelArguments(resource_name=res, variables=variables)
        )
        logger.info(f"Generated tfvars for {res}")
        tfvars += tfvars_result.value + "\n"

    # Write files
    main_tf_path = os.path.join(output_dir, 'main.tf')
    variables_tf_path = os.path.join(output_dir, 'variables.tf')
    outputs_tf_path = os.path.join(output_dir, 'outputs.tf')
    tfvars_path = os.path.join(output_dir, 'terraform.tfvars')

    print(f"[INFO] Writing main.tf to {main_tf_path}")
    logger.info(f"Writing main.tf to {main_tf_path}")
    with open(main_tf_path, 'w') as f:
        f.write(main_tf)

    print(f"[INFO] Writing variables.tf to {variables_tf_path}")
    logger.info(f"Writing variables.tf to {variables_tf_path}")
    with open(variables_tf_path, 'w') as f:
        f.write(variables_tf)

    print(f"[INFO] Writing outputs.tf to {outputs_tf_path}")
    logger.info(f"Writing outputs.tf to {outputs_tf_path}")
    with open(outputs_tf_path, 'w') as f:
        f.write(outputs_tf)

    print(f"[INFO] Writing terraform.tfvars to {tfvars_path}")
    logger.info(f"Writing terraform.tfvars to {tfvars_path}")
    with open(tfvars_path, 'w') as f:
        f.write(tfvars)

    # Validate generated Terraform config
    validation_result = await kernel.invoke(
        plugin_name="Validator",
        function_name="validate_code",
        arguments=KernelArguments(directory=output_dir)
    )
    logger.info(f"Validation Result: {validation_result.value}")



if __name__ == "__main__":
    print("[INFO] Running main pipeline entry point")
    logger.info("Running main pipeline entry point")
    asyncio.run(run_pipeline("resources.md", "generated_tf"))
