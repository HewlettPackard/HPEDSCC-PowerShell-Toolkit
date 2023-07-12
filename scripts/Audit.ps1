function Get-DSCCAuditEvent
{
<#
.SYNOPSIS
    Returns the DSCC Audit and Events information.    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Audit and Event information;
.PARAMETER id
    You can retrieve a single audit event ID by offing the ID of the specific ID to recover.
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
.LINK
    More details about the operation of this API can be found at https://console-us1.data.cloud.hpe.com/doc/api/v1/ under audit-events.
.NOTES 
    This version of the command will change soon as the new API Update has changed, and this location to gather events is not the published API location. 
#>   
[CmdletBinding()]
param(  [string]    $EventId,
        [switch]    $whatIf
    )
process
    {   $MyUri = 'audit-events'
        $SysColOnly = Invoke-DSCCRestMethod -uriadd $MyUri -method 'Get' -whatifBoolean $WhatIf        
        if ( $EventId )  { $SysColOnly = ( $SysColOnly | where-object { $_.id -eq $EventId }) }
        return ( Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Audit" )
    }       
}   
function Get-DSCCAuditEventDeviceType2
{
<#
.SYNOPSIS
    Returns the DSCC Audit and Events information for a specific Storage System of Device-Type 2.    
.DESCRIPTION
    Returns the DSCC Audit and Events information for a specific Storage System of Device-Type 2.
.PARAMETER SystemId
    You can retrieve a single device-type 2 storage sytems audit events by offing the ID of the specific system to recover.
.PARAMETER EventId
    You can retrieve a single device-type 2 storage sytems audit event specificed by an Event ID by offing the ID of the specific system to recover.
.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE
    PS:> Get-DSCCAuditEvent

    id                              loggedAt             message                                                    state            userEmail
    --                              --------             -------                                                      -----            ---------
    da171da2-708d-4d1d-b1b3-b91df8b 2021-12-02T18:05:36Z Unauthorized user access                                   PermissionDenied chris.lionetti@hpe.com
    dea78fb6-705b-4aa6-8ceb-af60e20 2021-12-02T16:27:30Z Export volume TesVolumes.0 - Initiated                     Initiated        chris.lionetti@hpe.com
    1e025981-14e4-4133-90cc-98a57f0 2021-12-02T16:27:30Z Create volume TesVolumes.0 - Initiated                     Initiated        chris.lionetti@hpe.com

    # This option would get all Device-Type2 Storage Systems events
.EXAMPLE
    PS:> Get-DSCCAuditEventDeviceType2 -SystemId 003a78e8778c204dc2000000000000000000000001

    id                              loggedAt             message                                                    state            userEmail
    --                              --------             -------                                                      -----            ---------
    da171da2-708d-4d1d-b1b3-b91df8b 2021-12-02T18:05:36Z Unauthorized user access                                   PermissionDenied chris.lionetti@hpe.com
    dea78fb6-705b-4aa6-8ceb-af60e20 2021-12-02T16:27:30Z Export volume TesVolumes.0 - Initiated                     Initiated        chris.lionetti@hpe.com
    1e025981-14e4-4133-90cc-98a57f0 2021-12-02T16:27:30Z Create volume TesVolumes.0 - Initiated                     Initiated        chris.lionetti@hpe.com

    # This option would get all the events for a specific Storage System
.EXAMPLE
    PS:> Get-DSCCAuditEventDeviceType2 -SystemId 003a78e8778c204dc2000000000000000000000001 -EventId 183a78e8778c204dc2000000000000000000001556 

    id                                         timestamp  category      severity summary                                           activity
    --                                         ---------  --------      -------- -------                                           --------
    183a78e8778c204dc2000000000000000000001556 1638212762 cloud_console info     Array connected successfully to the cloud console Array AF-230628 connected successfully to the cloud console: tunnel-scint-app.qa.cds.hpe.com:443.

    # This option would get ONLY a specific event from a specific storage system
.EXAMPLE
    PS:> Get-DSCCAuditEventDeviceType2 -SystemId 003a78e8778c204dc2000000000000000000000001 -EventId 183a78e8778c204dc2000000000000000000001556 -whatIf
    WARNING: You have selected the What-IF option, so the call will not be made to the array,
    instead you will see a preview of the RestAPI call
    The URI for this call will be
    https://scint-app.qa.cds.hpe.com/api/v1/storage-systems/device-type2/003a78e8778c204dc2000000000000000000000001/events/183a78e8778c204dc2000000000000000000001556
    The Method of this call will be
    Get
    The Header for this call will be :
        {   "Authorization": "Bearer eyJhbGciOiJSUzI1...hgxmbYbLxg51PJXSEnrCsIXYxd0A"
        }
    The Content-Type is set to
        application/json
    The Body of this call will be:
        No Body
.LINK
    More details about the operation of this API can be found at https://console-us1.data.cloud.hpe.com/doc/api/v1/ under audit-events.
#>   
[CmdletBinding()]
param(  [string]    $SystemId,
        [string]    $EventId,
        [switch]    $whatIf
    )
process
    {   if ( -not $PSBoundParameters.ContainsKey('SystemId' ) )
    {   # This is the recursive part where we will run against ALL systemIDs if none given.
        write-warning "No SystemID Given, running all SystemIDs"
        $ReturnCol=@()
        foreach( $Sys in Get-DSCCStorageSystem )
            {   write-verbose "Walking Through Multiple Systems"
                If ( ($Sys).Id )
                        {   write-verbose "Found a system with a System.id"
                            IF ( $WhatIf )  { $ReturnCol += Get-DSCCAuditEventDeviceType2 -SystemId ($Sys).Id -WhatIf    }
                            else            { $ReturnCol += Get-DSCCAuditEventDeviceType2 -SystemId ($Sys).Id            }      
                        }
            }
        write-verbose "Returning the Multiple System Id Events."
        if ( $EventId ) {   $ReturnCol = ( $ReturnCol | where-object { $_.id -eq $EventId } )   }
        return $ReturnCol
    }
else 
    {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        if ( $DeviceType )
            {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/events'
                if ( $EventId ) { $MyAdd += '/' + $EventId }
                $SysColOnly = Invoke-DSCCRestMethod -UriAdd $MyAdd -method Get -whatifBoolean $WhatIf
                # if ( $EventId ) { $SysColOnly = ( $SysColOnly | where-object { $_.id -eq $EventId } ) }
                return ( Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "AuditEvent" )
            }
    } 
}      
}  