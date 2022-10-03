function Get-DSCCPool
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Storage Systems Pools for a specific storage system and pool    
.DESCRIPTION
    Returns the HPE DSSC DOM Storage Systems Pools for a specific storage system and pool 
.PARAMETER StorageSystemID
    A single Storage System ID is specified and required, the pools defined will be returned unless a specific PoolID is requested.
.PARAMETER PoolID
    If a single Storage System Pool ID is specified, only that pools will be returned.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-DSCCStorageSystem -DeviceType device-type1 | Get-DSCCStoragePool

    System Id  Pool Id                          Name   Full Name  Free Space (MiB) RAID Type
    ---------  -------                          ----   ---------  ---------------- ---------
    2M2042059T e63f7f5ae9eeb141f7fff96814a53f7c SSD_r6 CPG SSD_r6 7434240          RAID_SIX
    2M2042059V 186ec5f389a8595971e64e3e9217061a SSD_r6 CPG SSD_r6 7434240          RAID_SIX
    2M202205GF f66539d66172bbd57625b0ba1b89c479 SSD_r6 CPG SSD_r6 7237632          RAID_SIX
    2M2042059X c73181b692546590743db4de992458e9 SSD_r6 CPG SSD_r6 7434240          RAID_SIX
    2M202205GG 3ff8fa3d971f16948fd9cff800775b9d SSD_r6 CPG SSD_r6 7434240          RAID_SIX
    2M2019018G 172810533da636adb16697058ac1b94f SSD_r6 CPG SSD_r6 7434240          RAID_SIX
.EXAMPLE
    PS:> Get-DSCCStoragePool -SystemId 2M2042059T

    System Id  Pool Id                          Name   Full Name  Free Space (MiB) RAID Type
    ---------  -------                          ----   ---------  ---------------- ---------
    2M2042059T e63f7f5ae9eeb141f7fff96814a53f7c SSD_r6 CPG SSD_r6 7434240          RAID_SIX
.EXAMPLE
    PS:> Get-DSCCStorageSystem -DeviceType device-type2 | Get-DSCCStoragePool

    System Id                                  Pool Id                                    Name    Full Name    Free Space (MiB) RAID Type
    ---------                                  -------                                    ----    ---------    ---------------- ---------
    0906b878a5a008ec63000000000000000000000001 0a06b878a5a008ec63000000000000000000000001 default Default pool 7985331164160    RAID-TripleParity
    090849204632ec0d70000000000000000000000001 0a0849204632ec0d70000000000000000000000001 default Default pool 33682373222400   RAID-TripleParity
    093be9f65d5b1de4fd000000000000000000000001 0a3be9f65d5b1de4fd000000000000000000000001 default Default pool 32499810201600   RAID-TripleParity
.EXAMPLE
    PS:> Get-DSCCStoragePool -StorageSystemId 2M202205GG -StoragePoolId 3ff8fa3d971f16948fd9cff800775b9d | format-list

    allocationSettings   : @{HA=; RAIDType=RAID_SIX; chunkletPosPref=; deviceSpeed=; deviceType=DEVICE_TYPE_SSD;
                           diskFilter=; requestedHA=; setSize=6 data, 2 parity; stepSize=-1}
    aoConfigId           : 0
    dedupCapable         : True
    storagePoolId        : 0
    name                 : SSD_r6
    state                : @{detailed=; overall=STATE_NORMAL}
    displayname          : CPG SSD_r6
    domain               : -
    freeForAllocationMiB : 7434240
    freeSizeMiB          : 0
    snapSpaceAdmin       : @{ldCount=0; totalMiB=0; totalRawMiB=0; usedMiB=0; usedRawMiB=0}
    snapSpaceData        : @{ldCount=0; totalMiB=0; totalRawMiB=0; usedMiB=0; usedRawMiB=0}
    systemId             : 2M202205GG
    totalReservedMiB     : 0
    id                   : 3ff8fa3d971f16948fd9cff800775b9d
    userSpace            : @{ldCount=0; totalMiB=0; totalRawMiB=0; usedMiB=0; usedRawMiB=0}
    saGrow               : @{warnMiB=0; limitMiB=0; sizeMiB=8192; args=-p -devtype SSD -p -devtype SSD}
    sdGrow               : @{warnMiB=0; limitMiB=0; sizeMiB=8192; args=-ssz 8 -ha mag -t r6 -p -devtype SSD}
    alert                : @{warnPercent=0; warn=--; limit=--; fail=--}
    dedupVersion         :
    baseSizeMiB          : 0
    totalSizeMiB         : 0
    resourceUri          : /api/v1/storage-systems/device-type1/2M202205GG/storage-pools/3ff8fa3d971f16948fd9cff800775b9d
    customerId           : 0056b71eefc411eba26862adb877c2d8
    type                 : storage-pool
    generation           : 1636042130750
    associatedLinks      : {@{type=storage-systems; resourceUri=/api/v1/storage-systems/device-type1/2M202205GG},
                           @{type=volumes; resourceUri=/api/v1/storage-systems/device-type1/2M202205GG/storage-pools/3ff
                           8fa3d971f16948fd9cff800775b9d/volumes}}
