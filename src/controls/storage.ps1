# This module assesses against the following CIS controls:
# 6.1 (L1) Ensure bidirectional CHAP authentication for iSCSI traffic is enabled
# 6.2 (L2) Ensure the uniqueness of CHAP authentication secrets for iSCSI traffic
# 6.3 (L1) Ensure storage area network (SAN) resources are segregated properly


function Ensure-BidirectionalCHAPAuthIsEnabled {
    # CIS 6.1 (L1) Ensure bidirectional CHAP authentication for iSCSI traffic is enabled
    Write-Host "`n* CIS control 6.1 (L1) Ensure bidirectional CHAP authentication for iSCSI traffic is enabled" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMhosts 
    $VMhosts = Get-VMHost | Get-VMHostHba | Select VMHost, Type
    # Check for Iscsi HBAs and whether they have bidirectional CHAP enabled
    Foreach ($VMHostHba in $VMhosts ){
        if ($VMHostHba.Type -eq "Iscsi") {
           $iSCSIProperties = Get-VMHost $VMHostHba.VMHost | Get-VMHostHba | Where {$_.Type -eq "Iscsi"} | Select VMHost, Device, ChapType, @{N="CHAPName";E={$_.AuthenticationProperties.ChapName}}
            Foreach ($iSCSIProperty in $iSCSIProperties) {
                if ($iSCSIProperty.ChapType -eq "Bidirectional") {
                    Write-Host "- Check Passed" -ForegroundColor Green
                    Write-Host "  Bidirectional CHAP authentication is enabled for $($iSCSIProperty.VMHost) on $($iSCSIProperty.Device)" -ForegroundColor Green
                    $passed++
                }
                else {
                    Write-Host "- Check Failed" -ForegroundColor Red
                    Write-Host "  Bidirectional CHAP authentication is not enabled for $($iSCSIProperty.VMHost) on $($iSCSIProperty.Device)" -ForegroundColor Red
                    $failed++
                }
            }
        }
        else {
            if ($VMHostHba -eq $VMhosts[-1]) { 
                Write-Host "- Check Unknown" -ForegroundColor Yellow
                Write-Host "  No iSCSI HBAs found" -ForegroundColor Yellow
                $unknown++
            }
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


function Ensure-UniquenessOfCHAPAuthSecretsForiSCSI {
    # CIS 6.2 (L2) Ensure the uniqueness of CHAP authentication secrets for iSCSI traffic
    Write-Host "`n* CIS control 6.2 (L2) Ensure the uniqueness of CHAP authentication secrets for iSCSI traffic" -ForegroundColor Blue
    

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

function Ensure-SANResourcesAreSegregatedProperly {
    # CIS 6.3 (L1) Ensure storage area network (SAN) resources are segregated properly
    Write-Host "`n* CIS control 6.3 (L1) Ensure storage area network (SAN) resources are segregated properly" -ForegroundColor Blue
    

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
