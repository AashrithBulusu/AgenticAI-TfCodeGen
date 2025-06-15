from orchestrators.agent_orchestrator import AgentOrchestrator
from agents.validation_agent import ValidationAgent
from agents.llm_validation_agent import LLMValidationAgent

import asyncio
import argparse
import os

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Agentic Terraform Pipeline")
    parser.add_argument('--validation_only', action='store_true', help='Run only validation (tflint, tfsec, terraform fmt) on a directory')
    parser.add_argument('directory', nargs='?', default='./generated_tf', help='Terraform directory to validate (default: ./generated_tf)')
    args = parser.parse_args()

    if args.validation_only:
        print(f"Running validation only on directory: {args.directory}")
        agent = ValidationAgent()
        result = agent.validate_code(args.directory)
        print("\nValidation Results:\n" + result)

        # Also run LLMValidationAgent.validate_code, passing the validation result
        llm_agent = LLMValidationAgent()
        llm_result = llm_agent.validate_code(args.directory, result)
        print("\nLLM Validation Results:\n" + llm_result)
        validations_dir = os.path.join(args.directory, 'validations')
        os.makedirs(validations_dir, exist_ok=True)
        output_file = os.path.join(validations_dir, "AI Review and Explanation.md")
        with open(output_file, "w") as f:
            f.write(llm_result)
        print(f"\nLLM review written to: {output_file}")
    else:
        orchestrator = AgentOrchestrator(md_file="./resources.md", output_dir="./generated_tf")
        asyncio.run(orchestrator.run())
