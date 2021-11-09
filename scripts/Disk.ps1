function Get-DSCCDisk
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Disks for a specific storage system     
.DESCRIPTION
    Returns the HPE DSSC DOM Disks for a specific storage system 
.PARAMETER StorageSystemID
    A single Storage System ID is specified and required, the pools defined will be returned unless a specific Disk ID is requested.
.PARAMETER DiskID
    If a single Storage System Disk ID is specified, only that Disk will be returned.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE

.EXAMPLE

.LINK
#>   
[CmdletBinding()]
param(  [parameter(mandatory)]                                              [string]    $StorageSystemId, 
                                                                            [string]    $DiskId,
        [parameter(mandatory)][validateset('device-type1','device-type2')]  [string]    $DeviceType,
                                                                            [switch]    $WhatIf
     )
process
    {   $MyURI = $BaseURI + 'storage-systems/device-type2/' + $StorageSystemId + '/disks'
        if ( $DiskId )
            {   $MyUri + $MyUri + '/' + $DiskId 
            }
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyUri -headers $MyHeaders -method Get
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyUri -headers $MyHeaders -method Get
                }
        if ( ($SysColOnly).items ) { $SysColOnly = ($SysColOnly).items }
        if ( $DiskId )
                {   Write-host "The results of the complete collection have been limited to just the supplied ID"
                    return ( ($SysColOnly) | where-object { $_.id -eq $DiskId } )
                } 
            else 
                {   return ( ($SysColOnly) )
                }
    }       
}