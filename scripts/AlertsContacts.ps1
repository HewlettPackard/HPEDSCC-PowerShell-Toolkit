function Get-DSCCAlertOrContact
{
<#
.SYNOPSIS
    Returns the DSCC Alerts and Contact Information    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager Alerts and Contact information;
.PARAMETER systemID
    The required system ID to query for the alerts
.PARAMETER Alertid
    If multiple alerts exist, Will limit the data returned to a single event identified by ID
.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE
    PS:> Get-DSCCAlertOrContact -SystemId 2M2042059T
    [   {   "company": "HPE",
            "companyCode": "HPE",
            "consoleUri": "data-ops-manager/storage-systems/device-type1/SGH014XGSP/settings/system-settings",
            "country": "US",
            "customerId": "fc5f41652a53497e88cdcebc715cc1sd",
            "fax": "+1 323 555 1234",
            "firstName": "john",
            "generation": 1627540907421,
            "id": "67d09515-8526-9b02-c0c4-c1f443a39402",
            "includeSvcAlerts": false,
            "lastName": "kevin",
            "notificationSeverities": [],
            "preferredLanguage": "en",
            "primaryEmail": "kevin.john@hpe.com",
            "primaryPhone": "98783456",
            "receiveEmail": true,
            "receiveGrouped": true,
            "secondaryEmail": "winny.pooh@hpe.com",
            "secondaryPhone": "23456789",
            "systemId": "7CE751P312",
            "systemSupportContact": false,
            "type": "alert-contacts"
        }
    ]
.EXAMPLE
    PS:> # The following command will detect any outstanding Alerts on all arrays of device-type1
    PS:> Get-DSCCStorageSystem -DeviceType device-type1 | Get-DSCCAlertOrContact
    
    WARNING: The call for alerts to system ID 2M2042059T returned nothing.
    WARNING: The call for alerts to system ID 2M202205GG returned nothing.
    WARNING: The call for alerts to system ID 2M2042059X returned nothing.
#>   
[CmdletBinding()]
param(  [parameter( mandatory, ValueFromPipeLineByPropertyName=$true )][Alias('id')]                                              
                                                                                [string]    $SystemId,
                                                                                [string]    $AlertId,
                                                                                [switch]    $whatIf
     )
process
    {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        write-verbose "Dectected the DeviceType is $DeviceType"
        if ( $DeviceType -eq 'device-type1' )
                {   $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + '/alert-contacts'
                    if ( $AlertId ) 
                            {   $MyURI = $MyURI + '/' + $AlertId 
                            }
                    if ( $WhatIf )
                            {   $FullObjSet = invoke-restmethodWhatIf -uri $MyURI -Headers $MyHeaders  -method 'Get'
                            }
                        else
                            {   try     {   $FullObjSet = Invoke-RestMethod -uri $MyURI -Headers $MyHeaders  -method 'Get' 
                                        }   
                                catch   { write-warning "The call for alerts to system ID $SystemId returned nothing."
                                        }
                            }
                    return $FullObjSet
                }
            else 
                {   if ( -not $DeviveType ) 
                            {   Write-Warning "This command only works against System with Device-Type 1."
                            }
                        else 
                            {   Write-Warning "No Valid Storage Systemd Detected using System ID $SystemId."
                    
                            }
                    return 
                
                }
           
    }       
}   
function Remove-DSCCAlertOrContact
{
<#
.SYNOPSIS
    Removes a HPE DSSC DOM Alert.    
.DESCRIPTION
    Removes a HPE Data Services Cloud Console Data Operations Manager Alert specified by ID;
.PARAMETER systemID
    The single System that the alert is to be delivered by.
.PARAMETER ID
    A single Host ID must be specified.
.PARAMETER force
    Will implement an API forcefull remove option instead of the default normal removal mechanism.
.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE
    PS:> Remove-DSCCHostServiceHostGroup -HostId e987ef683c27403e96caa51816ddc72c

    {   "message": "Successfully submitted",
        "status": "SUBMITTED",
        "taskUri": "/rest/vega/v1/tasks/4969a568-6fed-4915-bcd5-e4566a75e00c"
    }
.EXAMPLE
    PS:> Remove-DSCCAlertOrContact -systemId 1 -id 5 -WhatIf

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call
    The URI for this call will be
        https://pavo-user-api.common.cloud.hpe.com/api/v1Data-Ops-Manager-ProductType1-Volumes/storage-systems/1/alert-contacts/5
    The Method of this call will be 
        Delete
    The Header for this call will be :
        {
            "Content":  "application/json",
            "X-Auth-Token":  "122345346"
        }
    The Body of this call will be:
        "No Body"
.LINK
#>   
[CmdletBinding()]
param(  [Parameter(Mandatory)]  [string]    $systemId,
        [Parameter(Mandatory)]  [string]    $AlertId,
                                [switch]    $WhatIf
     )
process
    {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        write-verbose "Dectected the DeviceType is $DeviceType"
        if ( $DeviceType -eq 'device-type1' )
                {   $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + '/alert-contacts/' + $AlertId
                    if ( $WhatIf )
                            {   $FullObjSet = invoke-restmethodWhatIf -uri $MyURI -Headers $MyHeaders  -method 'Delete'
                            }
                        else
                            {   try     {   $FullObjSet = Invoke-RestMethod -uri $MyURI -Headers $MyHeaders  -method 'Delete' 
                                        }   
                                catch   { write-warning "The call for alerts to system ID $SystemId returned nothing."
                                        }
                            }
                    return $FullObjSet
                }
            else 
                {   if ( -not $DeviveType ) 
                            {   Write-Warning "This command only works against System with Device-Type 1."
                            }
                        else 
                            {   Write-Warning "No Valid Storage Systemd Detected using System ID $SystemId."
                    
                            }
                    return 
                
                }
           
    }       
}   
function New-DSCCAlertContact
{
<#
.SYNOPSIS
    Adds HPE DSSC DOM Alert details.    
.DESCRIPTION
    Adds HPE Data Services Cloud Console Data Operations Manager Alert contact details to a system specified by ID;
.PARAMETER systemID
    The single System that the alert contact information is to be added to.
.PARAMETER company
    Company
.PARAMETER companyCode
    Company code
.PARAMETER country
    Country
.PARAMETER fax
    Fax number
.PARAMETER firstName
    Fax number
.PARAMETER includeSvcAlerts
    Email sent to contact shall include service alert
.PARAMETER lastName
    Last name
.PARAMETER notificationSecerities
    Severities of notifications the contact will be notificated. An array of number: 0 - Fatal, 1 - Critical, 2 - Major, 3 - Minor, 4 - Degraded, 5 - Info, 6 - Debug.
    An example of this could be '@(0,1,3,4)' or just '4'
.PARAMETER preferredLanguages
    Preferred language when being contacted or emailed
.PARAMETER primaryEmail
    Primary email address
.PARAMETER primaryPhone
    Primary phone
.PARAMETER receiveEmail
    Contact will receive email notifications
.PARAMETER recieveGrouped
    Contact will receive grouped low urgency email notifications
.PARAMETER secondaryEmail
    Secondary email address
.PARAMETER secondaryPhone
    Secondary phone
.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE
    PS:> New-DSCCHostServiceHostGroup -HostId e987ef683c27403e96caa51816ddc72c -company MyCompany -$companyCode 42 -firstName Fred -lastName Flintstone

    {   "company": "MyCompany",
        "companyCode": "42",
        "country": "",
        "fax": "",
        "firstName": "Fred",
        "includeSvcAlerts": false,
        "lastName": "Flintstone",
        "notificationSeverities": [ ],
        "preferredLanguage": "en",
        "primaryEmail": "",
        "primaryPhone": "",
        "receiveEmail": false,
        "receiveGrouped": false,
        "secondaryEmail": "",
        "secondaryPhone": ""
    }
.EXAMPLE
    PS > New-DSCCAlertContact -SystemID 1 -company MyCompany -companyCode 45 -firstName Fred -lastName Flintstone -whatif
    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call
    The URI for this call will be
        https://pavo-user-api.common.cloud.hpe.com/api/v1Data-Ops-Manager-ProductType1-Volumes/storage-systems/device-type1/1/alert-contacts
    The Method of this call will be 
        Put
    The Header for this call will be :

    The Body of this call will be:
    {
        "lastName":  "Flintstone",
        "company":  "MyCompany",
        "firstName":  "Fred",
        "companyCode":  "45"
    }
#>   
[CmdletBinding()]
param(   [parameter( mandatory, ValueFromPipeLineByPropertyName=$true )][Alias('id')]                                              
                                [string]    $SystemId,
                                [string]    $company,
                                [string]    $companyCode,
                                [string]    $country,
                                [string]    $fax,
                                [string]    $firstName,
                                [string]    $includeSvcAlerts,
                                [string]    $lastName,
                                [array]     $notificationServices,
                                [string]    $preferredLanguages,
                                [string]    $primaryEmail,
                                [string]    $primaryPhone,
                                [string]    $receiveEmail,
                                [string]    $receiveGrouped,
                                [string]    $secondaryEmail,
                                [string]    $secondaryPhone,
                                [switch]    $whatIf
    )
process
    {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        write-verbose "Dectected the DeviceType is $DeviceType"
        if ( $DeviceType -eq 'device-type1' )
                {   $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + '/alert-contacts'
                    $MyBody=@{}
                    if ( $company )             { $MyBody += @{ company = $company } } 
                    if ( $companyCode )         { $MyBody += @{ companyCode = $companyCode } } 
                    if ( $country )             { $MyBody += @{ country = $country } } 
                    if ( $fax )                 { $MyBody += @{ fax = $fax } } 
                    if ( $firstName )           { $MyBody += @{ firstName = $firstName } } 
                    if ( $includeSvcAlerts )    { $MyBody += @{ includeSvcAlerts = $includeSvcAlerts } } 
                    if ( $lastName )            { $MyBody += @{ lastName = $lastName } } 
                    if ( $notificationServices ){ $MyBody += @{ notificationServices = $notificationServices } } 
                    if ( $preferredLanguages )  { $MyBody += @{ preferredLanguages = $preferredLanguages } } 
                    if ( $primaryEmail )        { $MyBody += @{ primaryEmail = $primaryEmail } } 
                    if ( $primaryPhone )        { $MyBody += @{ primaryPhone = $primaryPhone } } 
                    if ( $receiveEmail )        { $MyBody += @{ receiveEmail = $receiveEmail } } 
                    if ( $secondaryEmail )      { $MyBody += @{ secondaryEmail = $secondaryEmail } } 
                    if ( $secondaryPhone )      { $MyBody += @{ secondaryPhone = $secondaryPhone } } 
                    if ( $WhatIf )
                            {   $FullObjSet = invoke-restmethodWhatIf -uri $MyURI -Headers $MyHeaders  -Method Post
                            }
                        else
                            {   try     {   $FullObjSet = Invoke-RestMethod -uri $MyURI -Headers $MyHeaders  -method Post 
                                        }   
                                catch   { $_
                                          write-warning "The call for alerts to system ID $SystemId returned nothing."
                                        }
                            }
                    return $FullObjSet
                }
            else 
                {   if ( -not $DeviveType ) 
                            {   Write-Warning "This command only works against System with Device-Type 1."
                            }
                        else 
                            {   Write-Warning "No Valid Storage Systemd Detected using System ID $SystemId."
                            }
                    return 
                }
    }
}  
function Set-DSCCAlertContact
{
<#
.SYNOPSIS
    Modifies existing event HPE DSSC DOM Alert details.    
.DESCRIPTION
    Modifies existing event HPE Data Services Cloud Console Data Operations Manager Alert contact details to a system specified by ID;
.PARAMETER systemID
    The single System that the alert contact information is to be added to.
.PARAMETER ID
    The single Event that the alert contact information is to be added to.
.PARAMETER company
    Company
.PARAMETER companyCode
    Company code
.PARAMETER country
    Country
.PARAMETER fax
    Fax number
.PARAMETER firstName
    Fax number
.PARAMETER includeSvcAlerts
    Email sent to contact shall include service alert
.PARAMETER lastName
    Last name
.PARAMETER notificationSecerities
    Severities of notifications the contact will be notificated. An array of number: 0 - Fatal, 1 - Critical, 2 - Major, 3 - Minor, 4 - Degraded, 5 - Info, 6 - Debug.
    An example of this could be '@(0,1,3,4)' or just '4'
.PARAMETER preferredLanguages
    Preferred language when being contacted or emailed
.PARAMETER primaryEmail
    Primary email address
.PARAMETER primaryPhone
    Primary phone
.PARAMETER receiveEmail
    Contact will receive email notifications
.PARAMETER recieveGrouped
    Contact will receive grouped low urgency email notifications
.PARAMETER secondaryEmail
    Secondary email address
.PARAMETER secondaryPhone
    Secondary phone
.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE
    PS:> Set-DSCCHostServiceHostGroup -SystemId 32 -id 3456 -fax '425-949-9999'

   {    "company": "HPE",
        "companyCode": "HPE",
        "country": "US",
        "fax": "425-949-9999",
        "firstName": "john",
        "includeSvcAlerts": false,
        "lastName": "kevin",
        "notificationSeverities": [ 0, 1, 2, 3, 4, 5 ],
        "preferredLanguage": "en",
        "primaryEmail": "kevin.john@hpe.com",
        "primaryPhone": "98783456",
        "receiveEmail": true,
        "receiveGrouped": true,
        "secondaryEmail": "winny.pooh@hpe.com",
        "secondaryPhone": "23456789"
    }
.EXAMPLE
    PS:> Set-DSCCAlertContact -SystemID 1 -Id 34 -company 1214 -fax '425-949-9999' -whatIf

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call
    The URI for this call will be
        https://pavo-user-api.common.cloud.hpe.com/api/v1Data-Ops-Manager-ProductType1-Volumes/storage-systems/device-type1/1/alert-contacts/34
    The Method of this call will be 
        Patch
    The Header for this call will be :
        {
            "Content":  "application/json",
            "X-Auth-Token":  "122345346"
        }
    The Body of this call will be:
    {
        "company":  "1214",
        "fax":      "425-949-9999"
    }

#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [parameter( mandatory, ValueFromPipeLineByPropertyName=$true )][Alias('id')]                                              
                                [string]    $SystemId,
        [Parameter (Mandatory)] [string]    $ContactId,
                                [string]    $company,
                                [string]    $companyCode,
                                [string]    $country,
                                [string]    $fax,
                                [string]    $firstName,
                                [string]    $includeSvcAlerts,
                                [string]    $lastName,
                                [array]     $notificationServices,
                                [string]    $preferredLanguages,
                                [string]    $primaryEmail,
                                [string]    $primaryPhone,
                                [string]    $receiveEmail,
                                [string]    $receiveGrouped,
                                [string]    $secondaryEmail,
                                [string]    $secondaryPhone,
                                [switch]    $whatIf
    )
