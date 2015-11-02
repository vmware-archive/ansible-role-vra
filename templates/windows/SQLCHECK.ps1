##################################################################################
# Copyright (c) 2014 VMware, Inc. All Rights Reserved.
#
# "Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE."
##################################################################################
$VMname = $args[0]
$vCACAPFQDN = $args[1]
# Start SQL Installation and Configuration in new PS Window
$chksql = Get-Service "MSSQL*SQLEXPRESS"
write-host "`$vmname = $vmname"
while ($chksql.status -ne 'Running')
{
	$chksql = Get-Service "MSSQL*SQLEXPRESS"
	Write-Host "Waiting for SQLEXPRESS Service to be installed" -ForegroundColor Yellow
	Start-Sleep -Seconds 15
}
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
