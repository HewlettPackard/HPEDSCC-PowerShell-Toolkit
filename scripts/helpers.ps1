function Connect-DSCC {
    <#
.SYNOPSIS
    Connects to an HPE DSCC Endpoint.
.DESCRIPTION
    Connect-HPEDSCC is an advanced function that provides the initial connection to a HPE Data Storage Cloud Services
    so that other subsequent commands can be run without having to authenticate individually. This command will take your credentials and attempt to get 
    and authorization token, or will take an authorization token and connect 
.PARAMETER Client_id
    The Client ID that is given to the user from the DSCC service. This can be found on the DSCC GUI. If the Client ID is specified, so must the Client_Secret.
.PARAMETER client_secret
    The Client Secret which is given when a new API account is created, this item must be remembered from when the account was created, and is
    not available anywhere in the DSCC gui. If the Client_Secret is specified the Client_Id must also be provided.
.PARAMETER AccessToken
    If the Access Token can be gathered seperately, you can use this to authenticate your RestAPI Calls. 
    If no AccessToken is specified a Client_Id or Client_Secret need be specified. The Access token will expire after 2 hours of issue, and 
    since credentials are not offered, there is no ability to autorenew them.
.PARAMETER GreenlakeType
    This can either be the Production Instance of DSSC or it can be the Prototype/Dev instance of the DSSC. The values can either be Production either
    in the USA, the EU, or Asia or multiple Devevlopment sites. 
.PARAMETER AutoRenew
    This switch will allow the Toolkit to reconnect automatically once a successfull connection has been made every 1h and 45 minutes.
.PARAMETER WhatIfToken
    This option shows you the command that will be sent to DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
    Since this command has two parts, the use of this will show you the what-if option for the call to the single-sign-on service which returns the authorization
    token only. This will show you ONLY how the authentication call is made, and will not tryin and connect to the end-user cloud.
.PARAMETER WhatIfGreenLakeType
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
    Since this command has two parts, the use of this will obtain the authorization token from the single-sign-on server, and then attemp to make a standard 
    call to the defined cloud. This command is useful to determine if your authentication token is returned correctly
    If the cloud choosen is incorrect, the SSO server would still succeed, but the following command would fail.
    .EXAMPLE
    PS:> Connect-HPEDSCC -AccessToken 'ABC123XYZ' -GreenlakeType Dev
.EXAMPLE
    PS:> Connect-HPEDSCC -AccessToken 'ABC123XYZ' -GreenlakeType Dev -whatifToken
    
    The URI for this call will be https://pavo-user-api.common.cloud.hpe.com/api/v1
    The Method of this call will be Get
    The Header for this call will be :
        {   "Content":  "application/json",
            "X-Auth-Token":  "122345346"
        }
    The Body of this call will be:
        "No Body"   
.EXAMPLE
    PS:> Connect-DSCC -Client_Id '1234abcd' -Client_Secret 'ABC123XYZ' -GreenlakeType Dev1 -autorenew
.EXAMPLE
    PS:> Connect-DSCC -Client_Id '1234abcd' -Client_Secret 'ABC123XYZ' -GreenlakeType Dev1 -autorenew -whatifToken
.EXAMPLE
    PS:> Connect-DSCC -Client_Id '1234abcd' -Client_Secret 'ABC123XYZ' -GreenlakeType Dev1 -whatifGreenLakeType        
#>
    [CmdletBinding()]
    param ( [Parameter(Mandatory, ParameterSetName = 'ByClientCreds')]                         [string]    $Client_Id,
        [Parameter(Mandatory, ParameterSetName = 'ByClientCreds')]                         [string]    $Client_Secret,         
        [Parameter(Mandatory, ParameterSetName = 'ByAccessToken')]                         [string]    $AccessToken,         
        [Parameter(Mandatory)][ValidateSet('Dev1', 'Dev2', 'Dev3', 'Asia', 'USA', 'EU')]   [string]    $GreenlakeType, 
        [Parameter(ParameterSetName = 'ByClientCreds')]                                   [switch]    $AutoRenew, 
        [Parameter(ParameterSetName = 'ByClientCreds')]                                   [switch]    $WhatIfToken, 
        [switch]    $WhatIfGreenLakeType 
    )
    Process {
        $Global:AuthUri = 'https://sso.common.cloud.hpe.com/as/token.oauth2'
        Write-Verbose 'Changing default TLS to 1.2 from 1.0'
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        if ( $PsCmdlet.ParameterSetName -eq 'ByClientCreds') {
            if ( Resolve-DnsName 'sso.common.cloud.hpe.com' ) {
                Write-Verbose 'Able to DNS Resolve the Single Sign On (SSO) Server Successfully : SSO.Common.Cloud.HPE.com'
            }
            else {
                Write-Error 'The Single Sign In (SSO) Server was not DSN Resolvable./r/n Please fix the network enviornment before re-running this command.'
                return 
            }
            if ( ($PSVersionTable.PSVersion).Major -ge 7 ) {
                Write-Verbose 'Detected PowerShell 7, so can test-connection. Testing SSO.Common.Cloud.HPE.com'
                if ( ( Test-Connection 'sso.common.cloud.hpe.com' -TcpPort 443 ) ) {
                    # the Test-Connection by port feature is only available in PowerShell 7 and newer, so the test only if 7+
                    Write-Verbose 'Able to successfully connect to the SSO Server: SSO.Common.Cloud.HPE.com.'
                }
                else {
                    Write-Error 'The Single Sign-In Server SSO.Common.Cloud.HPE.com Cannot be connected to. /r/n Please fix the network enviornment before re-running this command.'
                    return
                }
            } 
            else {
                Write-Verbose 'PowerShell 7 not detected, so unable to run the Test-Connection to ensure connectivity to SSO.Common.Cloud.HPE.com'
            }
            Write-Verbose 'Obtaining Access Token using Passed Client_Id and Client_Secrets.'
            $Global:AuthHeaders = @{  'Content-Type' = 'application/x-www-form-urlencoded'
            }
            $Global:AuthBody = [ordered]@{   'grant_type' = 'client_credentials'
                'client_id'                               = $Client_Id
                'client_secret'                           = $Client_Secret
            }  
            Try {
                if ( $WhatifToken ) {
                    $Output = Invoke-RestMethodWhatIf -Uri "$AuthURI" -Method Post -Headers $AuthHeaders -body $AuthBody
                    Write-Host 'The Following is the output from the attempt to retrieve the Access Token using Credentials'
                    $Output | Out-String 
                }     
                else {
                    try {
                        $AccessToken = ( Invoke-RestMethod -Uri "$AuthURI" -Method Post -Headers $AuthHeaders -Body $AuthBody ).access_token
                    }
                    catch {
                        Write-Error 'The Token was not returned. Please check your ID and Secret.'
                        return
                    }      
                }     
            }
            Catch {
                $_
            }
        }
        Write-Verbose "Successfully gathered new AccessToken : $AccessToken"
        switch ( $GreenlakeType ) {
            'Dev1' { $CloudAddr = 'scalpha-app.qa.cds.hpe.com' }
            'Dev2' { $CloudAddr = 'fleetscale-app.qa.cds.hpe.com' }
            'Dev3' { $CloudAddr = 'scint-app.qa.cds.hpe.com' }
            'Asia' { $CloudAddr = 'jp1.data.cloud.hpe.com' }
            'EU' { $CloudAddr = 'eu1.data.cloud.hpe.com' }
            'USA' { $CloudAddr = 'us1.data.cloud.hpe.com' }
        }
        if ( Resolve-DnsName $CloudAddr ) {
            Write-Verbose "Able to DNS Resolve the Cloud Server Successfully : $CloudAddr"  
        }
        else {
            Write-Error "The $CloudAddr Server was not DNS Resolvable./r/n Please fix the network enviornment before re-running this command."
            return 
        }
        if ( ($PSVersionTable.PSVersion).Major -ge 7 ) {
            Write-Verbose 'Detected PowerShell 7, so can test-connection. Testing SSO.Common.Cloud.HPE.com'
            if ( ( Test-Connection $CloudAddr -TcpPort 443 ) -or ( ($PSVersionTable.PSVersion).Major -ge 7 ) ) {
                # the Test-Connection by port feature is only available in PowerShell 7 and newer, so the test only if 7+
                Write-Verbose "Able to successfully connect to the $CloudAddr Server."
            }
            else {
                Write-Error "The $CloudAddr Server Cannot be connected to. /r/n Please fix the network enviornment before re-running this command."
                return
            }
        }
        else {
            Write-Verbose "PowerShell 7 not detected, so unable to run the Test-Connection to ensure connectivity to $CloudAddr"
        }
        $Global:Base = 'https://' + $CloudAddr
        $Global:CloudRoot = '/api/v1/'
        $Global:BaseUri = $Base + $CloudRoot
        $Global:MyHeaders = @{  Authorization = 'Bearer ' + $AccessToken
        }
        if ( $AccessToken -or $whatifGreenLakeType ) {
            Try {
                if ( $WhatifGreenLakeType ) {
                    $ReturnData = invoke-restmethodwhatif -uri ( $BaseUri + 'audit-events') -Headers $MyHeaders 
                } 
                else {
                    Write-Verbose 'This operation will run a Get-DSCCAuditEvent to test if the Cloud Type is set right'
                    $ReturnData = Invoke-RestMethod -Uri ( $BaseUri + 'audit-events') -Headers $MyHeaders
                }
            }
            Catch {
                $_
            }
            if ( $ReturnData ) {
                $ReturnData = @{   Access_Token = $AccessToken 
                    Token_Creation              = $( Get-Date ).datetime
                    Token_CreationEpoch         = $( (New-TimeSpan -Start (Get-Date '01/01/1970') -End (Get-Date)).TotalSeconds ) 
                    Auto_Renew                  = $( if ($AutoRenew) { $true } else { $false } )
                }
                $ReturnData2 = $ReturnData | ConvertTo-Json | ConvertFrom-Json
                $Global:AuthToken = Invoke-RepackageObjectWithType -RawObject $ReturnData2 -ObjectName 'AccessToken'
                return $AuthToken 
            } 
            else {
                if (-not $whatifGreenLakeType) {
                    Write-Error 'No HPE DSCC target Detected or wrong port used at that address'
                }
                else {
                    Write-Warning 'Since WhatIF option was used, no expected return data is expected.'
                }
            }
        }
        else {
            Write-Warning 'The request for a Token was not successful using the supplied Client-ID and CLient-Secret.'            
        }
    }
}
function Find-DSCCDeviceTypeFromStorageSystemID {
    [CmdletBinding()]
    param   ( [Parameter(Mandatory)][AllowEmptyString()]    [string]    $SystemId, 
        [switch]    $WhatIf
    )
    Process {
        if ( $SystemId -eq '') {
            # This makes sure if an empty string is sent, no response is given
            Write-Verbose 'Empty String sent in as a SystemId'
            Return
        }
        if ( ( Get-DSCCStorageSystem -SystemId $SystemId -DeviceType Device-Type1 ) ) {
            Write-Verbose 'The DeviceType Detected was Device-Type1'
            return 'device-type1'
        } 
        else {
            if ( ( Get-DSCCStorageSystem -SystemId $SystemId -DeviceType Device-Type2 ) ) {
                Write-Verbose 'The DeviceType detected was Device-Type2'
                return 'device-type2'
            }
            else {
                return
            }
        }
    }
}
function Invoke-DSCCAutoReconnect {   
    Param()
    $CurrentEpoch = [int](New-TimeSpan -Start (Get-Date '01/01/1970') -End (Get-Date)).TotalSeconds
    $TokenEpoch = [int]($AuthToken).Token_CreationEpoch
    $Timeout = 60 * 105 # 1 hour and 45 minutes 
    if ( ($AuthToken).AutoRenew ) {
        Write-Verbose "CurrentEpoch = $CurrentEpoch; TokenEpoch = $TokenEpoch"        
        $TimeDiff = ( $CurrentEpoch - $TokenEpoch )
        if ( $TimeDiff -gt $Timeout ) {
            Write-Verbose 'The Token is close to expiring, This will renew the command'
            $AccessToken = ( Invoke-RestMethod -Uri "$AuthURI" -Method Post -Headers $AuthHeaders -Body $AuthBody ).access_token
            $ReturnData = @{   Access_Token = $AccessToken 
                Token_Creation              = $( Get-Date ).datetime
                Token_CreationEpoch         = [int]$( (New-TimeSpan -Start (Get-Date '01/01/1970') -End (Get-Date)).TotalSeconds ) 
                Auto_Renew                  = ($AuthToken).AutoRenew
            }
            $ReturnData2 = $ReturnData | ConvertTo-Json | ConvertFrom-Json
            $Global:AuthToken = Invoke-RepackageObjectWithType -RawObject $ReturnData2 -ObjectName 'AccessToken' 
        } 
        Write-Verbose "The Time difference in seconds was $TimeDiff seconds and allowable difference is $Timeout."
    }
    return
}
function ThrowHTTPError {  
    Param   ( $ErrorResponse
    )
    Process {
        $Response = ((($ErrorResponse).Exception).Response | ConvertTo-Json -Depth 10 )
        $R2 = ((($ErrorResponse).Exception).Response)
        $ECode = (((($ErrorResponse).Exception).Response).StatusCode).value__
        $EText = ((($ErrorResponse).Exception).Response).StatusDescription + ((($ErrorResponse).Exception).Response).ReasonPhrase 
        Write-Verbose "The RestAPI Request failed with the following Status: `r`n`tHTTPS Return Code = $ECode`r`n`tHTTPS Return Code Description = $EText"
        Write-Verbose "Raw Response  = $Response"
        if ( ($R2).StatusCode -eq 400 ) {
            Write-Warning 'The command returned an error status Code 400:Bad Request'
        } 
        if ( ($R2).StatusCode -eq 401 ) {
            Write-Warning 'The command returned an error status Code 401:Unauthorized'
        } 
        return
    }
}
function Invoke-DSCCRestMethod {  
    Param   (   $UriAdd,
        $Body = '',
        $Method = 'Get',
        $WhatIfBoolean = $false
    )
    Process {
        Invoke-DSCCAutoReconnect
        $MyURI = $BaseURI + $UriAdd
        Clear-Variable -Name InvokeReturnData -ErrorAction SilentlyContinue
        if ( $WhatIfBoolean ) {
            invoke-RestMethodWhatIf -Uri $MyUri -Method $Method -Headers $MyHeaders -Body $Body -ContentType 'application/json'
        }
        else {
            Write-Verbose "About to make rest call to URL $MyUri."
            try {
                $InvokeReturnData = Invoke-RestMethod -Uri $MyUri -Method $Method -Headers $MyHeaders -Body $Body -ContentType 'application/json'
            }
            catch {
                ThrowHTTPError -ErrorResponse $_ 
                return
            }
            if (($InvokeReturnData).items) {
                $InvokeReturnData = ($InvokeReturnData).items
            }
            if (($InvokeReturnData).Total -eq 0) {
                Write-Verbose 'The call succeeded however zero items were returned'
                $InvokeReturnData = ''
            }
        }   
        return $InvokeReturnData
    }
}

