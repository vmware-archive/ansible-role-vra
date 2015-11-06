@echo off
echo Installing system components for vCAC IAAS
echo Importing and Installing vCAC Appliance Certificate
certutil -addstore Root "c:\temp\ap.cer"
echo Start Time:
date/t
time /t
echo.
ping -n 5 127.0.0.1 > nul
echo Deploying vCAC Core Server Components ...
"C:\Temp\vCAC-Server-Setup.exe" /s /w /V" /qn ADDLOCAL=Database,ManagerService,Website,ModelManagerWeb,ModelManagerData"
time /t
echo.
ping -n 5 127.0.0.1 > nul
:loop
tasklist | find " vCAC " >nul
if not errorlevel 1 (
    timeout /t 5 >nul
    goto :loop
)

echo Configuring vCAC Core Server Components ...
echo This part can take a while, please be patient
"C:\Program Files (x86)\VMware\vCAC\\Server\ConfigTool\vCAC-Config.exe"/S "/P:C:\Temp\vCAC-ServerConfig.xml" "/L:C:\Temp\vCAC-Config.log"
time /t
echo.
ping -n 5 127.0.0.1 > nul

echo Installing WAPI Service ...
"C:\temp\vCAC-Wapi-Setup.exe" /s /w /V"/qn ADDLOCAL=All"
time /t
echo.
ping -n 5 127.0.0.1 > nul

echo Configuring WAPI Service ...
"C:\Program Files (x86)\VMware\vCAC\Web API\ConfigTool\Wapi-Config.exe" /S "/P:C:\temp\WAPI-ConfigTool.xml"
time /t
echo.

echo Installing DEM Worker ...
"msiexec.exe"  /i "c:\temp\WorkflowManagerInstaller.msi"  /qn /norestart /Lvoicewarmup! "Install-DEM.log" ADDLOCAL=All REPO_SERVER_URL="https://{{ win_vra_vcaciaasvm }}/repository/" REPO_HOSTNAME="{{ win_vra_vcaciaasvm }}" REPOSITORY_USER="{{ win_vra_vcacisvm }}\Administrator" REPOSITORY_USER_PASSWORD="{{ win_vra_service_user_password }}"  SERVICE_USER_NAME="{{ win_vra_vcacisvm }}\Administrator" SERVICE_USER_PASSWORD="{{ win_vra_service_user_password }}" DEM_NAME="DEM" DEM_NAME_DESCRIPTION="DEM WORKER" VALID_DEM_NAME="1" MSINEWINSTANCE="1" TRANSFORMS=":DemInstanceId01" DEM_ROLE="Worker" HTTPS_SUPPORT=1 ENABLE_SSL=true  MANAGERSERVICE_HOSTNAME="{{ win_vra_vcaciaasvm }}"
time /t
echo.

echo Installing DEO Orchestrator ...
"msiexec.exe"  /i "c:\temp\WorkflowManagerInstaller.msi"  /qn /norestart /Lvoicewarmup! "Install-DEO.log" ADDLOCAL=All  REPO_SERVER_URL="https://{{ win_vra_vcaciaasvm }}/repository/" REPO_HOSTNAME="{{ win_vra_vcaciaasvm }}" REPOSITORY_USER="{{ win_vra_vcacisvm }}\Administrator" REPOSITORY_USER_PASSWORD="{{ win_vra_service_user_password }}"  SERVICE_USER_NAME="{{ win_vra_vcacisvm }}\Administrator" SERVICE_USER_PASSWORD="{{ win_vra_service_user_password }}"  DEM_NAME="DEO"  DEM_NAME_DESCRIPTION="DEM Orchestrator" VALID_DEM_NAME="1" MSINEWINSTANCE="1" TRANSFORMS=":DemInstanceId02" DEM_ROLE="Orchestrator"  HTTPS_SUPPORT=1 ENABLE_SSL=true  MANAGERSERVICE_HOSTNAME="{{ win_vra_vcaciaasvm }}"
time /t
echo.

echo Installing the vSphere Agent ...
msiexec.exe /i "c:\temp\VrmAgentInstaller.msi" /qn /norestart /Lvoicewarmup! "c:\temp\vrmlog.log" ADDLOCAL="vSphereAgent,CoreAgent" AGENT_TYPE="vSphere" AGENT_NAME="vSphereAgent" VSPHERE_AGENT_ENDPOINT="vCenter" REPOSITORY_HOSTNAME="{{ win_vra_vcaciaasvm }}" VRM_SERVER_NAME="{{ win_vra_vcaciaasvm }}" SERVICE_USER_NAME="{{ win_vra_vcacisvm }}\Administrator" SERVICE_USER_PASSWORD="{{ win_vra_service_user_password }}" INSTALLLOCATION="C:\Program Files (x86)\VMware\vCAC\Agents" HTTPS_SUPPORT=1 MSINEWINSTANCE=1 TRANSFORMS=":VrmAgentInstanceId01"
time /t
echo.

echo Register Catalog Types ... simply echoing for now
echo "C:\Program Files (x86)\VMware\vCAC\Server\Model Manager Data\Cafe\Vcac-Config.exe" RegisterCatalogTypes -v
echo time /t
echo.

echo End Time:
date/t
time /t
echo.

echo vCAC Installation Complete.
