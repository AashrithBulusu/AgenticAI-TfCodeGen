import os
import requests
import time

class AzureOpenAIChat:
    def __init__(self):
        self.api_key = os.environ["AZURE_OPENAI_API_KEY"]
        self.endpoint = os.environ["AZURE_OPENAI_ENDPOINT"]
        self.deployment = os.environ["AZURE_OPENAI_DEPLOYMENT_NAME"]
        self.api_version = "2024-05-01-preview"

    def chat(self, messages, temperature=0.2, max_tokens=1024, retries=5, backoff_factor=2):
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
        for attempt in range(retries):
            response = requests.post(url, headers=headers, json=payload, timeout=60)
            if response.status_code == 429:
                # Azure sometimes returns a 'Retry-After' header (in seconds)
                retry_after = response.headers.get('Retry-After')
                if retry_after is not None:
                    wait = int(retry_after)
                else:
                    wait = backoff_factor ** attempt
                print(f"[AzureOpenAIChat] Rate limited (429). Retrying in {wait} seconds...")
                time.sleep(wait)
                continue
            try:
                response.raise_for_status()
                return response.json()["choices"][0]["message"]["content"]
            except Exception as e:
                print(f"[AzureOpenAIChat] Error: {e}")
                raise
        raise Exception("Exceeded maximum retries due to rate limiting.")
