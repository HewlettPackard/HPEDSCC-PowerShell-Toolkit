function Get-DSCCFolder
{
<#
.SYNOPSIS
    Returns the HPE DSSC Device-Type2 Storage Systems Folders for a specific storage system     
.DESCRIPTION
    Returns the HPE DSSC Device-Type2 Storage Systems Folders for a specific storage system 
.PARAMETER StorageSystemID
    A single Storage System ID is specified and required, the Folders defined will be returned unless a specific FolderID is requested.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
#>   
[CmdletBinding()]
param(  [parameter(ValueFromPipeLineByPropertyName=$true )][Alias('id')]                                              
                                                                            [string]    $systemId,
                                                                            [switch]    $WhatIf
    )
process
    {   if ( -not $PSBoundParameters.ContainsKey('SystemId' ) )
                {   write-verbose "No SystemID Given, running all SystemIDs"
                    $ReturnCol=@()
                    foreach( $Sys in Get-DSCCStorageSystem )
                        {   write-verbose "Walking Through Multiple Systems"
                            If ( ($Sys).Id )
                                {   write-verbose "Found a system with a System.id"
                                    if ( $whatIf )  { $ReturnCol += ( Get-DSCCFolder -SystemId ($Sys).Id -WhatIf )  }
                                    else            { $ReturnCol += ( Get-DSCCFolder -SystemId ($Sys).Id )          }
                                }
                        }
                    write-verbose "Returning the Multiple System Id Certificates."
                    return $ReturnCol
                }
            else 
                {   Invoke-DSCCAutoReconnect
                    $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -systemId $systemId )
                    switch ( $DeviceType )
                        {   'device-type1'  {   write-warning "This command only works on Device-Type 2 devices." 
                                                return
                                            }
                            'device-type2'  {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $systemId + '/folders'
                                                $SysColOnly = invoke-DSCCrestmethod -uriadd $MyAdd -method Get -whatifBoolean $whatif
                                                $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Folder"
                                                return $ReturnData
                                            }
                        }       
                }
    }       
}   
function Remove-DSCC
{
<#
.SYNOPSIS
    Removes a Folder from a DSCC Device-Type2 Storage System.     
.DESCRIPTION
    The command will remove a specific folder from a Storage System, but to run this command you will need to know the FolderID 
    and the StorageSystemID. This command includes parameters to both force the delete, as well as force a cascading delete that removes linked items. 
.PARAMETER SystemID
    A single Storage System ID is specified and required, This command will accept pipeline input from the Get-DSCCStorageSystems command.
.PARAMETER FolderID
    A single Storage System Folder ID is specified and required.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Remove-Volume -SystemId 040abe24534563245234243abef -FolderId 0b12343564567abcdef0234123 
#>   
[CmdletBinding()]
param(  [Parameter(mandatory=$true, ValueFromPipeLineByPropertyName=$true )][Alias('id')]   [string]    $SystemId, 
        [Parameter(mandatory=$true )]                                                       [string]    $FolderId,
                                                                                            [switch]    $WhatIf
    )
process
    {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        switch ( $DeviceType )
        {   'device-type1'  {   Write-warning "This command ONLY works on Device-Type2 Devices, the given System ID belongs to a Device-Type1."
                                return       
                            }
            'device-type2'  {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/folders/' + $FolderId
                                return invoke-DSCCrestmethod -UriAdd $MyAdd -method Delete -whatifBoolean $WhatIf
                            }
            default         {   write-warning 'The SystemID did not return a valid system.'
                                return
                            }
        } 
    }       
} 

