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
    [System.IO.DirectoryInfo]$DestinationPath
)
Begin {
    $SiteCodeObjs = Get-WmiObject -Namespace "root\SMS" -Class SMS_ProviderLocation -ComputerName $env:COMPUTERNAME -ErrorAction Stop
    foreach ($SiteCodeObj in $SiteCodeObjs) {
        if ($SiteCodeObj.ProviderForLocalSite -eq $true) {
            $SiteCode = $SiteCodeObj.SiteCode
        }
    }
    $SitePath = $SiteCode + ":"
    Import-Module ($Env:SMS_ADMIN_UI_PATH.Substring(0, $Env:SMS_ADMIN_UI_PATH.Length - 5) + '\ConfigurationManager.psd1')
}
PROCESS { 
    Set-Location $SitePath
    $Scripts = Get-CMScript 

    if (-not (Test-Path $DestinationPath)) {
        New-Item -Path $DestinationPath -ItemType Directory -Force
    }

    foreach ($Script in $Scripts) {
        $PS = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($($Script).Script))
        $ScriptName = $Script.ScriptName.Split([IO.Path]::GetInvalidFileNameChars()) -join '_'
        Out-File -FilePath "$DestinationPath\$($ScriptName).ps1" -InputObject $PS
    }
}
