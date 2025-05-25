#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Parses Azure Verified Modules Pattern pages and converts to Markdown.

.DESCRIPTION
    This script reads the HTML content of the Azure Verified Modules Pattern
    Specifications pages for both Terraform and Bicep, parses the tables,
    and generates structured Markdown documents.
    
    It first clones the Azure Verified Modules repository to get the latest specs,
    then processes the module specifications and generates markdown documentation.

.NOTES
    File Name: fetch-pattern-specs.ps1
    Author: GitHub Copilot
    Date: March 26, 2025
#>

# Configuration
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$terraformUrl = "https://azure.github.io/Azure-Verified-Modules/specs/tf/ptn/"
$bicepUrl = "https://azure.github.io/Azure-Verified-Modules/specs/bcp/ptn/"
$tfInputHtmlFile = Join-Path $scriptDir "avm-pattern-terraform-page.html"
$bicepInputHtmlFile = Join-Path $scriptDir "avm-pattern-bicep-page.html"
$tfOutputFile = Join-Path $scriptDir "avm-pattern-terraform-spec.md"
$bicepOutputFile = Join-Path $scriptDir "avm-pattern-bicep-spec.md"
$specFilesDir = Join-Path $scriptDir "avm-specs/content/specs-defs/includes" # Used to build specification mapping
$specFilesDestDir = Join-Path $scriptDir "specs" # Destination directory for moved spec files
$cleanupAfterRun = $true # Set to $false to keep downloaded HTML files and unused specification files
$fetchSpecsFromRepo = $true # Set to $false to skip cloning the AVM repo

# Track used specification files
$usedSpecFiles = @{}

# Function to initialize the AVM specs by cloning the repository
function Initialize-AvmSpecs {
    # Repository and directory configuration
    $repoUrl = "https://github.com/Azure/Azure-Verified-Modules.git"
    $tempDir = Join-Path $env:TEMP "avm-temp-clone"
    $targetDir = Join-Path $scriptDir "avm-specs"
    
    # Ensure we have a clean start
    Write-Host "Preparing environment..." -ForegroundColor Cyan
    if (Test-Path $tempDir) {
        Remove-Item -Path $tempDir -Recurse -Force
    }
    
    if (Test-Path $targetDir) {
        Write-Host "Removing existing specs directory..." -ForegroundColor Yellow
        Remove-Item -Path $targetDir -Recurse -Force
    }
    
    try {
        # Clone the repository to temporary location
        Write-Host "Cloning Azure Verified Modules repository..." -ForegroundColor Green
        git clone $repoUrl $tempDir --depth 1
        
        if (-not $?) {
            throw "Failed to clone repository. Please check your network connection and try again."
        }
        
        # Check if the docs/content directory exists
        $contentDir = Join-Path $tempDir "docs/content"
        if (-not (Test-Path $contentDir)) {
            throw "The docs/content directory was not found in the cloned repository."
        }
        
        # Create target directory
        New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
        
        # Copy only the docs/content directory
        Write-Host "Extracting docs/content directory..." -ForegroundColor Green
        Copy-Item -Path $contentDir -Destination $targetDir -Recurse
        
        Write-Host "Successfully prepared AVM specs content at: $targetDir" -ForegroundColor Green
        Write-Host "This directory contains only the documentation content from the repository." -ForegroundColor Gray
        
        return $true
    }
    catch {
        $errorMessage = $_.Exception.Message
        Write-Host "Error preparing AVM specs - $errorMessage" -ForegroundColor Red
        return $false
    }
    finally {
        # Clean up temporary clone directory
        if (Test-Path $tempDir) {
            Write-Host "Cleaning up temporary files..." -ForegroundColor Gray
            Remove-Item -Path $tempDir -Recurse -Force
        }
    }
}

