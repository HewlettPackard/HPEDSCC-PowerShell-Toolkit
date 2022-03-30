function Get-DSCCVolume
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Storage Systems Pools for a specific storage system and pool    
.DESCRIPTION
    Returns the HPE DSSC DOM Storage Systems Pools for a specific storage system and pool 
.PARAMETER StorageSystemID
    A single Storage System ID is specified and required, the pools defined will be returned unless a specific PoolID is requested.
.PARAMETER VolumeID
    A single Storage System Volume ID is specified and required, and all volumes in that system will be returned if a single volume is not specified.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-DSCCStorageSystem -DeviceType device-type2 | Get-DSCCVolume
    
    Id                                         name         size  serial number or wwn             volume detail       system id                                  thin de-dupe compression
    --                                         ----         ----  --------------------             -------------       ---------                                  ---- ------- -----------
    0606b878a5a008ec63000000000000000000000037 TesVolumes.1 10240 e40f50ef8300e4436c9ce900c694b0a6 Windows File Server 0006b878a5a008ec63000000000000000000000001 True True    0
    0606b878a5a008ec63000000000000000000000038 TesVolumes.2 10240 139cdbd49d23ed3f6c9ce900c694b0a6 Windows File Server 0006b878a5a008ec63000000000000000000000001 True True    0
    0606b878a5a008ec63000000000000000000000036 TesVolumes.0 10240 b5fa15bc2e0c0db56c9ce900c694b0a6 Windows File Server 0006b878a5a008ec63000000000000000000000001 True True    0

.EXAMPLE
    PS:> Get-DSCCStorageSystem -DeviceType device-type1 | Get-DSCCVolume

    Id                               name      size   serial number or wwn             volume detail            system id  thin  de-dupe compression
    --                               ----      ----   --------------------             -------------            ---------  ----  ------- -----------
    ee9f3c18a83aeef9ebfaabb8526b7386 .srdata   71680  60002AC0000000000000000100026AFD Virtual Volume .srdata   2M2042059T False N/A     0
    2c7fcac83ec31572e625f39fa98b744f .mgmtdata 524288 60002AC0000000000000000200026AFD Virtual Volume .mgmtdata 2M2042059T False N/A     0
    72b6077ba59d6bfd6f74e9252f02d3e8 admin     10240  60002AC0000000000000000000026AFD Virtual Volume admin     2M2042059T False N/A     0
    4f7dbf983f9607469d584722a1ed2736 .mgmtdata 524288 60002AC0000000000000000200025F89 Virtual Volume .mgmtdata 2M202205GF False N/A     0
    1070dbef0bad8a313ada2b67f401c28b admin     10240  60002AC0000000000000000000025F89 Virtual Volume admin     2M202205GF False N/A     0
    6acfbbd149c521a16bfb9fc72360a8fd .srdata   71680  60002AC0000000000000000100025F89 Virtual Volume .srdata   2M202205GF False N/A     0
.EXAMPLE
    PS:> Get-DSCCStorageVolume -StorageSystemId 2M202205GF

    Id                               name      size   serial number or wwn             volume detail            system id  thin  de-dupe compression
    --                               ----      ----   --------------------             -------------            ---------  ----  ------- -----------
    4f7dbf983f9607469d584722a1ed2736 .mgmtdata 524288 60002AC0000000000000000200025F89 Virtual Volume .mgmtdata 2M202205GF False N/A     0
    1070dbef0bad8a313ada2b67f401c28b admin     10240  60002AC0000000000000000000025F89 Virtual Volume admin     2M202205GF False N/A     0
    6acfbbd149c521a16bfb9fc72360a8fd .srdata   71680  60002AC0000000000000000100025F89 Virtual Volume .srdata   2M202205GF False N/A     0
.EXAMPLE
    PS:> Get-DSCCStorageVolume -StorageSystemId 2M202205GF -VolumeId 1070dbef0bad8a313ada2b67f401c28b

    Id                               name      size   serial number or wwn             volume detail            system id  thin  de-dupe compression
    --                               ----      ----   --------------------             -------------            ---------  ----  ------- -----------
    1070dbef0bad8a313ada2b67f401c28b admin     10240  60002AC0000000000000000000025F89 Virtual Volume admin     2M202205GF False N/A     0
