function Connect-DSCC
{
<#
.SYNOPSIS
    Connects to an HPE DSCC Endpoint.
.DESCRIPTION
    Connect-HPEDSCC is an advanced function that provides the initial connection to a HPE Data Storage Cloud Services
    so that other subsequent commands can be run without having to authenticate individually.
.PARAMETER Client_id
    The Client ID that is given to the user from the DSCC service. This can be found on the DSCC GUI. If the Client ID is specified, so must the Client_Secret.
.PARAMETER client_secret
    The Client Secret which is given when a new API account is created, this item must be remembered from when the account was created, and is
    not available anywhere in the DSCC gui. If the Client_Secret is specified the Client_Id must also be provided.
.PARAMETER AccessToken
    If the Access Token can be gathered seperately, you can use this to authenticate your RestAPI Calls. 
    If no AccessToken is specified a Client_Id or Client_Secret need be specified.
.PARAMETER GreenlakeType
    This can either be the Production Instance of DSSC or it can be the Prototype/Dev instance of the DSSC. The values can either be Production or Dev.
.PARAMETER AutoRenew
    This switch will allow the Toolkit to reconnect automatically once a successfull connection has been made every 1h and 45 minutes.
.PARAMETER WhatIfToken
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
    Since this command has two parts, the use of this will show you the what-if option for the call to the single-sign-on service which returns the authorization
    token only.
.PARAMETER WhatIfGreenLakeType
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
    Since this command has two parts, the use of this will obtain the authorization token from the single-sign-on server, and then attemp to make a standard 
    call to the defined cloud. If the cloud choosen is incorrect, the SSO server would still succeed, but the following command would fail.
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
    PS:> Connect-DSCC -Client_Id '1234abcd' -Client_Secret 'ABC123XYZ' -GreenlakeType Dev
.EXAMPLE
    PS:> Connect-DSCC -Client_Id '1234abcd' -Client_Secret 'ABC123XYZ' -GreenlakeType Dev -whatifToken
.EXAMPLE
    PS:> Connect-DSCC -Client_Id '1234abcd' -Client_Secret 'ABC123XYZ' -GreenlakeType Dev -whatifGreenLakeType        
#>
[CmdletBinding()]
param ( [Parameter(Mandatory,ParameterSetName='ByClientCreds')]
        [string]    $Client_Id,

        [Parameter(Mandatory,ParameterSetName='ByClientCreds')]
        [string]    $Client_Secret,         

        [Parameter(Mandatory,ParameterSetName='ByAccessToken')]
        [string]    $AccessToken,         

        [Parameter(Mandatory)][ValidateSet("Dev1","Dev2","Dev3","Asia", "USA", "EU")]
        [string]    $GreenlakeType  = 'Dev', 
        
        [Parameter(ParameterSetName='ByClientCreds')]
        [switch]    $AutoRenew, 

        [Parameter(ParameterSetName='ByClientCreds')]
        [switch]    $WhatIfToken, 

        [switch]    $WhatIfGreenLakeType 
      )
Process{
    $Global:AuthUri = "https://sso.common.cloud.hpe.com/as/token.oauth2"
    write-verbose "Changing default TLS to 1.2 from 1.0"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    if ( $PsCmdlet.ParameterSetName -eq 'ByClientCreds')
        {   write-verbose 'Obtaining Access Token using Passed Client_Id and Client_Secrets.'
            $Global:AuthHeaders =  @{  'Content-Type' = 'application/x-www-form-urlencoded'
                                    }
            $Global:AuthBody    = [ordered]@{   'grant_type' = 'client_credentials'
                                                'client_id' = $Client_Id
                                                'client_secret' = $Client_Secret
                                          }  
            # clear-variable $Client_Id
            # clear-variable $Client_Secret              
    Try     {   if ( $WhatifToken )
                        {   $Output = Invoke-RestMethodWhatIf -Uri "$AuthURI" -Method Post -Headers $AuthHeaders -body $AuthBody
                            Write-host "The Following is the output from the attempt to retrieve the Access Token using Credentials"
                            $Output | out-string 
                        }     
                    else 
                        {   try {   $AccessToken = ( invoke-restmethod -uri "$AuthURI" -Method Post -headers $AuthHeaders -body $AuthBody ).access_token
                                }
                            catch{  write-warning "The Token was not returned."

                                 }      
                        }     
            }
    Catch   {   $_
            }
            #if ( -not $AutoRenew )
               # {   # clear-variable $AuthBody Mana
               # }
        }
    write-Verbose "The AccessToken is $AccessToken"
    switch( $GreenlakeType )
    {   'Dev1'  {   $Global:Base = 'https://scalpha-app.qa.cds.hpe.com'    }
        'Dev2'  {   $Global:Base = 'https://fleetscale-app.qa.cds.hpe.com' }
        'Dev3'  {   $Global:Base = 'https://scint-app.qa.cds.hpe.com'      }
        'Asia'  {   $Global:Base = "https://jp1.data.cloud.hpe.com"        }
        'EU'    {   $Global:Base = 'https://eu1.data.cloud.hpe.com'        }
        'USA'   {   $Global:Base = 'https://us1.data.cloud.hpe.com'        }
    }
    $Global:CloudRoot = "/api/v1/"
    $Global:BaseUri   = $Base+$CloudRoot
    $Global:MyHeaders = @{  Authorization = 'Bearer '+$AccessToken

                         }
    $Global:TestUri = $BaseUri + "host-initiators/"
    if ( $AccessToken -or $whatifGreenLakeType )
            {   Try     {   if ( $WhatifGreenLakeType )
                                    {   Write-Warning 'This operation will run a Get-DSCCStorageSystem to test if the Cloud Type is set right'
                                        $ReturnData = Get-DsccStorageSystem -whatif
                                        write-warning ''
                                    } 
                                else 
                                    {   Write-Verbose 'This operation will run a Get-DSCCStorageSystem to test if the Cloud Type is set right'
                                        $ReturnData = Get-DSCCStorageSystem
                                    }
                        }
                Catch   {   $_
                        }
                if ( $ReturnData )
                        {   $ReturnData =  @{   Access_Token    = $AccessToken 
                                                Token_Creation  = $( Get-Date ).datetime
                                                Token_CreationEpoch = $( (New-TimeSpan -Start (Get-Date "01/01/1970") -End (Get-Date)).TotalSeconds ) 
                                                Auto_Renew      = $( if ($AutoRenew) { $true } else { $false } )
                                            }
                            $ReturnData2 = $ReturnData | convertto-json | convertfrom-json
                            $Global:AuthToken = Invoke-RepackageObjectWithType -RawObject $ReturnData2 -ObjectName 'AccessToken'
                            return $AuthToken 
                        } 
                    else 
                        {   if (-not $whatifGreenLakeType) 
                                    {   Write-Error "No HPE DSSC target Detected or wrong port used at that address"
                                    }
                                else 
                                    {   Write-Warning "Since WhatIF option was used, no expected return data is expected."
                                    
                                    }
                        }
            }
        else    
            {   Write-warning "The request for a Token was not successful using the supplied Client-ID and CLient-Secret."            
            }
}
}
 
