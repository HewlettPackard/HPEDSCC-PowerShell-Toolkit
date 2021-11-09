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
    PS:>Get-DSCCCertificate -SystemID 2M202205GF  | format-table

    id                               uri                                                   systemId   displayname                           domain commonname
    --                               ---                                                   --------   -----------                           ------ ----------
    6c8147a658f8a0f97c0442aaa8d8cc9a /api/v3/certificates/6c8147a658f8a0f97c0442aaa8d8cc9a 2M202205GF Certificate 2M202205GF                       2M202205GF
    3155164bf6035ae734687f415a50d7c7 /api/v3/certificates/3155164bf6035ae734687f415a50d7c7 2M202205GF Certificate hpe.com CA - Intermediate        hpe.com CA - Interme...
    d689398f8b71b4f5548fbe8e574276c0 /api/v3/certificates/d689398f8b71b4f5548fbe8e574276c0 2M202205GF Certificate hpe.com CA - Root                hpe.com CA - Root
    26eff476fdf58cc3c2b93b0a07f74b6a /api/v3/certificates/26eff476fdf58cc3c2b93b0a07f74b6a 2M202205GF Certificate HPE_3PAR A630-2M202205GF         HPE_3PAR A630-2M2022...
#>
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(ParameterSetName='ByCertificateId')]
[Parameter(Mandatory=$true,ParameterSetName='Default')]     [string]   $SystemID,
        [Parameter(ParameterSetName='ByCertificateId')]     [string]   $CertificateID,
        [Parameter(ParameterSetName='Default')]             [string]   $select,
        [Parameter(ParameterSetName='Default')]             [string]   $limit,
        [Parameter(ParameterSetName='Default')]             [int]      $offset,
        [Parameter(ParameterSetName='ByCertificateId')]
        [Parameter(ParameterSetName='Default')]             [switch]   $whatIf
        )
process
    {   $MyURI = $BaseUri + 'storage-systems/device-type1/' + $SystemID + '/certificates'
        $MyBody=@{}
        if ( $CertificateID )
                {   $MyURI = $MyURI + '/' + $CertificateId
                }   
            else 
                {   if ( $select )          { $MyBody += @{ select = $select } } 
                    if ( $limit  )          { $MyBody += @{ limit = $limit } } 
                    if ( $offset )          { $MyBody += @{ offset = $offset } } 
                }
        if ( $WhatIf )
                {   $collect = invoke-restmethodWhatIf -uri $MyURI -Headers $MyHeaders -body $MyBody -method 'Get'
                }
            else 
                {   $collect = invoke-restmethod -uri $MyURI -Headers $MyHeaders -body $MyBody -method 'Get' 
                }
        if ( ($Collect).items )
                {   $Collect = ($Collect).items
                }
        return $collect      
    }       
}   