.EXAMPLE
    PS:> Get-DSCCStorageVolume -StorageSystemId 2M202205GF -VolumeId 1070dbef0bad8a313ada2b67f401c28b | format-list

    id                           : 67e1c89608b1657b34369d16a07f2689
    systemId                     : 2M2042059V
    displayname                  : Virtual Volume admin
    domain                       : -
    name                         : admin
    healthState                  : 3
    usedCapacity                 : 100
    volumeId                     : 0
    wwn                          : 60002AC0000000000000000000026AF6
    state                        : @{detailed=; overall=STATE_NORMAL}
    creationTime                 : @{ms=; tz=America/Chicago}
    comment                      :
    adminSpace                   : @{reservedMiB=0; rawReservedMiB=0; usedMiB=0; freeMiB=0; grownMiB=0; reclaimedMiB=0;
                                   totalMiB=0}
    userSpace                    : @{reservedMiB=10240; rawReservedMiB=30720; usedMiB=10240; freeMiB=0; grownMiB=0;
                                   reclaimedMiB=0; totalMiB=10240}
    snapshotSpace                : @{reservedMiB=0; rawReservedMiB=0; usedMiB=0; freeMiB=0; grownMiB=0; reclaimedMiB=0;
                                   totalMiB=0}
    totalReservedMiB             : 10240
    totalRawReservedMiB          : 30720
    usedSizeMiB                  : 10240
    sizeMiB                      : 10240
    totalSpaceMiB                : 10240
    hostWrittenToVirtualPercent  : 0
    userReservedToVirtualPercent : 1
    userUsedToVirtualPercent     : 1
    snapshotUsedToVirtualPercent : 0
    adminAllocationSettings      : @{deviceType=DEVICE_TYPE_ALL; deviceSpeed=; RAIDType=RAID_UNKNOWN; HA=;
                                   requestedHA=; setSize=; stepSize=-1; diskFilter=}
    userAllocationSettings       : @{deviceType=DEVICE_TYPE_SSD; deviceSpeed=; RAIDType=RAID_ONE; HA=; requestedHA=;
                                   setSize=3 data; stepSize=32768; diskFilter=}
    snapshotAllocationSettings   : @{deviceType=DEVICE_TYPE_ALL; deviceSpeed=; RAIDType=RAID_UNKNOWN; HA=;
                                   requestedHA=; setSize=; stepSize=-1; diskFilter=}
    raid                         : RAID_ONE
    devType                      : DEVICE_TYPE_SSD
    sectorsPerTrack              : 304
    headsPerCylinder             : 8
    vlunSectorSize               : 512
    volumeType                   : VVTYPE_BASE
    provType                     : PROVTYPE_FULL
    fullyProvisioned             : True
    thinProvisioned              : False
    policy                       : @{staleSnapshot=True; oneHost=False; zeroDetect=False; system=True; noCache=False;
                                   fileService=False; zeroFill=False; hostDif3par=True; hostDifStd=False}
    physicalCopy                 : False
    readOnly                     : False
    started                      : True
    compressionPolicy            : N/A
    dedup                        : N/A
    hostWrittenMiB               : 0
    rcopyStatus                  : none
    hidden                       : False
    snapshotTdvvSize             : @{virtualSizeMiB=0; ddcSizeMiB=0; ddsSizeMiB=0; writtenSizeMiB=0}
    baseId                       : 0
    dataReduction                : DATA_REDUCTION_OFF
    thinSavings                  : 1:1
    volumePerformance            : @{customerId=0056b71eefc411eba26862adb877c2d8; latencyMs=; iops=; throughputKbps=}
    associatedLinks              : {@{type=systems; resourceUri=/api/v1/storage-systems/device-type1/2M2042059V}}
    snapshots                    : @{items=System.Object[]; total=0; pageLimit=200; pageOffset=0}
    vluns                        : @{items=System.Object[]; total=0; pageLimit=50; pageOffset=0}
    customerId                   : 0056b71eefc411eba26862adb877c2d8
    generation                   : 1636042781827
    type                         : volume
    consoleUri                   : /data-ops-manager/storage-systems/device-type1/2M2042059V/volumes/67e1c89608b1657b34369d16a07f2689
.EXAMPLE
    PS:> Get-DSCCStoragePool -StorageSystemId 2M202205GG -StoragePoolId 3ff8fa3d971f16948fd9cff800775b9d -whatif
    
    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/storage-systems/device-type1/2M202205GG/storage-pools/213434545567/volumes
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IlhwRUVZUGlZWDVkV1JTeDR4SmpNcEVPc1hTSSIsInBpLmF0bSI6ImRlejAifQ.eyJjbGllbnRfaWQiOiIzZjIwODU4NS0zZGE2LTRiZjctOTRjYS00ZjMxMGQwOTYzYjUiLCJpc3MiOiJodHRwczovL3Nzby5jb21tb24uY2xvdWQuaHBlLmNvbSIsImF1ZCI6ImV4dGVybmFsX2FwaSIsInN1YiI6ImNocmlzLmxpb25ldHRpQGhwZS5jb20iLCJ1c2VyX2N0eCI6IjAwNTZiNzFlZWZjNDExZWJhMjY4NjJhZGI4NzdjMmQ4IiwiYXV0aF9zb3VyY2UiOiJjY3NfdG9rZW5fbWFuYWdlbWVudCIsInBsYXRmb3JtX2N1c3RvbWVyX2lkIjoiOGZmYzRiN2VlOWQyMTFlYjhjZWU2ZTEzYzA3MWVhMzciLCJpYXQiOjE2MzYwNjY4NzksImFwcGxpY2F0aW9uX2luc3RhbmNlX2lkIjoiM2MxOGJkMDMtODMwNi00YzdjLTk0MmUtYzcwNGE0Yjg3NDRjIiwiZXhwIjoxNjM2MDc0MDc5fQ.D38GnVgiQVgNl6TboQC8UOOq0CxlRPo6oEdiq7KnNAojZfrIZJ2bHkAqcqaua4aEB6Y5d2q-DCVf6DQjsKec2utfLHYv-cOEWzzx06dUk4B11fJaCsRWuLNT-NZjSqugUKpp22VBbFn5stUAs3_YXVIlR9x3UqYk9MGZW2QgQtqKjheD6msFiplgzx5g9RPqyViX24V0gNcIXVcRd36wb-Rr_wGP9X6ycy6fXhWtqkKc7c8aKcfwflKsgvcI7p4NIS2LGswuuTrTAspoNgAp-Io0ytsepnxZ6vEiJrxZHhLcL4zEBP-IV9ElsgS3ymMVfhT-uBZXdr1CfV9EHQ0Vgw"
        }
    The Body of this call will be:
        "No Body"
.EXAMPLE
    PS:> Get-DSCCDOMStoragePoolVolume -StorageSystemId 2M202205GG -StoragePoolId 3ff8fa3d971f16948fd9cff800775b9d | format-table

    id                               systemId   displayname              domain name      healthState usedCapacity volumeId 
    --                               --------   -----------              ------ ----      ----------- ------------ -----
    97183a044aecc5fed6f0fc3e36b042c7 2M2042059V Virtual Volume .mgmtdata -      .mgmtdata           3          100     2
    bd1ab3e2e9882c2d4aeb9e2126df65f5 2M2042059X Virtual Volume .mgmtdata -      .mgmtdata           3          100     2
    5a510bf1234afdcca6f8e98ce915b6ad 2M202205GG Virtual Volume .srdata   -      .srdata             3          100     1
    ee9f3c18a83aeef9ebfaabb8526b7386 2M2042059T Virtual Volume .srdata   -      .srdata             3          100     1
    6acfbbd149c521a16bfb9fc72360a8fd 2M202205GF Virtual Volume .srdata   -      .srdata             3          100     1
