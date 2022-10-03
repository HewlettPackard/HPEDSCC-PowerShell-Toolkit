function Get-DSCCController
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Storage Systems Controllers    
.DESCRIPTION
    Returns the HPE DSSC DOM Storage Systems Controllers
.PARAMETER StorageSystemID
    A single Storage System ID is specified and required, the events will be returned unless a specific EventId is requested.
.PARAMETER DeviceType
    This can either be set to Device-Type1 or Device-Type2, where Device-Type1 refers to 3PAR/Primera/Alletra9K, while Device-Type2 refers to NimbleStorage/Alletra9K.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-HPEDSCCDOMController -StorageSystemId 2M202205GG -DeviceType device-type1

    
.EXAMPLE
    PS:> Get-DSCCController -StorageSystemId 2M202205GG -DeviceType device-type1 -ControllerID 3ff8fa3d971f16948fd9cff800775b9d -whatif
    
    
.EXAMPLE
    PS:> Get-DSCCController -StorageSystemId 2M202205GG -DeviceType device-type1 | format-table
  
.LINK
#>   
[CmdletBinding()]
param(  [parameter( mandatory, ValueFromPipeLineByPropertyName=$true )][Alias('id')]                                              
                                                                            [string]    $SystemId,
                                                                            [string]    $ControllerId,
                                                                            [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        switch($DeviceType)
                {   'Device-Type1'  { $ControllerWord = '/nodes'        }
                    'Device-Type2'  { $ControllerWord = '/controllers'  }
                }    
        $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + $ControllerWord
        if ( $ControllerId )
                {   $MyURI = $MyURI + '/' + $ControllerId 
                }
        $SysColOnly = invoke-DSCCrestmethod -uriAdd $MyAdd -method Get -whatifBoolean $WhatIf
        if ( ($SysColOnly).items ) 
                {   $SysColOnly = ($SysColOnly).items 
                }
        $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Controller.$DeviceType"        
        return $ReturnData
    }       
} 
function Get-DSCCControllerSubComponent
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Storage Systems Controllers    
.DESCRIPTION
    Returns the HPE DSSC DOM Storage Systems Controllers
.PARAMETER StorageSystemID
    A single Storage System ID is specified and required, the events will be returned unless a specific EventId is requested.
.PARAMETER DeviceType
    This can either be set to Device-Type1 or Device-Type2, where Device-Type1 refers to 3PAR/Primera/Alletra9K, while Device-Type2 refers to NimbleStorage/Alletra9K.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-DSCCControllerSubComponent -SystemId 2M2019018G -NodeId a8e846634d139a21a1a9dd635302e19f -SubComponent batteries

    chargeLevel     : 98
    expirationDate  : @{ms=1778135508000; tz=America/Chicago}
    fullyCharged    : True
    nodeBatteryId   : 0
    life            : 10
    locateEnabled   : False
    manufacturing   : @{assemblyRev=--; checkSum=--; hpeModelName=--; saleablePartNumber=--; saleableSerialNumber=--; sparePartNumber=; serialNumber=31323633; model=800-200012.02; manufacturer=CHN}
    maxLife         : 11
    name            : Battery
    powerSupplyId   : 0
    primaryNodeId   : 0
    safeToRemove    : True
    secondaryNodeId : 0
    serviceLED      : LED_OFF
    state           : @{detailed=; overall=STATE_NORMAL}
    testInProgress  : False
    timeToCharge    : -1
    domain          :
    resourceUri     : /api/v1/storage-systems/device-type1/2M2019018G/nodes/0/nodes-batteries/b1a3f62c608af59ec2dfd2eb9c919d09
    displayname     : Controller Node - 0,0, Power Supply - 0, Battery - 0
    faultLED        : LED_UNKNOWN
    statusLED       : LED_UNKNOWN
    dischargeLED    : LED_OFF
    id              : b1a3f62c608af59ec2dfd2eb9c919d09
    systemId        : 2M2019018G
    associatedLinks : {@{type=systems; resourceUri=/api/v1/storage-systems/device-type1/2M2019018G}, @{type=nodes; resourceUri=/api/v1/storage-systems/device-type1/2M2019018G/nodes/0}}
    customerId      : 0056b71eefc411eba26862adb877c2d8
    generation      : 1637284024663
    type            : node-battery
