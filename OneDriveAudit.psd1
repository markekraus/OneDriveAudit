<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.128
	 Created on:   	10/20/2016 10:01 AM
	 Created by:   	Mark Kraus
	 Organization: 	Mitel
	 Filename:     	OneDriveAudit.psd1
	 -------------------------------------------------------------------------
	 Module Manifest
	-------------------------------------------------------------------------
	 Module Name: OneDriveAudit
	===========================================================================
#>

@{
	
	# Script module or binary module file associated with this manifest
	ModuleToProcess = 'OneDriveAudit.psm1'
	
	# Version number of this module.
	ModuleVersion = '1.0.0.20'
	
	# ID used to uniquely identify this module
	GUID = 'ca6120cf-3222-4a42-9d34-f5a87be949ff'
	
	# Author of this module
	Author = 'Mark Kraus'
	
	# Company or vendor of this module
	CompanyName = 'Mitel'
	
	# Copyright statement for this module
	Copyright = '(c) 2016. All rights reserved.'
	
	# Description of the functionality provided by this module
	Description = 'OneDrive Auditing Module'
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '4.0'
	
	# Name of the Windows PowerShell host required by this module
	PowerShellHostName = ''
	
	# Minimum version of the Windows PowerShell host required by this module
	PowerShellHostVersion = ''
	
	# Minimum version of the .NET Framework required by this module
	DotNetFrameworkVersion = '4.0'
	
	# Minimum version of the common language runtime (CLR) required by this module
	CLRVersion = '2.0.50727'
	
	# Processor architecture (None, X86, Amd64, IA64) required by this module
	ProcessorArchitecture = 'None'
	
	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @()
	
	# Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @(
        'Microsoft.SharePoint.Client'
        'Microsoft.SharePoint.Client.Runtime'
    )
	
	# Script files (.ps1) that are run in the caller's environment prior to
	# importing this module
	ScriptsToProcess = @()
	
	# Type files (.ps1xml) to be loaded when importing this module
	TypesToProcess = @()
	
	# Format files (.ps1xml) to be loaded when importing this module
	FormatsToProcess = @()
	
	# Modules to import as nested modules of the module specified in
	# ModuleToProcess
    NestedModules = @(
        'Connect-OneDrive.ps1'
        'Connect-SharePoint.ps1'
        'Get-OneDriveSites.ps1'
        'Get-OneDirveDoumentsItems.ps1'
        'Get-OneDriveList.ps1'
        'Invoke-LoadMethod.ps1'
        'Get-OneDriveItemPermissions.ps1'
        'Select-OneDriveItemWithEveryone.ps1'
    )
	
	# Functions to export from this module
    FunctionsToExport = @(
        'Connect-OneDrive'
        'Connect-SharePoint'
        'Get-OneDriveSites'
        'Get-OneDirveDoumentsItems'
        'Get-OneDriveList'
        'Invoke-LoadMethod'
        'Get-OneDriveItemPermissions'
        'Select-OneDriveItemWithEveryone'
    )
	
	# Cmdlets to export from this module
	CmdletsToExport = '*' 
	
	# Variables to export from this module
	VariablesToExport = '*'
	
	# Aliases to export from this module
	AliasesToExport = '*' #For performanace, list alias explicity
	
	# List of all modules packaged with this module
	ModuleList = @()
	
	# List of all files packaged with this module
	FileList = @()
	
	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
		
		#Support for PowerShellGet galleries.
		PSData = @{
			
			# Tags applied to this module. These help with module discovery in online galleries.
			# Tags = @()
			
			# A URL to the license for this module.
			# LicenseUri = ''
			
			# A URL to the main website for this project.
			# ProjectUri = ''
			
			# A URL to an icon representing this module.
			# IconUri = ''
			
			# ReleaseNotes of this module
			# ReleaseNotes = ''
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}







