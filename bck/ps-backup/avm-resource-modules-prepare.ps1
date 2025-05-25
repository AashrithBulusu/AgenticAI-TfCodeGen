# Script to extract published Azure Verified Modules with version from URLs
# Output is saved in Markdown format for Bicep and Terraform modules

# Configuration
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$bicepResourceModulesUrl = "https://azure.github.io/Azure-Verified-Modules/indexes/bicep/bicep-resource-modules/"
$terraformResourceModulesUrl = "https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/"
$bicepOutputFile = Join-Path $scriptDir "avm-resource-modules-bicep.md"
$terraformOutputFile = Join-Path $scriptDir "avm-resource-modules-terraform.md"

# Function to fetch HTML content from URL
function Fetch-HtmlContent {
    param (
        [string]$Url
    )
    
    try {
        $response = Invoke-WebRequest -Uri $Url -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            $contentSizeKB = [math]::Round($response.Content.Length / 1024, 1)
            Write-Host "Successfully fetched HTML content from $Url ($contentSizeKB KB)"
            return $response.Content
        }
        else {
            Write-Host "Failed to fetch HTML content from $Url with status code $($response.StatusCode)"
            return $null
        }
    }
    catch {
        Write-Host "Error fetching HTML content from $Url"
        return $null
    }
}

# Function to extract modules from HTML content
function Extract-Modules {
    param (
        [string]$HtmlContent,
        [string]$ModuleType  # 'Bicep' or 'Terraform'
    )
    
    $results = @{}  # Using a hashtable with module name as key to avoid duplicates
    
    if ($ModuleType -eq 'Bicep') {
        # Split HTML into rows to avoid duplicate matches
        $rows = $HtmlContent -split '<tr'
        
        Write-Host "Processing $($rows.Count) rows from HTML"
        $moduleCount = 0
        
        foreach ($row in $rows) {
            # Skip rows that don't contain module information
            if (-not $row.Contains('<td style=text-align:right>') -or -not $row.Contains('<a href=')) {
                continue
            }
            
            # Extract module info from the row
            $urlMatch = [regex]::Match($row, '<a\s+href=([^>]+)>([^<]+)</a>')
            if (-not $urlMatch.Success) {
                continue
            }
            
            $url = $urlMatch.Groups[1].Value
            $moduleName = $urlMatch.Groups[2].Value
            
            # Skip if this doesn't look like a module name
            if (-not $moduleName.StartsWith('avm/res/')) {
                continue
            }
            
            $displayNameMatch = [regex]::Match($row, '<b>([^<]+)</b>')
            $displayName = if ($displayNameMatch.Success) { $displayNameMatch.Groups[1].Value } else { $moduleName }
            
            # Look for version in the badge
            $versionPattern = "badge/(Available|Orphaned)%20[^-]+-([0-9\.]+)-"
            $versionMatch = [regex]::Match($row, $versionPattern)
            
            if ($versionMatch.Success) {
                $status = $versionMatch.Groups[1].Value
                $version = $versionMatch.Groups[2].Value
                
                # Use module name as key to avoid duplicates
                if (-not $results.ContainsKey($moduleName)) {
                    $moduleCount++
                    $results[$moduleName] = [PSCustomObject]@{
                        Name = $moduleName
                        DisplayName = $displayName
                        Version = $version
                        URL = $url
                        Status = $status
                    }
                }
            }
        }
        
        Write-Host "Found $moduleCount unique Bicep modules"
    }
    elseif ($ModuleType -eq 'Terraform') {
        # Split HTML into rows to avoid duplicate matches
        $rows = $HtmlContent -split '<tr'
        
        Write-Host "Processing $($rows.Count) rows from HTML"
        $moduleCount = 0
        
        foreach ($row in $rows) {
            # Skip rows that don't contain module information
            if (-not $row.Contains('<td style=text-align:right>') -or -not $row.Contains('<a href=')) {
                continue
            }
            
            # Extract module info from the row
            $urlMatch = [regex]::Match($row, '<a\s+href=([^>]+)>([^<]+)</a>')
            if (-not $urlMatch.Success) {
                continue
            }
            
            $registryUrl = $urlMatch.Groups[1].Value
            $moduleName = $urlMatch.Groups[2].Value
            
            # Skip if this doesn't look like a module name
            if (-not $moduleName.StartsWith('avm-res-')) {
                continue
            }
            
            $sourceUrlMatch = [regex]::Match($row, '<td\s+style=text-align:center><a\s+href=([^"\s]+)')
            $sourceUrl = if ($sourceUrlMatch.Success) { $sourceUrlMatch.Groups[1].Value } else { "" }
            
            $displayNameMatch = [regex]::Match($row, '<b>([^<]+)</b>')
            $displayName = if ($displayNameMatch.Success) { $displayNameMatch.Groups[1].Value } else { $moduleName }
            
            $versionPattern = "Available%20%f0%9f%9f%a2-([0-9\.]+)-purple"
            $versionMatch = [regex]::Match($row, $versionPattern)
            
            if ($versionMatch.Success) {
                $version = $versionMatch.Groups[1].Value
                
                # Use module name as key to avoid duplicates
                if (-not $results.ContainsKey($moduleName)) {
                    $moduleCount++
                    $results[$moduleName] = [PSCustomObject]@{
                        Name = $moduleName
                        DisplayName = $displayName
                        Version = $version
                        URL = $registryUrl
                        SourceURL = $sourceUrl
                        Status = "Available"
                    }
                }
            }
        }
        
        Write-Host "Found $moduleCount unique Terraform modules"
    }
    
    # Convert hashtable to array for return
    $resultArray = $results.Values | Sort-Object -Property Name
    Write-Host "Extracted $($resultArray.Count) unique modules from $ModuleType HTML content"
    return $resultArray
}

