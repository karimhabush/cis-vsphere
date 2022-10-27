# This module assesses against the following CIS controls:
# 3.1 (L1) Ensure a centralized location is configured to collect ESXi host core dumps
# 3.2 (L1) Ensure persistent logging is configured for all ESXi hosts
# 3.3 (L1) Ensure remote logging is configured for ESXi hosts

function Ensure-CentralizedESXiHostDumps {
    # CIS 3.1 (L1) Ensure a centralized location is configured to collect ESXi host core dumps
    Write-Host "`n* CIS control 3.1 (L1) Ensure a centralized location is configured to collect ESXi host core dumps" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get the ESXi hosts
    $CoredumpConf = (Get-ESXCli).system.coredump.network.get()

    if ($CoredumpConf.Enabled -eq $true) {
        Write-Host "- Check Passed" -ForegroundColor Green
        Write-Host "  Coredump is enabled" -ForegroundColor Green
        $passed++
    }
    else {
        Write-Host "- Check Failed" -ForegroundColor Red
        Write-Host "  Coredump is disabled" -ForegroundColor Red
        $failed++
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow

}

function Ensure-PersistentLoggingIsConfigured {
    # CIS 3.2 (L1) Ensure persistent logging is configured for all ESXi hosts
    Write-Host "`n* CIS control 3.2 (L1) Ensure persistent logging is configured for all ESXi hosts" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get the ESXi hosts
    $VMHosts = Get-VMHost | Select Name, @{N="Syslog.global.logDir";E={$_ | Get-AdvancedConfiguration Syslog.global.logDir | Select -ExpandProperty Values}}

    Foreach ($VMHost in $VMHosts) {
        if ($VMHost.Syslog.global.logDir -ne $null) {
            Write-Host "- Check Passed" -ForegroundColor Green
            Write-Host "  Persistent logging is configured for $($VMHost.Name)" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- Check Failed" -ForegroundColor Red
            Write-Host "  Persistent logging is not configured for $($VMHost.Name)" -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow

}

function Ensure-RemoteLoggingIsConfigured {
    # CIS 3.3 (L1) Ensure remote logging is configured for ESXi hosts
    Write-Host "`n* CIS control 3.3 (L1) Ensure remote logging is configured for ESXi hosts" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get the ESXi hosts
    $VMHosts = Get-VMHost | Select Name, @{N="Syslog.global.logHost";E={$_ | Get-AdvancedSetting Syslog.global.logHost}}

    Foreach ($VMHost in $VMHosts) {
        if ($VMHost.Syslog.global.logHost -ne $null) {
            Write-Host "- Check Passed" -ForegroundColor Green
            Write-Host "  Remote logging is configured for $($VMHost.Name)" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- Check Failed" -ForegroundColor Red
            Write-Host "  Remote logging is not configured for $($VMHost.Name)" -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow

}