function Invoke-RestMethodWhatIf {   
    Param   (   $Uri,
        $Method,
        $Headers,
        $ContentType,
        $Body
    )
    process {
        if ( -not $Body ) {
            $Body = 'No Body'
        }
        Write-Warning "You have selected the What-IF option, so the call will not be made to the array, `ninstead you will see a preview of the RestAPI call"
        Write-Host 'The URI for this call will be ' 
        Write-Host  "$Uri" -ForegroundColor green
        Write-Host 'The Method of this call will be '
        Write-Host -ForegroundColor green $Method
        Write-Host 'The Header for this call will be :'
        Write-Host -ForegroundColor green ($Headers | ConvertTo-Json | Out-String)  
        if ( $ContentType ) {
            Write-Host 'The Content-Type is set to '
            Write-Host -ForegroundColor green ($ContentType)
        }  
        if ( $Body ) {
            Write-Host 'The Body of this call will be:'
            Write-Host -ForegroundColor green ($Body | Out-String)
        }
    }
}

function Invoke-RepackageObjectWithType {   
    Param   (   $RawObject,
        $ObjectName,
        [boolean]   $WhatIf = $false
    )
    process {
        if ( $RawObject ) {
            $OutputObject = @()
            if ( $WhatIf ) {
                Return 
            }
            foreach ( $RawElementObject in $RawObject ) {
                $Z = $RawElementObject
                $DataSetType = "DSCC.$ObjectName"
                $Z.PSTypeNames.Insert(0, $DataSetType)
                $DataSetType = $DataSetType + '.Typename'
                $Z.PSObject.TypeNames.Insert(0, $DataSetType)
                $OutputObject += $Z
            }
            return $OutputObject
        }
        else {
            Write-Verbose 'Null value sent to create object type.'
            return
        }
    }
}

function Get-DsccSystemIdFromName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string[]]$SystemName
    )

    foreach ($ThisSystemName in $SystemName) {
        Write-Output $DsccStorageSystem | 
            Where-Object Name -EQ $ThisSystemName | 
            Select-Object -ExpandProperty Id
    }
}