# Function to format results as markdown table with clickable links
function Format-ModuleMarkdown {
    param (
        [array]$Modules,
        [string]$ModuleType # 'Bicep' or 'Terraform'
    )
    
    $markdown = "# Azure Verified $ModuleType Resource Modules`n`n"
    $markdown += "Generated on: $(Get-Date)`n`n"
    
    if ($ModuleType -eq 'Bicep') {
        $markdown += "| # | Module Name | Display Name | Version | Source Code |`n"
        $markdown += "|---|------------|--------------|---------|-----|`n"
        
        $count = 1
        foreach ($module in $Modules) {
            $markdown += "| $count | $($module.Name) | $($module.DisplayName) | $($module.Version) | $($module.URL) |`n"
            $count++
        }
    }
    else {
        $markdown += "| # | Module Name | Display Name | Version | Registry | Source Code |`n"
        $markdown += "|---|------------|--------------|---------|----------|-------------|`n"
        
        $count = 1
        foreach ($module in $Modules) {
            $markdown += "| $count | $($module.Name) | $($module.DisplayName) | $($module.Version) | $($module.URL) | $($module.SourceURL) |`n"
            $count++
        }
    }
    
    $markdown += "`n`n_Note: This file was automatically generated from the public AVM module catalog._"
    return $markdown
}

# Main script execution
Write-Host "Starting Azure Verified Modules extraction process..."

# Fetch Bicep modules
$bicepHtml = Fetch-HtmlContent -Url $bicepResourceModulesUrl
if ($bicepHtml) {
    $bicepModules = Extract-Modules -HtmlContent $bicepHtml -ModuleType 'Bicep'
    if ($bicepModules.Count -gt 0) {
        $bicepMarkdown = Format-ModuleMarkdown -Modules $bicepModules -ModuleType 'Bicep'
        Set-Content -Path $bicepOutputFile -Value $bicepMarkdown
        Write-Host "Bicep results written to $bicepOutputFile"
    }
    else {
        Write-Host "No Bicep modules found. Generating empty output file."
        Set-Content -Path $bicepOutputFile -Value "# Azure Verified Bicep Resource Modules`n`nNo modules found.`n"
    }
}

# Fetch Terraform modules
$terraformHtml = Fetch-HtmlContent -Url $terraformResourceModulesUrl
if ($terraformHtml) {
    $terraformModules = Extract-Modules -HtmlContent $terraformHtml -ModuleType 'Terraform'
    if ($terraformModules.Count -gt 0) {
        $terraformMarkdown = Format-ModuleMarkdown -Modules $terraformModules -ModuleType 'Terraform'
        Set-Content -Path $terraformOutputFile -Value $terraformMarkdown
        Write-Host "Terraform results written to $terraformOutputFile"
    }
    else {
        Write-Host "No Terraform modules found. Generating empty output file."
        Set-Content -Path $terraformOutputFile -Value "# Azure Verified Terraform Resource Modules`n`nNo modules found.`n"
    }
}

Write-Host "Azure Verified Modules extraction process completed."