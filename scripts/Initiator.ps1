function Get-DSCCInitiator
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Initiators Collection    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager Initiators Collections;
.PARAMETER SystemID
    If the Target Device to detect the Initiators from is a Nimble Storage or Alletra 6K, you will need to supply a System ID.
.PARAMETER InitiatorID
    If a single Host ID is specified the output will be limited to that single record.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-DSCCDOMInitiator | convertTo-Json

    [   {   "address": "100008F1EABFE61C",
            "associatedLinks": [    {   "resourceUri": "string",
                                        "type": "string"
                                    }
                                ],
            "driverVersion": "4.1",
            "firmwareVersion": "10.0",
            "hbaModel": "myobject-5",
            "host": [   {   "id": "6848ef683c27403e96caa51816ddc72c",
                            "ipAddress": "15.212.100.100",
                            "name": "host1"
                        }
            "hostSpeed": 1000,
            "id": "d548ef683c27403e96caa51816ddc72c",
            "ipAddress": "15.212.100.100",
            "name": "init1",
            "protocol": "FC",
            "systems":  [    "string"    
                        ],
            "vendor": "hpe"
        }
    ],
.EXAMPLE
    PS:> Get-DSCCInitiator

    id                               address                 name                               protocol type      systems
    --                               -------                 ----                               -------- ----      -------
    00219be7785a43368fbab49295e2e0b1 c0:77:3f:58:5f:19:00:0a Host Path C0773F585F19000A (1:3:2) FC       initiator {2M2019018G}
    00bace011e774445b208858e2545a048 c0:77:2f:58:5f:19:00:50 Host Path C0772F585F190050 (1:3:1) FC       initiator {0006b878a5a008ec63000000000000000000000001, 2M202205GF}
    010814bed01b4258871fa834368c9796 c0:77:3f:58:5f:19:00:48 Host Path C0773F585F190048 (1:3:3) FC       initiator {2M2042059V}
    01ca788a6b244069a295d86dee748867 c0:77:3f:58:5f:19:00:2e Host Path C0773F585F19002E (1:3:2) FC       initiator {2M2042059V}
.EXAMPLE
    PS:> Get-DSCCInitiator -InitiatorID 46eaf545bf80404d8e479ec8d6871c97
    
    id                               address                 name                               protocol type      systems
    --                               -------                 ----                               -------- ----      -------
    46eaf545bf80404d8e479ec8d6871c97 c0:77:3f:58:5f:19:00:0a Host Path C0773F585F19000A (1:3:2) FC       initiator {2M2019018G}
.EXAMPLE
    PS:> Get-DSCCInitiator -InitiatorID 46eaf545bf80404d8e479ec8d6871c97  -WhatIf
    
    WARNING: You have selected the What-IF option, so the call will note be made to the array,
        instead you will see a preview of the RestAPI call
        
    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/initiators/46eaf545bf80404d8e479ec8d6871c97
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6Iko3Tmtmc3M4eDNEaGN3NWtQcnRNVVp5R0g2TSIsInBpLmF0bSI6ImRlejAifQ.eyJjbGllbnRfaWQiOiIzZjIwODU4NS0zZGE2LTRiZjctOTRjYS00ZjMxMGQwOTYzYjUiLCJpc3MiOiJodHRwczovL3Nzby5jb21tb24uY2xvdWQuaHBlLmNvbSIsImF1ZCI6ImV4dGVybmFsX2FwaSIsInN1YiI6ImNocmlzLmxpb25ldHRpQGhwZS5jb20iLCJ1c2VyX2N0eCI6IjAwNTZiNzFlZWZjNDExZWJhMjY4NjJhZGI4NzdjMmQ4IiwiYXV0aF9zb3VyY2UiOiJjY3NfdG9rZW5fbWFuYWdlbWVudCIsInBsYXRmb3JtX2N1c3RvbWVyX2lkIjoiOGZmYzRiN2VlOWQyMTFlYjhjZWU2ZTEzYzA3MWVhMzciLCJpYXQiOjE2MzU5NTM2NzYsImFwcGxpY2F0aW9uX2luc3RhbmNlX2lkIjoiM2MxOGJkMDMtODMwNi00YzdjLTk0MmUtYzcwNGE0Yjg3NDRjIiwiZXhwIjoxNjM1OTYwODc2fQ.Yp7WTVGc0vU6sE3r8KPL4R0_sW4dB9ZvGijqwGwMpDBZ4SEz5688s-C2al1HLFnpZygPnQfSm1NWjxQgLeKSbf54gvxz7kMlhsRWtRW4vWIIPw5XHmKGVjqnGsVjdkcs8QmlBAg7eR5FcrU_b4HAIicmNV07U5rtC2LoUytT85JM20_6SEV1uZwGTWSlSs26JKNOeOEepW5BdmWrIX7DQibwzq_HUz2COF_hdVZCYCNt-pzigb8c6POr9s3RD-ZSal9naLDz0gCfVds-CKOZ5WHxijtnqG-qZ5KBvcXk22_JcfXAoA02u2o9xZ2z6UZh71yLlH9dXQ1KAahJ26k5lw"
        }
    The Body of this call will be:
        "No Body"

    The results of the complete collection have been limited to just the supplied ID