function Find-DSCCDeviceTypeFromStorageSystemID
{
[CmdletBinding()]
    param ( [Parameter(Mandatory)]
            [string]    $SystemId,         

            [switch]    $WhatIf 
          )
    if ( ( Get-DSCCStorageSystem -SystemId $SystemId -DeviceType Device-Type1 ) )
            {   write-verbose "The DeviceType Detected was Device-Type1"
                return 'device-type1'
            } 
        else 
            {   if ( ( Get-DSCCStorageSystem -SystemId $SystemId -DeviceType Device-Type2 ) )
                        {   write-verbose "The DeviceType detected was Device-Type2"
                            return 'device-type2'
                        }
                    else 
                        {   return
                        }
}
}
function Invoke-DSCCAutoReconnect
{   Param()
    $CurrentEpoch = [int](New-TimeSpan -Start (Get-Date "01/01/1970") -End (Get-Date)).TotalSeconds
    $TokenEpoch = [int]($AuthToken).Token_CreationEpoch
    $Timeout = 60 * 105 # 1 hour and 45 minutes 
    if ( ($AuthToken).AutoRenew ) 
        {   write-verbose "CurrentEpoch = $CurrentEpoch; TokenEpoch = $TokenEpoch"        
            $TimeDiff = ( $CurrentEpoch - $TokenEpoch )
            if ( $TimeDiff -gt $Timeout ) 
                {   write-verbose "The Token is close to expiring, This will renew the command"
                    $AccessToken = ( invoke-restmethod -uri "$AuthURI" -Method Post -headers $AuthHeaders -body $AuthBody ).access_token
                    $ReturnData =  @{   Access_Token    = $AccessToken 
                                        Token_Creation  = $( Get-Date ).datetime
                                        Token_CreationEpoch = [int]$( (New-TimeSpan -Start (Get-Date "01/01/1970") -End (Get-Date)).TotalSeconds ) 
                                        Auto_Renew      = ($AuthToken).AutoRenew
                                    }
                    $ReturnData2 = $ReturnData | convertto-json | convertfrom-json
                    $Global:AuthToken = Invoke-RepackageObjectWithType -RawObject $ReturnData2 -ObjectName 'AccessToken' 
                } 
            write-verbose "The Time difference in seconds was $TimeDiff seconds and allowable difference is $Timeout."
        }
    return
}
function ThrowHTTPError 
{   Param ( $ErrorResponse
          )
    Process 
    {   $Response =   ((($ErrorResponse).Exception).Response | convertto-json )
        $ECode =      (((($ErrorResponse).Exception).Response).StatusCode).value__
        $EText =      ((($ErrorResponse).Exception).Response).StatusDescription + ((($ErrorResponse).Exception).Response).ReasonPhrase 
        write-warning "The RestAPI Request failed with the following Status: `r`n`tHTTPS Return Code = $ECode`r`n`tHTTPS Return Code Description = $EText"
        Write-Debug   "Raw Response  = $Response"
        return
    }
}
function Invoke-DSCCRestMethod
{   Param(  $UriAdd,
            $Body='',
            $Method='Get',
            $WhatIfBoolean=$false
         )
    Process
    {   $MyURI = $BaseURI + $UriAdd
        Clear-Variable -Name InvokeReturnData -ErrorAction SilentlyContinue
        if ( $WhatIfBoolean )
                {   invoke-RestMethodWhatIf -Uri $MyUri -Method $Method -Headers $MyHeaders -Body $Body -ContentType 'application/json'
                } 
            else 
                {   try     {   $InvokeReturnData = invoke-restmethod -Uri $MyUri -Method $Method -Headers $MyHeaders -Body $Body -ContentType 'application/json'
                                if (($InvokeReturnData).items)
                                    {   $InvokeReturnData = ($InvokeReturnData).items 
                                    }
                                if (($InvokeReturnData).Total -eq 0)
                                    {   Write-warning "The call succeeded however zero items were returned"
                                        $InvokeReturnData = ''
                                    }
                            }
                    catch   {   ThrowHTTPError -ErrorResponse $_
                            }
                }   
        return $InvokeReturnData
    }
}

