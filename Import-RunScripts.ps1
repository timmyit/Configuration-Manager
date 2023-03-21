#.NOTES
#    ===========================================================================
#     Created on:    3/21/2023 
#     Modified on:   3/21/2023 
#     Created by:    Timmy Andersson
#     Twitter:       @TimmyITdotcom
#     Blog:          www.timmyit.com
#    ===========================================================================
#    .DESCRIPTION
#        Import Run Scripts. 
#        Specify source path with the parameter -SourcePath
 
[CmdletBinding(DefaultParameterSetName = 'SourcePath')]
param
(
[Parameter(Mandatory = $true,
Position = 1)]
$SourcePath
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
Process
{
    $Scripts = (Get-ChildItem -Path $SourcePath) 
    
  
  
Set-Location $SitePath

                Foreach ($Script in $Scripts)
                    {

                     $ScriptFile = $SourcePath + "\" + $Script.name
                     New-CMScript -ScriptName "$($Script).name" -ScriptFile $ScriptFile  -Fast
                    }

  
}