# This module assesses against the following CIS controls:
# 7.1 (L1) Ensure the vSwitch Forged Transmits policy is set to reject
# 7.2 (L1) Ensure the vSwitch MAC Address Change policy is set to reject
# 7.3 (L1) Ensure the vSwitch Promiscuous Mode policy is set to reject
# 7.4 (L1) Ensure port groups are not configured to the value of the native VLAN
# 7.5 (L1) Ensure port groups are not configured to VLAN values reserved by upstream physical switches
# 7.6 (L1) Ensure port groups are not configured to VLAN 4095 and 0except for Virtual Guest Tagging (VGT)
# 7.7 (L1) Ensure Virtual Distributed Switch Netflow traffic is sent to an authorized collector
# 7.8 (L1) Ensure port-level configuration overrides are disabled


function Ensure-vSwitchForgedTransmitsIsReject {
    # CIS 7.1 (L1) Ensure the vSwitch Forged Transmits policy is set to reject
    Write-Host "`n* CIS control 7.1 (L1) Ensure the vSwitch Forged Transmits policy is set to reject" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get the vSwitches
    $vSwitches = Get-VirtualSwitch -Standard | Select VMHost, Name, @{N = "MacChanges"; E = { if ($_.ExtensionData.Spec.Policy.Security.MacChanges) { "Accept" } Else { "Reject" } } }, @{N = "PromiscuousMode"; E = { if ($_.ExtensionData.Spec.Policy.Security.PromiscuousMode) { "Accept" } Else { "Reject" } } }, @{N = "ForgedTransmits"; E = { if ($_.ExtensionData.Spec.Policy.Security.ForgedTransmits) { "Accept" } Else { "Reject" } } }

    # Check the vSwitches
    foreach ($vSwitch in $vSwitches) {
        if ($vSwitch.ForgedTransmits -eq "Reject") {
            Write-Host "- Check Passed" -ForegroundColor Green
            Write-Host "  $($vSwitch.VMHost) - $($vSwitch.Name)" -ForegroundColor Green
            $passed++
        }
        Else {
            Write-Host "- Check Failed" -ForegroundColor Red
            Write-Host "  $($vSwitch.VMHost) - $($vSwitch.Name)" -ForegroundColor Red
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

function Ensure-vSwitchMACAdressChangeIsReject {
    # CIS 7.2 (L1) Ensure the vSwitch MAC Address Change policy is set to reject
    Write-Host "`n* CIS control 7.2 (L1) Ensure the vSwitch MAC Address Change policy is set to reject" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get the vSwitches
    $vSwitches = Get-VirtualSwitch -Standard | Select VMHost, Name, @{N = "MacChanges"; E = { if ($_.ExtensionData.Spec.Policy.Security.MacChanges) { "Accept" } Else { "Reject" } } }, @{N = "PromiscuousMode"; E = { if ($_.ExtensionData.Spec.Policy.Security.PromiscuousMode) { "Accept" } Else { "Reject" } } }, @{N = "ForgedTransmits"; E = { if ($_.ExtensionData.Spec.Policy.Security.ForgedTransmits) { "Accept" } Else { "Reject" } } }

    # Check the vSwitches
    foreach ($vSwitch in $vSwitches) {
        if ($vSwitch.MacChanges -eq "Reject") {
            Write-Host "- Check Passed" -ForegroundColor Green
            Write-Host "  $($vSwitch.VMHost) - $($vSwitch.Name)" -ForegroundColor Green
            $passed++
        }
        Else {
            Write-Host "- Check Failed" -ForegroundColor Red
            Write-Host "  $($vSwitch.VMHost) - $($vSwitch.Name)" -ForegroundColor Red
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

function Ensure-vSwitchPromiscuousModeIsReject {
    # CIS 7.3 (L1) Ensure the vSwitch Promiscuous Mode policy is set to reject
    Write-Host "`n* CIS control 7.3 (L1) Ensure the vSwitch Promiscuous Mode policy is set to reject" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get the vSwitches
    $vSwitches = Get-VirtualSwitch -Standard | Select VMHost, Name, @{N = "MacChanges"; E = { if ($_.ExtensionData.Spec.Policy.Security.MacChanges) { "Accept" } Else { "Reject" } } }, @{N = "PromiscuousMode"; E = { if ($_.ExtensionData.Spec.Policy.Security.PromiscuousMode) { "Accept" } Else { "Reject" } } }, @{N = "ForgedTransmits"; E = { if ($_.ExtensionData.Spec.Policy.Security.ForgedTransmits) { "Accept" } Else { "Reject" } } }

    # Check the vSwitches
    foreach ($vSwitch in $vSwitches) {
        if ($vSwitch.PromiscuousMode -eq "Reject") {
            Write-Host "- Check Passed" -ForegroundColor Green
            Write-Host "  $($vSwitch.VMHost) - $($vSwitch.Name)" -ForegroundColor Green
            $passed++
        }
        Else {
            Write-Host "- Check Failed" -ForegroundColor Red
            Write-Host "  $($vSwitch.VMHost) - $($vSwitch.Name)" -ForegroundColor Red
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


function Ensure-PortGroupsNotNativeVLAN {
    # CIS 7.4 (L1) Ensure port groups are not configured to the value of the native VLAN
    Write-Host "`n* CIS control 7.4 (L1) Ensure port groups are not configured to the value of the native VLAN" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get the vSwitches
    $vSwitches = Get-VirtualPortGroup -Standard | Select  virtualSwitch, Name, VlanID
    
    # Checking for native VLAN ID 1
    $defaultNativeVLAN = 1
    Write-Host "Checking for native VLAN ID 1, if you have a different native VLAN ID, please change the value of the variable nativeVLANID in the script." -ForegroundColor Yellow
    
    # Check the vSwitches for port groups with the same VLAN ID as the native VLAN
    foreach ($vSwitch in $vSwitches) {
        if ($vSwitch.VlanID -eq $defaultNativeVLAN) {
            Write-Host "- Check Failed" -ForegroundColor Red
            Write-Host "  $($vSwitch.virtualSwitch) - $($vSwitch.Name) - VLAN $($vSwitch.VlanID)" -ForegroundColor Red
            $failed++
        }
        Else {
            Write-Host "- Check Passed" -ForegroundColor Green
            Write-Host "  $($vSwitch.virtualSwitch) - $($vSwitch.Name) - VLAN $($vSwitch.VlanID)" -ForegroundColor Green
            $passed++
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

function Ensure-PortGroupsNotUpstreamPhysicalSwitches {
    # CIS 7.5 (L1) Ensure port groups are not configured to VLAN values reserved by upstream physical switches
    Write-Host "`n* CIS control 7.5 (L1) Ensure port groups are not configured to VLAN values reserved by upstream physical switches" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get the vSwitches
    $vSwitches = Get-VirtualPortGroup -Standard | Select  virtualSwitch, Name, VlanID

    # Checking for Cisco reserved VLAN IDs 1001-1024 and 4094, Nexus reserved VLAN IDs 3968-4047 and 4049
    $reservedVLANs = 1001..1024
    $reservedVLANs += 3968..4047
    $reservedVLANs += 4094
    Write-Host "Checking for Cisco reserved VLAN IDs 1001-1024 and 4094, Nexus reserved VLAN IDs 3968-4047 and 4049, if you have a different reserved VLAN ID range, please change the value of the variable reservedVLANs in the script." -ForegroundColor Yellow
    
    # Check the vSwitches for port groups with the VLAN IDs reserved by upstream physical switches
    foreach ($vSwitch in $vSwitches) {
        if ($reservedVLANs -contains $vSwitch.VlanID) {
            Write-Host "- Check Failed" -ForegroundColor Red
            Write-Host "  $($vSwitch.virtualSwitch) - $($vSwitch.Name) - VLAN $($vSwitch.VlanID)" -ForegroundColor Red
            $failed++
        }
        Else {
            Write-Host "- Check Passed" -ForegroundColor Green
            Write-Host "  $($vSwitch.virtualSwitch) - $($vSwitch.Name) - VLAN $($vSwitch.VlanID)" -ForegroundColor Green
            $passed++
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


function Ensure-PortGroupsAreNotConfiguredToVLAN0and4095 {
    # CIS 7.6 (L1) Ensure port groups are not configured to VLAN 0 and 4095
    Write-Host "`n* CIS control 7.6 (L1) Ensure port groups are not configured to VLAN 0 and 4095" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get the vSwitches
    $vSwitches = Get-VirtualPortGroup -Standard | Select  virtualSwitch, Name, VlanID

    # Checking for VLAN IDs 0 and 4095
    $reservedVLANs = 0, 4095
    Write-Host "Checking for both VLAN IDs 0 and 4095, if you have set up Virtual Guest Tagging on your vSwitches, please change the value of the variable reservedVLANs in the script." -ForegroundColor Yellow
    
    # Check the vSwitches for port groups with the VLAN IDs reserved by upstream physical switches
    foreach ($vSwitch in $vSwitches) {
        if ($reservedVLANs -contains $vSwitch.VlanID) {
            Write-Host "- Check Failed" -ForegroundColor Red
            Write-Host "  $($vSwitch.virtualSwitch) - $($vSwitch.Name) - VLAN $($vSwitch.VlanID)" -ForegroundColor Red
            $failed++
        }
        Else {
            Write-Host "- Check Passed" -ForegroundColor Green
            Write-Host "  $($vSwitch.virtualSwitch) - $($vSwitch.Name) - VLAN $($vSwitch.VlanID)" -ForegroundColor Green
            $passed++
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

function Ensure-VirtualDistributedSwitchNetflowTrafficSentToAuthorizedCollector {
    # CIS 7.7 (L1) Ensure virtual distributed switch netflow traffic is sent to an authorized collector
    Write-Host "`n* CIS control 7.7 (L1) Ensure virtual distributed switch netflow traffic is sent to an authorized collector" -ForegroundColor Blue
    

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

function Ensure-PortLevelConfigurationOverridesAreDisabled {
    # CIS 7.8 (L1) Ensure port level configuration overrides are disabled
    Write-Host "`n* CIS control 7.8 (L1) Ensure port level configuration overrides are disabled" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # 
    $vdPortGroupOverridePolicy = Get-VDPortgroup | Get-VDPortgroupOverridePolicy

    # Check if the port level configuration overrides are disabled
    if ($vdPortGroupOverridePolicy -eq $null) {
        Write-Host "- Check Passed" -ForegroundColor Green
        Write-Host "  Port level configuration overrides are disabled" -ForegroundColor Green
        $passed++
    }
    Else {
        Write-Host "- Check Failed" -ForegroundColor Red
        Write-Host "  Port level configuration overrides are enabled" -ForegroundColor Red
        $failed++
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

