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
        $MyAdd = 'storage-systems/' + $DeviceType + '/' + $systemId + '/volumes/' + $Id + '/snapshots'
        $SysColOnly = Invoke-DSCCRestMethod -UriAdd $MyAdd -method Get -WhatIfBoolean $WhatIf
        $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Snapshot.$DeviceType"
        if ( $VolumeId )
                {   return ( $ReturnData | where-object { $_.id -eq $VolumeId } )
                } 
            else 
                {   return $ReturnData
                }
    }       
} 
function Remove-DSCCSnapshot{
<#
.SYNOPSIS
    Removes the HPE DSSC DOM Storage Systems Snapshots for a specific storage system and volume    
.DESCRIPTION
    Removes the HPE DSSC DOM Storage Systems Snapshots for a specific storage system and volume 
.PARAMETER systemID
    A single Storage System ID is specified and required, the pools defined will be returned unless a specific PoolID is requested.
.PARAMETER volumeId
    A single volume ID is specified and required.
.PARAMETER snapshotId
    A single snapshot ID is specified and required.
.PARAMETER force
    implemented as a switch, if triggered will cause the array to allow the deletion of a snapshot regardless of certain blocking factors
    such as the snapshot being online.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
#>   
[CmdletBinding()]
param(  [Parameter(ValueFromPipeLineByPropertyName=$true,mandatory=$true )][Alias('owned_by_group_id')]     [string]    $systemId, 
        [Parameter(ValueFromPipeLineByPropertyName=$true,mandatory=$true )][Alias('volumeId')]              [string]    $Id,
        [Parameter(mandatory=$true)]                                                                        [string]    $snapshotId,
                                                                                                            [switch]    $force,
                                                                                                            [switch]    $WhatIf
     )
process
    {       Invoke-DSCCAutoReconnect
            $systemId = $( $systemId + $owned_by_group_id )
            $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $systemId )
            $MyAdd = 'storage-systems/' + $DeviceType + '/' + $systemId + '/volumes/' + $Id + '/snapshots/' + $snapshotId 
            if ( $force )   
                {   $MyAdd = $MyAdd + '?force=true' 
                }
            return Invoke-DSCCRestMethod -UriAdd $MyAdd -method DELETE -WhatIfBoolean $WhatIf
    }       
} 
    
