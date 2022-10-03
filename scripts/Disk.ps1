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
    PS:> Get-DSCCStorageSystem -DeviceType device-type1 | Get-DSCCdisk

    id                               name   wwn              displayName                           systemId   encosureId                       enclosureName enclosureType
    --                               ----   ---              -----------                           --------   ----------                       ------------- -------------
    898333cdcb23f3b28640ec056ebe72e6 0:20:0 002538F401005192 Drive Enclosure Disk 0.SIDE_NONE.20.0 2M2042059T 0929bb1a282fc6ea8d81549e77dca70c cage0         ENCLOSURE_DCN5
    fcae935fdd39e38dfc10e57789a03393 0:19:0 002538F4010051A0 Drive Enclosure Disk 0.SIDE_NONE.19.0 2M2042059T 0929bb1a282fc6ea8d81549e77dca70c cage0         ENCLOSURE_DCN5
    5906dadf09f9a84c1a74a14511301029 0:17:0 002538F401005197 Drive Enclosure Disk 0.SIDE_NONE.17.0 2M2042059T 0929bb1a282fc6ea8d81549e77dca70c cage0         ENCLOSURE_DCN5
    4e8a78e143f218deff00449347d6a2bb 0:19:0 002538F40100518A Drive Enclosure Disk 0.SIDE_NONE.19.0 2M2042059V 269fe18d901c8173d70697a7aff46d7c cage0         ENCLOSURE_DCN5
    61661c558978b3d87df3f381a2b98fa6 0:17:0 002538F401005173 Drive Enclosure Disk 0.SIDE_NONE.17.0 2M2042059V 269fe18d901c8173d70697a7aff46d7c cage0         ENCLOSURE_DCN5
.EXAMPLE
    PS:> Get-DSCCStorageSystem -DeviceType device-type2 | Get-DSCCdisk

    id                                         model                      serial             bank slot arrayId                                    arrayName            shelfLocation shelfSerial
    --                                         -----                      ------             ---- ---- -------                                    ---------            ------------- -----------
    2c06b878a5a008ec630001000000000b0000000b00 INTEL SSDSC2BB480G7        PHDV804403D9480BGN 0    11   0906b878a5a008ec63000000000000000000000001 TMEHOU-Pod3-Nimble   B.0           AF-204952
    2c06b878a5a008ec630001000000000b0000001400 INTEL SSDSC2BB480G7        PHDV804403F0480BGN 0    20   0906b878a5a008ec63000000000000000000000001 TMEHOU-Pod3-Nimble   B.0           AF-204952
    2c06b878a5a008ec630001000000000b0000001000 INTEL SSDSC2BB480G7        PHDV80440277480BGN 0    16   0906b878a5a008ec63000000000000000000000001 TMEHOU-Pod3-Nimble   B.0           AF-204952
    2c06b878a5a008ec630001000000000b0000000500 INTEL SSDSC2BB480G7        PHDV804403AU480BGN 0    5    0906b878a5a008ec63000000000000000000000001 TMEHOU-Pod3-Nimble   B.0           AF-204952
    2c06b878a5a008ec630001000000000b0000000800 INTEL SSDSC2BB480G7        PHDV804404FZ480BGN 0    8    0906b878a5a008ec63000000000000000000000001 TMEHOU-Pod3-Nimble   B.0           AF-204952
    2c06b878a5a008ec630001000000000b0000000900 INTEL SSDSC2BB480G7        PHDV804401DE480BGN 0    9    0906b878a5a008ec63000000000000000000000001 TMEHOU-Pod3-Nimble   B.0           AF-204952
.EXAMPLE
    PS:> Get-DSCCDisk -SystemId 2M2042059T

    id                               name   wwn              displayName                           systemId   encosureId                       enclosureName enclosureType
    --                               ----   ---              -----------                           --------   ----------                       ------------- -------------
    898333cdcb23f3b28640ec056ebe72e6 0:20:0 002538F401005192 Drive Enclosure Disk 0.SIDE_NONE.20.0 2M2042059T 0929bb1a282fc6ea8d81549e77dca70c cage0         ENCLOSURE_DCN5
    25e48e6ce009ec2687c3d421bb951605 0:21:0 002538F40100519C Drive Enclosure Disk 0.SIDE_NONE.21.0 2M2042059T 0929bb1a282fc6ea8d81549e77dca70c cage0         ENCLOSURE_DCN5
    6b5ca17ecd0ccc9462bef616130078c5 0:16:0 002538F401005193 Drive Enclosure Disk 0.SIDE_NONE.16.0 2M2042059T 0929bb1a282fc6ea8d81549e77dca70c cage0         ENCLOSURE_DCN5
