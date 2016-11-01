<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.128
	 Created on:   	10/20/2016 1:47 PM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Connect-OneDrive.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
<#
    .SYNOPSIS
        Connects to OneDrive
    
    .DESCRIPTION
        Returns a OneDrive.Connection object containin the CSOM Contexts for the  OneDrive site.
    
    .PARAMETER SharePointConnection
        SharePoint.Connection object returned by Connect-SharePoint
    
    .PARAMETER OneDriveUrl
        OneDrive Site URL
        Example:
            https://adatum-my.sharepoint.com/personal/bob_testerton_adatum_com
    
    .EXAMPLE
        		PS C:\> Connect-OneDrive -SharePointConnection $value1 -OneDriveUrl $value2
    
    .NOTES
        Additional information about the function.
#>
function Connect-OneDrive {
    [CmdletBinding(ConfirmImpact = 'Low')]
    [OutputType('OneDrive.Connection')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [PsTypeName('SharePoint.Connection')]
        [system.management.Automation.psobject]$SharePointConnection,
        
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$OneDriveUrl
    )
    
    Process {
        
        foreach ($CurOneDriveUrl in $OneDriveUrl) {
            $OneDriveContext = New-Object Microsoft.SharePoint.Client.ClientContext($CurOneDriveUrl)
            $OneDriveContext.Credentials = $SharePointConnection.SharePointCredential
            $OneDriveSite = $OneDriveContext.Site
            $OneDriveWeb = $OneDriveContext.Web
            $OneDriveContext.Load($OneDriveSite)
            $OneDriveContext.Load($OneDriveWeb)
            $OneDriveContext.ExecuteQuery()
            $OneDriveLists = $OneDriveWeb.Lists
            $OneDriveContext.Load($OneDriveLists)
            $OneDriveContext.ExecuteQuery()
            $OutObject = [pscustomobject]@{
                PSTypeName = 'OneDrive.Connection'
                SharePointConnection = $SharePointConnection
                Url = $CurOneDriveUrl
                Context = $OneDriveContext
                Site = $OneDriveSite
                Web = $OneDriveWeb
                Lists = $OneDriveLists
            }
            #Send $OutObject to Output
            $OutObject
        }#End Foreach OndriveURL
    }#End Process    
}#End Function
