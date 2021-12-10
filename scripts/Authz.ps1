function Get-DSCCAccessControl
{
<#
.SYNOPSIS
    Returns the DSCC Authz Access Controls.    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager Access Controls information;
.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE
    PS:> Get-DSCCAccessControl

.EXAMPLE
    PS:> Get-DSCCAccessControl -whatIf

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/access-controls
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGcsONZZjviVT71xz0...iGDDefq_9NEzKX-CsC2dLww8WglRiODredKeRORGKIkesKew"
        }
    The Body of this call will be:
        "No Body"
#>   
[CmdletBinding()]
param(  [switch]    $whatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyURI = $BaseURI + 'access-controls'
        if ( $WhatIf )
                {   $FullObjSet = invoke-restmethodWhatIf -uri $MyURI -Headers $MyHeaders  -method 'Get'
                }
            else
                {   try     {   $FullObjSet = Invoke-RestMethod -uri $MyURI -Headers $MyHeaders  -method 'Get' 
                            }   
                    catch   {   write-warning "The call for audits and events returned nothing."
                            }
                }
        if ( ($FullObjSet).items )
                {   return ($FullObjSet).items 
                }
            else 
                {   return $FullObjSet   
                }
    }       
}   
function Get-DSCCResourceType
{
<#
.SYNOPSIS
    Returns the DSCC Authz Resource Types.    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager Resource Types information;
.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE
    PS:> Get-DSCCResourceType

    .EXAMPLE
    PS:> Get-DSCCResourceType -whatIf

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/access-controls
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGcsONZZjviVT71xz0...iGDDefq_9NEzKX-CsC2dLww8WglRiODredKeRORGKIkesKew"
        }
    The Body of this call will be:
        "No Body"
#>   
[CmdletBinding()]
param(  [switch]    $whatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyURI = $BaseURI + 'resource-types'
        if ( $WhatIf )
                {   $FullObjSet = invoke-restmethodWhatIf -uri $MyURI -Headers $MyHeaders  -method 'Get'
                }
            else
                {   try     {   $FullObjSet = Invoke-RestMethod -uri $MyURI -Headers $MyHeaders  -method 'Get' 
                            }   
                    catch   {   write-warning "The call for audits and events returned nothing."
                            }
                }
        if ( ($FullObjSet).items )
                {   return ($FullObjSet).items 
                }
            else 
                {   return $FullObjSet   
                }
    }       
}   