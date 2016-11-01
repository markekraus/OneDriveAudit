<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.128
	 Created on:   	10/21/2016 6:32 AM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Update-OneDriveItemSecurityDescriptors.ps1
	===========================================================================
	.DESCRIPTION
		Update-OneDriveItemSecurityDescriptors Function.
#>
<#
    .SYNOPSIS
        Loads the Security Descriptors on a OneDrive List or Document Library Item
    
    .DESCRIPTION
        A detailed description of the Update-OneDriveItemSecurityDescriptors function.
    
    .PARAMETER OneDriveItem
        OneDrive List or Docment Library Item
    
    .PARAMETER PassThru
        If set the object will be returned. By defatult, this function returns nothing
    
    .EXAMPLE
        		PS C:\> Update-OneDriveItemSecurityDescriptors -OneDriveItem $value1 -PassThru
    
    .OUTPUTS
        void, OneDrive.ListItem
    
    .NOTES
        Additional information about the function.
#>
function Update-OneDriveItemPermissions {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([void], ParameterSetName = 'Default')]
    [OutputType('OneDrive.ListItem', ParameterSetName = 'PassThru')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
                   Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'PassThru')]
        [ValidateNotNullOrEmpty()]
        [Alias('Item')]
        [PSTypeName('OneDrive.ListItem')]
        [system.management.Automation.psobject[]]$OneDriveItem,
        
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [switch]$PassThru
    )
    
    Process {
           
        foreach ($Item in $OneDriveItem) {
            $Item.Item | Invoke-LoadMethod -Property HasUniqueRoleAssignments
            $Permissions = $Item | Get-One
            if ($PassThru) {
                #Send $Item to Output
                $Item
            }
        }
    }
}
