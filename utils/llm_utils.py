import os
import requests

class AzureOpenAIChat:
    def __init__(self):
        self.api_key = os.environ["AZURE_OPENAI_API_KEY"]
        self.endpoint = os.environ["AZURE_OPENAI_ENDPOINT"]
        self.deployment = os.environ["AZURE_OPENAI_DEPLOYMENT_NAME"]
        self.api_version = "2024-05-01-preview"

    def chat(self, messages, temperature=0.2, max_tokens=1024):
        url = f"{self.endpoint}openai/deployments/{self.deployment}/chat/completions?api-version={self.api_version}"
        headers = {
            "Content-Type": "application/json",
            "api-key": self.api_key
        }
        payload = {
            "messages": messages,
            "temperature": temperature,
            "max_tokens": max_tokens
        }
        response = requests.post(url, headers=headers, json=payload, timeout=60)
        response.raise_for_status()
        return response.json()["choices"][0]["message"]["content"]
