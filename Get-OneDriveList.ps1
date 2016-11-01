<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.129
	 Created on:   	10/21/2016 7:34 AM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Get-OneDriveList.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
<#
    .SYNOPSIS
        Returns OneDrive lsits
    
    .DESCRIPTION
        Returns a OneDrive.List by either ID, Name or All lists
    
    .PARAMETER OneDriveConnection
        OneDrive.Connection object returned from Connect-OneDrive
    
    .PARAMETER ListName
        Name of the List to retrun
    
    .PARAMETER ListId
        ID of the list to return
    
    .EXAMPLE
        		PS C:\> Get-OneDriveList -OneDriveConnection $value1 -ListName $value2
    
    .OUTPUTS
        OneDrive.List, OneDrive.List, OneDrive.List
    
    .NOTES
        Additional information about the function.
#>
function Get-OneDriveList {
    [CmdletBinding(DefaultParameterSetName = 'AllItems')]
    [OutputType('OneDrive.List', ParameterSetName = 'AllItems')]
    [OutputType('OneDrive.List', ParameterSetName = 'ListName')]
    [OutputType('OneDrive.List', ParameterSetName = 'ListId')]
    [OutputType('OneDrive.List')]
    param
    (
        [Parameter(ParameterSetName = 'AllItems',
                   Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ListId',
                   Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ListName',
                   Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('OneDrive', 'Connection')]
        [system.management.Automation.psobject[]]$OneDriveConnection,
        
        [Parameter(ParameterSetName = 'ListName',
                   Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Name')]
        [string[]]$ListName,
        
        [Parameter(ParameterSetName = 'ListId',
                   Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [system.guid[]]$ListId
    )
    
    Process {
        foreach ($OneDrive in $OneDriveConnection) {
            $ListCollection = @()
            switch ($PsCmdlet.ParameterSetName) {
                'AllItems' {
                    $ListCollection += $OneDrive.Web.Lists
                    break
                }
                'ListName' {
                    Foreach ($Name in $ListName) {
                        $ListCollection += $OneDrive.Web.Lists.GetByTitle($Name)
                    }
                    break
                }
                'ListId' {
                    foreach ($Id in $ListId) {
                        $ListCollection += $OneDrive.Web.Lists.GetById($ID)
                    }
                    break
                }
            }
            foreach ($Lists in $ListCollection) {
                try {
                    $OneDrive.Context.Load($Lists)
                    $OneDrive.Context.ExecuteQuery()
                }
                catch {
                    $ErrorMessage = $_.Exception.Message
                    Write-Error "Error enumerting lists."
                    break
                }
                foreach ($List in $Lists) {
                    $OutList = [pscustomobject]@{
                        PSTypeName = 'OneDrive.List'
                        OneDriveConnection = $OneDrive
                        ListId = $List.Id
                        ListName = $List.Title
                        List = $List
                    }
                    #Send $OutList to Output
                    $OutList
                }
            }
        }
    }
    End {
        
    }
}
