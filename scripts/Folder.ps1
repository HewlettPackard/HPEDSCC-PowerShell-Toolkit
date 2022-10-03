function Get-DSCCFolder
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Storage Systems Folders for a specific storage system     
.DESCRIPTION
    Returns the HPE DSSC DOM Storage Systems Folders for a specific storage system 
.PARAMETER StorageSystemID
    A single Storage System ID is specified and required, the pools defined will be returned unless a specific PoolID is requested.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.

.LINK
#>   
[CmdletBinding()]
param(  [parameter(mandatory,ValueFromPipeLineByPropertyName=$true )][Alias('id')]                                              
                                                                            [string]    $systemId, 
                                                                            [string]    $folderId,
                                                                            [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -systemId $systemId )
        switch ( $DeviceType )
        {   'device-type1'  {   write-warning "This command only works on Device-Type 2 devices." 
                                return
                            }
            'device-type2'  {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $systemId + '/folders'
                                $SysColOnly = invoke-DSCCrestmethod -uriadd $MyAdd -method Get -whatifBoolean
                                $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Folder"
                                if ( $folderId )
                                        {   return ( $ReturnData | where-object { $_.id -eq $folderId } )
                                        } 
                                    else 
                                        {   return $ReturnData
                                        }
                            }
        }       
    }       
}   