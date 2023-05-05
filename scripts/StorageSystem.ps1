<#
.SYNOPSIS
    Returns the storage systems accessible to an instance of Data Storage Cloud Console (DSCC) Data Ops Manager.
.DESCRIPTION
    Returns the storage systems accessible to an instance of Data Storage Cloud Console (DSCC) Data Ops Manager.
    You must be logged in with valid credentials to a HPE GreenLake account.
.PARAMETER SystemID
    Accepts one or more System IDs if specified, or shows all storage systems accessible to this HPE GreenLake account.
.PARAMETER SystemName
    Accepts one or more System names if specified, or shows all storage systems accessible to this HPE GreenLake account.
.PARAMETER DeviceType
    This can either be set to device-type1 (referring to HPE Alletra 9000, HPE Primera or HPE 3PAR) or device-type2, 
    (referring to HPE Alletra 6000 or 5000). If this parameter is not specified, both device types are displayed.
.EXAMPLE
    PS:> Get-DSCCStorageSystem -DeviceType device-type1
    
    Displays information about all HPE Alletra 9000, HPE Primera and HPE 3PAR storage systems accessible to this 
    instance of DSCC Data Ops Manager.
.EXAMPLE
    PS:> Get-DSCCStorageSystem -DeviceType device-type2

    Displays information about all HPE Alletra 6000 and 5000 storage systems accessible to this instance of
    DSCC Data Ops Manager.
.EXAMPLE
    PS:Get-DsccStorageSystem
    
    Displays all storage systems accessible to this instance of DSCC Data Ops Manager.
.EXAMPLE
    PS:>Get-DsccStorageSystem -SystemId 003a78e8778c204dc2000000000000000000000001

    Display information about the specific storage system(s) accessible to this instance of DSCC Data Ops Manager.
.EXAMPLE
    PS:>Get-DsccStorageSystem -SystemName tmehou-pod1-primera2,tme-pod1-alletra6k

    Display information about the specified system system(s) accessible to this instance of DSCC Data Ops Manager.
.EXAMPLE
    PS:> Get-DSCCStorageSystem -WhatIf

    Displays information about the RESTApi call itself, rather than displaying the data. No call is made to the RESTApi.
.OUTPUTS
    Returns objects of type DSCC.StorageSystem.Combined, made up of storage systems with device type 1 and 2. There 
    are some common properties between them but not all properties are common
.LINK
    https://github.com/HewlettPackard/HPEDSCC-PowerShell-Toolkit
#>
function Get-DsccStorageSystem { 
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'BySystemId')]
    param (
        [Parameter(ParameterSetName = 'BySystemId')]
        [alias('id')]
        [string[]]$SystemId,

        [Parameter(ParameterSetName = 'BySystemName')]
        [alias('name')]
        [string[]]$SystemName,
        
        [parameter(helpMessage = 'The acceptable values are device-type1 or device-type2.')]
        [validateset('device-type1', 'device-type2')]  
        [string]$DeviceType
    )
    begin {
        Write-Verbose 'Executing Get-DsccStorageSystem'
        if ($PSBoundParameters.ContainsKey('SystemName')) {
            $SystemId = Get-DsccSystemIdFromName -SystemName $SystemName
        }
    }
    process {
        if ( $DeviceType ) { 
            $DevType = $DeviceType
        }
        else {
            $DevType = @( 'device-type1', 'device-type2')
        }

        $SystemCollection = @()
        foreach ( $ThisDeviceType in $DevType ) {
            $UriAdd = "storage-systems/$ThisDeviceType"
            $RawObject = Invoke-DsccRestMethod -UriAdd $UriAdd -method Get -WhatIf:$WhatIfPreference
            if ($PSBoundParameters.ContainsKey('SystemId') -or $PSBoundParameters.ContainsKey('SystemName')) {
                $RawObject = $RawObject | Where-Object id -In $SystemId
            }
            $Returndata = Invoke-RepackageObjectWithType -RawObject $RawObject -ObjectName 'StorageSystem.Combined'
            $SystemCollection += $Returndata    
        }
        Write-Output $SystemCollection
    } #end process

    end {
        # If no parameters are specified, take the opportunity to update the Global variable 
        # Note: -Verbose does not affect this, if specified.
        foreach ($ExcludeParam in $('SystemId', 'DeviceType', 'WhatIf')) {
            if ($ExcludeParam -in $PSBoundParameters.Keys) {
                Write-Output 'Global Variable $DsccStorageSystem not updated'
                return
            }
        }
        $GlobalSystem = @{}
        foreach ($ThisSystem in $SystemCollection) {
            $GlobalSystem += @{
                Name       = $ThisSystem.Name
                Id         = $ThisSystem.Id
                DeviceType = ([regex]::Matches($ThisSystem.resourceUri, 'device-type\d')).Value
            }
        }
        $Global:DsccStorageSystem = [pscustomobject]$GlobalSystem
        Write-Verbose 'Global Variable $DsccStorageSystem updated'
    }
} #end Get-DsccStorageSystem

