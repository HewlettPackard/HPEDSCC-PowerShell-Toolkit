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
    {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        switch($DeviceType)
                {   'Device-Type1'  { $ControllerWord = '/nodes'        }
                    'Device-Type2'  { $ControllerWord = '/controllers'  }
                }    
        $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + $ControllerWord
        if ( $ControllerId )
                {   $MyURI = $MyURI + '/' + $ControllerId 
                }
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyURI -headers $MyHeaders -method Get
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyURI -headers $MyHeaders -method Get
                }
        if ( ($SysColOnly).items ) 
                {   $SysColOnly = ($SysColOnly).items 
                }
        return ( (($SysColOnly)) )
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
                                                                            [string]    $NodeId,
        [parameter(mandatory)][validateset('cards','cpus','drives','mcus','mems','powers','batteries')]
                                                                            [string]    $SubComponent,
                                                                            [string]    $SubComponentID,
                                                                            [switch]    $WhatIf
     )
process
    {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        switch($DeviceType)
                {   'Device-Type1'  { $ControllerWord = 'nodes'        }
                    'Device-Type2'  { $ControllerWord = 'controllers'  }
                }    
        $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + $ControllerWord
        if ( $ControllerId )
                {   $MyURI = $MyURI + '/' + $ControllerId 
                }
        $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + '/' + $ControllerWord + '/' + $NodeId + '/node-' + $SubComponent
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyURI -headers $MyHeaders -method Get
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyURI -headers $MyHeaders -method Get
                }
        if ( ($SysColOnly).items ) { $SysColOnly = ($SysColOnly).items }
        if ( $SubComponentId )
                {   Write-host "The results of the complete collection have been limited to just the supplied ID"
                    return ( $SysColOnly | where-object { $_.id -eq $SubComponentId } )
                } 
            else 
                {   return $SysColOnly
                }
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
param(  [parameter(mandatory)][string]    $StorageSystemId, 
        [parameter(mandatory)][string]    $NodeId,
        [parameter(mandatory)][boolean]   $Locate,
        [switch]    $WhatIf
     )
process
    {   $MyBody = @{ locate = $Locate
                   }
        $MyURI = $BaseURI + 'storage-systems/device-type1/' + $StorageSystemId + '/nodes/' + $NodeId
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyURI -headers $MyHeaders -body $MyBody -method Get
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyURI -headers $MyHeaders -body $MyBody -method Post
                }
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
param(  [parameter(mandatory)][string]    $StorageSystemId, 
        [parameter(mandatory)][string]    $NodeId,
        [parameter(mandatory)][string]    $PowerId,
        [parameter(mandatory)][boolean]   $Locate,
        [switch]    $WhatIf
     )
process
    {   $MyBody = @{ locate = $Locate
                   }
        $MyURI = $BaseURI + 'storage-systems/device-type1/' + $StorageSystemId + '/nodes/' + $NodeId + '/Powers/' + $PowerId
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyURI -headers $MyHeaders -body $MyBody -method Get
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyURI -headers $MyHeaders -body $MyBody -method Post
                }
        return $SysColOnly
    }       
} 