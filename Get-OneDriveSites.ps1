<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.128
	 Created on:   	10/20/2016 10:06 AM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Get-OneDriveSites.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

<#
    .SYNOPSIS
        Gets a list of all OneDrive sites
    
    .DESCRIPTION
        A detailed description of the Get-OneDriveSites function.
    
    .PARAMETER SharePointConnection
        SharePoint.Connection Object returned by Connect-SharePoint
    
    .EXAMPLE
        PS C:\> Get-OneDriveSites -SharePointConnection $value1
    
    .NOTES
        Additional information about the function.
#>
function Get-OneDriveSites {
    [CmdletBinding(ConfirmImpact = 'Low')]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   Position = 0)]
        
        [ValidateNotNullOrEmpty()]
        [Alias('OneDriveConnection')]
        [PSTypeName('SharePoint.Connection')]
        [System.Management.Automation.PSObject[]]$SharePointConnection
    )
    
    Process {
        foreach ($CurSharePointConnection in $SharePointConnection) {
            $UrlBase = $CurSharePointConnection.MyUrl -replace '/$', ''
            $UserProfileService = $CurSharePointConnection.UserProfileService
            $UserProfileResult = $UserProfileService.GetUserProfileByIndex(-1)
            While ($UserProfileResult.NextValue -ne -1) {
                $Url = $null
                $Properties = $UserProfileResult.UserProfile | Where-Object { $_.Name -eq "PersonalSpace" }
                $ProfilePath = $Properties.Values[0].Value
                if ($ProfilePath) {
                    $OneDriveUrl = '{0}{1}' -f $UrlBase, $ProfilePath
                    #Send $OneDriveUrl to output
                    $OneDriveUrl
                }
                $UserProfileResult = $UserProfileService.GetUserProfileByIndex($UserProfileResult.NextValue)
            } #End While
        } #End foreach
    } #End proocess
} #End Function