function New-DSCCSnapshot{
<#
.SYNOPSIS
    Creates a DSSC DOM Storage Systems Snapshots for a specific storage system and volume    
.DESCRIPTION
    Creates a DSSC DOM Storage Systems Snapshots for a specific storage system and volume 
.PARAMETER systemID
    A single Storage System ID is specified and required, the pools defined will be returned unless a specific PoolID is requested.
.PARAMETER Id
    A single volume ID is specified and required.
.PARAMETER name
    This field is required for Systems that are of Device-Type2 (Nimble Storage or Alletra 6k, and is the name of the parameter
.PARAMETER description
    This field is is also known as the snapshot 'comment' and is used to describe the contents of the snapshot, or a comment on the 
    process or cause or source of the snapshot. Any string can be used. 
.PARAMETER writable
    This is a boolean value and processed as a switch, this controls if the snapshot will be marked as a read-only snapshot, or if 
    that snapshot is writable. This value can be set for either a device-type1 or device-typ2 type devices.
.PARAMETER online
    This is a boolean value is implemented as a switch; and is only valid for Device-type2 devices (Nimble Storage or Alletra 6K). 
    This value should be set to true to allow the snapshot to be mounted and used by various backup software packages and is required
    when using VSS controlled backups.
.PARAMETER expireSecs
    The number of seconds that a snapshot will remain until it is valid for use. i.e. How long until the snapshot expires.
.PARAMETER retainSecs
    The number of seconds that a snapshot will remain until it is valid for use. i.e. How long until the snapshot expires.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
#>   
[CmdletBinding()]
param(      [Parameter(ValueFromPipeLineByPropertyName=$true,mandatory=$true,ParameterSetName='devicetype1','device-type2')]
            [Alias('owned_by_group_id')]                                                                                    [string]    $systemId, 
            [Parameter(ValueFromPipeLineByPropertyName=$true,mandatory=$true,ParameterSetName='devicetype1')]
            [Parameter(ValueFromPipeLineByPropertyName=$true,mandatory=$true,ParameterSetName='devicetype2')]
            [Alias('volumeId', 'applicationSetId')]                                                                         [string]    $Id,

            [Parameter(ParameterSetName='devicetype1','devicetype2')][Alias('customName')]                                  [string]    $name,
            [Parameter(ParameterSetName='devicetype1','devicetype2')][Alias('comment')]                                     [string]    $description,            
            [Parameter(ParameterSetName='devicetype1','devicetype2')][Alias('readonly')]                                    [switch]    $writable,
            [Parameter(ParameterSetName='devicetype1',mandatory=$true)]
            [ValidateSet('PARENT_TIMESTAMP','PARENT_SEC_SINCE_EPOCH','CUSTOM')]                                             [string]    $namePattern,
            [Parameter(ParameterSetName='devicetype1')]                                                                     [int]       $expireSecs,
            [Parameter(ParameterSetName='devicetype1')]                                                                     [int]       $retainSecs,
            [Parameter(ParameterSetName='devicetype2')]                                                                     [string]    $app_uuid,
            [Parameter(ParameterSetName='devicetype2')]                                                                     [switch]    $online,            
                                                                                                                            [switch]    $WhatIf
         )
process
    {       Invoke-DSCCAutoReconnect
            $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $systemId )
            $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $systemId + '/volumes/' + $Id + '/snapshots'
            switch ( $DeviceType )
                {   'device-type1'  {   if ( Get-DSCCVolume -systemId $systemId -volumeid $id )
                                                {   write-verbose "The ID given was for a valid Volume. Making a volume snapshot."
                                                } 
                                            elseif  ( Get-DSCCVolumeSet -systemId $systemId -volumeCollectionid $id )
                                                {   write-verbose "The ID given was for a valid Application Set, so an Application Set snapshot will be run."
                                                    $MyAdd = 'storage-systems/' + $DeviceType + '/' + $systemId + '/applicationsets/' + $Id + '/snapshots'
                                                }
                                            else
                                                {   write-warning "The ID presented for the VolumeId or Application Set ID did not return a valid item. Cannot create snaphot."
                                                    return
                                                }
                                                                    $MyBody =           @{ 'namePattern' = $namePattern } 
                                        if ( $description )     {   $MyBody = $MyBody + @{ 'comment'     = $description } }
                                        if ( $Name )            {   $MyBody = $MyBody + @{ 'customName'  = $name }        }
                                        if ( $expireSecs )      {   $MyBody = $MyBody + @{ 'expireSecs'  = $expireSecs }  }
                                        if ( $writeable )       {   $MyBody = $MyBody + @{ 'readOnly'    = $true }        }
                                            else                {   $MyBody = $MyBody + @{ 'readOnly'    = $false }       }
                                        if ( $retainSecs )      {   $MyBody = $MyBody + @{ 'retainSecs'  = $name }        }
                                    }
                    'device-type2'  {                               $MyBody + @{ 'name'  = $name } 
                                        if ( $app_uuid )        {   $MyBody = $MyBody + @{ 'app_uuid'    = $app_uuid }    }
                                        if ( $description )     {   $MyBody = $MyBody + @{ 'description' = $description } }
                                        if ( $online )          {   $MyBody = $MyBody + @{ 'online'      = $true }        }
                                            else                {   $MyBody = $MyBody + @{ 'online'      = $false }       }
                                        if ( $writeable )       {   $MyBody = $MyBody + @{ 'readOnly'    = $true }        }
                                            else                {   $MyBody = $MyBody + @{ 'readOnly'    = $false }       }
                                    }
                }
            return Invoke-DSCCRestMethod -UriAdd $MyAdd -method POST -body $MyBody -whatifBoolean $WhatIf
    }       
} 