.EXAMPLE
   PS:> Get-DSCCControllerSubComponent -SystemId 2M2019018G -NodeId a8e846634d139a21a1a9dd635302e19f -SubComponent batteries  -WhatIf
    
   WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/storage-systems/device-type1/2M2019018G/nodes/a8e846634d139a21a1a9dd635302e19f/nodes-batteries
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhVXtNEzKX-Cs...C2dLww8WglRiODredKeRORGKIkesKew"
        }
    The Body of this call will be:
    "No Body"
.LINK
#>   
[CmdletBinding()]
param(  [parameter( mandatory, ValueFromPipeLineByPropertyName=$true )][Alias('id')]                                              
                                                                            [string]    $SystemId,
                                                                            [string]    $NodeId,
        [parameter(mandatory)][validateset('cards','cpus','drives','mcus','mems','powers','batteries')]
                                                                            [string]    $SubComponent,
                                                                            [string]    $SubComponentID,
                                                                            [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        clear-varibable -name ControllerWord -ErrorAction SilentlyContinue
        switch($DeviceType)
                {   'Device-Type1'  {   $ControllerWord = 'nodes'        }
                    'Device-Type2'  {   Write-warning "This command only works on Device-Type1 which include 3par/Primera/Alletra9K devices"
                                        return  
                                    }
                    default         {   Write-Warning "No array was detected using the SystemID $SystemId"
                                        return
                                    }
                }
        $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/' + $ControllerWord + '/' + $NodeId + '/node-' + $SubComponent
        if ($SubComponent -eq 'batteries' )
                { $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/' + $ControllerWord + '/' + $NodeId + '/nodes-' + $SubComponent
                }
        $SysColOnly = invoke-DSCCrestmethod -uriAdd $MyAdd -method Get -whatifBoolean $WhatIf
        if ( $SubComponentId )
                {   Write-host "The results of the complete collection have been limited to just the supplied ID"
                    return ( $SysColOnly | where-object { $_.id -eq $SubComponentId } )
                } 
            else 
                {   return $SysColOnly
                }
    }       
} 
function Get-DSCCControllerPerf
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM performance statistics for a specific storage system controller     
.DESCRIPTION
    Returns the HPE DSSC DOM performance statistics for a specific storage system controller
.PARAMETER SystemID
    A single Storage System ID is specified and required, the pools defined will be returned unless a specific Disk ID is requested.
.PARAMETER NodeID
    If a single Storage System Disk ID is specified, only that Disk will be returned.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-DSCCControllerPerf -SystemId 2M2019018G -NodeId a8e846634d139a21a1a9dd635302e19f

    CpuPercentage                                                            cachePercentage                                                         customerId                       requestUri
    -------------                                                            ---------------                                                         ----------                       ----------
    @{avgOfLatest=12.671327585505013; avgOf1hour=; avgOf8hours=; avgOf1day=} @{avgOfLatest=69.84595038002811; avgOf1hour=; avgOf8hours=; avgOf1day=} 0056b71eefc411eba26862adb877c2d8 https://scalpha-app....
.EXAMPLE
    PS:> Get-DSCCControllerPerf -SystemId 2M2019018G -NodeId a8e846634d139a21a1a9dd635302e19f | convertto-json
    
    {   "cpuPercentage":  {     "avgOfLatest":  12.671327585504994,
                                "avgOf1hour":  null,
                                "avgOf8hours":  null,
                                "avgOf1day":  null
                          },
        "cachePercentage":  {   "avgOfLatest":  69.84595038002807,
                                "avgOf1hour":  null,
                                "avgOf8hours":  null,
                                "avgOf1day":  null
                            },
        "customerId":  "0056b71eefc411eba26862adb877c2d8",
        "requestUri":  "https://scalpha-app.qa.cds.hpe.com/api/v1/storage-systems/device-type1/2M2019018G/nodes/a8e846634d139a21a1a9dd635302e19f/component-performance-statistics"
    }