process
    {   $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        write-verbose "Dectected the DeviceType is $DeviceType"
        if ( $DeviceType -eq 'device-type1' )
                {   $MyURI = $BaseURI + 'storage-systems/' + $DeviceType + '/' + $SystemId + '/alert-contacts/' + $ContactId
                    $MyBody=@{}
                    if ( $company )             { $MyBody += @{ company = $company } } 
                    if ( $companyCode )         { $MyBody += @{ companyCode = $companyCode } } 
                    if ( $country )             { $MyBody += @{ country = $country } } 
                    if ( $fax )                 { $MyBody += @{ fax = $fax } } 
                    if ( $firstName )           { $MyBody += @{ firstName = $firstName } } 
                    if ( $includeSvcAlerts )    { $MyBody += @{ includeSvcAlerts = $includeSvcAlerts } } 
                    if ( $lastName )            { $MyBody += @{ lastName = $lastName } } 
                    if ( $notificationServices ){ $MyBody += @{ notificationServices = $notificationServices } } 
                    if ( $preferredLanguages )  { $MyBody += @{ preferredLanguages = $preferredLanguages } } 
                    if ( $primaryEmail )        { $MyBody += @{ primaryEmail = $primaryEmail } } 
                    if ( $primaryPhone )        { $MyBody += @{ primaryPhone = $primaryPhone } } 
                    if ( $receiveEmail )        { $MyBody += @{ receiveEmail = $receiveEmail } } 
                    if ( $secondaryEmail )      { $MyBody += @{ secondaryEmail = $secondaryEmail } } 
                    if ( $secondaryPhone )      { $MyBody += @{ secondaryPhone = $secondaryPhone } } 
                    if ( $WhatIf )
                            {   $FullObjSet = invoke-restmethodWhatIf -uri $MyURI -Headers $MyHeaders  -method Patch
                            }
                        else
                            {   try     {   $FullObjSet = Invoke-RestMethod -uri $MyURI -Headers $MyHeaders  -method Patch 
                                        }   
                                catch   { write-warning "The call for alerts to system ID $SystemId returned nothing."
                                        }
                            }
                    return $FullObjSet
                }
            else 
                {   if ( -not $DeviveType ) 
                            {   Write-Warning "This command only works against System with Device-Type 1."
                            }
                        else 
                            {   Write-Warning "No Valid Storage Systemd Detected using System ID $SystemId."
                            }
                    return 
                }
    }
}  