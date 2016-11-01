<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.129
	 Created on:   	10/21/2016 9:29 AM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Get-OneDriveItemPermissions.ps1
	===========================================================================
	.DESCRIPTION
		Get-OneDriveItemPermissions Function
#>
<#
    .SYNOPSIS
        Returns all permissions on an OneDrive List Item
    
    .DESCRIPTION
        Returns OneDrive.ListItem.RoleAssignment Objects containing the loginName Titlte, Roles, and relevant contexts for all permissions on a OneDrive list Item
    
    .PARAMETER OneDriveListItem
        OneDrive.ListItem Object
    
    .EXAMPLE
        		PS C:\> Get-OneDriveItemPermissions -OneDriveListItem $value1
    
    .NOTES
        Additional information about the function.
#>
function Get-OneDriveItemPermissions {
    [CmdletBinding(ConfirmImpact = 'Low')]
    [OutputType('OneDrive.ListItem.RoleAssignment')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('ListItem', 'Item')]
        [PSTypeName('OneDrive.ListItem')]
        [system.management.Automation.psobject[]]$OneDriveListItem
    )
    
    Process {
        foreach ($Item in $OneDriveListItem) {
            $Item.OneDriveList.OneDriveConnection.Context.Load($Item.Item.RoleAssignments)
            $Item.OneDriveList.OneDriveConnection.Context.ExecuteQuery()
            Foreach ($RoleAssignment in $Item.Item.RoleAssignments) {
                $Item.OneDriveList.OneDriveConnection.Context.Load($RoleAssignment.RoleDefinitionBindings)
                $Item.OneDriveList.OneDriveConnection.Context.Load($RoleAssignment.Member)
                $Item.OneDriveList.OneDriveConnection.Context.ExecuteQuery()
                $RoleDefinitionBindings = @()
                Foreach ($RoleDefinitionBinding in $RoleAssignment.RoleDefinitionBindings) {
                    $Item.OneDriveList.OneDriveConnection.Context.Load($RoleDefinitionBinding)
                    $Item.OneDriveList.OneDriveConnection.Context.ExecuteQuery()
                    $RoleDefinitionBindings += $RoleDefinitionBinding
                }
                $MemberType = $RoleAssignment.Member.GetType().Name
                $RoleAssignment.Member | Invoke-LoadMethod -Property Title, LoginName
                $OutObj = [pscustomobject]@{
                    PSTypeName = 'OneDrive.ListItem.RoleAssignment'
                    LoginName = $RoleAssignment.Member.LoginName
                    Title = $RoleAssignment.Member.Title
                    Roles = $RoleDefinitionBindings.Name
                    Member = $RoleAssignment.Member
                    RoleDefinitionBindings = $RoleDefinitionBindings
                    RoleAssignment = $RoleAssignment
                }
                #Send $OutObj to Output
                $OutObj
            }
        }
    }
}
