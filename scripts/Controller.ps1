
<#
.SYNOPSIS
    Returns controllers for storage systems accessible to an instance of Data Storage Cloud Console (DSCC).
.DESCRIPTION
    Returns disks for storage systems accessible to an instance of Data Storage Cloud Console (DSCC).
    
    Optionally, for device-Type2 devices only (HPE Alletra 9000, HPE Primera and HPE 3PAR), the command can return 
    component information about each controller passed in, such as CPU, memory, power supply and battery.

    Optionally, again for device-Type2 devices only, the command can return performance metrics for each controller
    passed in. If both -Component and -Performance are specified, -Component takes precedence. 
    
    You must be logged in with valid credentials to a HPE GreenLake account.
.PARAMETER SystemId
    Accepts one or more System IDs if specified, or shows disks from all storage systems accessible to this 
    HPE GreenLake account.
.PARAMETER SystemName
    Accepts one or more System names if specified, or shows disks from all storage systems accessible to this 
    HPE GreenLake account.
.PARAMETER ControllerId
    Accepts a controller ID.
.PARAMETER Component
    Only valid for Device-Type1 devices. Display component information rather than controllers.
.PARAMETER Performance
    Only valid for Device-Type1 devices. Display storage system controller performance information rather than controllers.
.EXAMPLE
    PS:> Get-DsccController

    Display all controllers for all storage systems accessible from this GreenLake account
.EXAMPLE
    PS:> Get-DsccController -SystemId 2M202205GG

    Display all controllers on the specified storage system.
.EXAMPLE
    PS:> Get-DsccController -SystemId 2M202205GG -ControllerID 3ff8fa3d971f16948fd9cff800775b9d
    
    Display the specified controller
.EXAMPLE
    PS:> Get-DsccController -ControllerID 3ff8fa3d971f16948fd9cff800775b9d

    This also displays the specified controller, but is less efficient, because it has to iterate through every
    storage system.
.EXAMPLE
    PS:> Get-DsccController -SystemId 2M202205GG -Component Battery

    Display batteries associated with all controllers on the specified storage system
.EXAMPLE
    PS:> Get-DsccController -SystemId 2M202205GG -ControllerID 3ff8fa3d971f16948fd9cff800775b9d -Component PowerSupply

    Display the power supplies associated with the specified storage system controller.
.EXAMPLE
    PS:> Get-DsccController -SystemId 2M202205GG -Performance

    Display the performance metrics for each controller on the specified storage system.
.EXAMPLE
    PS:> Get-DsccController -SystemId 2M202205GG -WhatIf

    Display information about the REST call itself rather than the data from the array(s), consisting of
    the URI, header, method and body of the call to the API. This is useful for troubleshooting.
.LINK
    https://github.com/HewlettPackard/HPEDSCC-PowerShell-Toolkit
#>
function Get-DSCCController {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'BySystemId')]
    param (
        [Parameter(ParameterSetName = 'BySystemId')]
        [alias('id')]
        [string[]]$SystemId = (($DsccStorageSystem).Id),

        [Parameter(ParameterSetName = 'BySystemName')]
        [alias('name')]
        [string[]]$SystemName,

        [string]$ControllerId,

        [validateset('Card', 'CPU', 'Drive', 'MicroControllerUnit', 'Memory', 'PowerSupply', 'Battery')]
        [string]$Component,

        [switch]$Performance
    )
    begin {
        Write-Verbose 'Executing Get-DsccStorageSystem'
        if ($PSBoundParameters.ContainsKey('SystemName')) {
            $SystemId = Get-DsccSystemIdFromName -SystemName $SystemName
        }
    }
    process {
        foreach ($ThisId in $SystemId) {
            $DeviceType = ($DsccStorageSystem | Where-Object Id -EQ $ThisId).DeviceType
            if (-not $DeviceType) {
                return
            }
            elseif ($DeviceType -eq 'Device-Type1') {
                $UriAdd = "storage-systems/$DeviceType/$SystemId/nodes"
            }
            elseif ($DeviceType -eq 'Device-Type2') {
                $UriAdd = "storage-systems/$DeviceType/$SystemId/controllers"
            }
            else {
                # Additional device types are coming
                Write-Error "Device type of $DeviceType (system $ThisId) is not currently supported"
                continue
            }
            if ($PSBoundParameters.ContainsKey('ControllerId')) {
                $UriAdd += "/$ControllerId"
            }
            $Response = Invoke-DsccRestMethod -uriAdd $UriAdd -Method Get -WhatIf:$WhatIfPreference

            # Display output - various object types, depending on specified parameters
            if (($PSBoundParameters.ContainsKey('Component'))) {
                # Output specified component
                foreach ($ThisController in $Response.Id) {
                    Get-DsccControllerComponent -SystemId $ThisId -ControllerID $ThisController -Component $Component
                }
            }
            elseif (($PSBoundParameters.ContainsKey('Performance'))) {
                # Output performance metrics. -Component takes precedence - can't use parameter sets.
                foreach ($ThisController in $Response.Id) {
                    Get-DSCCControllerPerformance -SystemId $ThisId -ControllerID $ThisController
                }
            }
            else {
                # Default is to display Controller/Node
                Invoke-RepackageObjectWithType -RawObject $Response -ObjectName "Controller.$DeviceType"
            }
        } #end foreach
    } #end process
} #end Get-DsccController

