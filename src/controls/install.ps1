# This module assesses against the following CIS controls:
# 1.1 Ensure ESXi is properly patched 
# 1.2 Ensure the Image Profile VIB acceptance level is configured properly
# 1.3 Ensure no unauthorized kernel modules are loaded on the host
# 1.4 Ensure the default value of individual salt per vm is configured

function Ensure-ESXiIsProperlyPatched {
    # CIS 1.1 Ensure ESXi is properly patched
    Write-Host "`n* CIS control 1.1 Ensure ESXi is properly patched" -ForegroundColor Blue
    
    # Read patches from a json file 
    $patches = Get-Content -Path $PSScriptRoot\..\..\patches.json | ConvertFrom-Json

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0
    # Get ESXi patches from the host and compare them to the patches in the json file
    Foreach ($VMHost in Get-VMHost) {
        $EsxCli = Get-EsxCli -VMHost $VMHost -V2
        # Get the name and version of the patch and store them in a hashtable
        $esxPatches = $EsxCli.software.vib.list.invoke() | Select-Object @{Name = 'Name'; Expression = { $_.Name } }, @{Name = 'Version'; Expression = { $_.Version } }
        
        # Compare the patches in the json file to the patches on the host
        Foreach ($hostpatch in $esxPatches) {
            Foreach ($patch in $patches) {
                if ($hostpatch.Name -eq $patch.Name) {
                    if ($hostpatch.Version -ne $patch.Version) {
                        Write-Host "- $($hostpatch.Name): Fail" -ForegroundColor Red
                        Write-Host "  Expected version: $($patch.Version)" -ForegroundColor Red
                        Write-Host "  Actual version: $($hostpatch.Version)" -ForegroundColor Red
                        $failed++
                        break
                    }
                    else {
                        Write-Host "- $($hostpatch.Name): Pass" -ForegroundColor Green
                        $passed++
                        break
                    }
                }
                else {
                    if ($patch -eq $patches[-1]) { 
                        Write-Host "- $($hostpatch.Name): Unknown" -ForegroundColor Yellow
                        Write-Host "  Patch not found in the json file" -ForegroundColor Yellow
                        $unknown++
                    }
                }

                
            }
        }
    }
    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow
}

function Ensure-VIBAcceptanceLevelIsConfiguredProperly {
    # CIS 1.2 Ensure the Image Profile VIB acceptance level is configured properly
    Write-Host "`n* CIS control 1.2 Ensure the Image Profile VIB acceptance level is configured properly" -ForegroundColor Blue
    
    $passed = 0
    $failed = 0
    # Get the Image Profile acceptance level for each VIB
    Foreach ($VMHost in Get-VMHost) {
        $EsxCli = Get-EsxCli -VMHost $VMHost -V2
        $vibs = $EsxCli.software.vib.list.invoke() | Select-Object @{Name = 'Name'; Expression = { $_.Name } }, @{Name = 'AcceptanceLevel'; Expression = { $_.AcceptanceLevel } }
        # Compare the acceptance level to the expected value
        Foreach ($vib in $vibs) {
            if ($vib.AcceptanceLevel -ne "CommunitySupported" -and $vib.AcceptanceLevel -ne "PartnerSupported" -and $vib.AcceptanceLevel -ne "VMwareCertified") {
                Write-Host "- $($vib.Name): Fail" -ForegroundColor Red
                Write-Host "  Expected acceptance level: communitySupported" -ForegroundColor Red
                Write-Host "  Actual acceptance level: $($vib.AcceptanceLevel)" -ForegroundColor Red
                $failed++
            }
            else {
                Write-Host "- $($vib.Name): Pass" -ForegroundColor Green
                Write-Host "  Acceptance level: $($vib.AcceptanceLevel)" -ForegroundColor Green
                $passed++
            }
        }
    }
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
}

function Ensure-UnauthorizedModulesNotLoaded {
    # CIS 1.3 Ensure no unauthorized kernel modules are loaded on the host
    Write-Host "`n* CIS control 1.3 Ensure no unauthorized kernel modules are loaded on the host" -ForegroundColor Blue
    
    # Get the list of loaded kernel modules and check if they are authorized
    $passed = 0
    $failed = 0
    Foreach ($VMHost in Get-VMHost) {
        $ESXCli = Get-EsxCli -VMHost $VMHost
        $systemModules = $ESXCli.system.module.list() | Foreach {
            $ESXCli.system.module.get($_.Name) | Select @{N = "VMHost"; E = { $VMHost } }, Module, License, Modulefile, Version, ContainingVIB, VIBAcceptanceLevel
        }

        # Check if the module corresponding VIB has an acceptance level is certified, exclude vmkernel module
        Foreach ($module in $systemModules) {
            if ($module.Module -ne "vmkernel") {
                if ($module.VIBAcceptanceLevel -ne "certified") {
                Write-Host "- $($module.Module): Fail" -ForegroundColor Red
                Write-Host "  Containing VIB: $($module.ContainingVIB)" -ForegroundColor Red
                Write-Host "  VIB acceptance level: $($module.VIBAcceptanceLevel)" -ForegroundColor Red
                $failed++
                }
                else {
                    Write-Host "- $($module.Module): Pass" -ForegroundColor Green
                    Write-Host "  Containing VIB: $($module.ContainingVIB)" -ForegroundColor Green
                    Write-Host "  VIB acceptance level: $($module.VIBAcceptanceLevel)" -ForegroundColor Green
                    $passed++
                }
            }
        }
    }
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
}


function Ensure-DefaultSaultIsConfiguredProperly {
    # CIS 1.4 Ensure the default value of individual salt per vm is configured
    Write-Host "`n* CIS control 1.4 Ensure the default value of individual salt per vm is configured" -ForegroundColor Blue
    
    $passed = 0
    $failed = 0
    # Get the default value of individual salt per vm using Get-AdvancedSetting
    $expectedSaltValue = 2
    $actualSaltValue = Get-VMHost | Get-AdvancedSetting -Name "Mem.ShareForceSalting" | Select-Object -ExpandProperty Value

    # Compare the value to the expected value
    if ($actualSaltValue -ne $expectedSaltValue) {
        Write-Host "- Default value of individual salt per vm: Fail" -ForegroundColor Red
        Write-Host "  Expected value: $expectedSaltValue" -ForegroundColor Red
        Write-Host "  Actual value: $actualSaltValue" -ForegroundColor Red
        $failed++
    }
    else {
        Write-Host "- Default value of individual salt per vm: Pass" -ForegroundColor Green
        Write-Host "  Expected Value: $actualSaltValue" -ForegroundColor Green
        Write-Host "  Actual Value: $actualSaltValue" -ForegroundColor Green
        $passed++
    }
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red

    
}