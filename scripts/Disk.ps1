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
param(  [parameter( mandatory, ValueFromPipeLineByPropertyName=$true )][Alias('id')]                                              
                                                                            [string]    $SystemId,
                                                                            [string]    $DiskId,
                                                                            [switch]    $WhatIf
     )
process
    {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        write-verbose "Dectected the DeviceType is $DeviceType"
        if ( $DeviceType )
            {   $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + '/disks'
                try {   if ( $WhatIf )
                                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyUri -headers $MyHeaders -method Get
                                }   
                            else 
                                {   $SysColOnly = invoke-restmethod -uri $MyUri -headers $MyHeaders -method Get
                                }
                    }
                catch { write-warning "The Attempt the gather information from DSCC failed with API Error"
                    }
                if ( ($SysColOnly).items ) { $SysColOnly = ($SysColOnly).items }
                if (  ($SysColOnly).total -eq 0 )
                    {   Write-Warning "The Call to SystemID $SystemId returned no Disk Records."
                        $SysColOnly = ''
                    }
                if ( $DiskId )
                        {   Write-host "The results of the complete collection have been limited to just the supplied ID"
                            return ( ($SysColOnly) | where-object { $_.id -eq $DiskId } )
                        } 
                    else 
                        {   return $SysColOnly
                        }
            }
        else
            {   Write-Warning "No Valid Storage Systemd Detected using System ID $SystemId."
                return
            }
    }       
}