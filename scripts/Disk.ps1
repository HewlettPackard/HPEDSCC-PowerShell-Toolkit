<#
.SYNOPSIS
    Returns disks for storage systems accessible to an instance of Data Storage Cloud Console (DSCC) Data Ops Manager.
.DESCRIPTION
    Returns disks for storage systems accessible to an instance of Data Storage Cloud Console (DSCC) Data Ops Manager.
    You must be logged in with valid credentials to a HPE GreenLake account.
.PARAMETER SystemID
    Accepts one or more System IDs if specified, or shows disks from all storage systems accessible to this 
    HPE GreenLake account.
.PARAMETER SystemName
    Accepts one or more System names if specified, or shows disks from all storage systems accessible to this 
    HPE GreenLake account.
.PARAMETER DiskId
    Accepts one or more disk IDs.
.EXAMPLE
    PS:> Get-DsccStorageSystem -DeviceType device-type1 | Get-DsccDisk

    Display the disks from all storage systems that are device type 1 (HPE Alletra 9000, HPE Primera and HPE 3PAR)
 .EXAMPLE
    PS:> Get-DsccStorageSystem -DeviceType device-type2 | Get-DsccDisk

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
    PS:> Get-DsccDisk -DiskId '89cc60ca6bc53785aa9ffc07f62eed7b','ec6b431eaec10bc32f1aa5aab67faa93'

    Display information about the specified disk or disks. 
.LINK
    https://github.com/HewlettPackard/HPEDSCC-PowerShell-Toolkit
#> 
function Get-DsccDisk {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'BySystemId')]
    param (
        [Parameter(ValueFromPipeLineByPropertyName, ParameterSetName = 'BySystemId')]
        [alias('id')]
        [string[]]$SystemId,

        [Parameter(ParameterSetName = 'BySystemName')]
        [alias('name')]
        [string[]]$SystemName,

        [string[]]$DiskId
    )
    begin {
        Write-Verbose 'Executing Get-DsccDisk'
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