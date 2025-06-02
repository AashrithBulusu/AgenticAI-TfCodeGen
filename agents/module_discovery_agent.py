import re
import requests
from urllib.parse import urlparse
import os

class AVMModuleCatalogFetcher:
    TERRAFORM_URL = "https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/"

    @staticmethod
    def fetch_html(url: str) -> str:
        try:
            resp = requests.get(url, timeout=30)
            resp.raise_for_status()
            return resp.text
        except Exception:
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
        self.module_map = AVMModuleCatalogFetcher.get_terraform_modules()

    def find_module(self, resource: str) -> dict:
        # Robust mapping: try exact, partial, fuzzy, synonym, and display name matches
        resource_key = resource.replace('_', '').replace('-', '').lower()
        # 1. Exact match (ignoring avm-res- prefix and dashes/underscores)
        for mod in self.module_map.values():
            mod_key = mod['name'].replace('avm-res-', '').replace('-', '').replace('_', '').lower()
            if resource_key == mod_key:
                print(f"[find_module] Exact match: {resource} -> {mod['name']}")
                return mod
        # 2. Partial match (resource is substring of module name)
        for mod in self.module_map.values():
            mod_key = mod['name'].replace('avm-res-', '').replace('-', '').replace('_', '').lower()
            if resource_key in mod_key or mod_key in resource_key:
                print(f"[find_module] Partial match: {resource} -> {mod['name']}")
                return mod
        # 3. Fuzzy match: allow for plural/singular, common Azure synonyms
        synonyms = {
            'subnet': ['virtualnetworksubnet', 'subnets'],
            'manageddisk': ['disk', 'manageddisks'],
            'appserviceplan': ['serviceplan', 'appserviceplans'],
            'appservice': ['webapp', 'appservices', 'webapps'],
            'sqldatabase': ['sql', 'database', 'sqldatabases'],
            'monitoringdiagnostics': ['diagnosticsetting', 'diagnosticsettings'],
            'loganalyticsworkspace': ['loganalytics', 'workspace', 'loganalyticsworkspaces'],
            'appinsights': ['applicationinsights', 'insights'],
            'recoveryservicesvault': ['recoveryvault', 'vault', 'recoveryservicesvaults'],
            'backuppolicy': ['backup', 'policy', 'backuppolicies'],
            'trafficmanager': ['traffic', 'manager', 'trafficmanagers'],
            'rediscache': ['redis', 'cache', 'rediscaches'],
            'functionapp': ['function', 'functions', 'functionapps'],
            # Additional Azure resource synonyms for robustness
            'storageaccount': ['storage', 'storageaccounts'],
            'virtualmachine': ['vm', 'virtualmachines'],
            'networkinterface': ['nic', 'networkinterfaces'],
            'publicip': ['publicipaddress', 'publicipaddresses'],
            'keyvault': ['vault', 'keyvaults'],
            'aks': ['kubernetes', 'kubernetescluster', 'kubernetesclusters'],
            'vnet': ['virtualnetwork', 'vnets', 'virtualnetworks'],
            'nsg': ['networksecuritygroup', 'networksecuritygroups'],
            'lb': ['loadbalancer', 'loadbalancers'],
            'route': ['routetable', 'routetables'],
            'dnszone': ['dns', 'dnszones'],
            'eventhub': ['eventhubs', 'eventhubnamespace', 'eventhubnamespaces'],
            'cosmosdb': ['cosmos', 'cosmosdbs'],
            'servicebus': ['servicebuses', 'servicebusnamespace', 'servicebusnamespaces'],
            'containerregistry': ['acr', 'containerregistries'],
            'containerapp': ['containerapps'],
        }
        for syn, mod_names in synonyms.items():
            if resource_key == syn or resource_key in mod_names:
                for mod in self.module_map.values():
                    mod_key = mod['name'].replace('avm-res-', '').replace('-', '').replace('_', '').lower()
                    if any(mn in mod_key for mn in [syn] + mod_names):
                        print(f"[find_module] Synonym/fuzzy match: {resource} -> {mod['name']}")
                        return mod
        # 4. Last resort: try if resource is in display_name (case-insensitive, ignore spaces)
        for mod in self.module_map.values():
            display_name = mod.get('display_name', '').replace(' ', '').lower()
            if resource_key in display_name or resource.lower() in display_name:
                print(f"[find_module] Display name match: {resource} -> {mod['name']}")
                return mod
        # 5. Fallback: try case-insensitive match on all fields
        for mod in self.module_map.values():
            if resource.lower() in str(mod).lower():
                print(f"[find_module] Fallback case-insensitive match: {resource} -> {mod['name']}")
                return mod
        print(f"[find_module] No match found for resource: {resource}")
        return {}


class ModuleGitCloner:
    def __init__(self, module: dict):
        self.module = module
        self.github_token = os.environ.get('GITHUB_TOKEN')  # Set this in your shell
        self.tf_content = self.fetch_tf_files_content()

    def github_headers(self):
        headers = {}
        if self.github_token:
            headers['Authorization'] = f'token {self.github_token}'
        return headers

    def fetch_tf_files_content(self) -> str:    
        git_url = self.module.get('source', '')
        if not git_url:
            raise ValueError("Module source URL is missing")

        # Parse the GitHub repo info
        parsed = urlparse(git_url)
        if 'github.com' not in parsed.netloc:
            raise NotImplementedError("Only GitHub repositories are supported in this version.")

        # Extract owner and repo name
        path_parts = parsed.path.strip('/').split('/')
        if len(path_parts) < 2:
            raise ValueError("Invalid GitHub repository URL.")
        owner, repo = path_parts[0], path_parts[1].replace('.git', '')

        # Get the default branch
        repo_api_url = f"https://api.github.com/repos/{owner}/{repo}"
        repo_info = requests.get(repo_api_url, headers=self.github_headers()).json()
        branch = repo_info.get('default_branch', 'main')

        # List files in the repo root
        contents_api_url = f"https://api.github.com/repos/{owner}/{repo}/contents?ref={branch}"
        files = requests.get(contents_api_url, headers=self.github_headers()).json()

        if not isinstance(files, list):
            # Handle error response from GitHub API
            error_msg = files.get('message', str(files)) if isinstance(files, dict) else str(files)
            raise RuntimeError(f"Failed to fetch repo contents from GitHub: {error_msg}")

        tf_content = []
        for file in files:
            if isinstance(file, dict) and file.get('name', '').endswith('.tf') and 'variable' in file.get('type', ''):
                file_content_url = file.get('download_url')
                if file_content_url:
                    content = requests.get(file_content_url, headers=self.github_headers()).text
                    tf_content.append(content)
        return "\n".join(tf_content)