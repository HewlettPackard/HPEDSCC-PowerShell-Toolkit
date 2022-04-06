function Get-DSCCAccessControlRecord
{
<#
.SYNOPSIS
    Returns the HPE DSSC Access Group Collection    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager Access Groups Collections.
.PARAMETER SystemID
    If a single Host Group ID is specified the output will be limited to that single record.
.PARAMETER AccessControlRecordID
    If a single Access Control Record ID is specified the output will be limited to that single record.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.LINK
    The API call for this operation is file:///api/v1/storage-systems/{systemid}/device-type1/access-control-records
.EXAMPLE
    PS:> Get-DSCCStorageSystem  | Get-DSCCAccessControlRecord
    
    WARNING: The Call to SystemID MXN5442108 returned no Access ControlRecord Records.

    Volume Name       id                                         systemId   'type'                InitiatorGroupName
    -----------       --                                         --------   ------                ------------------
    jpnvol04.1        05337c8f5eb8b41d9bd6237a0cd2f02d           MXN5442108 vlun                  jpnhost04
    jpnvol04.1        4d45e53862f8cb41b2e89171ffa1b195           MXN5442108 vlun                  jpnhostgroup04
    fleet-test-volume 21d4e8b481380388392db7617531af56           MXN5442108 vlun                  fleet-test-host
    fleet-test-volume f548680bf257c2d27c3f25f8ec6a824c           MXN5442108 vlun                  sc-fleet-test-hostgroup0
    jpnvol04.0        7cf3ebd3b23670a3fcf521c373b81905           MXN5442108 vlun                  jpnhost04
    jpnvol04.0        77bb708bb9b176670a8f46e8b5ea1384           MXN5442108 vlun                  jpnhostgroup04
    test-now          0d3a78e8778c204dc2000000000000000000000029            access-control-record jpnhost04
#>   
[CmdletBinding()]
param(  [Parameter(ValueFromPipeLineByPropertyName=$true,Mandatory=$true )][Alias('id')]    [string]    $SystemId,  
                                                                                            [string]    $AccessControlRecordId,    
                                                                                            [string]    $VolumeId,  
                                                                                            [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        write-verbose "Dectected the DeviceType is $DeviceType"
        switch ( $devicetype )
            {   'device-type1'  {   if ( $VolumeId )
                                            {   $VolObj = Get-DSCCVolume -systemid $Systemid -volumeid $VolumeId
                                            }
                                        else
                                            {   $VolObj = Get-DSCCVolume -systemId $SystemId
                                            }
                                    $SysColOnly = @()
                                    foreach ($MyVol in $VolObj)
                                        {   $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + '/volumes/' + ($MyVol).id + '/vluns'
                                            if ( $WhatIf )
                                                    {   $MyCol = invoke-restmethodWhatIf -uri $MyUri -headers $MyHeaders -method Get
                                                    }   
                                                else 
                                                    {   $MyCol = invoke-restmethod -uri $MyUri -headers $MyHeaders -method Get    
                                                    }
                                            if ( ( $MyCol ).items )
                                                    {   $MyCol = $MyCol.items 
                                                    }
                                            if ( ( $MyCol ).total -eq 0 )
                                                    {   Write-Warning "The Call to SystemID $SystemId returned no Access ControlRecord Records."
                                                        $MyCol = ''                                                
                                                    }  
                                                else
                                                    {   $SysColOnly += $MyCol                                                        
                                                    }
                                        } 
                                        $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName ( "AccessControlRecord")
                                        return $ReturnData
                                }
                'device-type2'  {   $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + '/access-control-records/' + $AccessControlRecordId
                                    if ( $WhatIf )
                                            {   $SysColOnly = invoke-restmethodWhatIf -uri $MyUri -headers $MyHeaders -method Get
                                            }   
                                        else 
                                            {   $SysColOnly = invoke-restmethod -uri $MyUri -headers $MyHeaders -method Get
                                            }
                                    if ( ( $SysColOnly ).items )
                                            {   $SysColOnly = $SysColOnly.items 
                                            }
                                    if ( ( $SysColOnly ).total -eq 0 )
                                            {   Write-Warning "The Call to SystemID $SystemId returned no Access ControlRecord Records."
                                                return                                                
                                            }
                                    $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "AccessControlRecord"
                                    if ( $AccessControlRecordId )
                                            {   return ( $ReturnData | where-object { $_.id -eq $AccessControlRecordId } )
                                            } 
                                        else 
                                            {   return $ReturnData
                                            }
                                }
            }
        
        
        
        

        
    }       
}   
function Remove-DSCCAccessControlRecord
{
<#
.SYNOPSIS
    Removes a HPE DSSC Access Group Record    
.DESCRIPTION
    Removes a HPE Data Services Cloud Console Data Operations Manager Access Groups Record.
.PARAMETER SystemID
    A single System ID is specified and required.
.PARAMETER AccessControlRecordID
    A single Access Control Record ID is specified and required.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.LINK
    The API call for this operation is file:///api/v1/storage-systems/{systemid}/device-type1/access-control-records
#>    
[CmdletBinding()]
param(  [Parameter(ValueFromPipeLineByPropertyName=$true,Mandatory=$true )][Alias('id')]    [string]    $SystemId,  
        [Parameter(Mandatory=$true )]                                                       [string]    $AccessControlRecordId,      
                                                                                            [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        write-verbose "Dectected the DeviceType is $DeviceType"
        switch ( $devicetype )
            {   'device-type1'  {   write-warning "This command only works on Device-Type2 so far"
                                    return 
                                }
                'device-type2'  {   $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + '/access-control-records/' + $AccessControlRecordId
                                }
            }
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyUri -headers $MyHeaders -method Get
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyUri -headers $MyHeaders -method Get
                }
        if ( $Whatif )
                {   return Invoke-RestMethodWhatIf -Uri $MyUri -Method 'Delete' -headers $MyHeaders -body $LocalBody
                } 
            else 
                {   return Invoke-RestMethod -uri $MyUri -Headers $MyHeaders -Method Delete -body $LocalBody
                }
    }       
}   
Function New-DSCCAccessControlRecord
{
<#
.SYNOPSIS
    Creates a HPE DSSC Access Group Record    
.DESCRIPTION
    Creates a HPE Data Services Cloud Console Data Operations Manager Access Group Record.
.PARAMETER SystemID
    A single System ID is specified and required.
.PARAMETER AccessControlRecordID
    A single Access Control Record ID is specified and required.
.PARAMETER applyTo
    External management agent type. Possible values:'volume', 'pe', 'vvol_volume', 'vvol_snapshot', 'snapshot', 'both'.
.PARAMETER chapUserId
    Identifier for the CHAP user.
.PARAMETER initiatorGroupId
    Identifier for the initiator group.
.PARAMETER lun
    If this access control record applies to a regular volume, this attribute is the volume's LUN (Logical Unit Number). 
    If the access protocol is iSCSI, the LUN will be 0. However, if the access protocol is Fibre Channel, the LUN will 
    be in the range from 0 to 2047. If this record applies to a Virtual Volume, this attribute is the volume's secondary 
    LUN in the range from 0 to 399999, for both iSCSI and Fibre Channel. If the record applies to a OpenstackV2 volume, 
    the LUN will be in the range from 0 to 2047, for both iSCSI and Fibre Channel. If this record applies to a protocol
     endpoint or only a snapshot, this attribute is not meaningful and is set to null.
.PARAMETER pe_id
    Identifier for the protocol endpoint this access control record applies to.
.PARAMETER pe_ids
    List of candidate protocol endpoints that may be used to access the Virtual Volume. One of them will be selected 
    for the access control record. This field is required only when creating an access control record for a Virtual Volume.
.PARAMETER snapId
    Identifier for the snapshot this access control record applies to.
.PARAMETER volId
    Identifier for the volume this access control record applies to.    
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.LINK
    The API call for this operation is file:///api/v1/storage-systems/{systemid}/device-type1/access-control-records
#>   
[CmdletBinding()]
param(  [Parameter(ValueFromPipeLineByPropertyName=$true,Mandatory=$true )][Alias('id')]    [string]    $SystemId, 
        [ValidateSet('volume','pe','vvol_volume','vvol_snapshot','snapshot','both') ]       [string]    $applyTo,
                                                                                            [string]    $chapUserId,
                                                                                            [string]    $initiatorGroupId,
                                                                                            [int]       $lun,
                                                                                            [string]    $pe_id,
                                                                                            [string]    $pe_ids,
                                                                                            [string]    $snapId,
                                                                                            [string]    $volId,
                                                                                            [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        write-verbose "Dectected the DeviceType is $DeviceType"
        switch ( $devicetype )
            {   'device-type1'  {   return 
                                }
                'device-type2'  {   $MyURI = $BaseURI + 'storage-systems/' + $devicetype + '/' + $SystemId + '/access-control-records'
                                                                $MyBody =  @{}
                                    if ($applyTo)           {   $MyBody += @{ apply_to = $applyTo }  }
                                    if ($chapUserId)        {   $MyBody += @{ chap_user_id = $chapUserId }  }
                                    if ($initiatorGroupId ) {   $MyBody += @{ initiator_group_id = $initiatorGroupId }  }
                                    if ($lun )              {   $MyBody += @{ lun = $lun }  }
                                    if ($pe_id )            {   $MyBody += @{ pe_id = $pe_id }  }
                                    if ($pe_ids )           {   $MyBody += @{ pe_ids = $pe_ids }  }
                                    if ($snapId )           {   $MyBody += @{ snap_id = $snapId }  }
                                    if ($volId )            {   $MyBody += @{ vol_id = $volId }  }
                                }
            }
        if ($Whatif)
                {   return Invoke-RestMethodWhatIf -uri $MyUri -method 'POST' -headers $MyHeaders -body $MyBody -ContentType 'application/json'
                } 
            else 
                {   return Invoke-RestMethod -uri $MyUri -method 'POST' -headers $MyHeaders -body ( $MyBody | ConvertTo-Json ) -ContentType 'application/json'
                }
     }      
} 
