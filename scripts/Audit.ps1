function Get-DSCCAuditEvent
{
<#
.SYNOPSIS
    Returns the DSCC Audit and Events information.    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager Audit and Event information;
.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE
    PS:> Get-DSCCAuditEvent

    id                              loggedAt             message                                                    state            userEmail
    --                              --------             -------                                                      -----            ---------
    da171da2-708d-4d1d-b1b3-b91df8b 2021-12-02T18:05:36Z Unauthorized user access                                   PermissionDenied chris.lionetti@hpe.com
    dea78fb6-705b-4aa6-8ceb-af60e20 2021-12-02T16:27:30Z Export volume TesVolumes.0 - Initiated                     Initiated        chris.lionetti@hpe.com
    6bb156fc-3a98-4b1a-a00e-9b05c39 2021-12-02T16:27:30Z Export volume TesVolumes.2 - Initiated                     Initiated        chris.lionetti@hpe.com
    6b255f71-405b-41df-90fa-56e72f3 2021-12-02T16:27:30Z Export volume TesVolumes.2 - Completed                     Success          chris.lionetti@hpe.com
    fb656da3-1bbe-4ef3-b52b-27718d0 2021-12-02T16:27:30Z Parent Task : Creating 3 DeviceType2 Volume(s)-Completed   Success          chris.lionetti@hpe.com
    1e025981-14e4-4133-90cc-98a57f0 2021-12-02T16:27:30Z Create volume TesVolumes.0 - Initiated                     Initiated        chris.lionetti@hpe.com
.EXAMPLE
    PS:> Get-DSCCAuditEvent -whatif

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/audit-events
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciOiJ...glRiODredKeRORGKIkesKew"
        }
    The Body of this call will be:
        "No Body"
#>   
[CmdletBinding()]
param(  [switch]    $whatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyAdd = 'audit-events'
        $SysColOnly = Invoke-DSCCRestMethod -uriadd $MyAdd -method 'Get' -whatifBoolean $WhatIf 
        $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Audit"
        return $ReturnData  
    }       
}   