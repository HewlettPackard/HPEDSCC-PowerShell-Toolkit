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
#>   
[CmdletBinding()]
param(  [Parameter(ValueFromPipeLineByPropertyName=$true,Mandatory=$true )][Alias('id')]    [string]    $SystemId,  
                                                                                            [string]    $AccessControlRecordId,      
                                                                                            [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        write-verbose "Dectected the DeviceType is $DeviceType"
        switch ( $devicetype )
            {   'device-type1'  {   return 
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
        if ( ( $SysColOnly ).items )
                {   $SysColOnly = $SysColOnly.items 
                }
        
        $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "AccessControlRecord"
        if ( ( $SysColOnly ).total -eq 0 )
                {   Write-Warning "The Call to SystemID $SystemId returned no Access ControlRecord Records."
                    $ReturnData = ''                                                
                }
        if ( $AccessControlRecordId )
                {   return ( $ReturnData | where-object { $_.id -eq $AccessControlRecordId } )
                } 
            else 
                {   return $ReturnData
                }
    }       
}   
function Remove-DSCCHostGroup
{
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
            {   'device-type1'  {   return 
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
Function New-DSCCHostGroup
{
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
<# Function Set-DSCCHostGroup
{
[CmdletBinding()]
param(  [Parameter(Mandatory)]  [string]    $hostGroupID,
                                [string]    $name,  
                                [array]     $hostsToCreate,
                                [array]     $updatedHosts,
                                [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyURI = $BaseURI + 'host-initiator-groups/' + $hostGroupID
                                    $MyBody += @{} 
        if ($name)              {   $MyBody += @{ name = $name}  }
        if ($updatedHosts)      {   $MyBody += @{ updatedHosts = $updatedHosts }  }
        if ($updatedHosts)      {   $MyBody += @{ HostsToCreate = $hostsToCreate }  }
        
        if ($Whatif)
                {   return Invoke-RestMethodWhatIf -uri $MyUri -Header $MyHeaders -body $MyBody -Method 'Put'
                } 
            else 
                {   return Invoke-RestMethod -uri $MyUri -Header $MyHeaders -body ( $MyBody | ConvertTo-Json ) -Method 'Put'
                }
    }       
} 
#>