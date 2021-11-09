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
    This can either be the Production Instance of DSSC or it can be the Prototype/Dev instance of the DSSC. The values can either be Production or Dev 
.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE
    PS:> Connect-HPEDSCC -AccessToken 'ABC123XYZ' -GreenlakeType Dev
.EXAMPLE
    PS:> Connect-HPEDSCC -AccessToken 'ABC123XYZ' -GreenlakeType Dev -whatif
    
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
    PS:> Connect-DSCC -Client_Id '1234abcd' -Client_Secret 'ABC123XYZ' -GreenlakeType Dev -whatif    
#>
[CmdletBinding()]
param ( [Parameter(Mandatory,ParameterSetName='ByClientCreds')]
        [string]    $Client_Id,

        [Parameter(Mandatory,ParameterSetName='ByClientCreds')]
        [string]    $Client_Secret,         

        [Parameter(Mandatory,ParameterSetName='ByAccessToken')]
        [string]    $AccessToken,         

        [Parameter(Mandatory)][ValidateSet("Production","Dev")]
        [string]    $GreenlakeType  = 'Dev', 
        
        [switch]    $WhatIf 
      )
Process{
    $Global:AuthUri = "https://sso.common.cloud.hpe.com/as/token.oauth2"
    write-verbose "Changing default TLS to 1.2 from 1.0"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    if ( $PsCmdlet.ParameterSetName -eq 'ByClientCreds')
        {   write-verbose 'Obtaining Access Token using Passed Client_Id and Client_Secrets.'
            $Global:AuthHeaders =  @{  'Content-Type' = 'application/x-www-form-urlencoded'
                                    }
            $Global:MyBody    = [ordered]@{     'grant_type' = 'client_credentials'
                                                'client_id' = $Client_Id
                                                'client_secret' = $Client_Secret
                                          }   
    Try     {   if ( $Whatif )
                        {   $Output = Invoke-RestMethodWhatIf -Uri "$AuthURI" -Method Post -Headers $AuthHeaders -body $MyBody
                            Write-host "The Following is the output from the attempt to retrieve the Access Token using Credentials"
                            $Output | out-string 
                        }     
                    else 
                        {   $AccessToken = ( invoke-restmethod -uri "$AuthURI" -Method Post -headers $AuthHeaders -body $MyBody -verbose ).access_token
                        }
            }
    Catch   {   $_
            }
        }
    write-Verbose "The AccessToken is $AccessToken"
    if ( $GreenlakeType -eq 'Dev')
                {   $Global:Base = "https://scalpha-app.qa.cds.hpe.com"
                } else 
                {   $Global:Base = "https://user-apicommon.cloud.hpe.com"                
                }

    $Global:CloudRoot = "/api/v1/"
    $Global:BaseUri   = $Base+$CloudRoot
    $Global:MyHeaders = @{  Authorization = 'Bearer '+$AccessToken
                         }
    $Global:TestUri = $BaseUri + "host-initiator-groups/"
    Try     {   if ( $Whatif )
                        {   $ReturnData = Invoke-RestMethodWhatIf -Uri $TestURI -Method Get -Headers $MyHeaders
                        } 
                    else 
                        {   $ReturnData = invoke-restmethod -uri "$TestUri" -Method Get -headers $MyHeaders
                        }
            }
    Catch   {   $_
            }
    if ( $ReturnData )
            {   return @{ Access_Token = $AccessToken }
            } 
        else 
            {   if (-not $whatif) 
                    {   Write-Error "No HPE DSSC target Detected or wrong port used at that address"
                    }
            }
        }
}
 
function Invoke-RestMethodWhatIf
{   Param(  $Uri,
            $Method,
            $Headers,
            $Body
         )
    if ( -not $Body ) 
        {   $Body = 'No Body'
        }
    write-warning "You have selected the What-IF option, so the call will note be made to the array, `ninstead you will see a preview of the RestAPI call"
    Write-host "The URI for this call will be " 
    write-host  "$Uri" -foregroundcolor green
    Write-host "The Method of this call will be "
    write-host -foregroundcolor green $Method
    Write-host "The Header for this call will be :"
    write-host -foregroundcolor green ($Headers | ConvertTo-JSON | Out-String)    
    write-host "The Body of this call will be:"
    write-host -foregroundcolor green ($Body | ConvertTo-JSON | Out-String)
}
