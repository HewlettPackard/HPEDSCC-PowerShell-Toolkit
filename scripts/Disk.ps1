<#
.SYNOPSIS
    Returns disk objects from HPE Data Services Cloud Console (DSCC), Data Ops Manager for a specific storage system.
.DESCRIPTION
    Returns disk objects from HPE Data Services Cloud Console (DSCC), Data Ops Manager for a specific storage system.
    You must be connected to HPE GreenLake via a valid account.
.PARAMETER SystemID
    Accepts one or more storage system IDs. Disks from all storage systems associated with the current HPE GreenLafe account
    will be displayed if no system id is specified.
.PARAMETER DiskId
    Accepts one or more disk IDs.
.EXAMPLE
    PS:> Get-DsccStorageSystem -DeviceType device-type1 | Get-Dsccdisk

    Display the disks from all storage systems that are device type 1 (HPE Alletra 9000, HPE Primera and HPE 3PAR)
 .EXAMPLE
    PS:> Get-DsccStorageSystem -DeviceType device-type2 | Get-Dsccdisk

    Display the disks from all storage systems that are device type 1 (HPE Alletra 6000 and 5000)
.EXAMPLE
    PS:> Get-DsccDisk -SystemId 2M2042059T

    Display the disks from the specified device type 1 storage system.
.EXAMPLE
    PS:> Get-DsccDisk -SystemId 000849204632ec0d70000000000000000000000001

    Display the disks from the specified device type 2 storage system.
.EXAMPLE
    PS:> Get-DsccDisk -SystemId 000849204632ec0d70000000000000000000000001 -WhatIf -Verbose

    Display information about the REST call itself rather than the data from the array(s), consisting of
    the URI, header, method and body of the call to the API. This is useful for troubleshooting.
.EXAMPLE
    PS:> Get-DsccDisk -DiskId ''89cc60ca6bc53785aa9ffc07f62eed7b','ec6b431eaec10bc32f1aa5aab67faa93'

    Display information about the specified disk or disks. 
.LINK
    https://github.com/HewlettPackard/HPEDSCC-PowerShell-Toolkit
#> 
function Get-DsccDisk {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [parameter(ValueFromPipeLineByPropertyName)]
        [alias('id')]
        [string[]]$SystemId = ((Get-DSCCStorageSystem).Id),

        [string[]]$DiskId
    )
    begin {
        Write-Verbose 'Executing Get-DsccDisk'
    }
    process {
        foreach ($ThisId in $SystemId) {
            $DeviceType = (Find-DSCCDeviceTypeFromStorageSystemID -SystemId $ThisId)
            if (-not $DeviceType) {
                return
            }
            elseif ($DeviceType -eq 'device-type1') {
                foreach ( $ShelfId in ((Get-DSCCShelf -SystemId $ThisId).Id)) {
                    $UriAdd = "storage-systems/$DeviceType/$ThisId/enclosures/$ShelfId/enclosure-disks"
                    $RawObject = Invoke-DsccRestMethod -uriAdd $UriAdd  -Method Get -WhatIf:$WhatIfPreference
                    if ($PSBoundParameters.ContainsKey('DiskId')) {
                        $RawObject = $RawObject | Where-Object id -In $DiskId
                    }
                    Invoke-RepackageObjectWithType -RawObject $RawObject -ObjectName 'Disk.Combined'
                }
            }
            elseif ($DeviceType -eq 'device-type2') {
                $UriAdd = "storage-systems/$DeviceType/$ThisId/disks"
                $RawObject = Invoke-DsccRestMethod -uriadd $UriAdd -Method Get -WhatIf:$WhatIfPreference
                if ($PSBoundParameters.ContainsKey('DiskId')) {
                    $RawObject = $RawObject | Where-Object id -In $DiskId
                }
                Invoke-RepackageObjectWithType -RawObject $RawObject -ObjectName 'Disk.Combined'
            }
            else {
                Write-Error "Unsupported device type found for system $ThisId"
            }
        } #end foreach
    } #end process
} #end Get-DsccDisk