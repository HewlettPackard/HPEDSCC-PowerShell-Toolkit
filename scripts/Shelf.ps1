function Get-DSCCShelf
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Shelves for a specific storage system     
.DESCRIPTION
    Returns the HPE DSSC DOM Shelves for a specific storage system 
.PARAMETER StorageSystemID
    A single Storage System ID is specified and required, the pools defined will be returned unless a specific Shelf ID is requested.
    You can feed the output of the Get-DSCCStorageSystems command to this command to specify the required parameter.
.PARAMETER ShelfID
    If a single Storage System Disk ID is specified, only that Disk will be returned.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-DSCCStorageSystem -DeviceType device-type1 | Get-DSCCShelf

    Id                               Model          Serial Number  SystemId   Detailed Name     Overall Status
    --                               -----          -------------  --------   -------------     --------------
    0929bb1a282fc6ea8d81549e77dca70c HPE     600 2N PWDRRA2LMDS00R 2M2042059T Drive Enclosure 0 STATE_NORMAL
    269fe18d901c8173d70697a7aff46d7c HPE     600 2N PWDRRA2LMDS01O 2M2042059V Drive Enclosure 0 STATE_NORMAL
    33ca0ba3498759d593028ad3db5539ad HPE     600 2N PWDRRA1LMD1040 2M202205GF Drive Enclosure 0 STATE_NORMAL
    0c6c79380a69c35d1a41fa47c086e834 HPE     600 2N PWDRRA2LMDS07C 2M2042059X Drive Enclosure 0 STATE_NORMAL
    6ab4ad21f76e1623ba6879bee11788a5 HPE     600 2N PWDRRA1LMCT05E 2M202205GG Drive Enclosure 0 STATE_NORMAL
    9b8276f429f20287faf3c4ecab95d4f9 HPE     600 2N PWDRRA1LMD107J 2M2019018G Drive Enclosure 0 STATE_NORMAL
.EXAMPLE
    PS:> Get-DSCCStorageSystem -DeviceType device-type2 | Get-DSCCShelf

    Id                                         Model          Serial Number System Name          Detailed Name     PSU Status Fan Status Temp Status
    --                                         -----          ------------- -----------          -------------     ---------- ---------- -----------
    2d06b878a5a008ec63000000010000414600032098 AF40-2P2QF-11T AF-204952     TMEHOU-Pod3-Nimble   chassis_nmbl_4u24 OK         OK         OK
    2d0849204632ec0d70000000010000414600037375 AF40-QP2QF-46T AF-226165     TMEHOL-POD2-AF40     chassis_nmbl_4u24 OK         OK         OK
    2d3be9f65d5b1de4fd000000010000414600036c15 6050-4N2QY-46T AF-224277     tmehou-pod1-bluetail chassis_nmbl_4u24 OK         OK         OK
.EXAMPLE
    PS:> Get-DSCCShelf -SystemId 000849204632ec0d70000000000000000000000001

    Id                                         Model          Serial Number System Name      Detailed Name     PSU Status Fan Status Temp Status
    --                                         -----          ------------- -----------      -------------     ---------- ---------- -----------
    2d0849204632ec0d70000000010000414600037375 AF40-QP2QF-46T AF-226165     TMEHOL-POD2-AF40 chassis_nmbl_4u24 OK         OK         OK
.EXAMPLE
    PS:>Get-DSCCStorageSystem | Get-DSCCShelf

    Id                                         Model               Serial Number   SystemId or Name Detailed Name     Overall Status PSU/Fan/Temp Status
    --                                         -----               -------------   ---------------- -------------     -------------- -------------------
    f6852422f12b903df418c541ac4ff464           --                  SHM1002657RBMM1 MXN5442108       unknown           STATE_DEGRADED
    2d0f2fad32a41581b2000000010000637300000000 Virtual-6G-12T-320F cs-fdcad6       ppatil-cds-8050  chassis_smc_3u16                 OK OK OK
    2d3a78e8778c204dc20000000100004146000384e4 6030-4NQY-46T       AF-230628       rtp-afa184       chassis_nmbl_4u24                OK OK OK
.LINK
.OUTPUTS
    The commmand should return an object of data type DSCC.Shelf.Combined which the default formatters
#>   
[CmdletBinding()]
param(  [parameter( mandatory, ValueFromPipeLineByPropertyName=$true )][Alias('id')]                                              
                                                                            [string]    $SystemId, 
                                                                            [string]    $ShelfId,
                                                                            [switch]    $WhatIf
     )
process
    { Invoke-DSCCAutoReconnect
      $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
      if ( $DeviceType )
            {   $ShelfWord = '/shelves'
                if ( $DeviceType -eq 'Device-Type1')
                    {   $ShelfWord = '/enclosures'
                    }
                $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + $ShelfWord
                $SysColOnly = Invoke-DSCCRestMethod -UriAdd $MyAdd -method Get -WhatIfBoolean $WhatIf                
                $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Shelf.Combined"
                if ( $ShelfId )
                        {   Write-host "The results of the complete collection have been limited to just the supplied ID"
                            return ( $ReturnData | where-object { $_.id -eq $ShelfId } )
                        } 
                    else 
                        {   return $ReturnData
                        }
            }
        else 
            {   write-warning "The Storage System ID presented was not detected."
                return  
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
param(  [parameter(mandatory,ValueFromPipeLineByPropertyName=$true )][Alias('id')]                          
                                                        [string]    $SystemId, 
        [parameter(mandatory)]                          [string]    $ShelfId, 
        [parameter(mandatory)][validateset('A','B')]    [string]    $CId,
        [parameter(mandatory)]                          [boolean]   $Status,        
                                                        [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        if ( $DeviceType )
            {   $MyAdd = 'storage-systems/' + $DeviceType2 + '/' + $SystemId + '/shelves/' + $ShelfId + '/action/locate'
                $MyBody = @{    cid     = $CId 
                                status  = $Status
                           } 
                return Invoke-DSCCRestMethod -UriAdd $MyAdd -body ( $MyBody | ConvertTo-json ) -method Post -WhatIfBoolean $WhatIf
            } 
            else 
            {   Write-Warning "No StorageSystem detected with a valid that valid System ID"  
                return          
            }
    }       
}   