.EXAMPLE
    PS:> Get-DSCCDOMStoragePoolVolume -StorageSystemId 2M202205GG -StoragePoolId 3ff8fa3d971f16948fd9cff800775b9d
    
    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://fleetscale-app.qa.cds.hpe.com/api/v1/storage-systems/device-type1/2M202205GG/volumes
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciLCJ...U_DgJPuVIP7Fjum2TA7UyrLlB3UZhxtQbOMfH2I4TJixAIQ"
        }
    The Body of this call will be:
        "No Body"
.LINK
#>   
[CmdletBinding()]
param(  [Parameter(ValueFromPipeLineByPropertyName=$true )][Alias('id')]    [string]    $SystemId, 
                                                                            [string]    $VolumeId,
                                                                            [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        write-verbose "Dectected the DeviceType is $DeviceType"
        $MyURI = $BaseURI + 'storage-systems/'
        if ( $SystemId )
            {   $MyURI = $MyURI + $SystemId + '/'
            } 
        $MyURI = $MyURI + 'volumes'
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyURI -headers $MyHeaders -method Get
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyURI -headers $MyHeaders -method Get
                }
        if ( ($SysColOnly).items ) 
                {   $SysColOnly = ($SysColOnly).items 
                    $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Volume.Combined"
                }
            else 
                {   if ( ($SysColOnly).Total -eq 0 )
                            {   Write-Warning "No Items Detected on system with ID $SystemId."
                                return
                            }
                }
        if ( $VolumeId )
                {   return ( $ReturnData | where-object { $_.id -eq $VolumeId } )
                } 
            else 
                {   return $ReturnData
                }
    }       
} 

