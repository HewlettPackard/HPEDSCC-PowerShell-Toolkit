function Get-DSCCEvent
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Storage Systems Events    
.DESCRIPTION
    Returns the HPE DSSC DOM Storage Systems Events
.PARAMETER StorageSystemID
    A single Storage System ID is specified and required, the events will be returned unless a specific EventId is requested.
.PARAMETER DeviceType
    This can either be set to Device-Type1 or Device-Type2, where Device-Type1 refers to 3PAR/Primera/Alletra9K, while Device-Type2 refers to NimbleStorage/Alletra9K.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-HPEDSCCDOMEvent -StorageSystemId 2M202205GG -DeviceType device-type1

    
.EXAMPLE
    PS:> Get-DSCCEvent -StorageSystemId 2M202205GG -DeviceType device-type1 -eventID 3ff8fa3d971f16948fd9cff800775b9d -whatif
    
    
.EXAMPLE
    PS:> Get-DSCCEvent -StorageSystemId 2M202205GG -DeviceType device-type1 | format-table
  
.LINK
#>   
[CmdletBinding()]
param(  [parameter( mandatory, ValueFromPipeLineByPropertyName=$true )][Alias('id')]                                              
                                                                            [string]    $SystemId, 
                                                                            [string]    $EventId,
                                                                            [switch]    $WhatIf
     )
process
    {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        write-verbose "Dectected the DeviceType is $DeviceType"
        if ( $DeviceType )
                { $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + '/events'
                    if ( $EventId )
                            {   $MyURI = $MyURI + '/' + $EventId 
                            }
                    if ( $WhatIf )
                            {   $SysColOnly = invoke-restmethodWhatIf -uri $MyURI -headers $MyHeaders -method Get
                            }
                        else 
                            {   Try     {   $SysColOnly = invoke-restmethod -uri $MyURI -headers $MyHeaders -method Get
                                        }
                                Catch   {   Write-warning "The Call to System ID $SystemId to gather Events Failed."
                                            $SysColOnly = ''
                                        }
                            }
                    if ( ($SysColOnly).items ) { $SysColOnly = ($SysColOnly).items }
                    if ( $EventId )
                            {   Write-host "The results of the complete collection have been limited to just the supplied ID"
                                return ( (($SysColOnly)) | where-object { $_.id -eq $EventId } )
                            }
                        else 
                            {   return ( (($SysColOnly)) )
                            }
                }
            else 
                {   write-warning "The System with the System ID of $SystemId was not found."
                
            }
    }       
} 
