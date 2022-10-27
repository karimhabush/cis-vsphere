# This module assesses against the following CIS controls:
# 5.1 (L1) Ensure the DCUI timeout is set to 600 seconds or less
# 5.2 (L1) Ensure the ESXi shell is disabled
# 5.3 (L1) Ensure SSH is disabled
# 5.4 (L1) Ensure CIM access is limited
# 5.5 (L1) Ensure Normal Lockdown mode is enabled
# 5.6 (L2) Ensure Strict Lockdown mode is enabled
# 5.7 (L2) Ensure the SSH authorized_keys file is empty
# 5.8 (L1) Ensure idle ESXi shell and SSH sessions time out after 300 seconds or less
# 5.9 (L1) Ensure the shell services timeout is set to 1 hour or less 
# 5.10 (L1) Ensure DCUI has a trusted users list for lockdown mode 
# 5.11 (L2) Ensure contents of exposed configuration files have not been modified





function Ensure-DCUITimeOutIs600 {
    # CIS 5.1 (L1) Ensure the DCUI timeout is set to 600 seconds or less
    Write-Host "`n* CIS control 5.1 (L1) Ensure the DCUI timeout is set to 600 seconds or less" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMhosts 
    $VMhosts = Get-VMHost | Select Name, @{N="DcuiTimeOut";E={$_ | Get-AdvancedSetting -Name UserVars.DcuiTimeOut | Select -ExpandProperty Value}}

    # Check the DCUI timeout
    Foreach ($VMhost in $VMhosts) {
        if ($VMhost.DcuiTimeOut -le 600) {
            Write-Host "- $($VMhost.Name): Passed" -ForegroundColor Green
            Write-Host "  The DCUI timeout is set to 600 seconds or less. " -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($VMhost.Name): Failed" -ForegroundColor Red
            Write-Host "  The DCUI timeout is not set to 600 seconds or less. " -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow

}

function Ensure-ESXiShellIsDisabled {
    # CIS 5.2 (L1) Ensure the ESXi shell is disabled
    Write-Host "`n* CIS control 5.2 (L1) Ensure the ESXi shell is disabled" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMhosts 
    $VMhosts = Get-VMHost | Get-VMHostService | Where { $_.key -eq "TSM" } | Select VMHost, Policy

    # Check the ESXi shell
    Foreach ($VMhost in $VMhosts) {
        if ($VMhost.Policy -eq "off") {
            Write-Host "- $($VMhost.VMHost): Passed" -ForegroundColor Green
            Write-Host "  The ESXi shell is disabled. " -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($VMhost.VMHost): Failed" -ForegroundColor Red
            Write-Host "  The ESXi shell is not disabled. " -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow

}

function Ensure-SSHIsDisabled {
    # CIS 5.3 (L1) Ensure SSH is disabled
    Write-Host "`n* CIS control 5.3 (L1) Ensure SSH is disabled" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMhosts 
    $VMhosts = Get-VMHost | Get-VMHostService | Where { $_.key -eq "TSM-SSH" } | Select VMHost, Policy

    # Check SSH
    Foreach ($VMhost in $VMhosts) {
        if ($VMhost.Policy -eq "off") {
            Write-Host "- $($VMhost.VMHost): Passed" -ForegroundColor Green
            Write-Host "  SSH is disabled. " -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($VMhost.VMHost): Failed" -ForegroundColor Red
            Write-Host "  SSH is not disabled. " -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow

}

function Ensure-CIMAccessIsLimited {
    # CIS 5.4 (L1) Ensure CIM access is limited
    Write-Host "`n* CIS control 5.4 (L1) Ensure CIM access is limited" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # This control needs to be verified manually
    Write-Host "- Check Unknown" -ForegroundColor Yellow
    Write-Host "  This control needs to be verified manually, refer to the CIS Benchmark for details" -ForegroundColor Yellow
    $unknown = 1
 

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow

}


function Ensure-NormalLockDownIsEnabled {
    # CIS 5.5 (L1) Ensure Normal Lockdown mode is enabled
    Write-Host "`n* CIS control 5.5 (L1) Ensure Normal Lockdown mode is enabled" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMhosts
    $VMhosts = Get-VMHost | Select Name,@{N="Lockdown";E={$_.Extensiondata.Config.adminDisabled}}

    # Check the lockdown mode
    Foreach ($VMhost in $VMhosts) {
        if ($VMhost.Lockdown -eq "Normal") {
            Write-Host "- $($VMhost.Name): Passed" -ForegroundColor Green
            Write-Host "  Normal Lockdown mode is enabled. " -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($VMhost.Name): Failed" -ForegroundColor Red
            Write-Host "  Normal Lockdown mode is not enabled. " -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow
}


function Ensure-StrickLockdownIsEnabled {
    # CIS 5.6 (L2) Ensure Strict Lockdown mode is enabled
    Write-Host "`n* CIS control 5.6 (L2) Ensure Strict Lockdown mode is enabled" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMhosts
    $VMhosts = Get-VMHost | Select Name,@{N="Lockdown";E={$_.Extensiondata.Config.adminDisabled}}

    # Check the lockdown mode
    Foreach ($VMhost in $VMhosts) {
        if ($VMhost.Lockdown -eq "Strict") {
            Write-Host "- $($VMhost.Name): Passed" -ForegroundColor Green
            Write-Host "  Strict Lockdown mode is enabled. " -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($VMhost.Name): Failed" -ForegroundColor Red
            Write-Host "  Strict Lockdown mode is not enabled. " -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow
}


function Ensure-SSHAuthorisedKeysFileIsEmpty {
    # CIS 5.7 (L2) Ensure SSH Authorized Keys file is empty
    Write-Host "`n* CIS control 5.7 (L2) Ensure SSH Authorized Keys file is empty" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # This control needs to be verified manually
    Write-Host "- Check Unknown" -ForegroundColor Yellow
    Write-Host "  This control needs to be verified manually, refer to the CIS Benchmark for details" -ForegroundColor Yellow
    $unknown = 1

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow
}


function Ensure-IdleESXiShellAndSSHTimeout {
    # CIS 5.8 (L1) Ensure idle ESXi shell and SSH sessions time out after 300 seconds or less
    Write-Host "`n* CIS control 5.8 (L1) Ensure idle ESXi shell and SSH sessions time out after 300 seconds or less" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMhosts
    $VMhosts = Get-VMHost | Select Name, @{N="UserVars.ESXiShellInteractiveTimeOut";E={$_ | Get-AdvancedSetting UserVars.ESXiShellInteractiveTimeOut | Select -ExpandProperty Values}}

    # Check the timeout
    Foreach ($VMhost in $VMhosts) {
        if ($VMhost.UserVars.ESXiShellInteractiveTimeOut -le 300 -and $VMhost.UserVars.ESXiShellInteractiveTimeOut -gt 0) {
            Write-Host "- $($VMhost.Name): Passed" -ForegroundColor Green
            Write-Host "  Idle ESXi shell and SSH sessions time out after 300 seconds or less. " -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($VMhost.Name): Failed" -ForegroundColor Red
            Write-Host "  Idle ESXi shell and SSH sessions time out not configured properly. " -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow

}

function Ensure-ShellServicesTimeoutIsProperlyConfigured {
    # CIS 5.9 (L1) Ensure the shell services timeout is set to 1 hour or less 
    Write-Host "`n* CIS control 5.9 (L1) Ensure the shell services timeout is set to 1 hour or less" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMhosts
    $VMhosts = Get-VMHost | Select Name, @{N="UserVars.ESXiShellTimeOut";E={$_ | Get-AdvancedSettings UserVars.ESXiShellTimeOut | Select -ExpandProperty Values}}

    # Check the timeout
    Foreach ($VMhost in $VMhosts) {
        if ($VMhost.UserVars.ESXiShellTimeOut -le 3600 -and $VMhost.UserVars.ESXiShellTimeOut -gt 0) {
            Write-Host "- $($VMhost.Name): Passed" -ForegroundColor Green
            Write-Host "  The shell services timeout is set to 1 hour or less. " -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($VMhost.Name): Failed" -ForegroundColor Red
            Write-Host "  The shell services timeout is not set to 1 hour or less. " -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow

}


function Ensure-DCUIHasTrustedUsersForLockDownMode {
    # CIS 5.10 (L1) Ensure DCUI has trusted users for Lock Down mode
    Write-Host "`n* CIS control 5.10 (L1) Ensure DCUI has trusted users for Lock Down mode" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMhosts
    $VMhosts = Get-VMHost | Select Name, @{N="DCUIAccess";E={$_ | Get-AdvancedSetting -Name DCUI.Access | Select -ExpandProperty Value}}

    # Check the DCUI access
    Foreach ($VMhost in $VMhosts) {
        if ($VMhost.DCUIAccess -ne $null) {
            Write-Host "- $($VMhost.Name): Passed" -ForegroundColor Green
            Write-Host "  DCUI has trusted users for Lock Down mode. " -ForegroundColor Green
            Write-Host "  DCUI users: $($VMhost.DCUIAccess)" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($VMhost.Name): Failed" -ForegroundColor Red
            Write-Host "  DCUI does not have trusted users for Lock Down mode. " -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow

}


function Ensure-ContentsOfExposedConfigurationsNotModified {
    # CIS 5.11 (L2) Ensure contents of exposed configuration files have not been modified
    Write-Host "`n* CIS control 5.11 (L1) Ensure contents of exposed configurations are not modified" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # This control needs to be verified manually, refer to the CIS Benchmark for details
    Write-Host "- Check Unknown" -ForegroundColor Yellow
    Write-Host "  This control needs to be verified manually, refer to the CIS Benchmark for details" -ForegroundColor Yellow
    $unknown++

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow

}

