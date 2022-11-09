# This module assesses against the following CIS controls:
# 4.1 (L1) Ensure a non-root user account exists for local admin access
# 4.2 (L1) Ensure passwords are required to be complex
# 4.3 (L1) Ensure the maximum failed login attempts is set to 5 
# 4.4 (L1) Ensure account lockout is set to 15 minutes 
# 4.5 (L1) Ensure previous 5 passwords are prohibited
# 4.6 (L1) Ensure Active Directory is used for local user authentication
# 4.7 (L1) Ensure only authorized users and groups belong to the esxAdminsGroup group
# 4.8 (L1) Ensure the Exception Users list is properly configured

function Ensure-NonRootExistsForLocalAdmin {
    # CIS 4.1 (L1) Ensure a non-root user account exists for local admin access
    Write-Host "`n* CIS control 4.1 (L1) Ensure a non-root user account exists for local admin access" -ForegroundColor Blue
    

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

    # Return true if all checks passed
    if ($failed -ne 0) {
        return -1
    }
    elseif ($unknown -ne 0) {
        return 0
    }
    else {
        return 1
    }

}


function Ensure-PasswordsAreRequiredToBeComplex {
    # CIS 4.2 (L1) Ensure passwords are required to be complex
    Write-Host "`n* CIS control 4.2 (L1) Ensure passwords are required to be complex" -ForegroundColor Blue
    

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

    # Return true if all checks passed
    if ($failed -ne 0) {
        return -1
    }
    elseif ($unknown -ne 0) {
        return 0
    }
    else {
        return 1
    }

}


function Ensure-LoginAttemptsIsSetTo5 {
    # CIS 4.3 (L1) Ensure the maximum failed login attempts is set to 5 
    Write-Host "`n* CIS control 4.3 (L1) Ensure the maximum failed login attempts is set to 5" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get the ESXi hosts
    $VMHosts = Get-VMHost | Select Name, @{N="MaxFailedLogin";E={$_ | Get-AdvancedSetting -Name Security.AccountLockFailures | Select -ExpandProperty Value}}

    Foreach ($VMHost in $VMHosts) {
        if ($VMHost.MaxFailedLogin -eq 5) {
            Write-Host "- $($VMHost.Name): Passed" -ForegroundColor Green
            Write-Host "  The maximum failed login attempts is set to 5. " -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($VMHost.Name): Failed" -ForegroundColor Red
            Write-Host "  The maximum failed login attempts is not set to 5. " -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow

    # Return true if all checks passed
    if ($failed -ne 0) {
        return -1
    }
    elseif ($unknown -ne 0) {
        return 0
    }
    else {
        return 1
    }

}



function Ensure-AccountLockoutIsSetTo15Minutes {
    # CIS 4.4 (L1) Ensure account lockout is set to 15 minutes 
    Write-Host "`n* CIS control 4.4 (L1) Ensure account lockout is set to 15 minutes" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get the ESXi hosts
    $VMHosts = Get-VMHost | Select Name, @{N="AccountLockoutDuration";E={$_ | Get-AdvancedSetting -Name Security.AccountUnlockTime | Select -ExpandProperty Value}}

    Foreach ($VMHost in $VMHosts) {
        if ($VMHost.AccountLockoutDuration -eq 900) {
            Write-Host "- $($VMHost.Name): Passed" -ForegroundColor Green
            Write-Host "  The account lockout is set to 15 minutes. " -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($VMHost.Name): Failed" -ForegroundColor Red
            Write-Host "  The account lockout is not set to 15 minutes. " -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow

    # Return true if all checks passed
    if ($failed -ne 0) {
        return -1
    }
    elseif ($unknown -ne 0) {
        return 0
    }
    else {
        return 1
    }

}


function Ensure-Previous5PasswordsAreProhibited {
    # CIS 4.5 (L1) Ensure previous 5 passwords are prohibited
    Write-Host "`n* CIS control 4.5 (L1) Ensure previous 5 passwords are prohibited" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    $VMHosts = Get-VMHost | Select Name, @{N="PasswordHistory";E={$_ | Get-AdvancedSetting -Name Security.PasswordHistory | Select -ExpandProperty Value}}

    Foreach ($VMHost in $VMHosts) {
        if ($VMHost.PasswordHistory -eq 5) {
            Write-Host "- $($VMHost.Name): Passed" -ForegroundColor Green
            Write-Host "  The previous 5 passwords are prohibited. " -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($VMHost.Name): Failed" -ForegroundColor Red
            Write-Host "  The previous 5 passwords are not prohibited. " -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow

    # Return true if all checks passed
    if ($failed -ne 0) {
        return -1
    }
    elseif ($unknown -ne 0) {
        return 0
    }
    else {
        return 1
    }

}


function Ensure-ADIsUsedForAuthentication {
    # CIS 4.6 (L1) Ensure AD is used for authentication
    Write-Host "`n* CIS control 4.6 (L1) Ensure AD is used for authentication" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    $VMHosts = Get-VMHost | Get-VMHostAuthentication | Select VmHost, Domain, DomainMembershipStatus

    Foreach ($VMHost in $VMHosts) {
        if ($VMHost.DomainMembershipStatus -ne $null) {
            Write-Host "- $($VMHost.VmHost): Passed" -ForegroundColor Green
            Write-Host "  AD is used for authentication. " -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($VMHost.VmHost): Failed" -ForegroundColor Red
            Write-Host "  AD is not used for authentication. " -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow

    # Return true if all checks passed
    if ($failed -ne 0) {
        return -1
    }
    elseif ($unknown -ne 0) {
        return 0
    }
    else {
        return 1
    }

}

function Ensure-OnlyAuthorizedUsersBelongToEsxAdminsGroup {
    # CIS 4.7 (L1) Ensure only authorized users belong to the ESX Admins group
    Write-Host "`n* CIS control 4.7 (L1) Ensure only authorized users belong to the ESX Admins group" -ForegroundColor Blue
    

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

    # Return true if all checks passed
    if ($failed -ne 0) {
        return -1
    }
    elseif ($unknown -ne 0) {
        return 0
    }
    else {
        return 1
    }

}

function Ensure-ExceptionUsersIsConfiguredManually {
    # CIS 4.8 (L1) Ensure exception users is configured manually
    Write-Host "`n* CIS control 4.8 (L1) Ensure exception users is configured manually" -ForegroundColor Blue
    

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

    # Return true if all checks passed
    if ($failed -ne 0) {
        return -1
    }
    elseif ($unknown -ne 0) {
        return 0
    }
    else {
        return 1
    }
    
}


