
. $PSScriptRoot\scripts\helpers.ps1

. $PSScriptRoot\scripts\AlertsContacts.ps1
. $PSScriptRoot\scripts\Capacity.ps1
. $PSScriptRoot\scripts\Certificate.ps1
. $PSScriptRoot\scripts\ComponentPerf.ps1
. $PSScriptRoot\scripts\Controller.ps1
. $PSScriptRoot\scripts\Disk.ps1
. $PSScriptRoot\scripts\Event.ps1
. $PSScriptRoot\scripts\HostService.ps1
. $PSScriptRoot\scripts\Mail.ps1
. $PSScriptRoot\scripts\Shelf.ps1
. $PSScriptRoot\scripts\StoragePool.ps1
. $PSScriptRoot\scripts\StorageSystem.ps1
. $PSScriptRoot\scripts\Volume.ps1

write-warning "This a Prototype PowerShell Module, and not supported by HPE."
Export-ModuleMember -Function           Connect-DSCC,                        
    Get-DSCCHostServiceHostVolume,  
    Get-DSCCHostServiceHostGroup, Remove-DSCCHostServiceHostGroup,  Set-DSCCHostServiceHostGroup, New-DSCCHostServiceHostGroup,      
    Get-DSCCHostServiceHost,      Remove-DSCCHostServiceHost,       Set-DSCCHostServiceHost,      New-DSCCHostServiceHost,
    Get-DSCCHostServiceInitiator, Remove-DSCCHostServiceInitiator,                                New-DSCCHostServiceInitiator,

    Get-DSCCStorageSystem,        Invoke-DSCCStorageSystemLocate,

    Get-DSCCStoragePool,          Get-DSCCStoragePoolVolume,

    Get-DSCCVolume,
    
    Get-DSCCController,           Get-DSCCControllerSubComponent,   Invoke-DSCCControllerLocatePCBM,
    
    Get-DSCCEvent,

    Get-DSCCMail,                 Remove-DSCCMail,                  Set-DSCCMail,                 New-DSCCMail,

    Get-DSCCComponentPerfStats,

    Get-DSCCDisk,                 Get-DSCCShelf,                    Invoke-DSCCShelfLocate,

    Get-DSCCAlertOrContact,       Remove-DSCCAlertOrContact,        Set-DSCCAlertContact,         New-DSCCAlertContact,

    Get-DSCCCapacitySummary,
    Get-DSCCCapacityHistory,
    Get-DSCCCapacity,

    Get-DSCCCertificate,
    
    Find-DSCCDeviceTypeFromStorageSystemID