.EXAMPLE
    PS:> Get-DSCCStoragePool -StorageSystemId 2M202205GG -StoragePoolId 3ff8fa3d971f16948fd9cff800775b9d -DeviceType device-type1 -whatif
    
    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/storage-systems/device-type1/2M202205GG/storage-pools
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IlhwRUVZUGlZWDVkV1JTeDR4SmpNcEVPc1hTSSIsInBpLmF0bSI6ImRlejAifQ.eyJjbGllbnRfaWQiOiIzZjIwODU4NS0zZGE2LTRiZjctOTRjYS00ZjMxMGQwOTYzYjUiLCJpc3MiOiJodHRwczovL3Nzby5jb21tb24uY2xvdWQuaHBlLmNvbSIsImF1ZCI6ImV4dGVybmFsX2FwaSIsInN1YiI6ImNocmlzLmxpb25ldHRpQGhwZS5jb20iLCJ1c2VyX2N0eCI6IjAwNTZiNzFlZWZjNDExZWJhMjY4NjJhZGI4NzdjMmQ4IiwiYXV0aF9zb3VyY2UiOiJjY3NfdG9rZW5fbWFuYWdlbWVudCIsInBsYXRmb3JtX2N1c3RvbWVyX2lkIjoiOGZmYzRiN2VlOWQyMTFlYjhjZWU2ZTEzYzA3MWVhMzciLCJpYXQiOjE2MzYwNjY4NzksImFwcGxpY2F0aW9uX2luc3RhbmNlX2lkIjoiM2MxOGJkMDMtODMwNi00YzdjLTk0MmUtYzcwNGE0Yjg3NDRjIiwiZXhwIjoxNjM2MDc0MDc5fQ.D38GnVgiQVgNl6TboQC8UOOq0CxlRPo6oEdiq7KnNAojZfrIZJ2bHkAqcqaua4aEB6Y5d2q-DCVf6DQjsKec2utfLHYv-cOEWzzx06dUk4B11fJaCsRWuLNT-NZjSqugUKpp22VBbFn5stUAs3_YXVIlR9x3UqYk9MGZW2QgQtqKjheD6msFiplgzx5g9RPqyViX24V0gNcIXVcRd36wb-Rr_wGP9X6ycy6fXhWtqkKc7c8aKcfwflKsgvcI7p4NIS2LGswuuTrTAspoNgAp-Io0ytsepnxZ6vEiJrxZHhLcL4zEBP-IV9ElsgS3ymMVfhT-uBZXdr1CfV9EHQ0Vgw"
        }
    The Body of this call will be:
        "No Body"
