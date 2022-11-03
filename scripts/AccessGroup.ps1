function Get-DSCCAccessControlRecord
{
<#
.SYNOPSIS
    Returns the HPE DSSC Access Group Collection     
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager Access Groups Collections.
.PARAMETER SystemID
    If a single System ID is specified the output will be limited to that single set of records. If no System ID is 
    given, the command will be run against all Storage Systems Ids
.PARAMETER VolumeId 
    With device-type1 devices you must specify the volumeID that you want access control records for, if left unset, it will 
    return the access control records for all volumes.
.PARAMETER WhatIf
    The WhatIf can be either $true or $false and will show you the RAW RestAPI call that would be made to DSCC instead of actually 
    sending the request. This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.LINK
    The API call for this operation is file:///api/v1/storage-systems/{systemid}/device-type1/access-control-records
.EXAMPLE
    PS:> Get-DSCCAccessControlRecord
    
    WARNING: The Call to SystemID MXN5442108 returned no Access ControlRecord Records.

    Volume Name       id                                         systemId   'type'                InitiatorGroupName
    -----------       --                                         --------   ------                ------------------
    jpnvol04.1        05337c8f5eb8b41d9bd6237a0cd2f02d           MXN5442108 vlun                  jpnhost04
    jpnvol04.1        4d45e53862f8cb41b2e89171ffa1b195           MXN5442108 vlun                  jpnhostgroup04
    fleet-test-volume 21d4e8b481380388392db7617531af56           MXN5442108 vlun                  fleet-test-host
    jpnvol04.0        7cf3ebd3b23670a3fcf521c373b81905           MXN5442108 vlun                  jpnhost04
    jpnvol04.0        77bb708bb9b176670a8f46e8b5ea1384           MXN5442108 vlun                  jpnhostgroup04
    test-now          0d3a78e8778c204dc2000000000000000000000029            access-control-record jpnhost04
#>   
[CmdletBinding()]
param   (  [Parameter(ValueFromPipeLineByPropertyName=$true)]   [Alias('id')]   [string]    $SystemId,  
                                                                                [string]    $VolumeId,  
                                                                                [boolean]   $WhatIf=$false
        )
process
{   if ( -not $PSBoundParameters.ContainsKey('SystemId' ) )
            {   write-verbose "No SystemID Given, running all SystemIDs"
                $ReturnCol=@()
                foreach( $Sys in Get-DSCCStorageSystem )
                    {   write-verbose "Walking Through Multiple Systems"
                        If ( ($Sys).Id )
                            {   write-verbose "Found a system with a System.id"
                                $ReturnCol += Get-DSCCAccessControlRecord -SystemId ($Sys).Id -WhatIf $WhatIf
                            }
                    }
                write-verbose "Returning the Multiple System Id Access Controll Groups."
                return $ReturnCol
            }
        else 
            {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
                switch ( $devicetype )
                    {   'device-type1'  {   if ( $VolumeId )
                                                    {   $VolObj = Get-DSCCVolume -systemid $Systemid -volumeid $VolumeId
                                                    }
                                                else
                                                    {   write-verbose "No Volume was given, so checking all Volumes on this System"
                                                        $VolObj = Get-DSCCVolume -systemId $SystemId
                                                    }
                                            $SysColOnly = @()
                                            foreach ($MyVol in $VolObj)
                                                {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/volumes/' + ($MyVol).id + '/vluns'
                                                    $MyCol = invoke-DSCCrestmethod -uriAdd $MyAdd -method Get -whatifBoolean $WhatIf    
                                                    $SysColOnly += $MyCol                                                        
                                                } 
                                            $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName ( "AccessControlRecord")
                                            return ( Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "AccessControlRecord" ) 
                                        }
                        'device-type2'  {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/access-control-records'
                                            $SysColOnly = invoke-Dsccrestmethod -uriAdd $MyAdd -method Get -whatifBoolean $WhatIf
                                            return ( Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "AccessControlRecord" )
                                        }
                    }     
            }       
}  
} 
function Remove-DSCCAccessControlRecord
{
<#
.SYNOPSIS
    Removes a HPE DSSC Access Group Record or vLUN mapping 
.DESCRIPTION
    Removes a HPE Data Services Cloud Console Data Operations Manager Access Groups Record or vLUN mapping.
.PARAMETER SystemID
    This parameter is required for both device-type1 and device-type2; A single System ID is specified and required.
.PARAMETER DeviceType1
    This switch is used to tell the command that the end device is the specific device type, and to only allow the correct
    parameter set that matches this device type.
.PARAMETER DeviceType2
    This switch is used to tell the command that the end device is the specific device type, and to only allow the correct
    parameter set that matches this device type.
.PARAMETER volumeId
    This parameter is required for device-type1 systems, and representes a volumeId
.PARAMETER vLunId
    This parameter is required for device-type1 systems, and representes a specific vlun mapping.
.PARAMETER AccessControlRecordID
    This parameter is required for device-type2; A single Access Control Record ID is specified and required.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
#>    
[CmdletBinding()]
param   (   [Parameter(ParameterSetName=('type1'),ValueFromPipeLineByPropertyName=$true,Mandatory=$true )]
            [Parameter(ParameterSetName=('type1'),ValueFromPipeLineByPropertyName=$true,Mandatory=$true )]
                                                        [Alias('id')]   [string]    $SystemId,  
            [Parameter(ParameterSetName=('type1'))]                     [switch]    $DeviceType1,
            [Parameter(ParameterSetName=('type2'))]                     [switch]    $DeviceType2,
                                                                        
            [Parameter(ParameterSetName=('type1'),Mandatory=$true )]    [string]    $volumeId,      
            [Parameter(ParameterSetName=('type1'),Mandatory=$true )]    [string]    $vLunId,      
            [Parameter(ParameterSetName=('type2'),Mandatory=$true )]    [string]    $AccessControlRecordId,      
                                                                        [switch]    $WhatIf
        )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        switch ( $devicetype )
            {   'device-type1'  {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/volumes/' + $VolumeId + '/vluns/' + $vLunId
                                    if ( $DeviceType2 ) 
                                        {   write-error "The Wrong Device Type was specified"
                                            Return
                                        }
                                }
                'device-type2'  {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/access-control-records/' + $AccessControlRecordId
                                    if ( $DeviceType1 )
                                        {   write-error "The Wrong Device Type was specified"
                                            Return
                                        }
                                }
            }
        return Invoke-DSCCRestMethod -uriAdd $MyAdd -Method Delete -WhatIfBoolean $WhatIf
    }       
}   
Function New-DSCCAccessControlRecord
{
<#
.SYNOPSIS
    Creates a HPE DSSC Access Group Record or LUN Mapping Record.
.DESCRIPTION
    Creates a HPE Data Services Cloud Console Data Operations Manager Access Group Record or LUN Mapping Record.
.PARAMETER SystemID
    A single System ID is specified and required.
.PARAMETER DeviceType1
    This switch is used to tell the command that the end device is the specific device type, and to only allow the correct
    parameter set that matches this device type.
.PARAMETER DeviceType2
    This switch is used to tell the command that the end device is the specific device type, and to only allow the correct
    parameter set that matches this device type.
.PARAMETER VolId
    A single Volume must be presented for either a device-type1 or device-type2 to be mapped to a set of hosts.
.PARAMETER autoLun
    Only valid for Device-Type1 target systems; Boolean if the volume should autocreate a LUN
.PARAMETER hostGroupIds
    Only valid for Device-Type1 target systems; Either a single or multiple Host Group IDs
.PARAMETER maxAutoLun
    Only valid for Device-Type1 target systems; The maximum number of AutoLuns
.PARAMETER noVcn
    Only valid for Device-Type1 target systems; a boolean if Nvc should be used.
.PARAMETER override
    Only valid for Device-Type1 target systems; will override specific safetys. 
.PARAMETER position
    Only valid for Device-Type1 target systems; will accept a position comment like 'position_1'. 
.PARAMETER applyTo
    Only valid for Device-Type2 target systems; External management agent type. Possible values:'volume', 'pe', 'vvol_volume', 'vvol_snapshot', 'snapshot', 'both'.
.PARAMETER chapUserId
    Only valid for Device-Type2 target systems; Identifier for the CHAP user.
.PARAMETER initiatorGroupId
    Only valid for Device-Type2 target systems; Identifier for the initiator group.
.PARAMETER lun
    Only valid for Device-Type2 target systems;  
    If this access control record applies to a regular volume, this attribute is the volume's LUN (Logical Unit Number). 
    If the access protocol is iSCSI, the LUN will be 0. However, if the access protocol is Fibre Channel, the LUN will 
    be in the range from 0 to 2047. If this record applies to a Virtual Volume, this attribute is the volume's secondary 
    LUN in the range from 0 to 399999, for both iSCSI and Fibre Channel. If the record applies to a OpenstackV2 volume, 
    the LUN will be in the range from 0 to 2047, for both iSCSI and Fibre Channel. If this record applies to a protocol
    endpoint or only a snapshot, this attribute is not meaningful and is set to null.
.PARAMETER pe_id
    Only valid for Device-Type2 target systems; Identifier for the protocol endpoint this access control record applies to.
.PARAMETER pe_ids
    Only valid for Device-Type2 target systems; 
    List of candidate protocol endpoints that may be used to access the Virtual Volume. One of them will be selected 
    for the access control record. This field is required only when creating an access control record for a Virtual Volume.
.PARAMETER snapId
    Only valid for Device-Type2 target systems; Identifier for the snapshot this access control record applies to.   
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.LINK
    The API call for this operation is file:///api/v1/storage-systems/{systemid}/device-type1/access-control-records
#>   
[CmdletBinding()]
param(  [Parameter(ParameterSetName=('type1'),ValueFromPipeLineByPropertyName=$true,Mandatory=$true )]
        [Parameter(ParameterSetName=('type2'),ValueFromPipeLineByPropertyName=$true,Mandatory=$true )]
                                                            [Alias('id')]            [string]    $SystemId, 
        [Parameter(ParameterSetName=('type1'),mandatory=$true)]  
        [Parameter(ParameterSetName=('type2'))]             [Alias('VolumeId')]      [string]    $vol_id,
        [Parameter(ParameterSetName=('type1'))]                                      [switch]    $DeviceType1,
        [Parameter(ParameterSetName=('type2'))]                                      [switch]    $DeviceType2,
        [Parameter(ParameterSetName=('type1'))]                                      [string]    $position,
        [Parameter(ParameterSetName=('type1'))]                                      [boolean]   $autoLun,
        [Parameter(ParameterSetName=('type1'))]                                      [int]       $maxAutoLun,
        [Parameter(ParameterSetName=('type1'))]                                      [boolean]   $override,
        [Parameter(ParameterSetName=('type1'))]                                      [boolean]   $noVcn,
        [Parameter(ParameterSetName=('type1'))]
        [ValidateSet('PRIMARY','SECONDARY','ALL')]                                   [string]   $proximity,
        [Parameter(ParameterSetName=('type1'))]                                      [string[]]  $hostGroupIds,

        [Parameter(ParameterSetName=('type2'))]                                      [int]       $lun,
        [ValidateSet('volume','pe','vvol_volume','vvol_snapshot','snapshot','both') ][string]    $applyTo,
        [Parameter(ParameterSetName=('type2'))]                                      [string]    $chapUserId,
        [Parameter(ParameterSetName=('type2'))]                                      [string]    $initiatorGroupId,
        [Parameter(ParameterSetName=('type2'))]                                      [string]    $pe_id,
        [Parameter(ParameterSetName=('type2'))]                                      [string]    $pe_ids,
        [Parameter(ParameterSetName=('type2'))]                                      [string]    $snapId,
        [Parameter(ParameterSetName=('type1'))]
        [Parameter(ParameterSetName=('type2'))]                                      [boolean]   $WhatIf = $false
    )
process
    {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        switch ( $devicetype )
            {   'device-type1'  {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/volumes/' + $vol_id + '/export'
                                                                $MyBody =  @{}
                                    if ($autoLun)           {   $MyBody += @{ autoLun       = $autoLun      }  }
                                    if ($hostGroupIds)      {   $MyBody += @{ hostGroupIds  = $hostGroupIds }  }
                                    if ($maxAutoLun )       {   $MyBody += @{ maxAutoLun    = $maxAutoLun   }  }
                                    if ($noVcn )            {   $MyBody += @{ noVcn         = $noVcn        }  }
                                    if ($override )         {   $MyBody += @{ override      = $override     }  }
                                    if ($position )         {   $MyBody += @{ position      = $position     }  }
                                    if ($proximity )        {   $MyBody += @{ proximity     = $proximity    }  }
                                    if ( $DeviceType2 ) 
                                        {   write-error "The Wrong Device Type was specified"
                                            Return
                                        }
                                }
                'device-type2'  {   $MyAdd = 'storage-systems/' + $devicetype + '/' + $SystemId + '/access-control-records'
                                                                $MyBody =  @{}
                                    if ($applyTo)           {   $MyBody += @{ apply_to           = $applyTo          }  }
                                    if ($chapUserId)        {   $MyBody += @{ chap_user_id       = $chapUserId       }  }
                                    if ($initiatorGroupId ) {   $MyBody += @{ initiator_group_id = $initiatorGroupId }  }
                                    if ($lun )              {   $MyBody += @{ lun                = $lun              }  }
                                    if ($pe_id )            {   $MyBody += @{ pe_id              = $pe_id            }  }
                                    if ($pe_ids )           {   $MyBody += @{ pe_ids             = $pe_ids           }  }
                                    if ($snapId )           {   $MyBody += @{ snap_id            = $snapId           }  }
                                    if ($vol_id )           {   $MyBody += @{ vol_id             = $vol_id           }  }
                                    if ( $DeviceType1 ) 
                                        {   write-error "The Wrong Device Type was specified"
                                            Return
                                        }
                                }
            }
        return Invoke-DSCCRestMethod -uriadd $MyAdd -method 'POST' -body ( $MyBody | ConvertTo-Json ) -whatifBoolean $WhatIf
    }      
} 