function Get-DSCCCertificate
{
<#
.SYNOPSIS
    Returns Certificate data for a storage system {DeviceType-1} 
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager Certificate data for a storage system {DeviceType-1} 
.PARAMETER systemID
    The required system ID to query for the alerts
.PARAMETER CertificateID
    A Specific Certificate to retrieve from the System ID specific. 
.PARAMETER select
    Example: 'id'
    Query to select only the required parameters, separated by . if nested
.PARAMETER limit
    Limits the number of responses
.PARAMETER offset
    The offset of the first item in the collection to return
.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE
    PS:> Get-DSCCCertificate -SystemID 12 -certificateId 21341234 -whatIf

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call
    The URI for this call will be
        https://pavo-user-api.common.cloud.hpe.com/api/v1Data-Ops-Manager-ProductType1-Volumes/storage-systems/device-type1/12/certificate/21341234
    The Method of this call will be 
        Get
    The Header for this call will be :
        {   "Content":  "application/json",
            "X-Auth-Token":  "123"
        }
    The Body of this call will be:
        {}
.EXAMPLE
    PS:> Get-DSCCStorageSystem -DeviceType device-type1 | Get-DSCCCertificate

    id                               systemId   displayname                           certtype fingerprint
    --                               --------   -----------                           -------- -----------
    da350f1b0945df4d4bf3de976fc0fbab 2M2042059T Certificate hpe.com CA - Intermediate intca    df394db1c7e2964a4d09ff51cb0613637de1d325
    57142be4da5c0980e7a5e07b16950d78 2M2042059T Certificate 2M2042059T                cert     daf4ac9d4f245a11b40b1ae4e5096b861aed159f
    7fa0b6bafa03a7a9079e11d36cd5e996 2M2042059T Certificate hpe.com CA - Root         rootca   8dc7f5891a5329c02f7aaeb489cebc00c285cd89
    4bacf3f2212fa819018a97c3b185c28c 2M2042059T Certificate HPE_3PAR A630-2M2042059T  cert     b6faf6a923cfdf324e92547ed7803dfb9ba7bf86
    abc262c9b0097508872555e71751004c 2M202205GG Certificate hpe.com CA - Root         rootca   8dc7f5891a5329c02f7aaeb489cebc00c285cd89
    70204c140f3d07be7b5a6db2b0a6db27 2M202205GG Certificate hpe.com CA - Intermediate intca    df394db1c7e2964a4d09ff51cb0613637de1d325
    ee5f51b62e30348d8336db3bb94ceaca 2M2042059X Certificate hpe.com CA - Root         rootca   8dc7f5891a5329c02f7aaeb489cebc00c285cd89
    e2d5a10c2f91dd0908df3f4ef3066924 2M2042059X Certificate HPE_3PAR A630-2M2042059X  cert     21e91f9060706eb17f3a05a330b449d40210ff4a
    8415bf51bc5c2c448768e7e21ff93993 2M2019018G Certificate hpe.com CA - Root         rootca   8dc7f5891a5329c02f7aaeb489cebc00c285cd89
    bf4b738626fd71c3cc0be61740b1100b 2M2019018G Certificate hpe.com CA - Intermediate intca    df394db1c7e2964a4d09ff51cb0613637de1d325
    3155164bf6035ae734687f415a50d7c7 2M202205GF Certificate hpe.com CA - Intermediate intca    df394db1c7e2964a4d09ff51cb0613637de1d325
    6c8147a658f8a0f97c0442aaa8d8cc9a 2M202205GF Certificate 2M202205GF                intca    9ab6290b4f95f2b85a5e00db92a317c24ae6ee21

.EXAMPLE
    PS:> Get-DSCCCertificate -SystemId 2M2042059T

    id                               systemId   displayname                           certtype fingerprint
    --                               --------   -----------                           -------- -----------
    da350f1b0945df4d4bf3de976fc0fbab 2M2042059T Certificate hpe.com CA - Intermediate intca    df394db1c7e2964a4d09ff51cb0613637de1d325
    57142be4da5c0980e7a5e07b16950d78 2M2042059T Certificate 2M2042059T                cert     daf4ac9d4f245a11b40b1ae4e5096b861aed159f
    7fa0b6bafa03a7a9079e11d36cd5e996 2M2042059T Certificate hpe.com CA - Root         rootca   8dc7f5891a5329c02f7aaeb489cebc00c285cd89
    4bacf3f2212fa819018a97c3b185c28c 2M2042059T Certificate HPE_3PAR A630-2M2042059T  cert     b6faf6a923cfdf324e92547ed7803dfb9ba7bf86
    e766500b75f853dde01548238d83115f 2M202205GG Certificate 2M202205GG                cert     1f7074a294a35bdd53b1bdc398e470f334ef4a22

#>
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [parameter( mandatory, ValueFromPipeLineByPropertyName=$true )][Alias('id')]                                              
                                                                                        [string]   $SystemId,
                                                                                        [string]   $CertificateID,
                                                                                        [switch]   $whatIf
        )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemID + '/certificates'
        if ( $CertificateID )
                {   $MyURI = $MyURI + '/' + $CertificateId
                }   
        $SysColOnly = invoke-DSCCrestmethod -uriAdd $MyAdd -method 'Get' -WhatIfBoolean $WhatIf
        $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Certificate.$DeviceType"
        return $ReturnData
    }       
}   