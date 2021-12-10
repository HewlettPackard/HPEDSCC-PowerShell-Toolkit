
. $PSScriptRoot\scripts\helpers.ps1

. $PSScriptRoot\scripts\Audit.ps1
. $PSScriptRoot\scripts\Authz.ps1
. $PSScriptRoot\scripts\Capacity.ps1
. $PSScriptRoot\scripts\Certificate.ps1
. $PSScriptRoot\scripts\Controller.ps1
. $PSScriptRoot\scripts\Disk.ps1
. $PSScriptRoot\scripts\HostGroup.ps1
. $PSScriptRoot\scripts\Initiator.ps1
. $PSScriptRoot\scripts\Host.ps1
. $PSScriptRoot\scripts\Port.ps1
. $PSScriptRoot\scripts\Shelf.ps1
. $PSScriptRoot\scripts\StoragePool.ps1
. $PSScriptRoot\scripts\StorageSystem.ps1
. $PSScriptRoot\scripts\Volume.ps1
. $PSScriptRoot\scripts\Snapshot.ps1

write-warning "This a Prototype PowerShell Module, and not supported by HPE."
Export-ModuleMember -Function           Connect-DSCC,                        
    Get-DSCCAuditEvent,

    Get-DSCCAccessControl,        Get-DSCCResourceType,    

    Get-DSCCController,               Get-DSCCControllerPerf,       Get-DSCCControllerSubComponent,   Invoke-DSCCControllerLocatePCBM,

    Get-DSCCHostVolume,  
    Get-DSCCHostGroup,          Remove-DSCCHostGroup,  Set-DSCCHostGroup, New-DSCCHostGroup,      

    Get-DSCCHost,               Remove-DSCCHost,       Set-DSCCHost,      New-DSCCHost,

    Get-DSCCInitiator,          Remove-DSCCInitiator,  New-DSCCInitiator,

    Get-DSCCStorageSystem,        Invoke-DSCCStorageSystemLocate,

    Get-DSCCStoragePool,          Get-DSCCStoragePoolVolume,

    Get-DSCCVolume,               

    Get-DSCCSnapshot,

    Get-DSCCComponentPerfStats,

    Get-DSCCPort,

    Get-DSCCDisk,                 Get-DSCCShelf,                    Invoke-DSCCShelfLocate,

    Get-DSCCCapacitySummary,
    Get-DSCCCapacityHistory,
    Get-DSCCCapacity,

    Get-DSCCCertificate,
    
    Find-DSCCDeviceTypeFromStorageSystemID,     Invoke-RepackageObjectWithType, Invoke-DSCCAutoReconnect
update-formatdata -prepend $PSScriptRoot\HPEDSCC.Format.ps1xml