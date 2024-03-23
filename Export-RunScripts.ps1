#.NOTES
#===========================================================================
#Created on:    3/21/2023
#Modified on:   4/21/2024
#Created by:    Timmy Andersson
#Twitter:       @TimmyITdotcom
#Blog:          www.timmyit.com
#===========================================================================
#.DESCRIPTION
#Export Run scripts. 
#Specify Destination path with the parameter $DestinationPath
 
[CmdletBinding(DefaultParameterSetName = 'DestinationPath')]
param
(
[Parameter(Mandatory = $true,
Position = 1)]
$DestinationPath
)
    Begin{
    $SiteCodeObjs = Get-WmiObject -Namespace "root\SMS" -Class SMS_ProviderLocation -ComputerName $env:COMPUTERNAME -ErrorAction Stop
        foreach ($SiteCodeObj in $SiteCodeObjs)
        {
            if ($SiteCodeObj.ProviderForLocalSite -eq $true)
                {
                $SiteCode = $SiteCodeObj.SiteCode
                }
        }
    $SitePath = $SiteCode + ":"
    Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0, $Env:SMS_ADMIN_UI_PATH.Length - 5) + '\ConfigurationManager.psd1')
}
PROCESS
{
 
Set-Location $SitePath
$Scripts = Get-CMScript 

    if (-not (Test-Path $DestinationPath))
    {
        new-item -Path $DestinationPath -ItemType Directory -Force
    }

foreach ($Script in $Scripts) {

  $PS = [System.Text.Encoding]::unicode.GetString([System.Convert]::FromBase64String($($Script).Script))
   Out-File -FilePath "$DestinationPath\$($Script.ScriptName).ps1" -InputObject $PS
 }

 }
