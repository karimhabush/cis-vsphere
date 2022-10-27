# This module assesses against the following CIS controls:
# 2.1 (L1) Ensure NTP time synchronization is configured properly
# 2.2 (L1) Ensure the ESXi host firewall is configured to restrict access to services running on the host
# 2.3 (L1) Ensure Managed Object Browser (MOB) is disabled
# 2.4 (L2) Ensure default self-signed certificate for ESXi communication is not used
# 2.5 (L1) Ensure SNMP is configured properly
# 2.6 (L1) Ensure dvfilter API is not configured if not used
# 2.7 (L1) Ensure expired and revoked SSL certificates are removed from the ESXi server
# 2.8 (L1) Ensure vSphere Authentication Proxy is used when adding hosts to Active Directory
# 2.9 (L2) Ensure VDS health check is disabled

function Ensure-NTPTimeSynchronizationIsConfiguredProperly {
    # CIS 2.1 Ensure NTP time synchronization is configured properly
    Write-Host "`n* CIS control 2.1 Ensure NTP time synchronization is configured properly" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0

    # Get the NTP servers from the host
    $VMHosts = Get-VMHost | Select Name, @{N="NTPSetting";E={$_ | Get-VMHostNtpServer}}

    # Check if the NTP servers are configured properly
    Foreach ($VMHost in $VMHosts) {
        if ($VMHost.NTPSetting -eq $null) {
            Write-Host "- $($VMHost.Name): Fail" -ForegroundColor Red
            Write-Host "  NTP servers are not configured" -ForegroundColor Red
            $failed++
        }
        else {
            Write-Host "- $($VMHost.Name): Pass" -ForegroundColor Green
            Write-Host "  NtpServers: $($VMHost.NTPSetting)" -ForegroundColor Green
            $passed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red

}


function Ensure-ESXiHostFirewallIsProperlyConfigured {
    # CIS 2.2 Ensure the ESXi host firewall is configured to restrict access to services running on the host
    Write-Host "`n* CIS control 2.2 Ensure the ESXi host firewall is configured to restrict access to services running on the host" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0


    # Check if the firewall rules are configured properly
    Foreach ($VMHost in Get-VMHost){
        $FirewallExceptions = Get-VMHost $VMHost | Get-VMHostFirewallException

        # Check if the firewall rules are configured properly
        
        Foreach ($Rule in $FirewallExceptions) {
            if ($Rule.Enabled -eq $true -and ($Rule.ExtensionData.AllowedHosts.AllIP) -eq $true) {
                Write-Host "- $($VMHost.Name): Fail" -ForegroundColor Red
                Write-Host "  Rule $($Rule.Name) is enabled and allows all hosts" -ForegroundColor Red
                $failed++
            }
            else {
                Write-Host "- $($VMHost.Name): Pass" -ForegroundColor Green
                Write-Host "  Rule $($Rule.Name) is disabled or allows specific hosts" -ForegroundColor Green
                $passed++
            }
        }


    }
    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red

}

function Ensure-MOBIsDisabled {
    # CIS 2.3 Ensure Managed Object Browser (MOB) is disabled
    Write-Host "`n* CIS control 2.3 Ensure Managed Object Browser (MOB) is disabled" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0

    # Get the MOB status from the host
    $VMHosts = Get-VMHost | Select Name, @{N="MOBStatus";E={$_ | Get-AdvancedSetting -Name "Config.HostAgent.plugins.solo.enableMob"}}

    # Check if the MOB is disabled
    Foreach ($VMHost in $VMHosts) {
        if ($VMHost.MOBStatus -eq $true) {
            Write-Host "- $($VMHost.Name): Fail" -ForegroundColor Red
            Write-Host "  MOB is enabled" -ForegroundColor Red
            $failed++
        }
        else {
            Write-Host "- $($VMHost.Name): Pass" -ForegroundColor Green
            Write-Host "  MOB is disabled" -ForegroundColor Green
            $passed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red

}

function Ensure-DefaultSelfSignedCertificateIsNotUsed {
    # CIS 2.4 (L2) Ensure default self-signed certificate for ESXi communication is not used
    Write-Host "`n* CIS control 2.4 (L2) Ensure default self-signed certificate for ESXi communication is not used" -ForegroundColor Blue

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


function Ensure-SNMPIsConfiguredProperly {
    # CIS 2.5 Ensure SNMP is configured properly
    Write-Host "`n* CIS control 2.5 Ensure SNMP is configured properly" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0
    $unknown = 0

    # Get the SNMP status from the host
    $VMHostSnmp = Get-VMHostSnmp

    # Check if any SNMP server is configured and notify the user that they need to invistigate the issue
    if ($VMHostSnmp -ne $null) {
        Write-Host "- SNMP: Unknown" -ForegroundColor Yellow
        Write-Host "  SNMP is enabled, please refer to the vSphere Monitoring and Performance guide, chapter 8 for steps to verify the parameters." -ForegroundColor Yellow
        $unknown++
    }
    else {
        Write-Host "- SNMP: Pass" -ForegroundColor Green
        Write-Host "  SNMP is not enabled" -ForegroundColor Green
        $passed++
    }
    
    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Unknown: $unknown" -ForegroundColor Yellow
    Write-Host "Failed: $failed" -ForegroundColor Red
}

function Ensure-dvfilterIsDisabled {
    # CIS 2.6 Ensure dvfilter is disabled
    Write-Host "`n* CIS control 2.6 Ensure dvfilter is disabled" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0

    # Get the dvfilter status from the host
    $VMHosts = Get-VMHost | Select Name, @{N="Net.DVFilterBindIpAddress";E={$_ | Get-AdvancedSetting Net.DVFilterBindIpAddress | Select -ExpandProperty Values}}

    # Check if the dvfilter is disabled
    Foreach ($VMHost in $VMHosts) {
        if ($VMHost.Net.DVFilterBindIpAddress -eq $null) {
            Write-Host "- $($VMHost.Name): Pass" -ForegroundColor Green
            Write-Host "  dvfilter is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($VMHost.Name): Fail" -ForegroundColor Red
            Write-Host "  dvfilter is enabled" -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
}

function Ensure-DefaultSelfSignedCertificateIsNotUsed {
    # CIS 2.7 (L1) Ensure expired and revoked SSL certificates are removed from the ESXi server
    Write-Host "`n* CIS control 2.7	(L1) Ensure expired and revoked SSL certificates are removed from the ESXi server" -ForegroundColor Blue

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


function Ensure-vSphereAuthenticationProxyIsUsedWithAD {
    # CIS 2.8 (L1) Ensure vSphere Authentication Proxy is used with Active Directory
    Write-Host "`n* CIS control 2.8 (L1) Ensure vSphere Authentication Proxy is used with Active Directory" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0

    # Check each host and their domain membership status
    $VMHostsAuth = Get-VMHost | Get-VMHostAuthentication | Select VmHost, Domain, DomainMembershipStatus

    # Check if the hosts are joined to a domain or not
    Foreach ($VMHost in $VMHostsAuth) {
        if ($VMHost.DomainMembershipStatus -eq $null) {
            Write-Host "- $($VMHost.VmHost): Fail" -ForegroundColor Red
            Write-Host "  Host is not joined to a domain" -ForegroundColor Red
            $failed++
        }
        else {
            Write-Host "- $($VMHost.VmHost): Pass" -ForegroundColor Green
            Write-Host "  Host is joined to a domain" -ForegroundColor Green
            $passed++
        }
    }
    
    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red

}


function Ensure-VDSHealthCheckIsDisabled {
    # CIS 2.9 (L2) Ensure VDS Health Check is disabled
    Write-Host "`n* CIS control 2.9 (L2) Ensure VDS Health Check is disabled" -ForegroundColor Blue
    

    # Results summary
    $passed = 0
    $failed = 0

    # Get the VDS Health Check status from the host
    $vds = Get-VDSwitch
    $HealthCheckConfig = $vds.ExtensionData.Config.HealthCheckConfig

    if ($HealthCheckConfig -ne $null) {
        Write-Host "- VDS Health Check: Fail" -ForegroundColor Red
        Write-Host "  VDS Health Check is enabled" -ForegroundColor Red
        $failed++
    }
    else {
        Write-Host "- VDS Health Check: Pass" -ForegroundColor Green
        Write-Host "  VDS Health Check is disabled" -ForegroundColor Green
        $passed++
    }

    # Check if the VDS Health Check is disabled
    Foreach ($VMHost in $VMHosts) {
        if ($VMHost.Net.VDSHealthCheckEnabled -eq $false) {
            Write-Host "- $($VMHost.Name): Pass" -ForegroundColor Green
            Write-Host "  VDS Health Check is disabled" -ForegroundColor Green
            $passed++
        }
        else {
            Write-Host "- $($VMHost.Name): Fail" -ForegroundColor Red
            Write-Host "  VDS Health Check is enabled" -ForegroundColor Red
            $failed++
        }
    }

    # Print the results
    Write-Host "`n-- Summary --"
    Write-Host "Passed: $passed" -ForegroundColor Green
    Write-Host "Failed: $failed" -ForegroundColor Red
}


