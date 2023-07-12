#
# Create a new Manifest file for HPE GreenLake Data Storage Cloud Console Module
#
$ModuleVersion = '1.0.2'
$ExportingFunctions = @(
    'Connect-Dscc',
    'Get-DSCCAuditEvent',
    'Get-DSCCAuditEventDeviceType2'
    'Get-DSCCAccessControl',
    'Get-DSCCResourceType',
    'Get-DsccController',
    'Invoke-DSCCControllerLocatePCBM',
    'Get-DSCCAccessControlRecord',
    'Remove-DSCCAccessControlRecord',
    'New-DSCCAccessControlRecord',
    'Get-DSCCVolumeSet',
    'Remove-DSCCVolumeSet',
    'Set-DSCCVolumeSet',
    'New-DSCCVolumeSet',
    'Get-DSCCHostVolume',
    'Get-DSCCHostGroup',
    'Remove-DSCCHostGroup',
    'Set-DSCCHostGroup',
    'New-DSCCHostGroup',
    'Get-DSCCHost',
    'Remove-DSCCHost',
    'Set-DSCCHost',
    'New-DSCCHost',
    'Get-DSCCInitiator',
    'Remove-DSCCInitiator',
    'New-DSCCInitiator',
    'Get-DsccStorageSystem',
    'Enable-DsccStorageSystemLocate',
    'Disable-DsccStorageSystemLocate',
    'Get-DSCCPool',
    'Get-DSCCFolder',
    'Get-DSCCPoolVolume',
    'Get-DSCCVolume',
    'Remove-DSCCVolume',
    'Set-DSCCVolume',
    'New-DSCCVolume',
    'Get-DSCCVolumePerf',
    'Get-DSCCSnapshot',
    'Remove-DSCCSnapshot',
    'New-DSCCSnapshot',
    'Get-DSCCComponentPerfStats',
    'Get-DSCCPort',
    'Get-DsccDisk',
    'Get-DsccEnclosure',
    'Invoke-DSCCShelfLocate',
    'Get-DSCCCertificate',
    'Find-DSCCDeviceTypeFromStorageSystemID',
    'Invoke-RepackageObjectWithType',
    'Invoke-DSCCAutoReconnect'
)
$ExportingAliases = @(
    'Get-DsccShelf'
)

New-ModuleManifest -Path '.\HPEDSCC.psd1' `
    -RootModule 'HPEDSCC.psm1' `
    -FormatsToProcess 'HPEDSCC.Format.ps1xml' `
    -Author 'HPE Services' `
    -CompanyName 'Hewlett Packard Enterprise' `
    -CompatiblePSEditions @('Desktop', 'Core') `
    -PowerShellVersion 5.1 `
    -ModuleVersion $ModuleVersion `
    -FunctionsToExport $ExportingFunctions `
    -AliasesToExport $ExportingAliases `
    -CmdletsToExport @() `
    -VariablesToExport @() `
    -Description 'The HPE GreenLake Data Storage Cloud Console (DSCC) PowerShell Module provides the ability to monitor and manage your on-premise HPE GreenLake storage infrastructure via the HPE DSCC REST API.' `
    -Copyright '(C) Copyright 2023 Hewlett Packard Enterprise Development L.P. Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' `
    -Tags 'Hewlett', 'Packard', 'Enterprise', 'HPE', 'DSCC', 'Storage', 'Cloud', 'REST', 'RESTAPI', 'Data Storage', 'Cloud Console' `
    -ProjectUri 'https://github.com/HewlettPackard/HPEDSCC-PowerShell-ToolKit'