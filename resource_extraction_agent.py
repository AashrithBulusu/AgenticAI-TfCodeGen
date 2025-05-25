import re

class ResourceExtractionAgent:
    """Extracts Azure resources from a Markdown file."""
    def extract(self, md_path: str) -> list:
        print(f"[ResourceExtractionAgent] Extracting resources from markdown file: {md_path}")
        resources = []
        with open(md_path, 'r', encoding='utf-8') as f:
            for line in f:
                match = re.match(r'- ([a-zA-Z0-9_\-]+)', line.strip())
                if match:
                    resources.append(match.group(1))
        print(f"[ResourceExtractionAgent] Extracted resources: {resources}")
        return resources
