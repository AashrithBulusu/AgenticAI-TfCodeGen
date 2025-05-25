

import re
import requests
from semantic_kernel.functions import kernel_function



class AVMModuleCatalogFetcher:
    TERRAFORM_URL = "https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/"

    @staticmethod
    def fetch_html(url: str) -> str:
        try:
            resp = requests.get(url, timeout=30)
            resp.raise_for_status()
            print(f"[INFO] Fetched {url} ({len(resp.content)//1024} KB)")
            return resp.text
        except Exception as e:
            print(f"[ERROR] Error fetching {url}: {e}")
            return ""

    @classmethod
    def get_terraform_modules(cls) -> dict:
        html = cls.fetch_html(cls.TERRAFORM_URL)
        rows = html.split('<tr')
        modules = {}
        for row in rows:
            if '<td style=text-align:right>' not in row or '<a href=' not in row:
                continue
            url_match = re.search(r'<a\s+href=([^>]+)>([^<]+)</a>', row)
            if not url_match:
                continue
            registry_url = url_match.group(1)
            module_name = url_match.group(2)
            if not module_name.startswith('avm-res-'):
                continue
            source_url_match = re.search(r'<td\s+style=text-align:center><a\s+href=([^"\s]+)', row)
            source_url = source_url_match.group(1) if source_url_match else ""
            display_name_match = re.search(r'<b>([^<]+)</b>', row)
            display_name = display_name_match.group(1) if display_name_match else module_name
            version_match = re.search(r'Available%20%f0%9f%9f%a2-([0-9\.]+)-purple', row)
            if version_match:
                version = version_match.group(1)
                if module_name not in modules:
                    modules[module_name] = {
                        'name': module_name,
                        'display_name': display_name,
                        'version': version,
                        'registry': registry_url,
                        'source': source_url,
                        'status': 'Available'
                    }
        return modules


class ModuleDiscoveryAgent:
    def __init__(self):
        print("[INFO] Fetching AVM Terraform module catalog from public index ...")
        self.module_map = AVMModuleCatalogFetcher.get_terraform_modules()

    @kernel_function(name="find_module", description="Map resource to AVM module")
    def find_module(self, resource: str) -> dict:
        print(f"[INFO] Finding AVM module for resource: {resource}")
        resource_key = resource.replace('_', '').replace('-', '').lower()
        for mod in self.module_map.values():
            mod_key = mod['name'].replace('avm-res-', '').replace('-', '').replace('_', '').lower()
            if resource_key == mod_key:
                print(f"[INFO] Found exact match for {resource}: {mod}")
                return mod
        for mod in self.module_map.values():
            mod_key = mod['name'].replace('avm-res-', '').replace('-', '').replace('_', '').lower()
            if resource_key in mod_key or mod_key in resource_key:
                print(f"[INFO] Found partial match for {resource}: {mod}")
                return mod
        print(f"[WARN] No module found for resource: {resource}")
        return {}
