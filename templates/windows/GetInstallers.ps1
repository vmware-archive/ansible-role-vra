[System.Net.ServicePointManager]::ServerCertificateValidationCallback ={$true}

$Username = "root"
$Password = $args[0]
$ApHost = $args[1]

$WebClient = New-Object System.Net.WebClient
$WebClient.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)

$Source = "https://" + $apHost + ":5480/service/iaas/download/VrmAgentInstaller.msi"
$Dest   = "C:\Temp\VrmAgentInstaller.msi"
$WebClient.DownloadFile($Source, $Dest)

$Source = "https://" + $apHost + ":5480/service/iaas/download/vCAC-Wapi-Setup.exe"
$Dest   = "C:\Temp\vCAC-Wapi-Setup.exe"
$WebClient.DownloadFile($Source, $Dest)

$Source = "https://" + $apHost + ":5480/service/iaas/download/vCAC-Server-Setup.exe"
$Dest   = "C:\Temp\vCAC-Server-Setup.exe"
$WebClient.DownloadFile($Source, $Dest)

$Source = "https://" + $apHost + ":5480/service/iaas/download/WorkflowManagerInstaller.msi"
$Dest   = "C:\Temp\WorkflowManagerInstaller.msi"
$WebClient.DownloadFile($Source, $Dest)
