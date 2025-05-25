import os
import asyncio
import semantic_kernel as sk
from semantic_kernel.connectors.ai.open_ai import AzureChatCompletion
from dotenv import load_dotenv
# Load .env file
load_dotenv()

# Use the correct variable for deployment name
chat_deployment_name = os.getenv("AZURE_OPENAI_CHAT_DEPLOYMENT") or os.getenv("AZURE_OPENAI_DEPLOYMENT_NAME")
# Load environment variables for Azure OpenAI
AZURE_OPENAI_ENDPOINT = os.getenv("AZURE_OPENAI_ENDPOINT")
AZURE_OPENAI_API_KEY = os.getenv("AZURE_OPENAI_API_KEY")
AZURE_OPENAI_DEPLOYMENT = os.getenv("AZURE_OPENAI_DEPLOYMENT")  # Your deployment name

# Define two simple agents
class AgentA:
    def __init__(self, kernel):
        self.kernel = kernel

    async def ask(self, prompt):
        return await self.kernel.invoke(prompt)

class AgentB:
    def __init__(self, kernel):
        self.kernel = kernel

    async def ask(self, prompt):
        return await self.kernel.invoke(prompt)

async def main():
    # Set up Semantic Kernel with Azure OpenAI Chat Completion
    kernel = sk.Kernel()
    kernel.add_service(AzureChatCompletion(
        deployment_name=chat_deployment_name,
        api_key=AZURE_OPENAI_API_KEY,
        base_url=AZURE_OPENAI_ENDPOINT,
    ))
    # Create agents
    agent_a = AgentA(kernel)
    agent_b = AgentB(kernel)
    # Define the conversation
    conversation = [
        "Agent A: What is the capital of France?",
        "Agent B: The capital of France is Paris.",
        "Agent A: What is the population of Paris?",
        "Agent B: The population of Paris is approximately 2.1 million.",
    ]
    # Simulate the conversation
    for line in conversation:
        if line.startswith("Agent A:"):
            prompt = line.replace("Agent A:", "").strip()
            response = await agent_a.ask(prompt)
            print(f"Agent A: {response}")
        elif line.startswith("Agent B:"):
            prompt = line.replace("Agent B:", "").strip()
            response = await agent_b.ask(prompt)
            print(f"Agent B: {response}")
    # Run the main function
if __name__ == "__main__":
    asyncio.run(main())