function Invoke-RestMethodWhatIf
{   Param(  $Uri,
            $Method,
            $Headers,
            $ContentType,
            $Body
         )
    if ( -not $Body ) 
        {   $Body = 'No Body'
        }
    write-warning "You have selected the What-IF option, so the call will not be made to the array, `ninstead you will see a preview of the RestAPI call"
    Write-host "The URI for this call will be " 
    write-host  "$Uri" -foregroundcolor green
    Write-host "The Method of this call will be "
    write-host -foregroundcolor green $Method
    Write-host "The Header for this call will be :"
    write-host -foregroundcolor green ($Headers | ConvertTo-JSON | Out-String)  
    if ( $ContentType )
        {   write-host "The Content-Type is set to "
            write-host -foregroundcolor green ($ContentType)
        }  
    if ( $Body )
        {   write-host "The Body of this call will be:"
            write-host -foregroundcolor green ($Body | ConvertTo-JSON | Out-String)
        }
}

function Invoke-RepackageObjectWithType 
{   Param(  $RawObject,
            $ObjectName
         )
    if ( $RawObject )
           {   $OutputObject = @()
                foreach ( $RawElementObject in $RawObject )
                    {   $Z=$RawElementObject
                        $DataSetType = "DSCC.$ObjectName"
                        $Z.PSTypeNames.Insert(0,$DataSetType)
                        $DataSetType = $DataSetType + ".Typename"
                        $Z.PSObject.TypeNames.Insert(0,$DataSetType)
                        $OutputObject += $Z
                    }
                return $OutputObject
           }
           else
           {    write-warning "Null value sent to create object type."
                return
           }
    
}