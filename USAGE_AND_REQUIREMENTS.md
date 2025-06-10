
## Codebase Flow Diagram

Below is a detailed Mermaid diagram showing the flow of the codebase, the main agents, and their key functions:

```mermaid
flowchart TD
    subgraph Main
        M1[main.py]
        M2[AgentOrchestrator]
    end
    M1 -->|validation_only| VAgent[ValidationAgent.validate_code]
    M1 -->|validation_only| LLMVAgent[LLMValidationAgent.validate_code]
    M1 -->|else| M2
    M2 --> REAgent[ResourceExtractionAgent.extract]
    M2 --> MDAgent[ModuleDiscoveryAgent.find_module]
    M2 --> CGAgent[CodeGenerationAgent]
    M2 --> TFVAgent[TFVarsGeneratorAgent.generate_tfvars_file]
    M2 --> VAgent2[ValidationAgent.validate_code]
    M2 --> LLMVAgent2[LLMValidationAgent.validate_code]
    REAgent -->|resources| MDAgent
    MDAgent -->|module| CGAgent
    CGAgent -->|main.tf| Out1[main.tf]
    CGAgent -->|variables.tf| Out2[variables.tf]
    CGAgent -->|outputs.tf| Out3[outputs.tf]
    TFVAgent -->|terraform.tfvars| Out4[terraform.tfvars]
    VAgent2 -->|validation results| LLMVAgent2
    LLMVAgent2 -->|AI Review| Out5[validations/AI Review and Summary.md]
    VAgent -->|validation results| LLMVAgent
    LLMVAgent -->|AI Review| Out6[validations/AI Review and Explanation.md]
    
    subgraph Agents
        REAgent
        MDAgent
        CGAgent
        TFVAgent
        VAgent
        LLMVAgent
        VAgent2
        LLMVAgent2
    end
    subgraph Outputs
        Out1
        Out2
        Out3
        Out4
        Out5
        Out6
    end
    
    CGAgent -.->|fix_code_with_validation| CGAgent
    CGAgent -.->|generate_main_tf| Out1
    CGAgent -.->|generate_variables_tf| Out2
    CGAgent -.->|generate_outputs_tf| Out3
    TFVAgent -.->|generate_tfvars_for_block| Out4
```

**Legend:**
- **main.py**: Entry point, parses arguments and runs either validation or full pipeline.
- **AgentOrchestrator**: Coordinates the pipeline, calling each agent in sequence.
- **ResourceExtractionAgent**: Extracts resource names from `resources.md`.
- **ModuleDiscoveryAgent**: Maps resource names to Terraform modules.
- **CodeGenerationAgent**: Generates `main.tf`, `variables.tf`, and `outputs.tf`.
- **TFVarsGeneratorAgent**: Generates `terraform.tfvars` from variables.
- **ValidationAgent**: Runs tflint, tfsec, terraform fmt, and validate.
- **LLMValidationAgent**: Uses LLM to review and explain validation results.
- **Outputs**: Generated files and validation reports.