.EXAMPLE
    PS:> Get-DSCCControllerPerf -SystemId 2M2019018G -NodeId a8e846634d139a21a1a9dd635302e19f -whatif
    
    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/storage-systems/device-type1/2M2019018G/nodes/a8e846634d139a21a1a9dd635302e19f/component-performance-statistics
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciO...ibJAt31ZZ2VQ"
        }
    The Body of this call will be:
        "No Body"
.LINK
#>   
[CmdletBinding()]
param(  [parameter( mandatory, ValueFromPipeLineByPropertyName=$true )]     [string]    $systemId,
        [parameter( mandatory, ValueFromPipeLineByPropertyName=$true )]     [string]    $id,
                                                                            [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $systemId )
        if ($DeviceType -eq 'device-type2' )
                {   Write-warning "This command only works on Device-Type1 which include 3par/Primera/Alletra9K devices"
                    return  
                }
        if ( -not $DeviceType )
                {   Write-Warning "No array was detected using the SystemID $systemId"
                    return
                }
        $MyAdd = 'storage-systems/device-type1/' + $systemId + '/nodes/' + $id + '/component-performance-statistics'
        $SysColOnly = invoke-DSCCrestmethod -uriAdd $MyAdd -method Get -whatifBoolean $WhatIf
        return $SysColOnly
    }       
}
function Invoke-DSCCControllerLocate
{
<#
.SYNOPSIS
    WIll illuminate the LED on the Storage Controller and specified node, or turn it off    
.DESCRIPTION
    WIll illuminate the LED on the Storage Controller and specified node, or turn it off 
.PARAMETER StorageSystemID
    A single Storage System ID type 1 only is specified and required.
.PARAMETER NodeId
    A Single controller in that system to control the beacon for.
.PARAMETER Status
    If set to true the light will be turned on, if set to false the light will be set to off.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
.LINK
#>   
[CmdletBinding()]
param(  [parameter(mandatory)][string]    $SystemId, 
        [parameter(mandatory)][string]    $NodeId,
        [parameter(mandatory)][boolean]   $Locate,
                              [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyBody = @{ locate = $Locate
                   }
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        if ($DeviceType -eq 'Device-Type2')  
                {   Write-warning "This command only works on Device-Type1 which include 3par/Primera/Alletra9K devices"
                    return  
                }
        if ( -not $DeviceType )
                {   Write-Warning "No array was detected using the SystemID $SystemId"
                    return
                }
        $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/nodes/' + $NodeId
        $SysColOnly = invoke-DSCCrestmethod -uriadd $MyAdd -body $MyBody -method Post -whatifBoolean $WhatIf
        return $SysColOnly
    }       
} 
function Invoke-DSCCControllerLocatePCBM
{
<#
.SYNOPSIS
    WIll illuminate the LED on the Storage Controller Power Supply and specified node, or turn it off    
.DESCRIPTION
    WIll illuminate the LED on the Storage Controller Power Supply and specified node, or turn it off 
.PARAMETER StorageSystemID
    A single Storage System ID type 1 only is specified and required.
.PARAMETER NodeId
    A Single controller in that system to control the beacon for.
.PARAMETER PowerId
    The Single Power Supply LED to either set to lit or un-lit
.PARAMETER Status
    If set to true the light will be turned on, if set to false the light will be set to off.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
.LINK
#>   
[CmdletBinding()]
param(  [parameter(mandatory)][string]    $SystemId, 
        [parameter(mandatory)][string]    $NodeId,
        [parameter(mandatory)][string]    $PowerId,
        [parameter(mandatory)][boolean]   $Locate,
                              [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyBody = ( @{ locate = $Locate } | convertto-json )
        if ( $DeviceType -eq 'Device-Type2' )   { Write-warning "This command only works on Device-Type1 which include 3par/Primera/Alletra9K devices"; return }
        if ( -not $DeviceType )                 { Write-Warning "No array was detected using the SystemID $SystemId"; return }
        $MyAdd = 'storage-systems/device-type1/' + $SystemId + '/nodes/' + $NodeId + '/Powers/' + $PowerId
        return $invoke-restmethod -uriadd $MyAdd -body $MyBody -method Post -whatifBoolean $WhatIf
    }       
} 