# Function to process a specification page and generate markdown
function ConvertFrom-SpecificationPage {
    param (
        [string]$url,
        [string]$inputHtmlFile,
        [string]$outputFile,
        [string]$moduleType # 'Terraform' or 'Bicep'
    )

    Write-Host "Parsing $moduleType HTML content from $url..." -ForegroundColor Cyan

    try {
        # Check if the HTML file exists
        if (-not (Test-Path -Path $inputHtmlFile)) {
            # If not, download it
            Write-Host "HTML file not found. Downloading from $url..." -ForegroundColor Yellow
            $webClient = New-Object System.Net.WebClient
            $webClient.Headers.Add("User-Agent", "Mozilla/5.0")
            $htmlContent = $webClient.DownloadString($url)
            $htmlContent | Out-File -FilePath $inputHtmlFile -Encoding UTF8
        } else {
            # Read the HTML content from file
            $htmlContent = Get-Content -Path $inputHtmlFile -Raw
        }
        
        Write-Host "Successfully loaded HTML content. Length: $($htmlContent.Length) characters" -ForegroundColor Gray
        
        # Extract categories from the HTML table of contents
        $tocPattern = '(?s)<nav\s+class=TableOfContents>.*?<ul>(.*?)</ul>'
        $tocMatch = [regex]::Match($htmlContent, $tocPattern)
        
        $categories = @()
        if ($tocMatch.Success) {
            $tocContent = $tocMatch.Groups[1].Value
            $categoryPattern = '<li><a\s+href=[^>]*>([^<]+)</a></li>'
            $categoryMatches = [regex]::Matches($tocContent, $categoryPattern)
            
            foreach ($match in $categoryMatches) {
                $categoryName = $match.Groups[1].Value.Trim()
                # Convert UI-formatted category names to the format used in the HTML sections
                $categoryNameFormatted = $categoryName.Replace(' / ', '/')
                $categories += $categoryNameFormatted
            }
            Write-Host "Extracted $($categories.Count) categories from the table of contents" -ForegroundColor Gray
        } else {
            # Fallback to default categories if TOC extraction fails
            Write-Host "Could not extract categories from the table of contents, using default categories." -ForegroundColor Yellow
            $categories = @(
                "Contribution/Support",
                "Telemetry",
                "Naming/Composition",
                "Resource Management",
                "Inputs/Outputs",
                "Testing",
                "Documentation",
                "Code Style",
                "Release/Publishing"
            )
        }
        
        # Build a mapping of specification IDs to their file paths
        Write-Host "Building specification ID to file path mapping..." -ForegroundColor Gray
        $specFiles = @()
        $specIdToPathMap = @{}
        
        if (Test-Path -Path $specFilesDir) {
            # Ensure destination directory exists
            if (-not (Test-Path -Path $specFilesDestDir)) {
                New-Item -Path $specFilesDestDir -ItemType Directory -Force | Out-Null
            }
            
            $specFiles = Get-ChildItem -Path $specFilesDir -Recurse -Filter "*.md"
            foreach ($file in $specFiles) {
                $id = $file.BaseName
                # Copy the file to ./ai-content/specs with just the ID as filename
                $destPath = Join-Path $specFilesDestDir "$id.md"
                Copy-Item -Path $file.FullName -Destination $destPath -Force
                Write-Host "  Copied $id spec file to $destPath" -ForegroundColor Gray
                
                # Update the mapping to point to the new location
                $specIdToPathMap[$id] = $destPath
            }
            Write-Host "Found and copied $($specFiles.Count) specification files to $specFilesDestDir" -ForegroundColor Gray
        } else {
            Write-Host "Specification files directory not found: $specFilesDir. Will use online URLs instead." -ForegroundColor Yellow
        }
        
        # Create a dictionary to store specifications by category
        $specsByCategory = @{}
        foreach ($category in $categories) {
            $specsByCategory[$category] = @()
        }
        
        # Function to clean up HTML text
        function ConvertFrom-HtmlText {
            param([string]$text)
            return $text -replace '<[^>]+>', '' -replace '&[^;]+;', '' -replace '\s+', ' ' -replace '^\s+|\s+$', ''
        }
        
        # Extract the category sections using regex
        $categoryPattern = '(?s)The content below is listed based on the following tags.*?Category-([^"]+).*?(?=The content below is listed based on the following tags|$)'
        $categoryMatches = [regex]::Matches($htmlContent, $categoryPattern)
        
        Write-Host "Found $($categoryMatches.Count) category sections" -ForegroundColor Gray
        
        foreach ($categoryMatch in $categoryMatches) {
            $categoryText = $categoryMatch.Value
            $categoryName = $categoryMatch.Groups[1].Value.Trim()
            
            # Skip if category is not in our list
            $matchedCategory = $categories | Where-Object { $categoryName -match $_ } | Select-Object -First 1
            if (-not $matchedCategory) {
                continue
            }
            
            Write-Host "Processing category: $matchedCategory" -ForegroundColor Gray
            
            # Extract rows from this category section - updated pattern to match actual HTML structure
            $rowPattern = '(?s)<tr[^>]*>\s*<td[^>]*>\d+</td>\s*<td[^>]*><a[^>]*>([A-Z]+[A-Z0-9]+)</a></td>\s*<td[^>]*>(.*?)</td>\s*<td[^>]*>.*?class=term-link[^>]*>(MUST|SHOULD|MAY|MUST NOT)</a>.*?</td>\s*<td[^>]*>.*?class=term-link[^>]*>([^<]+)</a>.*?</td>\s*<td[^>]*>.*?class=term-link[^>]*>([^<]+)</a>.*?</td>'
            $rowMatches = [regex]::Matches($categoryText, $rowPattern)
            
            Write-Host "  Found $($rowMatches.Count) specifications" -ForegroundColor Gray
            
            # Process each row in this category
            foreach ($row in $rowMatches) {
                $id = ConvertFrom-HtmlText -text $row.Groups[1].Value
                $title = ConvertFrom-HtmlText -text $row.Groups[2].Value
                $severity = ConvertFrom-HtmlText -text $row.Groups[3].Value
                $persona = ConvertFrom-HtmlText -text $row.Groups[4].Value
                $lifecycle = ConvertFrom-HtmlText -text $row.Groups[5].Value
                
                $specsByCategory[$matchedCategory] += [PSCustomObject]@{
                    ID = $id
                    Title = $title
                    Severity = $severity
                    Persona = $persona
                    Lifecycle = $lifecycle
                }
            }
        }
        
        # Count total specifications
        $totalSpecs = 0
        foreach ($category in $categories) {
            $totalSpecs += $specsByCategory[$category].Count
        }
        
        Write-Host "Found $totalSpecs specifications across $(($categories | Where-Object { $specsByCategory[$_].Count -gt 0 }).Count) categories." -ForegroundColor Green
        
        # If we didn't find any specifications, try an alternative approach
        if ($totalSpecs -eq 0) {
            Write-Host "No specifications found using category sections. Trying alternative approach..." -ForegroundColor Yellow
            
            # Try to extract all table rows with specification data
            $allRowPattern = '(?s)<tr[^>]*>\s*<td[^>]*>.*?([A-Z]+[A-Z0-9]+).*?</td>\s*<td[^>]*>(.*?)</td>\s*<td[^>]*>.*?>(MUST|SHOULD|MAY|MUST NOT).*?</td>\s*<td[^>]*>(.*?)</td>\s*<td[^>]*>(.*?)</td>'
            $allRowMatches = [regex]::Matches($htmlContent, $allRowPattern)
            
            Write-Host "Found $($allRowMatches.Count) specifications in tables" -ForegroundColor Gray
            
            # Hardcoded mapping of IDs to categories based on module type
            $idToCategoryMap = @{}
            if ($moduleType -eq "Terraform") {
                $idToCategoryMap = @{
                    "TFNFR1" = "Testing"
                    "TFNFR2" = "Testing"
                    "TFNFR3" = "Testing"
                    "TFNFR9" = "Documentation"
                    "TFNFR10" = "Documentation"
                    "TFNFR11" = "Documentation"
                    "PMTFNFR1" = "Naming/Composition"
                    "PMTFNFR2" = "Naming/Composition"
                    "PMTFNFR3" = "Naming/Composition"
                    "TFR5" = "Telemetry"
                    "TFR6" = "Telemetry"
                }
            } elseif ($moduleType -eq "Bicep") {
                $idToCategoryMap = @{
                    "BCPNFR1" = "Testing"
                    "BCPNFR8" = "Code Style"
                    "BCPNFR9" = "Documentation"
                    "BCPNFR10" = "Documentation"
                    "BCPNFR15" = "Contribution/Support"
                    "BCPNFR17" = "Code Style"
                    "BCPNRF22" = "Release/Publishing"
                    "PMBCPNFR1" = "Naming/Composition"
                    "PMBCPNFR2" = "Naming/Composition"
                    "SNFR8" = "Contribution/Support"
                    "SNFR9" = "Contribution/Support"
                    "SNFR10" = "Contribution/Support"
                    "SNFR11" = "Contribution/Support"
                    "SNFR12" = "Contribution/Support"
                    "SNFR20" = "Contribution/Support"
                    "SNFR21" = "Release/Publishing"
                }
            }
            
            foreach ($row in $allRowMatches) {
                $id = ConvertFrom-HtmlText -text $row.Groups[1].Value
                $title = ConvertFrom-HtmlText -text $row.Groups[2].Value
                $severity = ConvertFrom-HtmlText -text $row.Groups[3].Value
                $persona = ConvertFrom-HtmlText -text $row.Groups[4].Value
                $lifecycle = ConvertFrom-HtmlText -text $row.Groups[5].Value
                
                $category = $null
                
                # Try to determine category from the ID mapping
                if ($idToCategoryMap.ContainsKey($id)) {
                    $category = $idToCategoryMap[$id]
                } else {
                    # Try to infer category from ID prefix for each module type
                    if ($moduleType -eq "Terraform") {
                        switch -Regex ($id) {
                            '^PMTF' { $category = "Naming/Composition" }
                            '^TFR[0-9]' { $category = "Telemetry" }
                            '^TFNFR[0-9]' { 
                                # Check the title to make a guess
                                if ($title -match "Test|Validation|Idempotency|E2E") {
                                    $category = "Testing"
                                } elseif ($title -match "Document|Example|Changelog") {
                                    $category = "Documentation"
                                } elseif ($title -match "Style|Format|Naming") {
                                    $category = "Code Style"
                                } elseif ($title -match "GitHub|Owner|Contributor|Issue|Template") {
                                    $category = "Contribution/Support"
                                } else {
                                    $category = "Other"
                                }
                            }
                            default { $category = "Other" }
                        }
                    } elseif ($moduleType -eq "Bicep") {
                        switch -Regex ($id) {
                            '^PMBCP' { $category = "Naming/Composition" }
                            '^SFR[0-9]' { $category = "Telemetry" }
                            '^SNFR[0-9]' { $category = "Contribution/Support" }
                            '^BCPNFR[0-9]' { 
                                # Check the title to make a guess
                                if ($title -match "Test|Validation|Idempotency|E2E") {
                                    $category = "Testing"
                                } elseif ($title -match "Document|Example|Changelog") {
                                    $category = "Documentation"
                                } elseif ($title -match "Style|Format|Naming|Styling|Casing|Type casting") {
                                    $category = "Code Style"
                                } elseif ($title -match "GitHub|Owner|Contributor|Issue|Template") {
                                    $category = "Contribution/Support"
                                } elseif ($title -match "Publish|Version|Release") {
                                    $category = "Release/Publishing"
                                } else {
                                    $category = "Other"
                                }
                            }
                            default { $category = "Other" }
                        }
                    }
                }
                
                if ($category -and $categories -contains $category) {
                    $specsByCategory[$category] += [PSCustomObject]@{
                        ID = $id
                        Title = $title
                        Severity = $severity
                        Persona = $persona
                        Lifecycle = $lifecycle
                    }
                } else {
                    # Add to Other category
                    if (-not $specsByCategory.ContainsKey("Other")) {
                        $specsByCategory["Other"] = @()
                        $categories += "Other"
                    }
                    $specsByCategory["Other"] += [PSCustomObject]@{
                        ID = $id
                        Title = $title
                        Severity = $severity
                        Persona = $persona
                        Lifecycle = $lifecycle
                    }
                }
            }
            
            # Recount total
            $totalSpecs = 0
            foreach ($category in $categories) {
                $totalSpecs += $specsByCategory[$category].Count
            }
        }
        
        # Function to get the link for a specification ID
        function Get-SpecificationLink {
            param([string]$id, [string]$moduleType)
            
            # Check if we have a direct file match
            if ($specIdToPathMap.ContainsKey($id)) {
                # Mark this spec file as used for cleanup later
                $script:usedSpecFiles[$id] = $true
                # Return a relative path to the spec file in the specs directory
                return "specs/$id.md"
            }
            
            # If no direct match, determine the default link based on ID prefix and module type
            if ($id -and $id.Length -ge 2) {
                $prefix = $id.Substring(0, 2)
                
                $baseLink = "https://azure.github.io/Azure-Verified-Modules/specs/"
                
                if ($moduleType -eq "Terraform") {
                    $linkPath = switch ($prefix) {
                        "TF" { "tf/" }
                        "PM" { "tf/ptn/" }
                        "SN" { "shared/" }
                        "SF" { "shared/" }
                        default { "tf/" } # Default to tf/ for unknown prefixes
                    }
                } elseif ($moduleType -eq "Bicep") {
                    $linkPath = switch ($prefix) {
                        "BC" { "bcp/" }
                        "PM" { "bcp/ptn/" }
                        "SN" { "shared/" }
                        "SF" { "shared/" }
                        default { "bcp/" } # Default to bcp/ for unknown prefixes
                    }
                } else {
                    $linkPath = "shared/"
                }
                
                return "$baseLink$linkPath#$($id.ToLower())"
            }
            
            # Fallback if ID is invalid
            if ($moduleType -eq "Terraform") {
                return "https://azure.github.io/Azure-Verified-Modules/specs/tf/"
            } else {
                return "https://azure.github.io/Azure-Verified-Modules/specs/bcp/"
            }
        }
        
        # Generate Markdown content
        $markdown = @"
# $moduleType Pattern Module Specifications | Azure Verified Modules

This document contains specifications and best practices for Azure Verified Modules (AVM) $moduleType Pattern Modules.

## Table of Contents
"@
        
        foreach ($category in $categories) {
            if ($specsByCategory[$category].Count -gt 0) {
                $markdownCategory = $category.Replace('/', ' / ')
                $anchor = $category.ToLower().Replace('/', '-').Replace(' ', '-')
                $markdown += "`n- [$markdownCategory](#$anchor)"
            }
        }
        
        $markdown += "`n`n"
        
        foreach ($category in $categories) {
            if ($specsByCategory[$category].Count -gt 0) {
                $markdownCategory = $category.Replace('/', ' / ')
                $markdown += "## $markdownCategory`n`n"
                $markdown += "| ID | Title | Severity | Persona | Lifecycle |`n"
                $markdown += "|----|-------|----------|---------|-----------|`n"
                
                foreach ($spec in $specsByCategory[$category]) {
                    $specLink = Get-SpecificationLink -id $spec.ID -moduleType $moduleType
                    $markdown += "| [$($spec.ID)]($specLink) | $($spec.Title) | $($spec.Severity) | $($spec.Persona) | $($spec.Lifecycle) |`n"
                }
                
                $markdown += "`n"
            }
        }
        
        $markdown += @"
---

*Note: This document was generated from content at [Azure Verified Modules - $moduleType Pattern Modules]($url). For complete and up-to-date information, please refer to the original source.*

*This document was generated on $(Get-Date -Format "MMMM d, yyyy") using an automated script.*
"@
        
        # Save to file
        $markdown | Out-File -FilePath $outputFile -Encoding utf8
        
        Write-Host "Successfully generated Markdown file: $outputFile" -ForegroundColor Green
        Write-Host "The file contains $totalSpecs specifications organized by category." -ForegroundColor Gray
        
        return $true
    } catch {
        $errorMessage = $_.Exception.Message
        $errorStackTrace = $_.ScriptStackTrace
        Write-Host "Error processing $moduleType page - $errorMessage" -ForegroundColor Red
        Write-Host "Stack Trace - $errorStackTrace" -ForegroundColor Red
        return $false
    }
}

