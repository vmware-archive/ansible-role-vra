##################################################################################
# Copyright 2014 VMware, Inc.  All rights reserved.
# SPDX-License-Identifier: Apache-2.0 OR GPL-3.0-only
#
# This code is Dual Licensed Apache-2.0 or GPLv3
##################################################################################
$VMname = $args[0]
$vCACAPFQDN = $args[1]
# Start SQL Installation and Configuration in new PS Window
#$chksql = Get-Service "MSSQL*SQLEXPRESS"
#write-host "`$vmname = $vmname"
#while ($chksql.status -ne 'Running')
#{
#	$chksql = Get-Service "MSSQL*SQLEXPRESS"
#	Write-Host "Waiting for SQLEXPRESS Service to be installed" -ForegroundColor Yellow
#	Start-Sleep -Seconds 15
#}
Write-Host "SQL Server Service Installed and Running. Proceeding..."
$Verbosepreference = "Continue"
$service = @("MSSQL*SQLEXPRESS")
# Load the assemblies
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement")
$mc = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer
$urn = New-Object -TypeName Microsoft.SqlServer.Management.Sdk.Sfc.Urn -argumentlist "ManagedComputer[@Name='$vmname']/ServerInstance[@Name='SQLEXPRESS']/ServerProtocol[@Name='Tcp']"
$sp = $mc.GetSmoObject($urn)
$sp.IsEnabled = $true
$sp.ipaddresses[1].ipAddressproperties[1].value = $true
$sp.IPAddresses[1].ipAddressproperties[3].value = ""
$sp.ipaddresses[7].ipaddressproperties[0].value = ""
$sp.ipaddresses[7].ipaddressproperties[1].value = "1433"
$sp.Alter()
$sp
Write-Verbose "Starting $($service) ...."
restart-Service $service -Force

$chkwriter = Get-Service "SQLWRITER" -erroraction SilentlyContinue
while ($chkwriter.status -ne 'Running')
{
	$chkwriter = Get-Service "SQLWRITER" -erroraction SilentlyContinue
	Write-Host "Waiting for SQL Writer Service to be installed" -ForegroundColor Yellow
	Start-Sleep -Seconds 5
}
Write-host "SQL Writer Installed" -ForegroundColor Yellow
$Verbosepreference = "Continue"
$service = @("SQLWRITER")
Write-Verbose "Starting $($service) ...."
restart-Service $service -Force

Set-service "SQLBrowser" -Startuptype Automatic
Get-service "SQLBrowser" | Start-Service

restart-Service "MSSQL*SQLEXPRESS" -force
