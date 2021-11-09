function Get-DSCCMail
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Storage Systems Email and SMTP settings    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager Storage Systems Email and SMTP settings
.PARAMETER SystemID
    A single Storage System ID is specified.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:>Get-DSCCmail -SystemId 2M2042059T

    mailHostDomain         : smtp2go.com
    mailHostServer         : mail.smtp2go.com
    port                   : 25
    senderEmailId          : tmehou-pod1-primera2@hpe.com
    authenticationRequired : disabled
    username               :
    friendlyCert           :
    type                   : mail-settings
    customerId             : 0056b71eefc411eba26862adb877c2d8
    generation             : 1636042836956
    consoleUri             : /data-ops-manager/storage-systems/device-type1/2M2042059T/settings/system-settings
    associatedLinks        : {@{type=systems; resourceUri=/api/v1/storage-systems/device-type1/2M2042059T}}
    requestUri             : https://scalpha-app.qa.cds.hpe.com/api/v1/storage-systems/device-type1/2M2042059T/mail-
                             settings
.EXAMPLE
    PS:>Get-DSCCmail -SystemId 2M2042059T -WhatIf

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/storage-systems/device-type1/2M2042059T/mail-settings
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6Ik5EUk1nXzk0S0p6ZmNkOG9SQ1Bzbnp6eXdYdyIsInBpLmF0bSI6ImRlejAifQ.eyJjbGllbnRfaWQiOiIzZjIwODU4NS0zZGE2LTRiZjctOTRjYS00ZjMxMGQwOTYzYjUiLCJpc3MiOiJodHRwczovL3Nzby5jb21tb24uY2xvdWQuaHBlLmNvbSIsImF1ZCI6ImV4dGVybmFsX2FwaSIsInN1YiI6ImNocmlzLmxpb25ldHRpQGhwZS5jb20iLCJ1c2VyX2N0eCI6IjAwNTZiNzFlZWZjNDExZWJhMjY4NjJhZGI4NzdjMmQ4IiwiYXV0aF9zb3VyY2UiOiJjY3NfdG9rZW5fbWFuYWdlbWVudCIsInBsYXRmb3JtX2N1c3RvbWVyX2lkIjoiOGZmYzRiN2VlOWQyMTFlYjhjZWU2ZTEzYzA3MWVhMzciLCJpYXQiOjE2MzYxNDQzOTQsImFwcGxpY2F0aW9uX2luc3RhbmNlX2lkIjoiM2MxOGJkMDMtODMwNi00YzdjLTk0MmUtYzcwNGE0Yjg3NDRjIiwiZXhwIjoxNjM2MTUxNTk0fQ.P-OhnKmWiynFexDYHZ3omRxFWqksg0cCvA8z2fwlqns88yjp3YoEzsj-OTx8K60RtV0UnDUqq0JzeClAuH9qExAjxEx5kxs7oFgrkz97pxmnhrrglAoB1RXDbTb8VHtEOgpsx5_1vqmh9Btai5aYx54Ubxi5PtVoUGoDlX44crvtdhApb7jor4GEvSK1zQSWVYlpGEaqfvgZ9DhcCjXP-vMGpM9nOSh3oiPnSkt4aWlde6DmgKQWYG5jUsdM_XdBhQ7hJlyPme8pgruEGF24UMQN-5k-hFayACDd9W2fcf9BLhBNqi9FKvcvWaVI6bgSi2MDmcQ5oKNMpZYUbAI9Mw"
        }
    The Body of this call will be:
        "No Body"
.LINK
#>   
[CmdletBinding()]
param(      [parameter(mandatory)]  [string]    $SystemId, 
                                    [switch]    $WhatIf
     )