function Remove-DSCCVolume
{
<#
.SYNOPSIS
    Removes a Volume from a DSCC Storage System.     
.DESCRIPTION
    The command will remove a specific volume from a Storage System, but to run this command you will need to know the VolumeID 
    and the StorageSystemID. This command includes parameters to both force the delete, as well as force a cascading delete that removes linked items. 
.PARAMETER StorageSystemID
    A single Storage System ID is specified and required, This command will accept pipeline input from the Get-DSCCStorageSystems command.
.PARAMETER VolumeID
    A single Storage System Volume ID is specified and required.
.PARAMETER Cascade
    This option is only valid for devices that are of type Device-Type1 (Alletra9K, Primera, 3PAR) and will be ignored on Device-Type2 devices 
    (Alletra6K and Nimble Storage). This option will remove both the Volume and the dependant snapshots all in a single command.
.PARAMETER unExport
    This option is only valid for devices that are of type Device-Type1 (Alletra9K, Primera, 3PAR) and will be ignored on Device-Type2 devices 
    (Alletra6K and Nimble Storage). This option will remove both the volume as well as unexport the host and host-sets that this volume is mapped to.
.PARAMETER force
    The option will force the volume offline and remove it on a Device-type2 (Alletra 6K or Nimble Storage) type system. The default behaviour
    without the force option being set to true is to only delete a volume that is already offline. If used with a Device-Type2 (Alletra9K, Primera, 3PAR) 
    this field will be ignored.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-DSCCStorageSystem | Remove-Volume -Volumeid 0b12343564567abcdef0234123 -force
.EXAMPLE
    PS:> Get-DSCCStorageSystem | Remove-Volume -Volumeid 0b12343564567abcdef0234123 -force -whatif
.EXAMPLE
    PS:> Remove-Volume -SystemId 040abe24534563245234243abef -Volumeid 0b12343564567abcdef0234123 -force
.EXAMPLE
    PS:> Remove-Volume -SystemId MX1234ABDE -Volumeid 234Volref -Cascade -unExport
#>   
[CmdletBinding()]
param(  [Parameter(mandatory=$true, ValueFromPipeLineByPropertyName=$true )][Alias('id')]   [string]    $SystemId, 
        [Parameter(mandatory=$true )]                                                       [string]    $VolumeId,
                                                                                            [switch]    $Cascade,
                                                                                            [switch]    $unExport,
                                                                                            [switch]    $force,
                                                                                            [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        write-verbose "Dectected the DeviceType is $DeviceType"
        $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + '/volumes/' + $VolumeId
        switch ( $DeviceType )
        {   'device-type1'  {   if ( $Cascade ) 
                                        {  $MyURI = $MyURI + '?cascade=true' 
                                        }
                                if ( $UnExport )
                                        {   if ( $Cascade ) 
                                                    {   $MyURI = $MyURI + '&'
                                                    }
                                                else 
                                                    {   $MyURI = $MyURI + '?'
                                                    }
                                            $MyURI = $MyUri + 'cascade=true'
                                        }
                            }
            'device-type2'  {   if ( $force )
                                    { $MyURI = $MyURI + '?force=true'
                                    }

                            }
            default         {   write-warning 'The SystemID did not return a valid system.'
                                return
                            }

        } 
        if ( $WhatIf )
                {   $ReturnData = invoke-restmethodWhatIf -uri $MyURI -headers $MyHeaders -method Delete
                }   
            else 
                {   $ReturnData = invoke-restmethod -uri $MyURI -headers $MyHeaders -method Delete
                }
        return $ReturnData
    }       
} 

function New-DSCCVolume
{
<#
.SYNOPSIS
    Creates a new Volume on the specified Storage System.    
.DESCRIPTION
    Creates a new Volume on the Specified Storage System with the supplied parameters. Depending on the target storage system, the command will 
    accept either 1 of 2 sets of parameters; device-type1 or device-type2. 
.PARAMETER StorageSystemID
    A single Storage System ID is specified and required. This is required for both parameter sets
.PARAMETER name
    A single name is specified and required, and is required for both parameter sets.
.PARAMETER sizeMiB
Volume size in megabytes. Size is required for creating a volume but not for cloning an existing volume.When creating a 
    new volume, size is required. When cloning an existing volume, size defaults to that of the parent volume. 
    This parameter is only valid for device-type2 which represents Alletra 9K and Primera or 3PAR targets.
.PARAMETER userCpg
    User CPG. This parameter is only valid for device-type2 which represents Alletra 9K and Primera or 3PAR targets.
.PARAMETER comments
    The detailed description of the volume.This parameter is only valid for device-type2 which represents 
    Alletra 9K and Primera or 3PAR targets.
.PARAMETER count
    How many Volumes to create using the given parameters. This parameter is only valid for device-type2 which 
    represents Alletra 9K and Primera or 3PAR targets.
.PARAMETER dataReduction
    If data reduction technologies such as compression or deduplication should be turned on. This parameter is only valid 
    for device-type2 which represents Alletra 9K and Primera or 3PAR targets.
.PARAMETER snapCpg
    The CPG that will be used to store the snapshot data
.PARAMETER snapshotAllocWarning
    Snapshot Alloc Warning
.PARAMETER userAllocWarning
    User Alloc Warning
.PARAMETER size
    Volume size in megabytes. Size is required for creating a volume but not for cloning an existing volume.When creating a 
    new volume, size is required. When cloning an existing volume, size defaults to that of the parent volume.
.PARAMETER pool_id
    Identifier associated with the pool in the storage pool table. A 42 digit hexadecimal int64. Defaults to the ID of the 'default' pool.
.PARAMETER agent_type
    External management agent type. Defaults to 'none'. Possible values: 'none', 'smis', 'vvol', 'openstack', 'openstackv2'.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER app_uuid
    Application identifier of volume. String of up to 255 alphanumeric characters, hyphen, colon, dot and underscore are allowed. 
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER base_snap_id
    Base snapshot ID. This attribute is required together with name and clone when cloning a volume with the create operation. A 42 
    digit hexadecimal int64. Defaults to the empty string. This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER block_size
    Size in bytes of blocks in the volume. Defaults to 4096, but may also be set to 8192, 16388, 32786, and 65536, representing 4K, 8K, 16K, 32K, or 64K.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER cache_pinned
	If set to true, all the contents of this volume are kept in flash cache. This provides for consistent performance guarantees for all types of workloads. 
    The amount of flash needed to pin the volume is equal to the limit for the volume. Defaults to 'false'. 
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER clone
    Whether this volume is a clone. Use this attribute in combination with name and base_snap_id to create a clone by setting clone = true. Defaults to 'false'.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER dedepe_enabled
    Indicate whether dedupe is enabled. Defaults to 'false'. This parameter is only valid for device-type1 which 
    represents Alletra 6K and Nimble Storage. This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER description
    Text description of volume. String of up to 255 printable ASCII characters. Defaults to the empty string. 
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER dest_pool_id
    ID of the destination pool where the volume is moving to. A 42 digit hexadecimal int64. Defaults to the empty string.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER encryption_cipher
    The encryption cipher of the volume. Defaults to 'none'. Possible values: 'none', 'aes_256_xts'.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER folder_id
    ID of the folder holding this volume. An optional NsObjectID. A 42 digit hexadecimal int64 or the empty string. 
    Defaults to the empty string. This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER limit
    Limit for the volume as a percentage of volume size. Percentage as integer from 0 to 100. Defaults to the default 
    volume limit set on group, typically 100. This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER limit_iops
    IOPS limit for this volume. If limit_iops is not specified when a volume is created, or if limit_iops is set to -1, 
    then the volume has no IOPS limit. If limit_iops is not specified while creating a clone, IOPS limit of parent volume 
    will be used as limit. IOPS limit should be in range [256, 4294967294] or -1 for unlimited. If both limit_iops and 
    limit_mbps are specified, limit_mbps must not be hit before limit_iops. In other words, IOPS and MBPS limits should honor 
    limit_iops _ampersand_amp;lt;= ((limit_mbps MB/s * 2^20 B/MB) / block_size B). By default the volume is created with unlimited iops.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER multi_initiator
    This indicates whether volume and its snapshots are multi-initiator accessible. This attribute applies only to volumes and 
    snapshots available to iSCSI initiators. Defaults to 'false'. This parameter is only valid for device-type1 which represents 
    Alletra 6K and Nimble Storage.
.PARAMETer online
    Online state of volume, available for host initiators to establish connections. Defaults to 'true'.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER owned_by_group_id
    ID of group that currently owns the volume. A 42 digit hexadecimal int64. Defaults to the ID of the group that created the volume.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER perfpolicy_id
    Identifier of the performance policy. After creating a volume, performance policy for the volume can only be changed to another 
    performance policy with same block size. A 42 digit hexadecimal int64. Defaults to ID of the 'default' performance policy.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER read_only
    Volume is read-only. Defaults to 'false'. This parameter is only valid for device-type1 which represents Alletra 6K 
    and Nimble Storage.
.PARAMETER reserve
    Amount of space to reserve for this volume as a percentage of volume size. Percentage as integer from 0 to 100. 
    Defaults to the default volume reservation set on the group, typically 0. This parameter is only valid for 
    device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER snap_reserve
    Amount of space to reserve for snapshots of this volume as a percentage of volume size. Defaults to the default snapshot 
    reserve set on the group, typically 0. This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER snap_warn_level
    Threshold for available space as a percentage of volume size below which an alert is raised. Defaults to the default 
    snapshot warning level set on the group, typically 0. This parameter is only valid for device-type1 which represents 
    Alletra 6K and Nimble Storage.
.PARAMETER warn_level
    Threshold for available space as a percentage of volume size below which an alert is raised. If this option is not specified, 
    array default volume warn level setting is used to decide the warning level for this volume. Percentage as integer from 0 to 100. 
    Defaults to the default volume warning level set on the group, typically 80.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
#>   
[CmdletBinding()]
param(  [Parameter(Mandatory=$true, ParameterSetName='DeviceType1' )]
        [Parameter(Mandatory=$true, ParameterSetName='DeviceType2' )]       [string]    $SystemId, 
        [Parameter(Mandatory=$true, ParameterSetName='DeviceType1' )]
        [Parameter(Mandatory=$true, ParameterSetName='DeviceType2' )]       [string]    $name,
 
        [Parameter(Mandatory=$true, ParameterSetName='DeviceType1' )]       [string]    $sizeMiB,
        [Parameter(Mandatory=$true, ParameterSetName='DeviceType1' )]       [string]    $userCpg,
        [Parameter(ParameterSetName='DeviceType1' )]                        [string]    $comments,
        [Parameter(ParameterSetName='DeviceType1' )]                        [int]       $count,
        [Parameter(ParameterSetName='DeviceType1' )]                        [boolean]   $dataReduction,
        [Parameter(ParameterSetName='DeviceType1' )]                        [string]    $snapCpg,
        [Parameter(ParameterSetName='DeviceType1' )]                        [string]    $snapshotAllocWarning,
        [Parameter(ParameterSetName='DeviceType1' )]                        [string]    $userAllocWarning,
       
        [Parameter(Mandatory=$true, ParameterSetName='DeviceType2' )]       [string]    $size,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $pool_id,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateSet('none','smis','vvol','openstack','openstackv2')]   [string]    $agent_type,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $app_uid,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $base_snap_id,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateSet(4096,8192,16384,32768,65536)]                      [int]       $block_size,
        [Parameter(ParameterSetName='DeviceType2' )]                        [switch]    $cache_pinned,
        [Parameter(ParameterSetName='DeviceType2' )]                        [switch]    $clone,
        [Parameter(ParameterSetName='DeviceType2' )]                        [switch]    $dedupe_enabled,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $description,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $dest_pool_id,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateSet('none','aes_256_xts')]                             [string]    $encryption_cipher,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $folder_id,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateRange(0,100)]                                          [int]       $limit,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateRange(256,4294967294)]                                 [int]       $limit_iops,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateRange(256,4294967294)]                                 [int]       $limit_mbps,
        [Parameter(ParameterSetName='DeviceType2' )]                        [switch]    $multi_initiator,
        [Parameter(ParameterSetName='DeviceType2' )]                        [switch]    $online,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $owned_by_group_id,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $perfpolicy_id,
        [Parameter(ParameterSetName='DeviceType2' )]                        [switch]    $read_only,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateRange(0,100)]                                          [int]       $reserve,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateRange(0,100)]                                          [int]       $snap_reserve,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateRange(0,100)]                                          [int]       $snap_warn_level,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateRange(0,100)]                                          [int]       $warn_level,

                                                                            [switch]    $WhatIf
     )

