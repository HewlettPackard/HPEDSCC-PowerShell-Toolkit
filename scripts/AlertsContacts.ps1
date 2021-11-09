function Get-DSCCAlertOrContact
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Alerts and Contact Information    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager Alerts and Contact information;
.PARAMETER systemID
    The required system ID to query for the alerts
.PARAMETER limit
    Limits the number of responses
.PARAMETER offset
    The offset of the first item in the collection to return
.PARAMETER id
    Will limit the data returned to a single event identified by ID
.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE
    PS:> Get-DSCCAlertOrContact
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
#>   
[CmdletBinding(DefaultParameterSetName='Default')]
param(  [Parameter(Mandatory=$true,ParameterSetName='Default')] 
        [Parameter(Mandatory=$true,ParameterSetName='ById')]        [string]    $SystemID,
        [Parameter(ParameterSetName='Default')]                     [int32]     $limit,
        [Parameter(ParameterSetName='Default')]                     [int32]     $offset,
        [Parameter(ParameterSetName='ById')]                        [string]    $Id,
        [Parameter(ParameterSetName='Default')] 
        [Parameter(ParameterSetName='ById')]                        [switch]    $whatIf
        
     )
process
    {   $MyBody = @{}
        if ( $limit )   { $MyBody += @{ limit  = $limit  }  }
        if ( $offset )  { $MyBody += @{ offset = $offset }  }   
        $MyURI = $BaseURI + 'storage-systems/device-type1/' + $SystemID + '/alert-contacts'
        if ( $Id ) 
                {   $MyURI = $MyURI + '/' + $Id 
                }
        if ( $WhatIf )
                {   $FullObjSet = invoke-restmethodWhatIf -uri $MyURI -Headers $MyHeaders -body $MyBody -method 'Get'
                }
            else
                {   $FullObjSet = Invoke-RestMethod -uri $MyURI -Headers $MyHeaders -body $MyBody -method 'Get' 
                }
        return  $FullObjSet   
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
        [Parameter(Mandatory)]  [string]    $Id,
                                [switch]    $WhatIf
     )
process
    {   $MyURI = $BaseURI + 'storage-systems/' + $systemID + '/alert-contacts/' + $id
        if ( $Whatif )
                {   return Invoke-RestMethodWhatIf -uri $MyUri -method 'Delete' -headers $MyHeaders
                } 
            else 
                {   return Invoke-RestMethod -uri $MyUri -method 'Delete' -headers $MyHeaders
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
param(  [Parameter(Mandatory)]  [string]    $SystemID,
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
    {   $MyURI = $BaseURI + 'storage-systems/device-type1/' + $systemID + '/alert-contacts'
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
        if ( $whatIf )    
                {   return invoke-restmethodWhatIf -Uri $MyURI -Headers $MyHeaders -Method 'Put' -Body $MyBody 
                }
            else 
                {   return invoke-restmethodWhat -Uri $MyURI -Hearders $MyHeaders -Method 'Put' -Body $MyBody        
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
param(  [Parameter(Mandatory)]  [string]    $SystemID,
        [Parameter(Mandatory)]  [string]    $Id,
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
    {   $MyURI = $BaseURI + 'storage-systems/device-type1/' + $systemID + '/alert-contacts/' + $id
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
        if ( $whatIf )    
                {   return invoke-restmethodWhatIf -Uri $MyURI -Headers $MyHeaders -Method 'Patch' -Body $MyBody 
                }
            else 
                {   return invoke-restmethodWhat -Uri $MyURI -Headers $MyHeaders -Method 'Patch' -Body $MyBody        
                }
    }       
}   