.LINK
#>   
[CmdletBinding()]
param(  [parameter(mandatory,ValueFromPipeLineByPropertyName=$true )][Alias('id')]                                              
                                                                            [string]    $SystemId, 
                                                                            [string]    $PoolId,
                                                                            [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        if ( $DeviceType )
            {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/storage-pools'
                $SysColOnly = Invoke-DSCCRestMethod -UriAdd $MyAdd -method Get -whatifBoolean $WhatIf
                $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Pool.combined"
                if ( $PoolId )
                        {   return ( $ReturnData | where-object { $_.id -eq $PoolId } )
                        } 
                    else 
                        {   return $ReturnData
                        }
            }
    }       
}   
function Get-DSCCPoolVolume
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Storage Systems Pools for a specific storage system and pool    
.DESCRIPTION
    Returns the HPE DSSC DOM Storage Systems Pools for a specific storage system and pool 
.PARAMETER StorageSystemID
    A single Storage System ID is specified and required, the pools defined will be returned unless a specific PoolID is requested.
.PARAMETER StoragePoolID
    A single Storage System Pool ID is specified and required, and all volumes in that pool will be returned if a single volume is not specified.
.PARAMETER StoragePoolID
    A single Storage System Pool ID is specified and required, and all volumes in that pool will be returned if a single volume is not specified.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-DSCCStoragePool -StorageSystemId 2M202205GG -StoragePoolId 3ff8fa3d971f16948fd9cff800775b9d

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
    PS:> Get-DSCCStoragePoolVolume -StorageSystemId 2M202205GG -StoragePoolId 3ff8fa3d971f16948fd9cff800775b9d | format-table

    id                               systemId   displayname              domain name      healthState usedCapacity volumeId 
    --                               --------   -----------              ------ ----      ----------- ------------ -----
    97183a044aecc5fed6f0fc3e36b042c7 2M2042059V Virtual Volume .mgmtdata -      .mgmtdata           3          100     2
    bd1ab3e2e9882c2d4aeb9e2126df65f5 2M2042059X Virtual Volume .mgmtdata -      .mgmtdata           3          100     2
    5a510bf1234afdcca6f8e98ce915b6ad 2M202205GG Virtual Volume .srdata   -      .srdata             3          100     1
    ee9f3c18a83aeef9ebfaabb8526b7386 2M2042059T Virtual Volume .srdata   -      .srdata             3          100     1
    6acfbbd149c521a16bfb9fc72360a8fd 2M202205GF Virtual Volume .srdata   -      .srdata             3          100     1
.EXAMPLE
    PS:> Get-DSCCStoragePoolVolume -StorageSystemId 2M202205GG -StoragePoolId 3ff8fa3d971f16948fd9cff800775b9d -VolumeId 97183a044aecc5fed6f0fc3e36b042c7 | format-table

    id                               systemId   displayname              domain name      healthState usedCapacity volumeId 
    --                               --------   -----------              ------ ----      ----------- ------------ -----
    97183a044aecc5fed6f0fc3e36b042c7 2M2042059V Virtual Volume .mgmtdata -      .mgmtdata           3          100     2
.LINK
#>   
[CmdletBinding()]
param(  [parameter(mandatory,ValueFromPipeLineByPropertyName=$true )][Alias('id')]  [string]    $SystemId, 
        [parameter(mandatory)]                                                      [string]    $PoolId,
                                                                                    [string]    $VolumeId,
                                                                                    [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        if ( $DeviceType -eq 'device-type2')
                {   Write-Warning "This command only operates against Device-Type1 Storage Devices."
                    return 
                }
            else 
                {   $MyAdd = 'storage-systems/' + $SystemId + '/storage-pools/' + $PoolId + '/volumes'
                    $SysColOnly = Invoke-DSCCRestMethod -UriAdd $MyAdd -method Get -WhatIfBoolean $WhatIf
                    if ($SysColOnly)
                        {   $SysColOnly = (($SysColOnly).volumes).items
                            $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "PoolVolume.$DeviceType"
                        }
                }
        if ( $VolumeId )
                {   Write-host "The results of the complete collection have been limited to just the supplied ID"
                    return ( $ReturnData | where-object { $_.id -eq $VolumeId } )
                } 
            else 
                {   return $ReturnData
                }
    }       
}   