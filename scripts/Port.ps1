function Get-DSCCPort
{
<#
.SYNOPSIS
    Retreive the iSCSI and FC Ports on the target System
.DESCRIPTION
    Retreive the iSCSI and FC Ports on the target System
.PARAMETER SystemID
    A Single System ID that should be interrogated, this is a mandatory field but can be populated from the pipeline.
.PARAMETER PortID
    This is the single PortID to be retrieved if it exists, otherwise all ports will be returned.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-DSCCPort -SystemId 0006b878a5a008ec63000000000000000000000001 | format-table

    id                             array_name_or_serial array_id                    controller... controller_id                name   mac               is_present
    --                             -------------------- --------                    ------------- -------------                ----   ---               ---
    1c06b878a5a008ec630000010a0000 TMEHOU-Pod3-Nimble   0906b878a5a008ec63000000001 A             c306b878a5a008ec630100000000 eth0a  A4:BF:01:44:13:D5 True
    1c06b878a5a008ec630001021b0000 TMEHOU-Pod3-Nimble   0906b878a5a008ec63000000001 B             c306b878a5a008ec630100000001 tg1b   00:E0:ED:94:34:A3 True
    2106b878a5a008ec63000000000003 TMEHOU-Pod3-Nimble                               A                                          fc2c.1
    2106b878a5a008ec6300000000000e TMEHOU-Pod3-Nimble                               B                                          fc3b.1
.EXAMPLE
    PS:> Get-DSCCPort -SystemId 2M2042059T | format-table

    cardType                                nodeCardId                       devices                                configMode connectionType displayname failoverStatus fcData
    --------                                ----------                       -------                                ---------- -------------- ----------- -------------- ------
    @{default=iSCSI; key=pcicard_type-3}    1446e8bc92a5f117e60a6a927c17cf79                                        Host                      Port 1:4:3  None
    @{default=iSCSI; key=pcicard_type-3}    1446e8bc92a5f117e60a6a927c17cf79                                        Host                      Port 1:4:1  None
    @{default=SAS; key=pcicard_type-5}      dd6c9dcebf11e213245cb6bceaf4bf6b                                        Disk       Point          Port 0:0:1  -              @{nodeWWN=50002ACFF7026AFD; portWWN=50002AC001...
    @{default=SAS; key=pcicard_type-5}      dd6c9dcebf11e213245cb6bceaf4bf6b {@{name=cage0; position=0}}            Disk       Point          Port 0:0:2  -              @{nodeWWN=50002ACFF7026AFD; portWWN=50002AC002...
    @{default=iSCSI; key=pcicard_type-3}    1446e8bc92a5f117e60a6a927c17cf79                                        Host                      Port 1:4:2  None
    @{default=FC; key=pcicard_type-1}       d3b91a158321a5e751810b12123dca35 {@{name=21330002AC025F8B; position=0}} RCFC       Point          Port 1:3:3  -              @{nodeWWN=2FF70002AC026AFD; portWWN=21330002AC...
    @{default=iSCSI; key=pcicard_type-3}    f2e5dc4a5ec76a42f08d1e417ce276a6                                        Host                      Port 0:4:3  None
    @{default=Ethernet; key=pcicard_type-2} bfd70ee8e54b4885b99
.LINK
#>   
[CmdletBinding()]
param(  [parameter( mandatory, ValueFromPipeLineByPropertyName=$true )][Alias('id')][string]    $SystemId,
                                                                                    [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        if ( $DeviceType )
            {   $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + '/ports'
                $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/ports'
                $SysColOnly = invoke-DSCCRestMethod -UriAdd $MyAdd -Method Get -WhatIfBoolean $WhatIf
                if ( $DeviceType -eq 'device-type2')
                    {   $SysColOnly1 = (( $SysColOnly ).network_interfaces )
                        $SysColOnly2 = (( $SysColOnly ).fibre_channel_interfaces )
                        $SysColOnly  = @( $SysColOnly1, $SysColOnly2 )
                    }
                $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Port.$DeviceType"
                return $ReturnData
            }
        else
            {   Write-Warning "No Valid Storage Systemd Detected using System ID $SystemId"
                return
            }
    }       
}