process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        write-verbose "Dectected the DeviceType is $DeviceType"
        $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/volumes'
        $MyBody = @{    'name' =    $name 
                   }
        switch ( $ParameterSet )
          { 'device-type1'   {  if ( $sizeMiB   )           {   $MyBody = $MyBody + @{ 'SizeMiB'              = $sizeMiB }              }  
                                if ( $userCpg   )           {   $MyBody = $MyBody + @{ 'userCpg'              = $userCpg }              }
                                if ( $comments   )          {   $MyBody = $MyBody + @{ 'comments'             = $comments }             }
                                if ( $count     )           {   $MyBody = $MyBody + @{ 'count'                = $count }                }
                                if ( $dataReduction)        {   $MyBody = $MyBody + @{ 'dataReduction'        = $True }                 }
                                if ( $snapCpg   )           {   $MyBody = $MyBody + @{ 'snapCpg'              = $snapCpg }              }
                                if ( $snapshotAllocWarning) {   $MyBody = $MyBody + @{ 'snapshotAllocWarning' = $snapshotAllocWarning } }
                                if ( $dataReduction)        {   $MyBody = $MyBody + @{ 'userAllocWarning'     = $userAllocWarning }     }
                                if ( $snapCpg   )           {   $MyBody = $MyBody + @{ 'snapCpg'              = $snapCpg }              }
                            }
            'device-type2'   {   if ( $size   )              {   $MyBody = $MyBody + @{ 'size'                 = $size }                 }
                                if ( $pool_id   )           {   $MyBody = $MyBody + @{ 'pool_id'              = $pool_id }              }
                                if ( $agent_type   )        {   $MyBody = $MyBody + @{ 'agent_type'           = $agent_type }           }
                                if ( $app_uiid   )          {   $MyBody = $MyBody + @{ 'app_uiid'             = $app_uiid }             }
                                if ( $base_snap_id   )      {   $MyBody = $MyBody + @{ 'base_snap_id'         = $base_snap_id }         }
                                if ( $block_size   )        {   $MyBody = $MyBody + @{ 'block_size'           = $block_size }           }
                                if ( $cache_pinned   )      {   $MyBody = $MyBody + @{ 'cache_pinned'         = $cache_pinned }         }
                                if ( $clone   )             {   $MyBody = $MyBody + @{ 'clone'                = $clone }                }
                                if ( $dedupe_enabled   )    {   $MyBody = $MyBody + @{ 'dedupe_enabled'       = $dedupe_enabled }       }
                                if ( $description   )       {   $MyBody = $MyBody + @{ 'description'          = $description }          }
                                if ( $dest_pool_id   )      {   $MyBody = $MyBody + @{ 'dest_pool_id'         = $dest_pool_id }         }
                                if ( $encryption_cipher )   {   $MyBody = $MyBody + @{ 'encryption_cipher'    = $encryption_cipher }    }
                                if ( $folder_id   )         {   $MyBody = $MyBody + @{ 'folder_id'            = $folder_id }            }
                                if ( $limit   )             {   $MyBody = $MyBody + @{ 'limit'                = $limit }                }
                                if ( $limit_iops   )        {   $MyBody = $MyBody + @{ 'limit_iops'           = $limit_iops }           }
                                if ( $multi_initiator   )   {   $MyBody = $MyBody + @{ 'multi_initiator'      = $multi_initiator }      }
                                if ( $online   )            {   $MyBody = $MyBody + @{ 'online'               = $online }               }
                                if ( $owned_by_group_id   ) {   $MyBody = $MyBody + @{ 'owned_by_group_id'    = $owned_by_group_id }    }
                                if ( $perfpolicy_id   )     {   $MyBody = $MyBody + @{ 'perfpolicy_id'        = $perfpolicy_id }        }
                                if ( $read_only   )         {   $MyBody = $MyBody + @{ 'read_only'            = $read_only }            }
                                if ( $reserve   )           {   $MyBody = $MyBody + @{ 'reserve'              = $reserve }              }
                                if ( $snap_reserve   )      {   $MyBody = $MyBody + @{ 'snap_reserve'         = $snap_reserve }         }
                                if ( $snap_warn_level   )   {   $MyBody = $MyBody + @{ 'snap_warn_level'      = $snap_warn_level }      }
                                if ( $warn_level   )        {   $MyBody = $MyBody + @{ 'warn_level'           = $warn_level }           }
                            }
          }
        $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + '/volumes'
        if ( $WhatIf )
                {   $ReturnData = invoke-restmethodWhatIf -uri $MyURI -headers $MyHeaders -method POST -ContentType 'application/json' -body $MyBody 
                }   
            else 
                {   $ReturnData = invoke-restmethod -uri $MyURI -headers $MyHeaders -method POST -ContentType 'application/json' -body $MyBody 
                }
        return $ReturnData
    }       
} 