<#
.SYNOPSIS
    Enables the locate beacon for the specified storage system.
.DESCRIPTION
    Enables the locate beacon for the specified storage system. This is command is only valid for device type 1 
    storage systems (HPE Alletra 9000, HPE Primera and HPE 3PAR).
    You must be logged in with valid credentials to a HPE GreenLake account.
.PARAMETER SystemID
    The single storage systems beacon light will be illuminated
.EXAMPLE
    PS:> Enable-DsccStorageSystemLocate -SystemId 2M234353456TZ

    Enables the locate beacon for the specified system
.EXAMPLE
    PS:> Enable-DsccStorageSystemLocate -WhatIf

    Displays information about the RESTApi call itself, rather than displaying the data. No call is made to the RESTApi.
.LINK
    https://github.com/HewlettPackard/HPEDSCC-PowerShell-Toolkit
#>  
function Enable-DsccStorageSystemLocate { 
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'BySystemId')]
    param(
        [Parameter(ValueFromPipeLineByPropertyName, ParameterSetName = 'BySystemId')]
        [alias('id')]
        [string[]]$SystemId,

        [Parameter(ParameterSetName = 'BySystemName')]
        [alias('name')]
        [string[]]$SystemName
    )
    begin {
        Write-Verbose 'Executing Enable-DsccStorageSystemLocate'
        if ($PSBoundParameters.ContainsKey('SystemName')) {
            $SystemId = Get-DsccSystemIdFromName -SystemName $SystemName
        }
    }
    process {
        foreach ($ThisId in $SystemId) {
            $UriAdd = "storage-systems/device-type1/$ThisId" 
            $Body = @{
                locateEnabled = $true
            } | ConvertTo-Json
            Invoke-DsccRestMethod -UriAdd $UriAdd -Body $Body -Method Post -WhatIf:$WhatIfPreference
        }
    }
}

<#
.SYNOPSIS
    Disables the locate beacon for the specified storage system.
.DESCRIPTION
    Disables the locate beacon for the specified storage system. This is command is only valid for device type 1 
    storage systems (HPE Alletra 9000, HPE Primera and HPE 3PAR).
    You must be logged in with valid credentials to a HPE GreenLake account.
.PARAMETER SystemID
    The single storage systems beacon light will be disabled.
.EXAMPLE
    PS:> Disable-DsccStorageSystemLocate -SystemId 2M234353456TZ

    Enables the locate beacon for the specified system
.EXAMPLE
    PS:> Disable-DsccStorageSystemLocate -WhatIf

    Displays information about the RESTApi call itself, rather than displaying the data. No call is made to the RESTApi.
.LINK
    https://github.com/HewlettPackard/HPEDSCC-PowerShell-Toolkit
#>  
function Disable-DsccStorageSystemLocate { 
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'BySystemId')]
    param(
        [Parameter(ValueFromPipeLineByPropertyName, ParameterSetName = 'BySystemId')]
        [alias('id')]
        [string[]]$SystemId,

        [Parameter(ParameterSetName = 'BySystemName')]
        [alias('name')]
        [string[]]$SystemName
    )
    begin {
        Write-Verbose 'Executing Enable-DsccStorageSystemLocate'
        if ($PSBoundParameters.ContainsKey('SystemName')) {
            $SystemId = Get-DsccSystemIdFromName -SystemName $SystemName
        }
    }
    process {
        foreach ($ThisId in $SystemId) {
            $UriAdd = "storage-systems/device-type1/$ThisId" 
            $Body = @{
                locateEnabled = $false
            } | ConvertTo-Json
            Invoke-DsccRestMethod -UriAdd $UriAdd -Body $Body -Method Post -WhatIf:$WhatIfPreference
        }
    }
}