#>   
[CmdletBinding()]
param(  [parameter( ValueFromPipeLineByPropertyName=$true )][Alias('id')]   [string]    $SystemId,
                                                                            [string]    $InitiatorID,
                                                                            [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        if ( ( -not $SystemId )  -or ( (Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId) -eq 'device-type1' ) )
                {   $MyAdd = 'initiators'
                }
            else
                {   if ( ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId ) -ne 'device-type2' )
                            {   Write-warning "The System ID passed in does not register as a valid SystemId"
                                return
                            }
                    $MyAdd = 'storage-systems/device-type2/'+$SystemId+'/host-initiators'
                }
        $SysColOnly = Invoke-DSCCRestMethod -UriAdd $MyAdd -method Get -whatifBoolean $WhatIf
        $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Initiator"
        if ( $InitiatorID )
                {   Write-host "The results of the complete collection have been limited to just the supplied ID"
                    return ( $ReturnData | where-object { $_.id -eq $InitiatorID } )
                }
            else
                {   return $ReturnData
                }
    }
}
function Remove-DSCCInitiator
{
<#
.SYNOPSIS
    Removes a HPE DSSC DOM Initiator.    
.DESCRIPTION
    Removes a HPE Data Services Cloud Console Data Operations Manager Host specified by Initiator ID;
.PARAMETER InitiatorID
    A single Initiator ID must be specified.
.PARAMETER force
    Will implement an API forcefull remove option instead of the default normal removal mechanism.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.

.EXAMPLE
    PS:> Remove-DSCCHostServiceInitiator -InitiatorID d548ef683c27403e96caa51816ddc72c

    {   "deleteInitiator": true
    }
.LINK
#>   
[CmdletBinding()]
param(  [Parameter(Mandatory)]  [string]    $InitiatorID,
                                [switch]    $Force,
                                [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyAdd = 'initiators/' + $InitiatorID
        $MyBody = ''
        if ($Force)
                {   $MyBody = @{force=$true}
                }
        return Invoke-DSCCRestMethod -UriAdd $MyAdd -Method 'Delete' -Body $MyBody -WhatIfBoolean $WhatIf
    }       
}   
Function New-DSCCInitiator
{
<#
.SYNOPSIS
    Creates a HPE DSSC DOM Initiator Record.    
.DESCRIPTION
    Creates a HPE Data Services Cloud Console Data Operations Manager Host Initiator Record; This will create either a Device-Type1 type Initiator,
    or if a SystemID is specified, then it will make a Device-Type2 type initiator
.PARAMETER systemID
    This is required for Device-Type2, and references a specific system ID. This can be passed in as a pipeline variable.
.PARAMETER Address
    Used only for Device-Type1. The Address of the initiator and is required.
.PARAMETER wwpn
    The World Wide Port name, used only for Device-Type2, and only for FC connections
.PARAMETER driverVersion
    Driver Version of the Host Initiator. Used only for Device-Type1. 
.PARAMETER firmwareVersion
    Firmware Version of the Host Initiator. Used only for Device-Type1. 
.PARAMETER hbaModel
    Host bus adaptor model of the host initiator. Used only for Device-Type1. 
.PARAMETER HostSpeed
    Host Speed. Used only for Device-Type1. 
.PARAMETER ipAddress
    IP Address of the Initiator. Used for both Device-Types, but only for iSCSI connections.
.PARAMETER iqn
    The IQN of the Initiator, used for Device-Type2, but only for iSCSI connections
.PARAMETER name
    Name of the Initiator. Used only for Device-Type1. 
.PARAMETER alias
    Name of the Initiator. Used only for Device-Type2, and only for FC connections 
.PARAMETER label
    Name of the Initiator. Used only for Device-Type2, and only for iSCSI connections 
.PARAMETER protocol
    The protocol can be FC, iSCSI, or NVMe and is required.
.PARAMETER Vendor
    Vendor of the host initiator.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.

.EXAMPLE
    PS:> New-DSCCHostServiceInitiator -Address 100008F1EABFE61C -name Host1InitA -protocol FC

    {   "message": "Successfully submitted",
        "status": "SUBMITTED",
        "taskUri": "/rest/vega/v1/tasks/4969a568-6fed-4915-bcd5-e4566a75e00c"
    }
#>   
[CmdletBinding()]
param(  [Parameter(Mandatory)]          [string]    $address,
                                        [string]    $driverVersion,
                                        [string]    $firmwareVersion,
                                        [string]    $hbaModel,
                                        [int64]     $hostSpeed,
                                        [string]    $ipAddress,
                                        [string]    $name,  
        [Parameter(Mandatory)]  
        [ValidateSet('FC','iSCSI','NMVe')][string]  $protocol,
                                        [string]    $vendor,
                                        [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyAdd = 'initiators'
                                    $MyBody += [ordered]@{ address = $address           } 
        if ($driverVerson)      {   $MyBody += @{ driverVersion = $driverVersion     }  }
        if ($firmwareVersion)   {   $MyBody += @{ firmwareVersion = $firmwareVersion }  }
        if ($hbaModel)          {   $MyBody += @{ hbaModel = $hbaModel               }  }
        if ($hostSpeed)         {   $MyBody += @{ hostSpeed = $hostSpeed             }  }
        if ($ipAddress)         {   $MyBody += @{ ipAddress = $ipAddress             }  }
        if ($name)              {   $MyBody += @{ name = $name                       }  }
                                    $MyBody += @{ protocol = $protocol                  }
        if ($vendor)            {   $MyBody += @{ vendor = $vendor                   }  }
        Invoke-DSCCRestMethod -UriAdd $MyAdd - Method 'POST' -body $MyBody -whatifBoolean $WhatIf
    }       
}   