function New-DSCCFolder
{
<#
.SYNOPSIS
    Creates a new Folder on the specified Device-Type2 Storage System.    
.DESCRIPTION
    Creates a new Folder on the Specified Storage System with the supplied parameters. The Storage System must be of Device-Type2.  
.PARAMETER StorageID
    A single Storage System ID is specified and required. 
.PARAMETER name
    A single name is specified and required.
.PARAMETER access_protocol
    Access protocol of the folder. This attribute is used by the VASA Provider to determine the access protocol of the bind request. If not specified in the creation request, 
    it will be the access protocol supported by the group. If the group supports multiple protocols, the default will be Fibre Channel. 
    This field is meaningful only to VVol folder. Possible values: 'iscsi', 'fc'.
.PARAMETER agent_type
    External management agent type. Defaults to 'none'. Possible values: 'none', 'smis', 'vvol', 'openstack', 'openstackv2'.
.PARAMETER pool_id
    Identifier associated with the pool in the storage pool table. A 42 digit hexadecimal int64. Defaults to the ID of the 'default' pool.
.PARAMETER description
    Text description of volume. String of up to 255 printable ASCII characters. Defaults to the empty string. 
.PARAMETER poolId
    ID of the pool where the folder resides and is required
.PARAMETER limit_iops
    IOPS limit for this folder. If limit_iops is not specified when a folder is created, or if limit_iops 
    is set to -1, then the folder has no IOPS limit. IOPS limit should be in range [256, 4294967294] or -1 for unlimited.
.PARAMETER limit_mbps
    Throughput limit for this folder in MB/s. If limit_mbps is not specified when a folder is created, or if limit_mbps 
    is set to -1, then the folder has no throughput limit. MBPS limit should be in range [1, 4294967294] or -1 for unlimited.
.PARAMETER limit_size_bytes
    Folder size limit in bytes. If limit_size_bytes is not specified when a folder is created, or if limit_size_bytes is set 
    to -1, then the folder has no limit. Otherwise, a limit smaller than the capacity of the pool can be set. 
    Folders with an agent_type of 'smis' or 'vvol' must have a size limit.
.PARAMETER inherited_vol_perfpol_id
    Identifier of the default performance policy for a newly created volume.
    
.PARAMETER overdraft_limit_pct
    Amount of space to consider as overdraft range for this folder as a percentage of folder used limit. 
    Valid values are from 0% - 200%. This is the limit above the folder usage limit beyond which enforcement action(volume offline/non-writable) is issued.
.PARAMETER provisioned_limit_size
    Limit on the provisioned size of volumes in a folder. If provisioned_limit_size_bytes is not specified when a 
    folder is created, or if provisioned_limit_size_bytes is set to -1, then the folder has no provisioned size limit.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    Creating a Device-Type2 type Folder on a Alletra6K or Nimble Storage device.

    PS:> New-DSCCFolder -SystemId 003a78e8778c204dc2000000000000000000000001 -name 'testFolder' -pool_id 003a78e8778c204dc2000000000000000000000004-size 1024000 

    taskUri                              status    message
    -------                              ------    -------
    dd9e6b68-db1c-4f86-90b4-9ce31d65abfa SUBMITTED
#>   
[CmdletBinding()]
param(  [Parameter(Mandatory)]          [string]    $SystemId, 
        [Parameter(Mandatory)]          [string]    $name,
        [Parameter(Mandatory)]          [string]    $pool_id,
        [ValidateSet('none','smis','vvol','openstack','openstackv2')]   
                                        [string]    $agent_type,
        [ValidateSet('fc','iscsi')]
                                        [string]    $access_protocol,
                                        [string]    $appserver_id,
                                        [string]    $description,
                                        [string]    $inherited_volperfpol_id,
        [ValidateRange(256,4294967294)] [int]       $limit_iops,
        [ValidateRange(256,4294967294)] [int]       $limit_mbps,
                                        [int]       $limit_size_bytes,
        [ValidateRange(0,200)]          [int]       $overlimit_limit_pct,
                                        [int]       $provisioned_limit_size_bytes,
                                        [switch]    $WhatIf
    )
process
    {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        $MyBody = [ordered]@{}
        switch ( $DeviceType )
            { 'device-type2' {  if ( $agent_type   )                {   $MyBody = $MyBody + @{ 'agent_type'                 = $agent_type }             }
                                if ( $access_protocol -and ( $agent_type -eq 'vvol') )             
                                                                    {   $MyBody = $MyBody + @{ 'access_protocol'            = $access_protocol }        }            # This was intentional as Access protocol is only valid IF agent_type is set                                
                                if ( $appserver_id   )              {   $MyBody = $MyBody + @{ 'appserver_id'               = $appserver_id }           }
                                if ( $description   )               {   $MyBody = $MyBody + @{ 'description'                = $description }            }
                                if ( $inherited_vol_perfpol_id)     {   $MyBody = $MyBody + @{ 'inherited_vol_perfpol_id'   = $inherited_vol_perfpol_id}}
                                if ( $limit_iops   )                {   $MyBody = $MyBody + @{ 'limit_iops'                 = [int]$limit_iops }        }
                                if ( $limit_mbps   )                {   $MyBody = $MyBody + @{ 'limit_mbps'                 = [int]$limit_mbps }        }
                                if ( $name )                        {   $MyBody = $MyBody + @{ 'name'                       = $name }                   }
                                if ( $overdraft_limit_pct )         {   $MyBody = $MyBody + @{ 'overdraft_limit_pct'        = [int]$overdraft_limit_pct}}
                                if ( $pool_id   )                   {   $MyBody = $MyBody + @{ 'pool_id'                    = $pool_id }                }
                                if ( $provisioned_limit_size_bytes ){   $MyBody = $MyBody + @{ 'provisioned_limit_size_bytes'=[int]$provisioned_limit_size_bytes }            }
                                $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/folders'
                                return ( invoke-DSCCrestmethod -uri $MyAdd -method 'POST' -body ($MyBody | convertto-json) -whatifBoolean $WhatIf ) 
                            }
                default     {   write-warning "The given SystemID does not return as a Device-Type2. Please use this command only with Device-Type2 type storage systems."
                                Return
                            }
            }
    }       
} 