function Set-DSCCVolume
{
<#
.SYNOPSIS
    Modifies a Volume on the specified Storage System.    
.DESCRIPTION
    Modifies a Volume on the Specified Storage System with the supplied parameters. Depending on the target storage system, the command will 
    accept either 1 of 2 sets of parameters; device-type1 or device-type2. 
.PARAMETER StorageSystemId
    A single Storage System ID is specified and required. This is required for both parameter sets
.PARAMETER VolumeId
    A single Volume ID is specified and required. This is required for both parameter sets
.PARAMETER name
    A single name is specified and required, and is required for both parameter sets.
.PARAMETER sizeMiB
Volume size in megabytes. Size is required for creating a volume but not for cloning an existing volume.When creating a 
    new volume, size is required. When cloning an existing volume, size defaults to that of the parent volume. 
    This parameter is only valid for device-type2 which represents Alletra 9K and Primera or 3PAR targets.
.PARAMETER userCpg
    User CPG. This parameter is only valid for device-type2 which represents Alletra 9K and Primera or 3PAR targets.
.PARAMETER comments
    The detailed description of the volume.This parameter is only valid for device-type2 which represents 
    Alletra 9K and Primera or 3PAR targets.
.PARAMETER count
    How many Volumes to create using the given parameters. This parameter is only valid for device-type2 which 
    represents Alletra 9K and Primera or 3PAR targets.
.PARAMETER dataReduction
    If data reduction technologies such as compression or deduplication should be turned on. This parameter is only valid 
    for device-type2 which represents Alletra 9K and Primera or 3PAR targets.
.PARAMETER snapCpg
    The CPG that will be used to store the snapshot data
.PARAMETER snapshotAllocWarning
    Snapshot Alloc Warning
.PARAMETER userAllocWarning
    User Alloc Warning
.PARAMETER size
    Volume size in megabytes. Size is required for creating a volume but not for cloning an existing volume.When creating a 
    new volume, size is required. When cloning an existing volume, size defaults to that of the parent volume.
.PARAMETER pool_id
    Identifier associated with the pool in the storage pool table. A 42 digit hexadecimal int64. Defaults to the ID of the 'default' pool.
.PARAMETER agent_type
    External management agent type. Defaults to 'none'. Possible values: 'none', 'smis', 'vvol', 'openstack', 'openstackv2'.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER app_uuid
    Application identifier of volume. String of up to 255 alphanumeric characters, hyphen, colon, dot and underscore are allowed. 
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER base_snap_id
    Base snapshot ID. This attribute is required together with name and clone when cloning a volume with the create operation. A 42 
    digit hexadecimal int64. Defaults to the empty string. This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER block_size
    Size in bytes of blocks in the volume. Defaults to 4096, but may also be set to 8192, 16388, 32786, and 65536, representing 4K, 8K, 16K, 32K, or 64K.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER cache_pinned
	If set to true, all the contents of this volume are kept in flash cache. This provides for consistent performance guarantees for all types of workloads. 
    The amount of flash needed to pin the volume is equal to the limit for the volume. Defaults to 'false'. 
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER clone
    Whether this volume is a clone. Use this attribute in combination with name and base_snap_id to create a clone by setting clone = true. Defaults to 'false'.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER dedepe_enabled
    Indicate whether dedupe is enabled. Defaults to 'false'. This parameter is only valid for device-type1 which 
    represents Alletra 6K and Nimble Storage. This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER description
    Text description of volume. String of up to 255 printable ASCII characters. Defaults to the empty string. 
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER dest_pool_id
    ID of the destination pool where the volume is moving to. A 42 digit hexadecimal int64. Defaults to the empty string.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER encryption_cipher
    The encryption cipher of the volume. Defaults to 'none'. Possible values: 'none', 'aes_256_xts'.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER folder_id
    ID of the folder holding this volume. An optional NsObjectID. A 42 digit hexadecimal int64 or the empty string. 
    Defaults to the empty string. This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER limit
    Limit for the volume as a percentage of volume size. Percentage as integer from 0 to 100. Defaults to the default 
    volume limit set on group, typically 100. This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER limit_iops
    IOPS limit for this volume. If limit_iops is not specified when a volume is created, or if limit_iops is set to -1, 
    then the volume has no IOPS limit. If limit_iops is not specified while creating a clone, IOPS limit of parent volume 
    will be used as limit. IOPS limit should be in range [256, 4294967294] or -1 for unlimited. If both limit_iops and 
    limit_mbps are specified, limit_mbps must not be hit before limit_iops. In other words, IOPS and MBPS limits should honor 
    limit_iops _ampersand_amp;lt;= ((limit_mbps MB/s * 2^20 B/MB) / block_size B). By default the volume is created with unlimited iops.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER multi_initiator
    This indicates whether volume and its snapshots are multi-initiator accessible. This attribute applies only to volumes and 
    snapshots available to iSCSI initiators. Defaults to 'false'. This parameter is only valid for device-type1 which represents 
    Alletra 6K and Nimble Storage.
.PARAMETer online
    Online state of volume, available for host initiators to establish connections. Defaults to 'true'.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER owned_by_group_id
    ID of group that currently owns the volume. A 42 digit hexadecimal int64. Defaults to the ID of the group that created the volume.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER perfpolicy_id
    Identifier of the performance policy. After creating a volume, performance policy for the volume can only be changed to another 
    performance policy with same block size. A 42 digit hexadecimal int64. Defaults to ID of the 'default' performance policy.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER read_only
    Volume is read-only. Defaults to 'false'. This parameter is only valid for device-type1 which represents Alletra 6K 
    and Nimble Storage.
.PARAMETER reserve
    Amount of space to reserve for this volume as a percentage of volume size. Percentage as integer from 0 to 100. 
    Defaults to the default volume reservation set on the group, typically 0. This parameter is only valid for 
    device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER snap_reserve
    Amount of space to reserve for snapshots of this volume as a percentage of volume size. Defaults to the default snapshot 
    reserve set on the group, typically 0. This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER snap_warn_level
    Threshold for available space as a percentage of volume size below which an alert is raised. Defaults to the default 
    snapshot warning level set on the group, typically 0. This parameter is only valid for device-type1 which represents 
    Alletra 6K and Nimble Storage.
.PARAMETER warn_level
    Threshold for available space as a percentage of volume size below which an alert is raised. If this option is not specified, 
    array default volume warn level setting is used to decide the warning level for this volume. Percentage as integer from 0 to 100. 
    Defaults to the default volume warning level set on the group, typically 80.
    This parameter is only valid for device-type1 which represents Alletra 6K and Nimble Storage.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
#>   
[CmdletBinding()]
param(  [Parameter(Mandatory=$true, ParameterSetName='DeviceType1' )]
        [Parameter(Mandatory=$true, ParameterSetName='DeviceType2' )]       [string]    $SystemId, 
        [Parameter(Mandatory=$true, ParameterSetName='DeviceType1' )]
        [Parameter(Mandatory=$true, ParameterSetName='DeviceType2' )]       [string]    $name,
 
        [Parameter(Mandatory=$true, ParameterSetName='DeviceType2' )]       [string]    $sizeMiB,
        [Parameter(Mandatory=$true, ParameterSetName='DeviceType1' )]       [string]    $userCpg,
        [Parameter(ParameterSetName='DeviceType1' )]                        [string]    $comments,
        [Parameter(ParameterSetName='DeviceType1' )]                        [int]       $count,
        [Parameter(ParameterSetName='DeviceType1' )]                        [boolean]   $dataReduction,
        [Parameter(ParameterSetName='DeviceType1' )]                        [string]    $snapCpg,
        [Parameter(ParameterSetName='DeviceType1' )]                        [string]    $snapshotAllocWarning,
        [Parameter(ParameterSetName='DeviceType1' )]                        [string]    $userAllocWarning,
       
        [Parameter(Mandatory=$true, ParameterSetName='DeviceType2' )]       [string]    $size,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $pool_id,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateSet('none','smis','vvol','openstack','openstackv2')]   [string]    $agent_type,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $app_uid,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $base_snap_id,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateSet(4096,8192,16384,32768,65536)]                      [int]       $block_size,
        [Parameter(ParameterSetName='DeviceType2' )]                        [switch]    $cache_pinned,
        [Parameter(ParameterSetName='DeviceType2' )]                        [switch]    $clone,
        [Parameter(ParameterSetName='DeviceType2' )]                        [switch]    $dedupe_enabled,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $description,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $dest_pool_id,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateSet('none','aes_256_xts')]                             [string]    $encryption_cipher,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $folder_id,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateRange(0,100)]                                          [int]       $limit,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateRange(256,4294967294)]                                 [int]       $limit_iops,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateRange(256,4294967294)]                                 [int]       $limit_mbps,
        [Parameter(ParameterSetName='DeviceType2' )]                        [switch]    $multi_initiator,
        [Parameter(ParameterSetName='DeviceType2' )]                        [switch]    $online,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $owned_by_group_id,
        [Parameter(ParameterSetName='DeviceType2' )]                        [string]    $perfpolicy_id,
        [Parameter(ParameterSetName='DeviceType2' )]                        [switch]    $read_only,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateRange(0,100)]                                          [int]       $reserve,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateRange(0,100)]                                          [int]       $snap_reserve,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateRange(0,100)]                                          [int]       $snap_warn_level,
        [Parameter(ParameterSetName='DeviceType2' )]
            [ValidateRange(0,100)]                                          [int]       $warn_level,

        [Parameter(Mandatory=$true, ParameterSetName='DeviceType1' )]       [switch]    $WhatIf
     )