process
    {   $MyURI = $BaseURI + 'storage-systems/device-type1/' + $SystemId + '/mail-settings'
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyUri -headers $MyHeaders -method Get
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyUri -headers $MyHeaders -method Get
                }
        if ( ($SysColOnly).items )  {   $SysColOnly = ($SysColOnly).items }
        return $SysColOnly
    }       
} 
function New-DSCCMail
{
<#
.SYNOPSIS
    Adds new HPE DSSC DOM Storage Systems Email and SMTP settings    
.DESCRIPTION
    Adds new HPE Data Services Cloud Console Data Operations Manager Storage Systems Email and SMTP settings
.PARAMETER SystemID
    A single Storage System ID is specified and required.
.PARAMETER mailHostDomain
    string or null, SMTP server's Host Domain
.PARAMETER mailHostServer
    SMTP server address/IP
.PARAMETER port
    SMTP server's port number
.PARAMETER senderEmailId
	Sender email address
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> New-DSCCMail -SystemId '12345' -mailHostDomain 'MyDomain.com' -mailHostServer 'MyServer' -port 52 -senderEmailId 'chris@MyDomain.com' -whatif

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/storage-systems/device-type1/12345/mail-settings
    The Method of this call will be
        Delete
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6Ik5EUk1nXzk0S0p6ZmNkOG9SQ1Bzbnp6eXdYdyIsInBpLmF0bSI6ImRlejAifQ.eyJjbGllbnRfaWQiOiIzZjIwODU4NS0zZGE2LTRiZjctOTRjYS00ZjMxMGQwOTYzYjUiLCJpc3MiOiJodHRwczovL3Nzby5jb21tb24uY2xvdWQuaHBlLmNvbSIsImF1ZCI6ImV4dGVybmFsX2FwaSIsInN1YiI6ImNocmlzLmxpb25ldHRpQGhwZS5jb20iLCJ1c2VyX2N0eCI6IjAwNTZiNzFlZWZjNDExZWJhMjY4NjJhZGI4NzdjMmQ4IiwiYXV0aF9zb3VyY2UiOiJjY3NfdG9rZW5fbWFuYWdlbWVudCIsInBsYXRmb3JtX2N1c3RvbWVyX2lkIjoiOGZmYzRiN2VlOWQyMTFlYjhjZWU2ZTEzYzA3MWVhMzciLCJpYXQiOjE2MzYxNDQzOTQsImFwcGxpY2F0aW9uX2luc3RhbmNlX2lkIjoiM2MxOGJkMDMtODMwNi00YzdjLTk0MmUtYzcwNGE0Yjg3NDRjIiwiZXhwIjoxNjM2MTUxNTk0fQ.P-OhnKmWiynFexDYHZ3omRxFWqksg0cCvA8z2fwlqns88yjp3YoEzsj-OTx8K60RtV0UnDUqq0JzeClAuH9qExAjxEx5kxs7oFgrkz97pxmnhrrglAoB1RXDbTb8VHtEOgpsx5_1vqmh9Btai5aYx54Ubxi5PtVoUGoDlX44crvtdhApb7jor4GEvSK1zQSWVYlpGEaqfvgZ9DhcCjXP-vMGpM9nOSh3oiPnSkt4aWlde6DmgKQWYG5jUsdM_XdBhQ7hJlyPme8pgruEGF24UMQN-5k-hFayACDd9W2fcf9BLhBNqi9FKvcvWaVI6bgSi2MDmcQ5oKNMpZYUbAI9Mw"
        }
    The Body of this call will be:
        {   "port":  52,
            "mailHostServer":  "MyServer",
            "mailHostDomain":  "MyDomain.com",
            "senderEmailId":  "chris@MyDomain.com"
        }
.EXAMPLE
    PS:> Add-DSCCMail -SystemId '12345' -mailHostDomain 'MyDomain.com' -mailHostServer 'MyServer' -port 52 -senderEmailId 'chris@MyDomain.com'

    message : "Successfully submitted",
    status : "SUBMITTED",
    taskUri : "/rest/vega/v1/tasks/4969a568-6fed-4915-bcd5-e4566a75e00c"

.LINK
#>   
[CmdletBinding()]
param(      [parameter(mandatory)]  [string]    $SystemId,
                                    [string]    $mailHostDomain,
                                    [string]    $mailHostServer,
                                    [int]       $port,
                                    [string]    $senderEmailId,
                                    [switch]    $WhatIf
     )
