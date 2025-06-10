

This project uses several tools and dependencies to support Terraform code generation, validation, and analysis. Below is a list of requirements and instructions on how to set up and use the codebase.

## Python Requirements

Install the required Python packages:

```bash
pip install -r requirements.txt
```

## Terraform Requirements

- [Terraform](https://www.terraform.io/downloads.html): Infrastructure as Code tool.
- [tflint](https://github.com/terraform-linters/tflint): Linter for Terraform files.
- [tfsec](https://github.com/aquasecurity/tfsec): Security scanner for Terraform code.
- [tffmt](https://github.com/antonbabenko/tffmt): Formatter for Terraform files (optional, for formatting).


### Install these tools on Windows (using Chocolatey):

```powershell
choco install terraform
choco install tflint
choco install tfsec
choco install tffmt
```

If you do not have [Chocolatey](https://chocolatey.org/install), follow the installation instructions on their respective GitHub pages:
- [Terraform](https://www.terraform.io/downloads.html)
- [tflint](https://github.com/terraform-linters/tflint)
- [tfsec](https://github.com/aquasecurity/tfsec)
- [tffmt](https://github.com/antonbabenko/tffmt)


## Usage Instructions

1. **Clone the repository** and navigate to the project directory.
2. **Install Python dependencies**:

   ```bash
   pip install -r requirements.txt
   ```

3. **Install Terraform and related tools** as described above.

### Code Generation

To generate Terraform code, run:

```bash
python main.py
```

The generated Terraform files will appear in the `generated_tf/` directory.


### Validation Only

To validate existing Terraform code (without generating new code), you can use the following command:

```bash
python main.py --validation_only "<path/to/terraform/directory>"
```

This command will:
- Run `tflint` to lint the Terraform code.
- Run `tfsec` to check for security issues.
- Run `terraform validate` to validate the configuration.
- Run `tffmt` to format the code (if enabled in the script).

**Outputs:**
- Linting results (tflint) will be displayed in the terminal and/or saved in the `validations/` directory.
- Security scan results (tfsec) will be displayed and/or saved in the `validations/` directory.
- Validation results (terraform validate) will be shown in the terminal and/or saved in the `validations/` directory.
- Formatted files (if tffmt is run) will update the Terraform files in place.

You can also use the scripts in the `agents/` or `plugins/` directories for more advanced validation or custom workflows.

## Additional Notes

- Ensure you have the correct versions of each tool as required by your infrastructure policies.
- For more details, refer to the documentation of each tool.

---

*This file was auto-generated to help you set up and use the codebase efficiently.*
