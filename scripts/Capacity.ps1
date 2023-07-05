function Get-DSCCCapacity
{
<#
.SYNOPSIS
    Returns Application Summary for a storage system {DeviceType-1}    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Application Summary for a storage system {DeviceType-1}    
.PARAMETER systemID
    The required system ID to query for the alerts
.PARAMETER select
    Example: 'id'
    Query to select only the required parameters, separated by . if nested
.PARAMETER range
    Example: 'startTime eq 1605063600 and endTime eq 1605186000'
    range will define start and end time in which query has to be made.
.PARAMETER timeIntervalMin
    Enum: 5 60 1440 10080
    Example: timeIntervalMin=60
    It defines granularity in minutes.
.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE    
    PS:> Get-DSCCCapacity -SystemID 12

    {   "customerId": "string",
        "items": [  {   "applicationSetType": "Microsoft Exchange",
                        "totalSizeMiB": 307200,
                        "totalUsedSizeMiB": 7200,
                        "volumesCount": 5
                    }
                ],
        "requestUri": "/v1/storage-systems/device-type1/SGH014XGSP/application-summary",
        "total": 2
    }
.EXAMPLE
    PS:> Get-DSCCCapacity -SystemID 12 -whatIf
    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call
    The URI for this call will be
        https://pavo-user-api.common.cloud.hpe.com/api/v1Data-Ops-Manager-ProductType1-Volumes/storage-systems/device-type1/12/application-summary
    The Method of this call will be 
        Get
    The Header for this call will be :
        {   "Content":  "application/json",
            "X-Auth-Token":  "123"
        }
    The Body of this call will be:
        {
        }
#>   
[CmdletBinding()]
param(  [parameter( ValueFromPipeLineByPropertyName=$true )][Alias('id')]
            [string]   $SystemID,
            [string]   $select,
            [string]   $range,
            [int]      $timeIntervalMin,
            [boolean]  $whatIf = $false
        )
process
    {   if ( -not $PSBoundParameters.ContainsKey('SystemId' ) )
                {   write-verbose "No SystemID Given, running all SystemIDs"
                    $ReturnCol=@()
                    foreach( $Sys in Get-DSCCStorageSystem )
                        {   write-verbose "Walking Through Multiple Systems"
                            If ( ($Sys).Id )
                                    {   write-verbose "Found a system with a System.id"
                                        $ReturnCol += Get-DSCCCapacity -SystemId ($Sys).Id -WhatIf $WhatIf
                                    }
                        }
                    write-verbose "Returning the Multiple System Id Capacity Histories."
                    return $ReturnCol
                }
            else 
                {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
                    if ( $DeviceType -eq 'device-type1' )
                            {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/application-summary'
                                $MyBody=@{}
                                if ( $select )          { $MyBody += @{ select = $select } } 
                                if ( $range  )          { $MyBody += @{ range = $range } } 
                                if ( $timeIntervalMin ) { $MyBody += @{ timeIntervalMin = $TimeIntervalMin } } 
                                $SysColOnly = Invoke-DSCCRestMethod -uriAdd $MyAdd -method 'Get' -whatifBoolean $WhatIf 
                                return ( Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Disk.$DeviceType" )
                            }
                        else 
                            {   Write-Warning "This command may only be run agaisnt Device-Type1 type arrays, the System ID $SystemID is a Device-Type2."
                                return
                            }
                }
    }       
}   
function Get-DSCCCapacityHistory
{
<#
.SYNOPSIS
    Returns capacity trend data for a storage system {DeviceType-1} 
.DESCRIPTION
    Returns the HPE Data Services Cloud Console capacity trend data for a storage system {DeviceType-1} 
.PARAMETER systemID
    The required system ID to query for the alerts
.PARAMETER select
    Example: 'id'
    Query to select only the required parameters, separated by . if nested
.PARAMETER range
    Example: 'startTime eq 1605063600 and endTime eq 1605186000'
    range will define start and end time in which query has to be made.
.PARAMETER timeIntervalMin
    Enum: 5 60 1440 10080
    Example: timeIntervalMin=60
    It defines granularity in minutes.
.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE
    PS:> Get-DSCCCapacityHistory 
    {   "capacityData": {   "customerId": "string",
                            "items": [  {   "timestampMs": 1605063600,
                                            "usageMiB": 4
                                        }
                                    ],
                            "total": 1
                        },
        "endTime": 1625209133,
        "startTime": 1625122733
    }
.EXAMPLE
    PS:> Get-DSCCCapacityHistory -SystemId 12 -WhatIf
    
    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call
    The URI for this call will be
        https://us1.data.cloud.hpe.com/api/v1/storage-systems/device-type1/{systemId}/volumes/{id}/capacity-history
    The Method of this call will be 
        Get
    The Header for this call will be :
        {   "Content":  "application/json",
            "X-Auth-Token":  "123"
        }
    The Body of this call will be:
        {}

#>   
[CmdletBinding()]
param(  [string]   $SystemID,
        [string]   $select,
        [string]   $range,
        [int]      $timeIntervalMin,
        [boolean]  $whatIf = $false
    )
process
    {   if ( -not $PSBoundParameters.ContainsKey('SystemId' ) )
                {   write-verbose "No SystemID Given, running all SystemIDs"
                    $ReturnCol=@()
                    foreach( $Sys in Get-DSCCStorageSystem )
                        {   write-verbose "Walking Through Multiple Systems"
                            If ( ($Sys).Id )
                                    {   write-verbose "Found a system with a System.id"
                                        $ReturnCol += Get-DSCCCapacityHistory -SystemId ($Sys).Id -WhatIf $WhatIf
                                    }
                        }
                    write-verbose "Returning the Multiple System Id Capacity Histories."
                    return $ReturnCol
                }
            else 
                {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
                    if ( $DeviceType -eq 'device-type1' )
                            {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/capacity-history'
                                $MyBody=@{}
                                if ( $select )          { $MyBody += @{ select = $select } } 
                                if ( $range  )          { $MyBody += @{ range = $range } } 
                                if ( $timeIntervalMin ) { $MyBody += @{ timeIntervalMin = $TimeIntervalMin } } 
                                return ( Invoke-DSCCRestMethod -uriAdd $MyAdd -method 'Get' -WhatIfBoolean $WhatIf )
                            }
                        else 
                            {   Write-Warning "This command may only be run agaisnt Device-Type1 type arrays, the System ID $SystemID is a Device-Type2."
                                return
                            }
                }
    }       
}              
function Get-DSCCCapacitySummary
{
<#
.SYNOPSIS
    Returns capacity summary data for a storage system {DeviceType-1} 
.DESCRIPTION
    Returns the HPE Data Services Cloud Console capacity summary data for a storage system {DeviceType-1} 
.PARAMETER systemID
    The required system ID to query for the alerts
.PARAMETER select
    Example: 'id'
    Query to select only the required parameters, separated by . if nested
.PARAMETER range
    Example: 'startTime eq 1605063600 and endTime eq 1605186000'
    range will define start and end time in which query has to be made.
.PARAMETER timeIntervalMin
    Enum: 5 60 1440 10080
    Example: timeIntervalMin=60
    It defines granularity in minutes.
.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE
    PS:> Get-DSCCCapacitySummary -SystemID 12 -whatIf

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call
    The URI for this call will be
        https://pavo-user-api.common.cloud.hpe.com/api/v1Data-Ops-Manager-ProductType1-Volumes/storage-systems/device-type1/12/capacity-summary
    The Method of this call will be 
        Get
    The Header for this call will be :
        {   "Content":  "application/json",
            "X-Auth-Token":  "123"
        }
    The Body of this call will be:
        {}
#>   
[CmdletBinding()]
param(                                  [string]   $SystemID,
                                        [string]   $select,
                                        [string]   $range,
                                        [int]      $timeIntervalMin,
                                        [boolean]  $whatIf = $false
        )
process
{   if ( -not $PSBoundParameters.ContainsKey('SystemId' ) )
            {   write-verbose "No SystemID Given, running all SystemIDs"
                $ReturnCol=@()
                foreach( $Sys in Get-DSCCStorageSystem )
                    {   write-verbose "Walking Through Multiple Systems"
                        If ( ($Sys).Id )
                            {   write-verbose "Found a system with a System.id"
                                $ReturnCol += Get-DSCCCapacitySummary -SystemId ($Sys).Id -WhatIf $WhatIf
                            }
                    }
                write-verbose "Returning the Multiple System Id Access Controll Groups."
                return $ReturnCol
            }
        else 
            {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
                if ( $DeviceType -eq 'device-type1' )
                        {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/capacity-summary'
                            $MyBody=@{}
                            if ( $select )          { $MyBody += @{ select = $select } } 
                            if ( $range  )          { $MyBody += @{ range = $range } } 
                            if ( $timeIntervalMin ) { $MyBody += @{ timeIntervalMin = $TimeIntervalMin } } 
                            return ( Invoke-DSCCRestMethod -uriAdd $MyAdd -method 'Get' -WhatIfBoolean $WhatIf ) 
                        }
            }            
}    
}