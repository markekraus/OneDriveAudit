<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.128
	 Created on:   	10/20/2016 1:26 PM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Get-OneDirveDoumentsItems.ps1
	===========================================================================
	.DESCRIPTION
		Get-OneDirveDoumentsItems function.
#>

<#
    .SYNOPSIS
        Returns all Items from a OneDrive Document library
    
    .DESCRIPTION
        Returns a OneDrive.ListItem object for all Items in the default Documents Document Library
    
    .PARAMETER OneDriveConnection
        OneDrive.Connection object returned from Connect-OneDrive
    
    .EXAMPLE
        PS C:\> Get-OneDirveDoumentsItems -OneDriveConnection $OneDrive
    
    .NOTES
        Additional information about the function.
#>
function Get-OneDirveDoumentsItems {
    [CmdletBinding()]
    [OutputType('OneDrive.ListItem')]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [PSTypeName('OneDrive.Connection')]
        [System.Management.Automation.psobject[]]$OneDriveConnection
    )
    Begin {
        $PageSize = 100
        $ListName = 'Documents'
    }
    Process {
        
        foreach ($OneDrive in $OneDriveConnection) {
            Try {
                $Documents = $OneDrive | Get-OneDriveList -Name $ListName -ErrorAction Stop
            }
            Catch {
                $ErrorMessage = $_.Exception.Message
                Write-Error "Unable to query $ListName list."
                break                
            }
            $Items = $null
            do {
                $Query = [Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery($PageSize)
                if ($Items.ListItemCollectionPosition) {
                    $Query.ListItemCollectionPosition = $Items.ListItemCollectionPosition
                }
                $Items = $Documents.List.GetItems($Query)
                $OneDrive.Context.Load($Items)
                $OneDrive.Context.ExecuteQuery()
                foreach ($Item in $Items) {
                    $OutObj = [pscustomobject]@{
                        PSTypeName = 'OneDrive.ListItem'
                        OneDriveList = $Documents
                        ItemId = $Item.Id
                        ItemName = $Item.FieldValues.FileLeafRef
                        ItemPath = $Item.FieldValues.FileDirRef
                        Item = $Item                        
                    }
                    #Send $OutObj to output
                    $OutObj
                }
                $Position = $Items.ListItemCollectionPosition
            }
            While ($Position)
        }#end Foreach OneDrive
    }#End Process
}#End Function
