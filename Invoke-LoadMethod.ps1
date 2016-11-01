<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.128
	 Created on:   	10/20/2016 3:52 PM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	Invoke-LoadMethod.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
<#
    .SYNOPSIS
        Invokes the Load method from the SharePoint client Libraries
    
    .DESCRIPTION
        The Load method is not accessible to someporperties of context and needs to be invoked seperately of the standard $context.Load() method.
    
    .PARAMETER SharePointObject
        SharePoint object containing the desired property To Load
    
    .PARAMETER Property
        Name of the property to invoke the load method on.
    
    .EXAMPLE
        		PS C:\> Invoke-LoadMethod -SharePointObject $value1 -Property $value2
    
    .NOTES
        Additional information about the function.
    
    .LINK
        http://sharepoint.stackexchange.com/a/126226
#>
function Invoke-LoadMethod {
    [CmdletBinding(ConfirmImpact = 'Low',
                   HelpUri = 'http://sharepoint.stackexchange.com/a/126226')]
    [OutputType([void])]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.SharePoint.Client.ClientObject[]]$SharePointObject,
        
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Property
    )
    
    Process {       
        foreach ($Object in $SharePointObject) {
            foreach ($PropertyName in $Property) {
                $Context = $Object.Context
                $load = [Microsoft.SharePoint.Client.ClientContext].GetMethod("Load")
                $type = $Object.GetType()
                $clientLoad = $load.MakeGenericMethod($type)
                
                
                $Parameter = [System.Linq.Expressions.Expression]::Parameter(($type), $type.Name)
                $Expression = [System.Linq.Expressions.Expression]::Lambda(
                    [System.Linq.Expressions.Expression]::Convert(
                        [System.Linq.Expressions.Expression]::PropertyOrField($Parameter, $PropertyName),
                        [System.Object]
                    ),
                    $($Parameter)
                )
                $ExpressionArray = [System.Array]::CreateInstance($Expression.GetType(), 1)
                $ExpressionArray.SetValue($Expression, 0)
                $clientLoad.Invoke($Context, @($Object, $ExpressionArray))
            }
        }
    }
}
