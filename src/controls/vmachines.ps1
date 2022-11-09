# This module assesses against the following CIS controls:
# 8.1.1 (L1) Ensure informational messages from the VM to the VMX file are limited
# 8.1.2 (L2) Ensure only one remote console connection is permitted to a VM at any time
# 8.2.1 (L1) Ensure unnecessary floppy devices are disconnected 
# 8.2.2 (L1) Ensure unnecessary CD/DVD devices are disconnected 
# 8.2.3	(L1) Ensure unnecessary parallel ports are disconnected 
# 8.2.4 (L1) Ensure unnecessary serial ports are disconnected
# 8.2.5 (L1) Ensure unnecessary USB devices are disconnected
# 8.2.6	(L1) Ensure unauthorized modification and disconnection of devices is disabled 
# 8.2.7	(L1) Ensure unauthorized connection of devices is disabled 
# 8.2.8	(L1) Ensure PCI and PCIe device passthrough is disabled
# 8.4.2 (L2) Ensure Autologon is disabled
# 8.4.3	(L2) Ensure BIOS BBS is disabled 
# 8.4.4 (L1) Ensure Guest Host Interaction Protocol Handler is set to disabled 
# 8.4.5	(L2) Ensure Unity Taskbar is disabled 
# 8.4.6	(L2) Ensure Unity Active is disabled 
# 8.4.7	(L2) Ensure Unity Window Contents is disabled
# 8.4.8	(L2) Ensure Unity Push Update is disabled
# 8.4.9 (L2) Ensure Drag and Drop Version Get is disabled
# 8.4.10 (L2) Ensure Drag and Drop Version Set is disabled
# 8.4.11 (L2) Ensure Shell Action is disabled
# 8.4.12 (L2) Ensure Request Disk Topology is disabled
# 8.4.13 (L2) Ensure Trash Folder State is disabled
# 8.4.14 (L2) Ensure Guest Host Interaction Tray Icon is disabled
# 8.4.15 (L2) Ensure Unity is disabled
# 8.4.16 (L2) Ensure Unity Interlock is disabled
# 8.4.17 (L2) Ensure GetCreds is disabled
# 8.4.18 (L2) Ensure Host Guest File System Server is disabled
# 8.4.19 (L2) Ensure Guest Host Interaction Launch Menu is disabled
# 8.4.20 (L2) Ensure memSchedFakeSampleStats is disabled
# 8.4.21 (L2) Ensure VM Console Copy operations are disabled
# 8.4.22 (L2) Ensure VM Console Drag and Drop operations is disabled
# 8.4.23 (L1) Ensure VM Console GUI Options is disabled 
# 8.4.24 (L1) Ensure VM Console Paste operations are disabled



# Import utility functions
Import-Module -Name $PSScriptRoot\..\utils.ps1 -Force


