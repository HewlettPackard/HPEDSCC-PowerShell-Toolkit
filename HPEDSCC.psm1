
. $PSScriptRoot\scripts\helpers.ps1

. $PSScriptRoot\scripts\Audit.ps1
. $PSScriptRoot\scripts\AccessGroup.ps1
. $PSScriptRoot\scripts\Authz.ps1
. $PSScriptRoot\scripts\Certificate.ps1
. $PSScriptRoot\scripts\Controller.ps1
. $PSScriptRoot\scripts\Disk.ps1
. $PSScriptRoot\scripts\Folder.ps1
. $PSScriptRoot\scripts\HostGroup.ps1
. $PSScriptRoot\scripts\Initiator.ps1
. $PSScriptRoot\scripts\Host.ps1
. $PSScriptRoot\scripts\Port.ps1
. $PSScriptRoot\scripts\Shelf.ps1
. $PSScriptRoot\scripts\Pool.ps1
. $PSScriptRoot\scripts\StorageSystem.ps1
. $PSScriptRoot\scripts\Volume.ps1
. $PSScriptRoot\scripts\VolumeSet.ps1
. $PSScriptRoot\scripts\Snapshot.ps1
# The following commands are in columns that represent the different types of commands. Additionally a line exists between each object type to make the list more readable
#   GET/FIND Commands             REMOVE Commands                 SET Commands                NEW Commands          INVOKE/CONNECT Commands
write-warning "This a Prototype PowerShell Module, and not supported by HPE."
Export-ModuleMember -Function                                                                                       Connect-DSCC,                        
    Get-DSCCAuditEvent,
    Get-DSCCAccessControl,        
    Get-DSCCResourceType,    
    Get-DSCCController,           
    Get-DSCCControllerPerf,       
    Get-DSCCControllerSubComponent,                                                                                 Invoke-DSCCControllerLocatePCBM,
    Get-DSCCAccessControlRecord,    Remove-DSCCAccessControlRecord,                         New-DSCCAccessControlRecord, 
    Get-DSCCVolumeSet,              Remove-DSCCVolumeSet,       Set-DSCCVolumeSet,          New-DSCCVolumeSet,                                                                            
    Get-DSCCHostVolume, 
    Get-DSCCHostGroup,              Remove-DSCCHostGroup,       Set-DSCCHostGroup,          New-DSCCHostGroup,      
    Get-DSCCHost,                   Remove-DSCCHost,            Set-DSCCHost,               New-DSCCHost,
    Get-DSCCInitiator,              Remove-DSCCInitiator,                                   New-DSCCInitiator,
    Get-DSCCStorageSystem,                                                                                           Invoke-DSCCStorageSystemLocate,
    Get-DSCCPool, 
    Get-DSCCFolder,         
    Get-DSCCPoolVolume,
    Get-DSCCVolume,                 Remove-DSCCVolume,          Set-DSCCVolume,             New-DSCCVolume,     
    Get-DSCCVolumePerf,            
    Get-DSCCSnapshot,               Remove-DSCCSnapshot,                                     New-DSCCSnapshot,
    Get-DSCCComponentPerfStats,
    Get-DSCCPort,
    Get-DSCCDisk,                 
    Get-DSCCShelf,                                                                                                  Invoke-DSCCShelfLocate,
    Get-DSCCCertificate,
    Find-DSCCDeviceTypeFromStorageSystemID,                                                                         Invoke-RepackageObjectWithType, 
                                                                                                                    Invoke-DSCCAutoReconnect
update-formatdata -prepend $PSScriptRoot\HPEDSCC.Format.ps1xml