process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        write-verbose "Dectected the DeviceType is $DeviceType"
        $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/volumes/' + $VolumeId
        $MyBody = @{    'name' =    $name 
                   }
        switch ( $ParameterSet )
          { 'DeviceType1'   {   if ( $sizeMiB   )           {   $MyBody = $MyBody + @{ 'SizeMiB'              = $sizeMiB }              }  
                                if ( $userCpg   )           {   $MyBody = $MyBody + @{ 'userCpg'              = $userCpg }              }
                                if ( $comments   )          {   $MyBody = $MyBody + @{ 'comments'             = $comments }             }
                                if ( $count     )           {   $MyBody = $MyBody + @{ 'count'                = $count }                }
                                if ( $dataReduction)        {   $MyBody = $MyBody + @{ 'dataReduction'        = $True }                 }
                                if ( $snapCpg   )           {   $MyBody = $MyBody + @{ 'snapCpg'              = $snapCpg }              }
                                if ( $snapshotAllocWarning) {   $MyBody = $MyBody + @{ 'snapshotAllocWarning' = $snapshotAllocWarning } }
                                if ( $dataReduction)        {   $MyBody = $MyBody + @{ 'userAllocWarning'     = $userAllocWarning }     }
                                if ( $snapCpg   )           {   $MyBody = $MyBody + @{ 'snapCpg'              = $snapCpg }              }
                            }
            'DeviceType2'   {   if ( $size   )              {   $MyBody = $MyBody + @{ 'size'                 = $size }                 }
                                if ( $pool_id   )           {   $MyBody = $MyBody + @{ 'pool_id'              = $pool_id }              }
                                if ( $agent_type   )        {   $MyBody = $MyBody + @{ 'agent_type'           = $agent_type }           }
                                if ( $app_uiid   )          {   $MyBody = $MyBody + @{ 'app_uiid'             = $app_uiid }             }
                                if ( $base_snap_id   )      {   $MyBody = $MyBody + @{ 'base_snap_id'         = $base_snap_id }         }
                                if ( $block_size   )        {   $MyBody = $MyBody + @{ 'block_size'           = $block_size }           }
                                if ( $cache_pinned   )      {   $MyBody = $MyBody + @{ 'cache_pinned'         = $cache_pinned }         }
                                if ( $clone   )             {   $MyBody = $MyBody + @{ 'clone'                = $clone }                }
                                if ( $dedupe_enabled   )    {   $MyBody = $MyBody + @{ 'dedupe_enabled'       = $dedupe_enabled }       }
                                if ( $description   )       {   $MyBody = $MyBody + @{ 'description'          = $description }          }
                                if ( $dest_pool_id   )      {   $MyBody = $MyBody + @{ 'dest_pool_id'         = $dest_pool_id }         }
                                if ( $encryption_cipher )   {   $MyBody = $MyBody + @{ 'encryption_cipher'    = $encryption_cipher }    }
                                if ( $folder_id   )         {   $MyBody = $MyBody + @{ 'folder_id'            = $folder_id }            }
                                if ( $limit   )             {   $MyBody = $MyBody + @{ 'limit'                = $limit }                }
                                if ( $limit_iops   )        {   $MyBody = $MyBody + @{ 'limit_iops'           = $limit_iops }           }
                                if ( $multi_initiator   )   {   $MyBody = $MyBody + @{ 'multi_initiator'      = $multi_initiator }      }
                                if ( $online   )            {   $MyBody = $MyBody + @{ 'online'               = $online }               }
                                if ( $owned_by_group_id   ) {   $MyBody = $MyBody + @{ 'owned_by_group_id'    = $owned_by_group_id }    }
                                if ( $perfpolicy_id   )     {   $MyBody = $MyBody + @{ 'perfpolicy_id'        = $perfpolicy_id }        }
                                if ( $read_only   )         {   $MyBody = $MyBody + @{ 'read_only'            = $read_only }            }
                                if ( $reserve   )           {   $MyBody = $MyBody + @{ 'reserve'              = $reserve }              }
                                if ( $snap_reserve   )      {   $MyBody = $MyBody + @{ 'snap_reserve'         = $snap_reserve }         }
                                if ( $snap_warn_level   )   {   $MyBody = $MyBody + @{ 'snap_warn_level'      = $snap_warn_level }      }
                                if ( $warn_level   )        {   $MyBody = $MyBody + @{ 'warn_level'           = $warn_level }           }
                            }
          }
        $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + '/volumes'
        if ( $WhatIf )
                {   $ReturnData = invoke-restmethodWhatIf -uri $MyURI -headers $MyHeaders -method PUT -ContentType 'application/json' -body $MyBody 
                }   
            else 
                {   $ReturnData = invoke-restmethod -uri $MyURI -headers $MyHeaders -method PUT -ContentType 'application/json' -body $MyBody 
                }
        return $ReturnData
    }       
} 