function Set-DSCCFolder
{
<#
.SYNOPSIS
    Modifies a Folder on the specified Device-Type2 Storage System.    
.DESCRIPTION
    Modifies a Folder on the Specified Storage System with the supplied parameters. The Storage System must be of Device-Type2.  
.PARAMETER SystemID
    A single Storage System ID is specified and required. 
.PARAMETER FolderID
    A single Storage System Folder ID is specified and required. 
.PARAMETER name
    A single name is specified and required.
.PARAMETER access_protocol
    Access protocol of the folder. This attribute is used by the VASA Provider to determine the access protocol of the bind request. If not specified in the creation request, 
    it will be the access protocol supported by the group. If the group supports multiple protocols, the default will be Fibre Channel. 
    This field is meaningful only to VVol folder. Possible values: 'iscsi', 'fc'.
.PARAMETER agent_type
    External management agent type. Defaults to 'none'. Possible values: 'none', 'smis', 'vvol', 'openstack', 'openstackv2'.
.PARAMETER pool_id
    Identifier associated with the pool in the storage pool table. A 42 digit hexadecimal int64. Defaults to the ID of the 'default' pool.
.PARAMETER description
    Text description of volume. String of up to 255 printable ASCII characters. Defaults to the empty string. 
.PARAMETER poolId
    ID of the pool where the folder resides and is required
.PARAMETER limit_iops
    IOPS limit for this folder. If limit_iops is not specified when a folder is created, or if limit_iops 
    is set to -1, then the folder has no IOPS limit. IOPS limit should be in range [256, 4294967294] or -1 for unlimited.
.PARAMETER limit_mbps
    Throughput limit for this folder in MB/s. If limit_mbps is not specified when a folder is created, or if limit_mbps 
    is set to -1, then the folder has no throughput limit. MBPS limit should be in range [1, 4294967294] or -1 for unlimited.
.PARAMETER limit_size_bytes
    Folder size limit in bytes. If limit_size_bytes is not specified when a folder is created, or if limit_size_bytes is set 
    to -1, then the folder has no limit. Otherwise, a limit smaller than the capacity of the pool can be set. 
    Folders with an agent_type of 'smis' or 'vvol' must have a size limit.
.PARAMETER inherited_vol_perfpol_id
    Identifier of the default performance policy for a newly created volume.
    
.PARAMETER overdraft_limit_pct
    Amount of space to consider as overdraft range for this folder as a percentage of folder used limit. 
    Valid values are from 0% - 200%. This is the limit above the folder usage limit beyond which enforcement action(volume offline/non-writable) is issued.
.PARAMETER provisioned_limit_size
    Limit on the provisioned size of volumes in a folder. If provisioned_limit_size_bytes is not specified when a 
    folder is created, or if provisioned_limit_size_bytes is set to -1, then the folder has no provisioned size limit.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    Creating a Device-Type2 type Folder on a Alletra6K or Nimble Storage device.

    PS:> New-DSCCFolder -SystemId 003a78e8778c204dc2000000000000000000000001 -name 'testFolder' -pool_id 003a78e8778c204dc2000000000000000000000004-size 1024000 

    taskUri                              status    message
    -------                              ------    -------
    dd9e6b68-db1c-4f86-90b4-9ce31d65abfa SUBMITTED
#>   
[CmdletBinding()]
param(  [Parameter(Mandatory)]          [string]    $SystemId, 
        [Parameter(Mandatory)]          [string]    $folder_id,
                                        [string]    $appserver_id,
                                        [string]    $description,
                                        [string]    $inherited_volperfpol_id,
        [ValidateRange(256,4294967294)] [int]       $limit_iops,
        [ValidateRange(256,4294967294)] [int]       $limit_mbps,
                                        [int]       $limit_size_bytes,
                                        [string]    $name,
        [ValidateRange(0,200)]          [int]       $overlimit_limit_pct,
                                        [int]       $provisioned_limit_size_bytes,
                                        [switch]    $WhatIf
    )
process
    {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        $MyBody = [ordered]@{}
        switch ( $DeviceType )
            { 'device-type2' {  if ( $appserver_id   )              {   $MyBody = $MyBody + @{ 'appserver_id'               = $appserver_id }           }
                                if ( $description   )               {   $MyBody = $MyBody + @{ 'description'                = $description }            }
                                if ( $inherited_vol_perfpol_id)     {   $MyBody = $MyBody + @{ 'inherited_vol_perfpol_id'   = $inherited_vol_perfpol_id}}
                                if ( $limit_iops   )                {   $MyBody = $MyBody + @{ 'limit_iops'                 = [int]$limit_iops }        }
                                if ( $limit_mbps   )                {   $MyBody = $MyBody + @{ 'limit_mbps'                 = [int]$limit_mbps }        }
                                if ( $name )                        {   $MyBody = $MyBody + @{ 'name'                       = $name }                   }
                                if ( $overdraft_limit_pct )         {   $MyBody = $MyBody + @{ 'overdraft_limit_pct'        = [int]$overdraft_limit_pct}}
                                if ( $provisioned_limit_size_bytes ){   $MyBody = $MyBody + @{ 'provisioned_limit_size_bytes'=[int]$provisioned_limit_size_bytes }            }
                                $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/folders/' + $folder_id
                                return ( invoke-DSCCrestmethod -uri $MyAdd -method 'PUT' -body ($MyBody | convertto-json) -whatifBoolean $WhatIf ) 
                            }
                default     {   write-warning "The given SystemID does not return as a Device-Type2. Please use this command only with Device-Type2 type storage systems."
                                Return
                            }
            }
    }       
} 


