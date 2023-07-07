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
                                                                            [switch]    $WhatIf
    )
process
    {   if ( -not $PSBoundParameters.ContainsKey('SystemId' ) )
                {   write-verbose "No SystemID Given, running all SystemIDs"
                    $ReturnCol=@()
                    foreach( $Sys in Get-DSCCStorageSystem )
                        {   write-verbose "Walking Through Multiple Systems"
                            If ( ($Sys).Id )
                                {   write-verbose "Found a system with a System.id"
                                    $ReturnCol += ( Get-DSCCFolder -SystemId ($Sys).Id -WhatIf $WhatIf )
                                }
                        }
                    write-verbose "Returning the Multiple System Id Certificates."
                    return $ReturnCol
                }
            else 
                {   Invoke-DSCCAutoReconnect
                    $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -systemId $systemId )
                    switch ( $DeviceType )
                        {   'device-type1'  {   write-warning "This command only works on Device-Type 2 devices." 
                                                return
                                            }
                            'device-type2'  {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $systemId + '/folders'
                                                $SysColOnly = invoke-DSCCrestmethod -uriadd $MyAdd -method Get -whatifBoolean $whatif
                                                $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Folder"
                                                return $ReturnData
                                            }
                        }       
                }
    }       
}   