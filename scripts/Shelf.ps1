function Get-DSCCShelf
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
.PARAMETER DeviceType
    This can either be set to Device-Type1 or Device-Type2, where Device-Type1 refers to 3PAR/Primera/Alletra9K, while Device-Type2 refers to NimbleStorage/Alletra9K.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE

.EXAMPLE

.LINK
#>   
[CmdletBinding()]
param(  [parameter(mandatory)]                                              [string]    $StorageSystemId, 
                                                                            [string]    $ShelfId,
        [parameter(mandatory)][validateset('device-type1','device-type2')]  [string]    $DeviceType,
                                                                            [switch]    $WhatIf
     )
process
    {   $ShelfWord = '/shelves'
        if ( $DeviceType -eq 'device-type1')
            {   $ShelfWord = '/enclosures'
            }
        $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $StorageSystemId + $ShelfWord
        if ( $ShelfId )
            {   $MyUri + $MyUri + '/' + $ShelfId 
            }
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyUri -headers $MyHeaders -method Get
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyUri -headers $MyHeaders -method Get
                }
        if ( ($SysColOnly).items ) { $SysColOnly = ($SysColOnly).items }
        if ( $ShelfId )
                {   Write-host "The results of the complete collection have been limited to just the supplied ID"
                    return ( ($SysColOnly) | where-object { $_.id -eq $ShelfId } )
                } 
            else 
                {   return ( ($SysColOnly) )
                }
    }       
}
function Invoke-DSCCShelfLocate
{
<#
.SYNOPSIS
    Initiates the HPE DSSC DOM Storage Systems Beacon for a specific Storage System    
.DESCRIPTION
    Initiates the HPE Data Services Cloud Console Data Operations Manager Systems Beacon for a specific Storage System
.PARAMETER StorageSystemID
    The single storage systems beacon light will be illuminated
.PARAMETER ShelfID
    The ID for the beacon light will be illuminated
.PARAMETER CId
    The Controller ID for the LED to illuminate, either A or B
.PARAMETER Status
    The status that the light should be set to, either on ($True) or off ($False)
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Invoke-DSCCShelfLocate -StorageSystemId 2M234353456TZ -ShelfId 23980342789432789 -CId A -status $True

.EXAMPLE
    PS:> Invoke-DSCCShelfLocate -StorageSystemId 2M2134T112Z -ShelfId 122342234 -CId A -Status $True -WhatIf
    
    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/storage-systems/device-type2/2M2134T112Z/shelves/122342234/action/locate
    The Method of this call will be
        Post
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IlhwRUVZUGlZWDVkV1JTeDR4SmpNcEVPc1hTSSIsInBpLmF0bSI6ImRlejAifQ.eyJjbGllbnRfaWQiOiIzZjIwODU4NS0zZGE2LTRiZjctOTRjYS00ZjMxMGQwOTYzYjUiLCJpc3MiOiJodHRwczovL3Nzby5jb21tb24uY2xvdWQuaHBlLmNvbSIsImF1ZCI6ImV4dGVybmFsX2FwaSIsInN1YiI6ImNocmlzLmxpb25ldHRpQGhwZS5jb20iLCJ1c2VyX2N0eCI6IjAwNTZiNzFlZWZjNDExZWJhMjY4NjJhZGI4NzdjMmQ4IiwiYXV0aF9zb3VyY2UiOiJjY3NfdG9rZW5fbWFuYWdlbWVudCIsInBsYXRmb3JtX2N1c3RvbWVyX2lkIjoiOGZmYzRiN2VlOWQyMTFlYjhjZWU2ZTEzYzA3MWVhMzciLCJpYXQiOjE2MzYwNzU2NjQsImFwcGxpY2F0aW9uX2luc3RhbmNlX2lkIjoiM2MxOGJkMDMtODMwNi00YzdjLTk0MmUtYzcwNGE0Yjg3NDRjIiwiZXhwIjoxNjM2MDgyODY0fQ.bvcjJqsMO_Ielv2DPepKB_YOuaT5rE8A6T1p29ChOQqJ10W89Ob3-ou4YE_MQa2quaAkgcg_HK7q6AcU3ktmHd_P5l_cNjDkc8XOxux2Bh5n1YGNMkXOY2JPP7GyTOATxopCR311DmXQsUys-hg5LA50g-G8YXbFKzq9zuPIw2MPkEYjQsZ7fglAA36bEd1gQYKB316rrKXFArVMGQUEHJcad3NrkHzDAucw5WB8KkOuFZxN5cr-bShO2R11ZApdQwNRWOl9ph1i2MqjJKrLjSYu_JWeWJLDXoE3-g9gB1C9T4-n9ySLrsa3UT3W6_8v8RnfcuiHq51hcg3ZM9-LZg"
        }
    The Body of this call will be:
        {   "cid":  "A",
            "status":  true
    }
.LINK
#>   
[CmdletBinding()]
param(  [parameter(mandatory)]                          [string]    $StorageSystemId, 
        [parameter(mandatory)]                          [string]    $ShelfId, 
        [parameter(mandatory)][validateset('A','B')]    [string]    $CId,
        [parameter(mandatory)]                          [boolean]   $Status,        
                                                        [switch]    $WhatIf
     )
process
    {   $MyURI = $BaseURI + 'storage-systems/device-type2/' + $StorageSystemId + '/shelves/' + $ShelfId + '/action/locate'
        $MyBody = @{    cid     = $CId 
                        status  = $Status
                   }
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyUri -headers $MyHeaders -body $MyBody -method Post
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyUri -headers $MyHeaders -body $MyBody -method Post
                }
        return $SysColOnly
    }       
}   