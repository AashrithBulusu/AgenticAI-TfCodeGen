import os
import asyncio
from dotenv import load_dotenv
from semantic_kernel import Kernel
from semantic_kernel.connectors.ai.open_ai import AzureChatCompletion
from semantic_kernel.functions.kernel_arguments import KernelArguments

from plugins.resource_extraction import ResourceExtractionAgent
from plugins.module_discovery import ModuleDiscoveryAgent
from plugins.code_generation import TerraformCodeGenerationAgent
from plugins.tfvars_generator import TFVarsGeneratorAgent
from plugins.validation import ValidationAgent

# Load environment variables from .env
load_dotenv()

async def run_pipeline(md_file: str, output_dir: str):
    os.makedirs(output_dir, exist_ok=True)

    kernel = Kernel()
    kernel.add_service(AzureChatCompletion(
        deployment_name=os.environ["AZURE_OPENAI_DEPLOYMENT_NAME"],
        api_key=os.environ["AZURE_OPENAI_API_KEY"],
        base_url=os.environ["AZURE_OPENAI_ENDPOINT"],
        service_id="chat_completion"
    ))

    # Add plugins
    kernel.add_plugin(ResourceExtractionAgent(), "ResourceExtractor")
    kernel.add_plugin(ModuleDiscoveryAgent(), "ModuleDiscoverer")
    kernel.add_plugin(TerraformCodeGenerationAgent(), "CodeGenerator")
    # kernel.add_plugin(ValidationAgent(), "Validator")
    kernel.add_plugin(TFVarsGeneratorAgent(), "TFVarsGen")

    # Extract resource names from the markdown file
    extract_result = await kernel.invoke(
        plugin_name="ResourceExtractor",
        function_name="extract",
        arguments=KernelArguments(md_path=md_file)
    )
    resources = extract_result.value

    main_tf = ""
    tfvars = ""

    for res in resources:
        # Find AVM module for each resource
        module_result = await kernel.invoke(
            plugin_name="ModuleDiscoverer",
            function_name="find_module",
            arguments=KernelArguments(resource=res)
        )
        module = module_result.value

        variables = [{"name": "name"}, {"name": "location"}]  # Stubbed, customize as needed

        # Generate main.tf code
        code_result = await kernel.invoke(
            plugin_name="CodeGenerator",
            function_name="generate_code",
            arguments=KernelArguments(resource_name=res, module=module, variables=variables)
        )
        main_tf += code_result.value + "\n"

        # Generate terraform.tfvars
        tfvars_result = await kernel.invoke(
            plugin_name="TFVarsGen",
            function_name="generate_tfvars",
            arguments=KernelArguments(resource_name=res, variables=variables)
        )
        tfvars += tfvars_result.value + "\n"

    # Write files
    with open(os.path.join(output_dir, 'main.tf'), 'w') as f:
        f.write(main_tf)
    with open(os.path.join(output_dir, 'terraform.tfvars'), 'w') as f:
        f.write(tfvars)

    # Validate generated Terraform config
    # validation_result = await kernel.invoke(
    #     plugin_name="Validator",
    #     function_name="validate_code",
    #     arguments=KernelArguments(directory=output_dir)
    # )
    # print("Validation Result:", validation_result.value)

if __name__ == "__main__":
    asyncio.run(run_pipeline("resources.md", "generated_tf"))