# Helper function for Get-DsccController. Implements the -Component parameter functionality
function Get-DsccControllerComponent {
    [CmdletBinding()]
    param(
        [parameter(Mandatory)]
        [string]$SystemId,

        [parameter(Mandatory)]
        [string]$ControllerId,

        [parameter(Mandatory)]
        [validateset('Card', 'CPU', 'Drive', 'MicroControllerUnit', 'Memory', 'PowerSupply', 'Battery')]
        [string]$Component
    )
    begin {
        $ComponentType = @{
            Card                = 'cards'
            CPU                 = 'cpus'
            Drive               = 'drives'
            MicroControllerUnit = 'mcus'
            Memory              = 'mems'
            PowerSupply         = 'powers'
            Battery             = 'batteries'
        }
        $ThisComponent = $ComponentType.$Component
    }
    process {
        $DeviceType = ($DsccStorageSystem | Where-Object Id -EQ $SystemId).DeviceType
        if ($DeviceType -eq 'Device-Type1') {
            if ($Component -eq 'Battery' ) {
                # Bug in the API? This might get fixed in the future
                $UriAdd = "storage-systems/device-type1/$SystemId/nodes/$ControllerId/nodes-$ThisComponent"
            }
            else {
                # All other components use the same formatted URI.
                $UriAdd = "storage-systems/device-type1/$SystemId/nodes/$ControllerId/node-$ThisComponent"
            }
            Invoke-DsccRestMethod -uriAdd $UriAdd -Method Get
        }
        elseif ($DeviceType -eq 'Device-Type2') {
            Write-warning 'This command supports HPE Alletra 9000, HPE Primera and HPE 3AR devices only'
            return
        }
        else {
            # Additional device types are coming
            Write-Warning "Device type of $DeviceType (system $ThisId) is not currently supported"
            return
        }
    }
}

#Helper function for Get-DsccController. Implements the -Performance parameter functionality
function Get-DSCCControllerPerformance {  
[CmdletBinding()]
param(  [parameter(Mandatory)]    [string]$SystemId,
        [parameter(Mandatory)]    [string]$ControllerId
    )
process {
        $DeviceType = ($DsccStorageSystem | Where-Object Id -EQ $SystemId).DeviceType
        if ($DeviceType -eq 'Device-Type1') {
            $UriAdd = "storage-systems/device-type1/$SystemId/nodes/$ControllerId/component-performance-statistics"
            return ( Invoke-DsccRestMethod -uriAdd $UriAdd -Method Get )
        }
        elseif ($DeviceType -eq 'Device-Type2') {
            Write-warning 'This command supports HPE Alletra 9000, HPE Primera and HPE 3AR devices only'
        }
        else {
            # Additional device types are coming
            Write-warning "Device type of $DeviceType (system $SystemId) is not currently supported"
            return
        }
    }
}
function Invoke-DSCCControllerLocate {
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
    param(  [parameter(mandatory)]  [string]    $SystemId, 
        [parameter(mandatory)]  [string]    $NodeId,
        [parameter(mandatory)]  [boolean]   $Locate,
        [switch]    $WhatIf
    )
    process {
        $MyBody = @{ locate = $Locate }
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        if ($DeviceType -eq 'Device-Type2') {
            Write-Warning 'This command only works on Device-Type1 which include 3par/Primera/Alletra9K devices'
            return  
        }
        if ( -not $DeviceType ) {
            Write-Warning "No array was detected using the SystemID $SystemId"
            return
        }
        $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/nodes/' + $NodeId
        return ( invoke-DSCCrestmethod -uriadd $MyAdd -body ( $MyBody | ConvertTo-Json ) -method Post -whatifBoolean $WhatIf )
    }       
} 
function Invoke-DSCCControllerLocatePCBM {
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
    param(  [parameter(mandatory)]  [string]    $SystemId, 
        [parameter(mandatory)]  [string]    $NodeId,
        [parameter(mandatory)]  [string]    $PowerId,
        [parameter(mandatory)]  [boolean]   $Locate,
        [switch]    $WhatIf
    )
    process {
        $MyBody = ( @{ locate = $Locate } | ConvertTo-Json )
        if ( $DeviceType -eq 'Device-Type2' ) { 
            Write-Warning 'This command only works on Device-Type1 which include 3par/Primera/Alletra9K devices'
            return 
        }
        if ( -not $DeviceType ) { 
            Write-Warning "No array was detected using the SystemID $SystemId"
            return 
        }
        $MyAdd = 'storage-systems/device-type1/' + $SystemId + '/nodes/' + $NodeId + '/Powers/' + $PowerId
        return ( Invoke-RestMethod -uriadd $MyAdd -Body ( $MyBody | ConvertTo-Json ) -Method Post -whatifBoolean $WhatIf )
    }       
} 