function Get-DSCCSnapshot{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Storage Systems Snapshots for a specific storage system and volume    
.DESCRIPTION
    Returns the HPE DSSC DOM Storage Systems Snapshots for a specific storage system and volume 
.PARAMETER systemID
    A single Storage System ID is specified and required, the pools defined will be returned unless a specific PoolID is requested.
.PARAMETER Id
    A single volume ID is specified and required.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-DSCCStorageSystem -DeviceType device-type2 | Get-DSCCVolume | Get-DSCCSnapShot

    WARNING: No Snapshots Detected on system ID 2M2042059X and Volume ID ecdaac9a8a84bb495bfa9404bdc282b2.

    id                               systemId   displayname          name  snapshotId sizeMiB readOnly
    --                               --------   -----------          ----  ---------- ------- --------
    b6205637d35333b54f69ea6db2b5400b 2M2042059T Virtual Volume snap2 snap2 1320       10240   False
    1c955df393c955c1e27987922b713d44 2M2042059T Virtual Volume snap1 snap1 1318       10240   True
.EXAMPLE
    PS:> Get-DSCCSnapshot -systemId 2M2042059T -id 139166f938bc3a5d984214951569f728 

    id                               systemId   displayname          name  snapshotId sizeMiB readOnly
    --                               --------   -----------          ----  ---------- ------- --------
    b6205637d35333b54f69ea6db2b5400b 2M2042059T Virtual Volume snap2 snap2 1320       10240   False
    1c955df393c955c1e27987922b713d44 2M2042059T Virtual Volume snap1 snap1 1318       10240   True
.EXAMPLE
    PS:> Get-DSCCStorageSystem -DeviceType device-type1 | Get-DSCCVolume | Get-DSCCSnapShot

    WARNING: No Snapshots Detected on system ID b6205637d35333b54f69ea6db2b5400b and Volume ID ecdaac9a8a84bb495bfa9404bdc282b2.

    id                               systemId                         displayname          name  snapshotId sizeMiB readOnly
    --                               --------                         -----------          ----  ---------- ------- --------
    b6205637d35333b54f69ea6db2b5400b 1c955df393c955c1e27987922b713d44 Virtual Volume snap3 snap2 1320       10240   False
    1c955df393c955c1e27987922b713d44 b6205637d35333b54f69ea6db2b5400b Virtual Volume snap4 snap1 1318       10240   True
.EXAMPLE
    PS:> Get-DSCCStorageSystem -DeviceType device-type1 | Get-DSCCVolume | Get-DSCCSnapShot -whatif

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/storage-systems/device-type1/2M202205GG/volumes/213434545567/snapshots
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
param(  [Parameter(ValueFromPipeLineByPropertyName=$true,mandatory=$true )][Alias('owned_by_group_id')]     [string]    $systemId, 
        [Parameter(ValueFromPipeLineByPropertyName=$true,mandatory=$true )][Alias('volumeId')]              [string]    $Id,
        [Parameter(                                                      )]                                 [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $systemId = $( $systemId + $owned_by_group_id )
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $systemId )
        write-verbose "Dectected the DeviceType is $DeviceType"
        $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $systemId + '/volumes/' + $Id + '/snapshots'
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyURI -headers $MyHeaders -method Get
                }   
            else 
                {   try     {   $SysColOnly = invoke-restmethod -uri $MyURI -headers $MyHeaders -method Get
                            }
                    catch   {   Write-Warning "No Snapshots Detected on system ID $SystemId and Volume ID $Id."
                                return
                            }
                }
        if ( ($SysColOnly).items ) 
                {   $SysColOnly = ($SysColOnly).items 
                    $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Snapshot.$DeviceType"
                }
            else 
                {   if ( ($SysColOnly).Total -eq 0 )
                            {   Write-Warning "No Snapshots Detected on system ID $SystemId and Volume ID $Id."
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