.EXAMPLE
    PS:> Get-DSCCDisk -SystemId 000849204632ec0d70000000000000000000000001

    id                                         model                      serial         bank slot arrayId                                    arrayName        shelfLocation shelfSerial
    --                                         -----                      ------         ---- ---- -------                                    ---------        ------------- -----------
    2c0849204632ec0d700001000000000a0000000200 SAMSUNG MZ7LH1T9HMLT-00005 S455NC0NB08330 0    2    090849204632ec0d70000000000000000000000001 TMEHOL-POD2-AF40 A.0           AF-226165
    2c0849204632ec0d700001000000000a0000000900 SAMSUNG MZ7LH1T9HMLT-00005 S455NC0NB08340 0    9    090849204632ec0d70000000000000000000000001 TMEHOL-POD2-AF40 A.0           AF-226165
    2c0849204632ec0d700001000000000a0000001000 SAMSUNG MZ7LH1T9HMLT-00005 S455NC0NB14060 0    16   090849204632ec0d70000000000000000000000001 TMEHOL-POD2-AF40 A.0           AF-226165
.EXAMPLE
    PS:> Get-DSCCDisk -SystemId 000849204632ec0d70000000000000000000000001 -WhatIf

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://fleetscale-app.qa.cds.hpe.com/api/v1/storage-systems/device-type2/000849204632ec0d70000000000000000000000001/disks
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6Inh0UGFCcHI1ZjRieVdGaXNqX0tsV1JiaXVVdyIsInBpLmF0bSI6ImRlejAifQ.eyJjbGllbnRfaWQiOiJmYjA5Yzk1MS03NzNiLTRkNzgtOTI1ZS1kMmUzZTMwZjFhZGMiLCJpc3MiOiJodHRwczovL3Nzby5jb21tb24uY2xvdWQuaHBlLmNvbSIsImF1ZCI6ImV4dGVybmFsX2FwaSIsInN1YiI6ImNocmlzLmxpb25ldHRpQGhwZS5jb20iLCJ1c2VyX2N0eCI6ImZmYzMxMTQ2M2Q4NzExZWNiZGQ1NDI4NjA3ZWUxNzA0IiwiYXV0aF9zb3VyY2UiOiJjY3NfdG9rZW5fbWFuYWdlbWVudCIsInBsYXRmb3JtX2N1c3RvbWVyX2lkIjoiOGZmYzRiN2VlOWQyMTFlYjhjZWU2ZTEzYzA3MWVhMzciLCJpYXQiOjE2Mzg0ODQwNjIsImFwcGxpY2F0aW9uX2luc3RhbmNlX2lkIjoiOTBjYTg5MjMtZjI4YS00OTkxLTg4NmItMTgyOWRhYWU4YWFjIiwiZXhwIjoxNjM4NDkxMjYyfQ.CNDYWJ8Mvsf0Xt9HHrxPX4MXg4OooTzxdB69PdFniFzC51BUOkJpymkK_np4XkOeeJdLePSY95taxxtZb7OapQZAY4zH2giYapoNNnaGCUS_2x9P_yOrAhSeE1068iSt-6Gt5r7HUm0tU2qAiG7psmVPnHSOoW0GqAgYsR2Q6HBtrolhQ2K_luYenNwJZtU8YaoAMev5LBl84gScFKyLHzJYb5QcQfd1CC_IN1iLhsupadW6eySVgU6NRw9enbkse-sW33KunV2ZDRxSQQ5EzrD3x4Fef4hDangyQ5iX4AW5tsJf5HXIrWDGpBItrkZX_wdujUA7ZF9XTzksX7pzZg"
        }
    The Body of this call will be:
        "No Body"
.LINK
#>   
[CmdletBinding()]
param(  [parameter( mandatory, ValueFromPipeLineByPropertyName=$true )][Alias('id')]                                              
                                                                            [string]    $SystemId,
                                                                            [string]    $DiskId,
                                                                            [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        if ( $DeviceType )
            {   switch ( $DeviceType )
                {   'device-type2'  {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/disks'
                                        $SysColOnly = invoke-DSCCrestmethod -uriadd $MyAdd -method Get -whatifBoolean $WhatIf
                                        $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Disk.Combined"
                                        if ( $DiskId )
                                                {   Write-host "The results of the complete collection have been limited to just the supplied ID"
                                                    return ( $ReturnData | where-object { $_.id -eq $DiskId } )
                                                } 
                                            else 
                                                {   return $ReturnData
                                                }   
                                    }
                    'device-type1'  {   $Shelflist = Get-DSCCShelf -systemId $SystemID  
                                        foreach ( $Shelfid in $Shelflist )
                                            {   $Shelfid = $Shelfid.Id
                                                $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/enclosures/' + $Shelfid +'/enclosure-disks'
                                                $SysColOnly = invoke-DSCCrestmethod -uriAdd $MyAdd  -method Get -whatifBoolean $WhatIf
                                                $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Disk.Combined"
                                                if ( $DiskId )
                                                        {   Write-host "The results of the complete collection have been limited to just the supplied ID"
                                                            return ( $ReturnData | where-object { $_.id -eq $DiskId } )
                                                        } 
                                                    else 
                                                        {   return $ReturnData
                                                        }         
                                            } 
                                    }
                }  
            }
        return
    }       
}