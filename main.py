from orchestrators.agent_orchestrator import AgentOrchestrator
import asyncio

if __name__ == "__main__":
    orchestrator = AgentOrchestrator(md_file="./resources.md", output_dir="./generated_tf")
    asyncio.run(orchestrator.run())