function Ensure-InformationalMessagesFromVMToVMXLimited {
    # CIS 8.1.1 (L1) Ensure informational messages from the VM to the VMX file are limited
    Write-Host "`n* CIS control 8.1.1 (L1) Ensure informational messages from the VM to the VMX file are limited" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Recommended value
    $recommendedsizeLimit = 1048576

    # Get size limit from VM 
    $sizeLimitByVM = Get-VM | Select Name, @{N = "SizeLimit"; E = { Get-AdvancedSetting -Entity $_ -Name "tools.setInfo.sizeLimit" | Select -ExpandProperty Value } }

    # Check if the size limit is set to the recommended value
    Foreach ($sizeLimit in $sizeLimitByVM) {
        if ($sizeLimit.SizeLimit -eq $recommendedsizeLimit) {
            Write-Host "- $($sizeLimit.Name): Passed" -ForegroundColor Green
            Write-Host "  Size limit is set to the recommended value of $recommendedsizeLimit" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($sizeLimit.Name): Failed" -ForegroundColor Red
            Write-Host "  Size limit : $($sizeLimit.SizeLimit)" -ForegroundColor Red
            Write-Host "  Recommended size limit: $recommendedsizeLimit" -ForegroundColor Red
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

function Ensure-OnlyOneRemoteConnectionIsPermittedToVMAtAnyTime {
    # CIS 8.1.2 (L2) Ensure only one remote console connection is permitted to a VM at any time
    Write-Host "`n* CIS control 8.1.2 (L2) Ensure only one remote console connection is permitted to a VM at any time" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Recommended value
    $recommendedMaxConnections = 1

    # Get max connections from VM
    $maxConnectionsByVM = Get-VM | Select Name, @{N = "MaxConnections"; E = { Get-AdvancedSetting -Entity $_ -Name "RemoteDisplay.maxConnections" | Select -ExpandProperty Value } }

    # Check if the max connections is set to the recommended value
    Foreach ($maxConnections in $maxConnectionsByVM) {
        if ($maxConnections.MaxConnections -eq $recommendedMaxConnections) {
            Write-Host "- $($maxConnections.Name): Passed" -ForegroundColor Green
            Write-Host "  Max connections is set to the recommended value of $recommendedMaxConnections" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($maxConnections.Name): Failed" -ForegroundColor Red
            Write-Host "  Max connections : $($maxConnections.MaxConnections)" -ForegroundColor Red
            Write-Host "  Recommended max connections: $recommendedMaxConnections" -ForegroundColor Red
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


function Ensure-UnnecessaryFloppyDevicesAreDisconnected {
    # CIS 8.2.1 (L1) Ensure unnecessary floppy devices are disconnected
    Write-Host "`n* CIS control 8.2.1 (L1) Ensure unnecessary floppy devices are disconnected" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get floppy devices from VM
    $floppyDevicesByVM = Get-VM | Get-FloppyDrive | Select @{N = "VM"; E = { $_.Parent } }, Name, ConnectionState

    # Check if the ConnectionState.Connected is set to false
    Foreach ($floppyDevice in $floppyDevicesByVM) {
        if ($floppyDevice.ConnectionState.Connected -eq $false) {
            Write-Host "- $($floppyDevice.VM): Passed" -ForegroundColor Green
            Write-Host "  Floppy device $($floppyDevice.Name) is disconnected" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($floppyDevice.VM): Failed" -ForegroundColor Red
            Write-Host "  Floppy device $($floppyDevice.Name) is connected" -ForegroundColor Red
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

function Ensure-UnnecessaryCdDvdDevicesAreDisconnected {
    # CIS 8.2.2 (L1) Ensure unnecessary CD/DVD devices are disconnected
    Write-Host "`n* CIS control 8.2.2 (L1) Ensure unnecessary CD/DVD devices are disconnected" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get CD/DVD devices from VM
    $cdDvdDevicesByVM = Get-VM | Get-CDDrive | Select @{N = "VM"; E = { $_.Parent } }, Name, ConnectionState

    # Check if the ConnectionState.Connected is set to false
    Foreach ($cdDvdDevice in $cdDvdDevicesByVM) {
        if ($cdDvdDevice.ConnectionState.Connected -eq $false) {
            Write-Host "- $($cdDvdDevice.VM): Passed" -ForegroundColor Green
            Write-Host "  CD/DVD device $($cdDvdDevice.Name) is disconnected" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($cdDvdDevice.VM): Failed" -ForegroundColor Red
            Write-Host "  CD/DVD device $($cdDvdDevice.Name) is connected" -ForegroundColor Red
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

function Ensure-UnnecessaryParallelPortsAreDisconnected {
    # CIS 8.2.3 (L1) Ensure unnecessary parallel ports are disconnected
    Write-Host "`n* CIS control 8.2.3 (L1) Ensure unnecessary parallel ports are disconnected" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get parallel ports from VM
    $parallelPortsByVM = Get-VM | Get-ParallelPort | Select VM, Name, Connected

    # Check if the Connected is set to false, if none is found, the test is passed
    Foreach ($parallelPort in $parallelPortsByVM) {
        if ($parallelPort.Connected -eq $false) {
            Write-Host "- $($parallelPort.VM): Passed" -ForegroundColor Green
            Write-Host "  Parallel port $($parallelPort.Name) is disconnected" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($parallelPort.VM): Failed" -ForegroundColor Red
            Write-Host "  Parallel port $($parallelPort.Name) is connected" -ForegroundColor Red
            $failed++
        }
    }

    # if none is found, the test is passed
    if ($parallelPortsByVM.Count -eq 0) {
        Write-Host "- Passed" -ForegroundColor Green
        Write-Host "  No parallel ports found" -ForegroundColor Green
        $passed++
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


function Ensure-UnnecessarySerialPortsAreDisabled {
    # CIS 8.2.4 (L1) Ensure unnecessary serial ports are disabled
    Write-Host "`n* CIS control 8.2.4 (L1) Ensure unnecessary serial ports are disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get serial ports from VM
    $serialPortsByVM = Get-VM | Get-SerialPort | Select VM, Name, Connected

    # Check if the Connected is set to false, if none is found, the test is passed
    Foreach ($serialPort in $serialPortsByVM) {
        if ($serialPort.Connected -eq $false) {
            Write-Host "- $($serialPort.VM): Passed" -ForegroundColor Green
            Write-Host "  Serial port $($serialPort.Name) is disconnected" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($serialPort.VM): Failed" -ForegroundColor Red
            Write-Host "  Serial port $($serialPort.Name) is connected" -ForegroundColor Red
            $failed++
        }
    }

    # if none is found, the test is passed
    if ($serialPortsByVM.Count -eq 0) {
        Write-Host "- Passed" -ForegroundColor Green
        Write-Host "  No serial ports found" -ForegroundColor Green
        $passed++
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


function Ensure-UnnecessaryUsbDevicesAreDisconnected {
    # CIS 8.2.5 (L1) Ensure unnecessary USB devices are disconnected
    Write-Host "`n* CIS control 8.2.5 (L1) Ensure unnecessary USB devices are disconnected" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get USB devices from VM
    $usbDevicesByVM = Get-VM | Get-USBDevice | Select @{N = "VM"; E = { $_.Parent } }, Name, ConnectionState

    # Check if the ConnectionState.Connected is set to false
    Foreach ($usbDevice in $usbDevicesByVM) {
        if ($usbDevice.ConnectionState.Connected -eq $false) {
            Write-Host "- $($usbDevice.VM): Passed" -ForegroundColor Green
            Write-Host "  USB device $($usbDevice.Name) is disconnected" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($usbDevice.VM): Failed" -ForegroundColor Red
            Write-Host "  USB device $($usbDevice.Name) is connected" -ForegroundColor Red
            $failed++
        }
    }

    # if none is found, the test is passed
    if ($usbDevicesByVM.Count -eq 0) {
        Write-Host "- Passed" -ForegroundColor Green
        Write-Host "  No USB devices found" -ForegroundColor Green
        $passed++
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


function Ensure-UnauthorizedModificationOrDisconnectionOfDevicesIsDisabled {
    # CIS 8.2.6 (L1) Ensure unauthorized modification or disconnection of devices is disabled
    Write-Host "`n* CIS control 8.2.6 (L1) Ensure unauthorized modification or disconnection of devices is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "EditDisable"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.device.edit.disable" | Select -ExpandProperty Value } }

    # Check if the EditDisable is set to true
    Foreach ($vm in $vms) {
        if ($vm.EditDisable -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Unauthorized modification or disconnection of devices is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Unauthorized modification or disconnection of devices is not disabled" -ForegroundColor Red
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


function Ensure-UnauthorizedConnectionOfDevicesIsDisabled {
    # CIS 8.2.7 (L1) Ensure unauthorized connection of devices is disabled
    Write-Host "`n* CIS control 8.2.7 (L1) Ensure unauthorized connection of devices is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "ConnectDisable"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.device.connectable.disable" | Select -ExpandProperty Value } }

    # Check if the ConnectDisable is set to true
    Foreach ($vm in $vms) {
        if ($vm.ConnectDisable -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Unauthorized connection of devices is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Unauthorized connection of devices is not disabled" -ForegroundColor Red
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


function Ensure-PciPcieDevicePassthroughIsDisabled {
    # CIS 8.2.8 (L1) Ensure PCI/PCIe device passthrough is disabled
    Write-Host "`n* CIS control 8.2.8 (L1) Ensure PCI/PCIe device passthrough is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "PassthroughDisable"; E = { Get-AdvancedSetting -Entity $_ -Name "pciPassthru*.present" | Select -ExpandProperty Value } }

    # Check if the PassthroughDisable is not set to true
    Foreach ($vm in $vms) {
        if ($vm.PassthroughDisable -ne $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  PCI/PCIe device passthrough is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  PCI/PCIe device passthrough is enabled" -ForegroundColor Red
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

function Ensure-UnnecessaryFunctionsInsideVMsAreDisabled {
    # CIS 8.3.1 (L1) Ensure unnecessary or superfluous functions inside VMs are disabled
    Write-Host "`n* CIS control 8.3.1 (L1) Ensure unnecessary or superfluous functions inside VMs are disabled" -ForegroundColor Blue
    

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

function Ensure-UseOfTheVMConsoleIsLimited {
    # CIS 8.3.2	(L1) Ensure use of the VM console is limited (Manual)
    Write-Host "`n* CIS control 8.3.2 (L1) Ensure use of the VM console is limited" -ForegroundColor Blue
    

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

function Ensure-SecureProtocolsAreUsedForVirtualSerialPortAccess {
    # CIS 8.3.3	(L1) Ensure secure protocols are used for virtual serial port access 
    Write-Host "`n* CIS control 8.3.3 (L1) Ensure secure protocols are used for virtual serial port access" -ForegroundColor Blue
    

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

function Ensure-StandardProcessesAreUsedForVMDeployment {
    # CIS 8.3.4	(L1) Ensure standard processes are used for VM deployment
    Write-Host "`n* CIS control 8.3.4 (L1) Ensure standard processes are used for VM deployment" -ForegroundColor Blue
    

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

function Ensure-AccessToVMsThroughDvFilterNetworkAPIsIsConfiguredCorrectly {
    # CIS 8.4.1	(L1) Ensure access to VMs through the dvfilter network APIs is configured correctly
    Write-Host "`n* CIS control 8.4.1 (L1) Ensure access to VMs through the dvfilter network APIs is configured correctly" -ForegroundColor Blue
    

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


function Ensure-AutologonIsDisabled {
    # CIS 8.4.2 (L1) Ensure Autologon is disabled
    Write-Host "`n* CIS control 8.4.2 (L2) Ensure Autologon is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0
    
    # Get VMs
    $vms = Get-VM | Select Name, @{N = "AutoLogon"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.ghi.autologon.disable" | Select -ExpandProperty Value } }

    # Check if the AutoLogon is not set to true
    Foreach ($vm in $vms) {
        if ($vm.AutoLogon -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Autologon is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Autologon is not disabled" -ForegroundColor Red
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

function Ensure-BIOSBBSIsDisabled {
    # CIS 8.4.3 (L2) Ensure BIOS Boot Specification (BBS) is disabled
    Write-Host "`n* CIS control 8.4.3 (L1) Ensure BIOS Boot Specification (BBS) is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "BBS"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.bios.bbs.disable" | Select -ExpandProperty Value } }

    # Check if the BIOS BBS is set to true
    Foreach ($vm in $vms) {
        if ($vm.BBS -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  BIOS Boot Specification (BBS) is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  BIOS Boot Specification (BBS) is not disabled" -ForegroundColor Red
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


function Ensure-GuestHostInteractionProtocolIsDisabled {
    # CIS 8.4.4 (L1) Ensure Guest Host Interaction Protocol Handler is set to disabled
    Write-Host "`n* CIS control 8.4.4 (L1) Ensure Guest Host Interaction Protocol Handler is set to disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "GHI"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.ghi.protocolhandler.info.disable" | Select -ExpandProperty Value } }

    # Check if the GHI is set to true
    Foreach ($vm in $vms) {
        if ($vm.GHI -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Guest Host Interaction Protocol Handler is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Guest Host Interaction Protocol Handler is not disabled" -ForegroundColor Red
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


function Ensure-UnityTaskBarIsDisabled {
    # CIS 8.4.5 (L2) Ensure Unity Taskbar is disabled
    Write-Host "`n* CIS control 8.4.5 (L2) Ensure Unity Taskbar is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "Unity"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.unity.taskbar.disable" | Select -ExpandProperty Value } }

    # Check if the Unity is set to true
    Foreach ($vm in $vms) {
        if ($vm.Unity -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Unity Taskbar is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Unity Taskbar is not disabled" -ForegroundColor Red
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


function Ensure-UnityActiveIsDisabled {
    # CIS 8.4.6 (L2) Ensure Unity Active is disabled
    Write-Host "`n* CIS control 8.4.6 (L2) Ensure Unity Active is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "Unity"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.unityActive.disable" | Select -ExpandProperty Value } }

    # Check if the Unity is set to true
    Foreach ($vm in $vms) {
        if ($vm.Unity -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Unity Active is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Unity Active is not disabled" -ForegroundColor Red
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


function Ensure-UnityWindowContentsIsDisabled {
    # CIS 8.4.7 (L2) Ensure Unity Window Contents is disabled
    Write-Host "`n* CIS control 8.4.7 (L2) Ensure Unity Window Contents is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "Unity"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.unityWindowContents.disable" | Select -ExpandProperty Value } }

    # Check if the Unity is set to true
    Foreach ($vm in $vms) {
        if ($vm.Unity -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Unity Window Contents is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Unity Window Contents is not disabled" -ForegroundColor Red
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


function Ensure-UnityPushUpdateIsDisabled {
    # CIS 8.4.8 (L2) Ensure Unity Push Update is disabled
    Write-Host "`n* CIS control 8.4.8 (L2) Ensure Unity Push Update is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "Unity"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.unity.push.update.disable" | Select -ExpandProperty Value } }

    # Check if the Unity is set to true
    Foreach ($vm in $vms) {
        if ($vm.Unity -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Unity Push Update is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Unity Push Update is not disabled" -ForegroundColor Red
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

function Ensure-DragAndDropVersionGetIsDisabled {
    # CIS 8.4.9 (L2) Ensure Drag and Drop Version Get is disabled
    Write-Host "`n* CIS control 8.4.9 (L2) Ensure Drag and Drop Version Get is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "Unity"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.vmxDnDVersionGet.disable" | Select -ExpandProperty Value } }

    # Check if the Unity is set to true
    Foreach ($vm in $vms) {
        if ($vm.Unity -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Drag and Drop Version Get is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Drag and Drop Version Get is not disabled" -ForegroundColor Red
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

function Ensure-DragAndDropVersionSetIsDisabled {
    # CIS 8.4.10 (L2) Ensure Drag and Drop Version Set is disabled
    Write-Host "`n* CIS control 8.4.10 (L2) Ensure Drag and Drop Version Set is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "Unity"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.vmxDnDVersionSet.disable" | Select -ExpandProperty Value } }

    # Check if the Unity is set to true
    Foreach ($vm in $vms) {
        if ($vm.Unity -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Drag and Drop Version Set is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Drag and Drop Version Set is not disabled" -ForegroundColor Red
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

function Ensure-ShellActionIsDisabled {
    # CIS 8.4.11 (L2) Ensure Shell Action is disabled
    Write-Host "`n* CIS control 8.4.11 (L2) Ensure Shell Action is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "Unity"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.ghi.host.shellAction.disable" | Select -ExpandProperty Value } }

    # Check if the Unity is set to true
    Foreach ($vm in $vms) {
        if ($vm.Unity -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Shell Action is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Shell Action is not disabled" -ForegroundColor Red
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

function Ensure-DiskRequestTopologyIsDisabled {
    # CIS 8.4.12 (L2) Ensure Request Disk Topology is disabled
    Write-Host "`n* CIS control 8.4.12 (L2) Ensure Request Disk Topology is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "Unity"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.dispTopoRequest.disable" | Select -ExpandProperty Value } }

    # Check if the Unity is set to true
    Foreach ($vm in $vms) {
        if ($vm.Unity -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Disk Topology is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Disk Topology is not disabled" -ForegroundColor Red
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


function Ensure-TrashFolderStateIsDisabled {
    # CIS 8.4.13 (L2) Ensure Trash Folder State is disabled
    Write-Host "`n* CIS control 8.4.13 (L2) Ensure Trash Folder State is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "Unity"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.trashFolderState.disable" | Select -ExpandProperty Value } }

    # Check if the Unity is set to true
    Foreach ($vm in $vms) {
        if ($vm.Unity -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Trash Folder State is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Trash Folder State is not disabled" -ForegroundColor Red
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

function Ensure-GuestHostInterationTrayIconIsDisabled {
    # CIS 8.4.14 (L2) Ensure Guest Host Interation Tray Icon is disabled
    Write-Host "`n* CIS control 8.4.14 (L2) Ensure Guest Host Interation Tray Icon is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "Unity"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.ghi.trayicon.disable" | Select -ExpandProperty Value } }

    # Check if the Unity is set to true
    Foreach ($vm in $vms) {
        if ($vm.Unity -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Guest Host Interation Tray Icon is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Guest Host Interation Tray Icon is not disabled" -ForegroundColor Red
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

function Ensure-UnityIsDisabled {
    # CIS 8.4.15 (L2) Ensure Unity is disabled
    Write-Host "`n* CIS control 8.4.15 (L2) Ensure Unity is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "Unity"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.unity.disable" | Select -ExpandProperty Value } }

    # Check if the Unity is set to true
    Foreach ($vm in $vms) {
        if ($vm.Unity -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Unity is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Unity is not disabled" -ForegroundColor Red
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


function Ensure-UnityInterlockIsDisabled {
    # CIS 8.4.16 (L2) Ensure Unity Interlock is disabled
    Write-Host "`n* CIS control 8.4.16 (L2) Ensure Unity Interlock is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "Unity"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.unityInterlockOperation.disable" | Select -ExpandProperty Value } }

    # Check if the Unity is set to true
    Foreach ($vm in $vms) {
        if ($vm.Unity -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Unity Interlock is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Unity Interlock is not disabled" -ForegroundColor Red
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


function Ensure-GetCredsIsDisabled {
    # CIS 8.4.17 (L2) Ensure Get Creds is disabled
    Write-Host "`n* CIS control 8.4.17 (L2) Ensure Get Creds is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "Unity"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.getCreds.disable" | Select -ExpandProperty Value } }

    # Check if the Unity is set to true
    Foreach ($vm in $vms) {
        if ($vm.Unity -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Get Creds is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Get Creds is not disabled" -ForegroundColor Red
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

function Ensure-HostGuestFileSystemServerIsDisabled {
    # CIS 8.4.18 (L2) Ensure Host-Guest File System Service is disabled
    Write-Host "`n* CIS control 8.4.18 (L2) Ensure Host-Guest File System Service is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "HostGuestFileSystemServer"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.hgfsServerSet.disable" | Select -ExpandProperty Value } }

    # Check if the HostGuestFileSystemServer is set to true
    Foreach ($vm in $vms) {
        if ($vm.HostGuestFileSystemServer -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Host-Guest File System Service is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Host-Guest File System Service is not disabled" -ForegroundColor Red
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

function Ensure-GuestHostInteractionLaunchMenuIsDisabled {
    # CIS 8.4.19 (L2) Ensure Guest Host Interaction Service is disabled
    Write-Host "`n* CIS control 8.4.19 (L2) Ensure Guest Host Interaction Service is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "GuestHostInteractionLaunchMenu"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.ghi.launchmenu.change" | Select -ExpandProperty Value } }

    # Check if the GuestHostInteractionLaunchMenu is set to true
    Foreach ($vm in $vms) {
        if ($vm.GuestHostInteractionLaunchMenu -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Guest Host Interaction Service is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Guest Host Interaction Service is not disabled" -ForegroundColor Red
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


function Ensure-memSchedFakeSampleStatsIsDisabled {
    # CIS 8.4.20 (L2) Ensure memSchedFakeSampleStats is disabled
    Write-Host "`n* CIS control 8.4.20 (L2) Ensure memSchedFakeSampleStats is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "memSchedFakeSampleStats"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.memSchedFakeSampleStats.disable" | Select -ExpandProperty Value } }

    # Check if the memSchedFakeSampleStats is set to true
    Foreach ($vm in $vms) {
        if ($vm.memSchedFakeSampleStats -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  memSchedFakeSampleStats is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  memSchedFakeSampleStats is not disabled" -ForegroundColor Red
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


function Ensure-VMConsoleCopyOperationsAreDisabled {
    # CIS 8.4.21 (L2) Ensure VM Console Copy Operations are disabled
    Write-Host "`n* CIS control 8.4.21 (L2) Ensure VM Console Copy Operations are disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "VMConsoleCopyOperations"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.copy.disable" | Select -ExpandProperty Value } }

    # Check if the VMConsoleCopyOperations is missing or is set to true
    Foreach ($vm in $vms) {
        if ($vm.VMConsoleCopyOperations -eq $null -or $vm.VMConsoleCopyOperations -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  VM Console Copy Operations are disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  VM Console Copy Operations are not disabled" -ForegroundColor Red
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


function Ensure-VMConsoleDragAndDropOprerationsIsDisabled {
    # CIS 8.4.22 (L2) Ensure VM Console Drag and Drop Oprerations are disabled
    Write-Host "`n* CIS control 8.4.22 (L2) Ensure VM Console Drag and Drop Oprerations are disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "VMConsoleDragAndDropOprerations"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.dnd.disable" | Select -ExpandProperty Value } }

    # Check if the VMConsoleDragAndDropOprerations is set to true or is missing
    Foreach ($vm in $vms) {
        if ($vm.VMConsoleDragAndDropOprerations -eq $null -or $vm.VMConsoleDragAndDropOprerations -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  VM Console Drag and Drop Oprerations are disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  VM Console Drag and Drop Oprerations are not disabled" -ForegroundColor Red
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

function Ensure-VMConsoleGUIOptionsIsDisabled {
    # CIS 8.4.23 (L2) Ensure VM Console GUI Options are disabled
    Write-Host "`n* CIS control 8.4.23 (L2) Ensure VM Console GUI Options are disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "VMConsoleGUIOptions"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.setGUIOptions.enable" | Select -ExpandProperty Value } }

    # Check if the VMConsoleGUIOptions is set to false or is missing
    Foreach ($vm in $vms) {
        if ($vm.VMConsoleGUIOptions -eq $null -or $vm.VMConsoleGUIOptions -eq $false) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  VM Console GUI Options are disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  VM Console GUI Options are not disabled" -ForegroundColor Red
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


function Ensure-VMConsolePasteOperationsAreDisabled {
    # CIS 8.4.24 (L1) Ensure VM Console Paste Operations are disabled
    Write-Host "`n* CIS control 8.4.24 (L1) Ensure VM Console Paste Operations are disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "VMConsolePasteOperations"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.paste.disable" | Select -ExpandProperty Value } }

    # Check if the VMConsolePasteOperations is set to true or missing
    Foreach ($vm in $vms) {
        if ($vm.VMConsolePasteOperations -eq $null -or $vm.VMConsolePasteOperations -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  VM Console Paste Operations are disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  VM Console Paste Operations are not disabled" -ForegroundColor Red
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

function Ensure-VMLimitsAreConfiguredCorrectly {
    # CIS 8.5.1	(L2) Ensure VM limits are configured correctly
    Write-Host "`n* CIS control 8.5.1 (L2) Ensure VM limits are configured correctly" -ForegroundColor Blue
    

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

function Ensure-HardwareBased3DAccelerationIsDisabled {
    # CIS 8.5.2	(L2) Ensure hardware-based 3D acceleration is disabled 
    Write-Host "`n* CIS control 8.5.2 (L2) Ensure hardware-based 3D acceleration is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "HardwareBased3DAcceleration"; E = { Get-AdvancedSetting -Entity $_ -Name "mks.enable3d" | Select -ExpandProperty Value } }

    # Check if the HardwareBased3DAcceleration is set to false
    Foreach ($vm in $vms) {
        if ($vm.HardwareBased3DAcceleration -eq $false) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Hardware-based 3D acceleration is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Hardware-based 3D acceleration is not disabled" -ForegroundColor Red
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

function Ensure-NonPersistentDisksAreLimited {
    # CIS 8.6.1	(L2) Ensure non-persistent disks are limited
    Write-Host "`n* CIS control 8.6.1 (L2) Ensure non-persistent disks are limited" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Get-HardDisk | Select Parent, Name, Filename, DiskType, Persistence

    # Verify that persistence is absent or set to a value other than "nonpersistent"
    Foreach ($vm in $vms) {
        if ($vm.Persistence -eq $null -or $vm.Persistence -ne "nonpersistent") {
            Write-Host "- $($vm.Parent): Passed" -ForegroundColor Green
            Write-Host "  Persistence mode : $($vm.Persistence)" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Parent): Failed" -ForegroundColor Red
            Write-Host "  Non-persistent disks are not limited" -ForegroundColor Red
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


function Ensure-VirtualDiskShrinkingIsDisabled {
    # CIS 8.6.2	(L2) Ensure virtual disk shrinking is disabled
    Write-Host "`n* CIS control 8.6.2 (L2) Ensure virtual disk shrinking is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "VirtualDiskShrinking"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.diskShrink.disable" | Select -ExpandProperty Value } }

    # Check if the VirtualDiskShrinking is set to true
    Foreach ($vm in $vms) {
        if ($vm.VirtualDiskShrinking -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Virtual disk shrinking is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Virtual disk shrinking is not disabled" -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red

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


function Ensure-VirtualDiskWipingIsDisabled {
    # CIS 8.6.3	(L1) Ensure virtual disk wiping is disabled
    Write-Host "`n* CIS control 8.6.3 (L1) Ensure virtual disk wiping is disabled" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "VirtualDiskWiping"; E = { Get-AdvancedSetting -Entity $_ -Name "isolation.tools.diskWiper.disable" | Select -ExpandProperty Value } }

    # Check if the VirtualDiskWiping is set to true
    Foreach ($vm in $vms) {
        if ($vm.VirtualDiskWiping -eq $true) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Virtual disk wiping is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Virtual disk wiping is not disabled" -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red

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


function Ensure-TheNumberOfVMLogFilesIsConfiguredProperly {
    # CIS 8.7.1	(L1) Ensure the number of VM log files is configured properly
    Write-Host "`n* CIS control 8.7.1 (L1) Ensure the number of VM log files is configured properly" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "NumberOfVMLogFiles"; E = { Get-AdvancedSetting -Entity $_ -Name "log.keepOld" | Select -ExpandProperty Value } }

    # Check if the NumberOfVMLogFiles is set to 10
    Foreach ($vm in $vms) {
        if ($vm.NumberOfVMLogFiles -eq 10) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Number of VM log files is configured properly" -ForegroundColor Green
            Write-Host "  Number of VM log files: $($vm.NumberOfVMLogFiles)" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Current value: $($vm.NumberOfVMLogFiles)" -ForegroundColor Red
            Write-Host "  Expected value: 10" -ForegroundColor Red
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

function Ensure-HostInformationIsNotSentToGuests {
    # CIS 8.7.2	(L2) Ensure host information is not sent to guests
    Write-Host "`n* CIS control 8.7.2 (L2) Ensure host information is not sent to guests" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "HostInformation"; E = { Get-AdvancedSetting -Entity $_ -Name "tools.guestlib.enableHostInfo" | Select -ExpandProperty Value } }

    # Check if the HostInformation is set to false
    Foreach ($vm in $vms) {
        if ($vm.HostInformation -eq $false) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  Host information is not sent to guests" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Host information is sent to guests" -ForegroundColor Red
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


function Ensure-VMLogFileSizeIsLimited {
    # CIS 8.7.3	(L1) Ensure VM log file size is limited
    Write-Host "`n* CIS control 8.7.3 (L1) Ensure VM log file size is limited" -ForegroundColor Blue

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get VMs
    $vms = Get-VM | Select Name, @{N = "VMLogFileSize"; E = { Get-AdvancedSetting -Entity $_ -Name "log.rotateSize" | Select -ExpandProperty Value } }

    # Check if the VMLogFileSize is set to 1024000
    Foreach ($vm in $vms) {
        if ($vm.VMLogFileSize -eq 1024000) {
            Write-Host "- $($vm.Name): Passed" -ForegroundColor Green
            Write-Host "  VM log file size is limited" -ForegroundColor Green
            Write-Host "  VM log file size: $($vm.VMLogFileSize)" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($vm.Name): Failed" -ForegroundColor Red
            Write-Host "  Current value: $($vm.VMLogFileSize)" -ForegroundColor Red
            Write-Host "  Expected value: 1024000" -ForegroundColor Red
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