Function Get-DSCCVolumePerf
{
<#
.SYNOPSIS
    Retrieves the HPE DSSC DOM Storage Volume performance statistics for a specific storage system volume    
.DESCRIPTION
    Returns the HPE DSSC DOM Storage Volume performance statistics for a specific storage system volume 
.PARAMETER StorageSystemID
    A single Storage System ID is specified and required, the pools defined will be returned unless a specific PoolID is requested.
.PARAMETER VolumeID
    A single Storage System Volume ID is specified and required, and all volumes in that system will be returned if a single volume is not specified.
.PARAMETER PerformanceType
    This is mandatory and can either be 'statistics' or it can be 'history'.
.PARAMETER Metric
    The performance metric to gather, can be either 'iops', 'latency', or 'throughput'.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
#>   
[CmdletBinding()]
param(  [Parameter(Mandatory=$true, ValueFromPipeLineByPropertyName=$true )][Alias('id')]   [string]    $SystemId, 
        [Parameter(Mandatory=$true )]                                                       [string]    $VolumeId,
        [Parameter(Mandatory=$true )][validateSet('statistics','history')]                  [String]    $PerformanceType,
        [Parameter(Mandatory=$true )][validateSet('iops','latency','throughput')]           [String]    $Metric,
                                                                                            [switch]    $WhatIf
     )
process
    {       Invoke-DSCCAutoReconnect
            $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
            write-verbose "Dectected the DeviceType is $DeviceType"
            $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + '/volumes/' + $VolumeId + '/performance-' + $PerformanceType 
            if ( $WhatIf )
                    {   $SysColOnly = invoke-restmethodWhatIf -uri $MyURI -headers $MyHeaders -method Get
                    }   
                else 
                    {   $SysColOnly = invoke-restmethod -uri $MyURI -headers $MyHeaders -method Get
                    }
            if ( ($SysColOnly).items ) 
                    {   $SysColOnly = ($SysColOnly).items 
                    }
            if ( ($SysColOnly).Total -eq 0 )
                    {   Write-Warning "No Items Detected on system with ID $SystemId."
                        return
                    }
            switch ( $Metric )
            {   'iops'          {   if ( ($SysColOnly).iops  )             { $ReturnData = ($SysColOnly).iops }             else { $ReturnData = ($SysColOnly).iops_metrics_data } }
                'latency'       {   if ( ($SysColOnly).latencyMs )         { $ReturnData = ($SysColOnly).latencyMs }        else { $ReturnData = ($SysColOnly).latency_metrics_data } }
                'throughtput'   {   if ( ($SysColOnly).throughtputKbps  )  { $ReturnData = ($SysColOnly).throughtputKbps }  else { $ReturnData = ($SysColOnly).throughout_metrics_data }}
            }
            if ( ($ReturnData).series_data )
                    {   $ReturnData = ($ReturnData).series_data
                    }
            $ReturnData = Invoke-RepackageObjectWithType -RawObject $ReturnData -ObjectName "VolumePerf.Combined"        
            return $ReturnData
    }       
}