# Function to perform cleanup after processing
function Clear-ProcessingArtifacts {
    param(
        [string[]]$htmlFiles,
        [string]$specsDir,
        [hashtable]$usedFiles
    )
    
    Write-Host "`nPerforming cleanup..." -ForegroundColor Cyan
    
    # 1. Remove downloaded HTML files
    foreach ($file in $htmlFiles) {
        if (Test-Path $file) {
            try {
                Remove-Item -Path $file -Force
                Write-Host "  Removed HTML file: $file" -ForegroundColor Gray
            } catch {
                $errorMessage = $_.Exception.Message
                Write-Host "  Failed to remove HTML file $file - $errorMessage" -ForegroundColor Yellow
            }
        }
    }
    
    # 2. Remove the entire avm-specs directory
    $avmSpecsDir = Join-Path $scriptDir "avm-specs"
    if (Test-Path $avmSpecsDir) {
        try {
            Write-Host "  Removing entire avm-specs directory..." -ForegroundColor Gray
            Remove-Item -Path $avmSpecsDir -Recurse -Force
            Write-Host "  Successfully removed $avmSpecsDir" -ForegroundColor Gray
        } catch {
            $errorMessage = $_.Exception.Message
            Write-Host "  Failed to remove avm-specs directory - $errorMessage" -ForegroundColor Yellow
        }
    }
    
    # 3. Clean up unused spec files in the specs directory
    if (Test-Path $specFilesDestDir) {
        $allSpecFiles = Get-ChildItem -Path $specFilesDestDir -Filter "*.md" | Where-Object { $_.Name -match "^[A-Z]+[A-Z0-9]+\.md$" }
        $unusedSpecFiles = @()
        
        foreach ($file in $allSpecFiles) {
            $id = $file.BaseName
            if (-not $usedFiles.ContainsKey($id)) {
                $unusedSpecFiles += $file.FullName
            }
        }
        
        if ($unusedSpecFiles.Count -gt 0) {
            Write-Host "  Found $($unusedSpecFiles.Count) unused specification files in specs directory" -ForegroundColor Gray
            
            # Delete unused files automatically without confirmation
            foreach ($file in $unusedSpecFiles) {
                try {
                    Remove-Item -Path $file -Force
                    Write-Host "  Removed unused spec file: $file" -ForegroundColor Gray
                } catch {
                    $errorMessage = $_.Exception.Message
                    Write-Host "  Failed to remove spec file $file - $errorMessage" -ForegroundColor Yellow
                }
            }
        } else {
            Write-Host "  No unused specification files found in specs directory" -ForegroundColor Gray
        }
    }
    
    Write-Host "Cleanup completed" -ForegroundColor Green
}

