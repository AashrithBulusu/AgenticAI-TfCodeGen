from orchestrators.agent_orchestrator import AgentOrchestrator
from agents.validation_agent import ValidationAgent
import asyncio
import argparse

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
    else:
        orchestrator = AgentOrchestrator(md_file="./resources.md", output_dir="./generated_tf")
        asyncio.run(orchestrator.run())