process
    {   $MyURI = $BaseURI + 'storage-systems/device-type1/' + $SystemId + '/mail-settings'
        $MyBody = @{}
        if ( $mailHostDomain )  { $MyBody += @{ mailHostDomain  = $mailHostDomain   } }
        if ( $mailHostServer )  { $MyBody += @{ mailHostServer  = $mailHostServer   } }
        if ( $Port )            { $MyBody += @{ port            = $port             } }
        if ( $senderEmailId )   { $MyBody += @{ senderEmailId   = $senderEmailId    } }
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyUri -headers $MyHeaders -body $MyBody -method Post
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyUri -headers $MyHeaders -body $MyBody -method Post
                }
        if ( ($SysColOnly).items )  {   $SysColOnly = ($SysColOnly).items }
        return $SysColOnly
    }       
} 
function Set-DSCCMail
{
<#
.SYNOPSIS
    Edits HPE DSSC DOM Storage Systems Email and SMTP settings    
.DESCRIPTION
    Edits HPE Data Services Cloud Console Data Operations Manager Storage Systems Email and SMTP settings
.PARAMETER SystemID
    A single Storage System ID is specified and required.
.PARAMETER mailHostDomain
    string or null, SMTP server's Host Domain
.PARAMETER mailHostServer
    SMTP server address/IP
.PARAMETER port
    SMTP server's port number
.PARAMETER senderEmailId
	Sender email address
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> New-DSCCMail -SystemId '12345' -mailHostDomain 'MyDomain.com' -mailHostServer 'MyServer' -port 52 -senderEmailId 'chris@MyDomain.com' -whatif

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/storage-systems/device-type1/12345/mail-settings
    The Method of this call will be
        Put
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6Ik5EUk1nXzk0S0p6ZmNkOG9SQ1Bzbnp6eXdYdyIsInBpLmF0bSI6ImRlejAifQ.eyJjbGllbnRfaWQiOiIzZjIwODU4NS0zZGE2LTRiZjctOTRjYS00ZjMxMGQwOTYzYjUiLCJpc3MiOiJodHRwczovL3Nzby5jb21tb24uY2xvdWQuaHBlLmNvbSIsImF1ZCI6ImV4dGVybmFsX2FwaSIsInN1YiI6ImNocmlzLmxpb25ldHRpQGhwZS5jb20iLCJ1c2VyX2N0eCI6IjAwNTZiNzFlZWZjNDExZWJhMjY4NjJhZGI4NzdjMmQ4IiwiYXV0aF9zb3VyY2UiOiJjY3NfdG9rZW5fbWFuYWdlbWVudCIsInBsYXRmb3JtX2N1c3RvbWVyX2lkIjoiOGZmYzRiN2VlOWQyMTFlYjhjZWU2ZTEzYzA3MWVhMzciLCJpYXQiOjE2MzYxNDQzOTQsImFwcGxpY2F0aW9uX2luc3RhbmNlX2lkIjoiM2MxOGJkMDMtODMwNi00YzdjLTk0MmUtYzcwNGE0Yjg3NDRjIiwiZXhwIjoxNjM2MTUxNTk0fQ.P-OhnKmWiynFexDYHZ3omRxFWqksg0cCvA8z2fwlqns88yjp3YoEzsj-OTx8K60RtV0UnDUqq0JzeClAuH9qExAjxEx5kxs7oFgrkz97pxmnhrrglAoB1RXDbTb8VHtEOgpsx5_1vqmh9Btai5aYx54Ubxi5PtVoUGoDlX44crvtdhApb7jor4GEvSK1zQSWVYlpGEaqfvgZ9DhcCjXP-vMGpM9nOSh3oiPnSkt4aWlde6DmgKQWYG5jUsdM_XdBhQ7hJlyPme8pgruEGF24UMQN-5k-hFayACDd9W2fcf9BLhBNqi9FKvcvWaVI6bgSi2MDmcQ5oKNMpZYUbAI9Mw"
        }
    The Body of this call will be:
        {   "port":  52,
            "mailHostServer":  "MyServer",
            "mailHostDomain":  "MyDomain.com",
            "senderEmailId":  "chris@MyDomain.com"
        }
.EXAMPLE
    PS:> Add-DSCCMail -SystemId '12345' -mailHostDomain 'MyDomain.com' -mailHostServer 'MyServer' -port 52 -senderEmailId 'chris@MyDomain.com'

    message : "Successfully submitted",
    status : "SUBMITTED",
    taskUri : "/rest/vega/v1/tasks/4969a568-6fed-4915-bcd5-e4566a75e00c"

.LINK
#>   
[CmdletBinding()]
param(      [parameter(mandatory)]  [string]    $SystemId,
                                    [string]    $mailHostDomain,
                                    [string]    $mailHostServer,
                                    [int]       $port,
                                    [string]    $senderEmailId,
                                    [switch]    $WhatIf
     )
process
    {   $MyURI = $BaseURI + 'storage-systems/device-type1/' + $SystemId + '/mail-settings'
        $MyBody = @{}
        if ( $mailHostDomain )  { $MyBody += @{ mailHostDomain  = $mailHostDomain   } }
        if ( $mailHostServer )  { $MyBody += @{ mailHostServer  = $mailHostServer   } }
        if ( $Port )            { $MyBody += @{ port            = $port             } }
        if ( $senderEmailId )   { $MyBody += @{ senderEmailId   = $senderEmailId    } }
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyUri -headers $MyHeaders -body $MyBody -method Put
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyUri -headers $MyHeaders -body $MyBody -method Put
                }
        if ( ($SysColOnly).items )  {   $SysColOnly = ($SysColOnly).items }
        return $SysColOnly
    }       
} 
function Remove-DSCCMail
{
<#
.SYNOPSIS
    Removes the HPE DSSC DOM Storage Systems Email and SMTP settings    
.DESCRIPTION
    Removes the HPE Data Services Cloud Console Data Operations Manager Storage Systems Email and SMTP settings
.PARAMETER SystemID
    A single Storage System ID is specified and required.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE

.LINK
#>   
[CmdletBinding()]
param(      [parameter(mandatory)]  [string]    $SystemId, 
                                    [switch]    $WhatIf
     )
process
    {   $MyURI = $BaseURI + 'storage-systems/device-type1/' + $SystemId + '/mail-settings'
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyUri -headers $MyHeaders -method Delete
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyUri -headers $MyHeaders -method Delete
                }
        if ( ($SysColOnly).items )  {   $SysColOnly = ($SysColOnly).items }
        return $SysColOnly
    }       
} 