# Main execution flow
Write-Host "=== Azure Verified Modules Specification Processor ===" -ForegroundColor Magenta
Write-Host "Starting script execution..." -ForegroundColor Cyan

# Step 1: First prepare the AVM specs if enabled
if ($fetchSpecsFromRepo) {
    $specsReady = Initialize-AvmSpecs
    if (-not $specsReady) {
        Write-Host "Warning: Failed to prepare AVM specs. Will continue using online references." -ForegroundColor Yellow
    }
}

# Step 2: Process the Terraform pattern modules
Write-Host "Processing Terraform Pattern Modules..." -ForegroundColor Cyan
$tfResult = ConvertFrom-SpecificationPage -url $terraformUrl -inputHtmlFile $tfInputHtmlFile -outputFile $tfOutputFile -moduleType "Terraform"

# Step 3: Process the Bicep pattern modules
Write-Host "Processing Bicep Pattern Modules..." -ForegroundColor Cyan
$bicepResult = ConvertFrom-SpecificationPage -url $bicepUrl -inputHtmlFile $bicepInputHtmlFile -outputFile $bicepOutputFile -moduleType "Bicep"

# Step 4: Summary
Write-Host "`n=== Summary ===" -ForegroundColor Green
if ($tfResult) {
    Write-Host "✓ Successfully generated Terraform Pattern Modules: $tfOutputFile" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to generate Terraform Pattern Modules" -ForegroundColor Red
}

if ($bicepResult) {
    Write-Host "✓ Successfully generated Bicep Pattern Modules: $bicepOutputFile" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to generate Bicep Pattern Modules" -ForegroundColor Red
}

# Step 5: Perform cleanup if enabled
if ($cleanupAfterRun) {
    Clear-ProcessingArtifacts -htmlFiles @($tfInputHtmlFile, $bicepInputHtmlFile) -specsDir $specFilesDir -usedFiles $usedSpecFiles
}