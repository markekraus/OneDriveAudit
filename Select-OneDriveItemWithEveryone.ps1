<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.129
	 Created on:   	10/21/2016 10:30 AM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Select-OneDriveItemWithEveryone.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
<#
    .SYNOPSIS
        Returns Items that have Permissions for Eeveryone
    
    .DESCRIPTION
        Returns only Items that have Permisions for the 'Everyone' principal
    
    .PARAMETER OneDriveListItem
        OneDrive.ListItem object
    
    .EXAMPLE
        		PS C:\> Select-OneDriveItemWithEveryone -OneDriveListItem $value1
    
    .NOTES
        Additional information about the function.
#>
function Select-OneDriveItemWithEveryone {
    [CmdletBinding(ConfirmImpact = 'Low')]
    [OutputType('OneDrive.ListItem')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('OneDrive.ListItem')]
        [system.management.Automation.psobject[]]$OneDriveListItem
    )
    
    Process {
        foreach ($Item in $OneDriveListItem) {
            try {
                $Permission = $Item.Item.RoleAssignments.GetByPrincipalId(4)
                $Item.OneDriveList.OneDriveConnection.Context.Load($Permission)
                $Item.OneDriveList.OneDriveConnection.Context.ExecuteQuery()
                $Item.OneDriveList.OneDriveConnection.Context.Load($Permission.RoleDefinitionBindings)
                $Item.OneDriveList.OneDriveConnection.Context.Load($Permission.Member)
                $Item.OneDriveList.OneDriveConnection.Context.ExecuteQuery()
                Foreach ($RoleDefinitionBinding in $Permission.RoleDefinitionBindings) {
                    $Item.OneDriveList.OneDriveConnection.Context.Load($RoleDefinitionBinding)
                    $Item.OneDriveList.OneDriveConnection.Context.ExecuteQuery()
                    Write-Verbose $RoleDefinitionBinding.Name
                    If ($RoleDefinitionBinding.Name -notlike 'Limited Access') {
                        #Send $Item to output
                        $Item
                        break
                    }
                }
            }
            Catch {
                Write-Verbose 'Everyone Not Found'
                Continue
            }
        }
    }
    
}
