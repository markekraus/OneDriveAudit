<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.128
	 Created on:   	10/20/2016 10:02 AM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Connect-SharePoint.ps1
	===========================================================================
	.DESCRIPTION
		Connect-SharePoint Function
#>
<#
    .SYNOPSIS
        Connects to SharePoint Online
    
    .DESCRIPTION
        Creates a SharePoint.Connection object
    
    .PARAMETER AdminUrl
        URL for the admin site of the SharePoint online Tenant.
        Example:
            https://adatum-admin.sharepoint.com
    
    .PARAMETER Credential
        SharePoint Online Administrator Credentials
    
    .EXAMPLE
        		PS C:\> Connect-OneDrive -AdminUrl 'Value1' -Credential $value2
    
    .NOTES
        Additional information about the function.
#>
function Connect-SharePoint {
    [CmdletBinding()]
    [OutputType('SharePoint.Connection')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true,
                   HelpMessage = 'Admin URL of the SharePoint Online Tenant (e.g.   https://adatum-admin.sharepoint.com)')]
        [ValidateNotNullOrEmpty()]
        [Alias('Url')]
        [string]$AdminUrl,
        
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true,
                   HelpMessage = 'SharePoint Online Administrator Credentials')]
        [ValidateNotNull()]
        [system.management.automation.pscredential]$Credential
    )
    
    Process {
        $SharePointCredential = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Credential.UserName, $Credential.Password)
        $ProfilerProxyAddress = "$AdminURL/_vti_bin/UserProfileService.asmx?wsdl"
        $UserProfileService = New-WebServiceProxy -Uri $ProfilerProxyAddress-UseDefaultCredential False
        $UserProfileService.Credentials = $SharePointCredential
        $AuthCookie = $SharePointCredential.GetAuthenticationCookie($AdminUrl)
        $AdminUri = New-Object System.Uri($AdminURL)
        $AdminUrlAdjusted = $AdminUri.AbsoluteUri
        $CookieContainer = New-Object System.Net.CookieContainer
        $CookieContainer.SetCookies($AdminUri, $AuthCookie)
        $UserProfileService.CookieContainer = $CookieContainer
        $MyUrl = $AdminUrl -replace '-admin', '-my'
        $MyUri = [uri]$MyUrl
        $MyUrl = $MyUri.AbsoluteUri
        $SitesUrl = $AdminUrl -replace '-admin', ''
        $SitesUri = [uri]$SitesUrl
        $SitesUrl = $SitesUri.AbsoluteUri
        $OutObj = [pscustomobject]@{
            Credential = $Credential
            SharePointCredential = $SharePointCredential
            ProfilerProxyAddress = $ProfilerProxyAddress
            UserProfileService = $UserProfileService
            AdminUrl = $AdminUrlAdjusted
            AdminUri = $AdminUri
            MyUrl = $MyUrl
            MyUri = $MyUri
            SitesUrl = $SitesUrl
            SitesUri = $SitesUri
        }
        $OutObj.psobject.typenames.clear()
        $OutObj.psobject.typenames.insert(0, 'SharePoint.Connection')
        #Write $OutObj to Output
        $OutObj
    }
}
