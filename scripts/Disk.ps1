<#
.SYNOPSIS
    Returns disk objects from HPE Data Services Cloud Console (DSCC), Data Ops Manager for a specific storage system.
.DESCRIPTION
    Returns disk objects from HPE Data Services Cloud Console (DSCC), Data Ops Manager for a specific storage system.
    You must be connected to HPE GreenLake via a valid account.
.PARAMETER SystemID
    Accepts one or more storage system IDs. Disks from all storage systems associated with the current HPE GreenLafe account
    will be displayed if no system id is specified. 
.EXAMPLE
    PS:> Get-DSCCStorageSystem -DeviceType device-type1 | Get-DSCCdisk

    This command displays the disks from all storage systems that are device type 1 (HPE Alletra 9000, HPE Primera and HPE 3PAR)
 .EXAMPLE
    PS:> Get-DSCCStorageSystem -DeviceType device-type2 | Get-DSCCdisk

    This command displays the disks from all storage systems that are device type 1 (HPE Alletra 6000 and 5000)
.EXAMPLE
    PS:> Get-DSCCDisk -SystemId 2M2042059T

    This command displays the disks from the specified device type 1 storage system.
.EXAMPLE
    PS:> Get-DSCCDisk -SystemId 000849204632ec0d70000000000000000000000001

    This command displays the disks from the specified device type 2 storage system.
.EXAMPLE
    PS:> Get-DSCCDisk -SystemId 000849204632ec0d70000000000000000000000001 -WhatIf -Verbose

    This command displays information about the REST call itself rather than the data from the array(s), consisting of
    the URI, header, method and body of the call to the API. This is useful for troubleshooting.
.LINK
    https://github.com/HewlettPackard/HPEDSCC-PowerShell-Toolkit
#> 
function Get-DsccDisk {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [parameter(ValueFromPipeLineByPropertyName)]
        [alias('id')]
        [string[]]$SystemId = ((Get-DSCCStorageSystem).Id)
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
                    Invoke-RepackageObjectWithType -RawObject $RawObject -ObjectName 'Disk.Combined'
                }
            }
            elseif ($DeviceType -eq 'device-type2') {
                $UriAdd = "storage-systems/$DeviceType/$ThisId/disks"
                $RawObject = Invoke-DsccRestMethod -uriadd $UriAdd -Method Get -WhatIf:$WhatIfPreference
                Invoke-RepackageObjectWithType -RawObject $RawObject -ObjectName 'Disk.Combined'
            }
            else {
                Write-Error "Unsupported device type found for system $ThisId"
            }
        } #end foreach
    } #end process
} #end Get-DsccDisk