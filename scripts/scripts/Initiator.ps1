function Get-DSCCInitiator
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Initiators Collection    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager Initiators Collections;
.PARAMETER SystemID
    If the Target Device to detect the Initiators from is a Nimble Storage or Alletra 6K, you will need to supply a System ID.
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
    PS:> Get-DSCCInitiator | where {$_.id -like '46eaf545bf80404d8e479ec8d6871c97'
    
    id                               address                 name                               protocol type      systems
    --                               -------                 ----                               -------- ----      -------
    46eaf545bf80404d8e479ec8d6871c97 c0:77:3f:58:5f:19:00:0a Host Path C0773F585F19000A (1:3:2) FC       initiator {2M2019018G}
.EXAMPLE
    PS:> Get-DSCCInitiator -WhatIf
    
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
                                                                            [boolean]   $WhatIf=$false
     )
process
{   Invoke-DSCCAutoReconnect
    if ( -not $SystemId )
            {   $ReturnCol= @()
                write-verbose "No SystemID was given, so running against all system IDs"
                foreach ( $Sys in Get-DSCCStorageSystem )
                    {   write-verbose "Running discover on a singular System ID"
                        IF ( ($Sys).id )
                            {   write-verbose "This systemID is valid."
                                $ReturnCol += Get-DSCCInitiator -SystemId ($Sys).id -whatif $WhatIf
                            }
                    }
                return $ReturnCol
            } 
        else
            {
                switch(Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId)
                    {   'device-type1'  {   $MyAdd = 'initiators'  
                                        }    
                        'device-type2'  {   $MyAdd = 'storage-systems/device-type2/'+$SystemId+'/host-initiators'  
                                        }    
                        default         {   Write-warning "The System ID passed in does not register as a valid SystemId"
                                            return
                                        }                
                    }
                write-verbose "About to make main call to retrieve Initiators"
                $SysColOnly = Invoke-DSCCRestMethod -UriAdd $MyAdd -Method 'Get' -WhatIfBoolean $WhatIf
                $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Initiator"
                return $ReturnData
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
                                [boolean]   $WhatIf=$false
     )
process
    {   $MyAdd = 'initiators/' + $InitiatorID
        $MyBody = ''
        if ($Force)
                {   $MyBody = @{force=$true}
                }
        return ( Invoke-DSCCRestMethod -UriAdd $MyAdd -Method 'Delete' -Body $MyBody -WhatIfBoolean $WhatIf )
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
    This is required for Device-Type2, and references a specific system ID.
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
[CmdletBinding(DefaultParameterSetName = 'type1')]
param(  [Parameter(Mandatory, ParameterSetName = 'type2iscsi')]
        [Parameter(Mandatory, ParameterSetName = 'type2fc')]                             [string]    $SystemId,
        [Parameter(Mandatory, ParameterSetName = 'type2isci')]
        [Parameter(Mandatory, ParameterSetName = 'type2fc')][ValidateSet('fc','iscsi')]  [string]    $access_protocol,
        [Parameter(           ParameterSetName = 'type2fc')]                             [string]    $alias,
        [Parameter(           ParameterSetName = 'type2iscsi')]                          [string]    $label,
        [Parameter(           ParameterSetName = 'type2iscsi')]                          [string]    $chapuser_id,
        [Parameter(Mandatory, ParameterSetName = 'type2iscsi')]
        [Parameter(Mandatory, ParameterSetName = 'type2fc')]                             [string]    $initiator_group_id,
        [Parameter(           ParameterSetName = 'type2iscsi')]                          [string]    $ip_address,
        [Parameter(           ParameterSetName = 'type2iscsi')]                          [string]    $iqn,
        [Parameter(           ParameterSetName = 'type2')]                               [boolean]   $override_existing_alias,
        [Parameter(           ParameterSetName = 'type2fc')]                             [string]   $wwpn,

        
        [Parameter(Mandatory, parameterSetName = 'type1')]          [string]    $address,
        [Parameter(ParameterSetName = 'type1')]                     [string]    $driverVersion,
        [Parameter(ParameterSetName = 'type1')]                     [string]    $firmwareVersion,
        [Parameter(ParameterSetName = 'type1')]                     [string]    $hbaModel,
        [Parameter(ParameterSetName = 'type1')]                     [int64]     $hostSpeed,
        [Parameter(ParameterSetName = 'type1')]                     [string]    $ipAddress,
        [Parameter(ParameterSetName = 'type1')]                     [string]    $name,  
        [Parameter(ParameterSetName = 'type1', Mandatory)]  
        [ValidateSet('FC','iSCSI','NMVe')]                          [string]    $protocol,
        [Parameter(ParameterSetName = 'type1')]                     [string]    $vendor,
        [Parameter(ParameterSetName = 'type1')]                     [switch]    $WhatIf
     )
process
    {   Switch($PSCmdlet.ParameterSetName)
            {   'type1'     {   $MyAdd = 'initiators'
                                $MyBody += [ordered]@{                    address  = $address           } 
                                if ($driverVerson)      {   $MyBody += @{ driverVersion = $driverVersion     }  }
                                if ($firmwareVersion)   {   $MyBody += @{ firmwareVersion = $firmwareVersion }  }
                                if ($hbaModel)          {   $MyBody += @{ hbaModel = $hbaModel               }  }
                                if ($hostSpeed)         {   $MyBody += @{ hostSpeed = $hostSpeed             }  }
                                if ($ipAddress)         {   $MyBody += @{ ipAddress = $ipAddress             }  }
                                if ($name)              {   $MyBody += @{ name = $name                       }  }
                                                            $MyBody += @{ protocol = $protocol                  }
                                if ($vendor)            {   $MyBody += @{ vendor = $vendor                   }  }
                            }
                'type2iscsi'{   $MyAdd = 'storage-systems/device-type2/' + $SystemId + 'host-initiators'
                                $MyBody += [ordered]@{                         access_protocol         = $access_protocol            } 
                                if ($chapuser_id)            {   $MyBody += @{ chapuser_id             = $chapuser_id             }  }
                                                                 $MyBody += @{ initiator_group_id      = $initiator_group_id         }  
                                if ($ip_address)             {   $MyBody += @{ ip_address              = $ip_address              }  }
                                if ($iqn)                    {   $MyBody += @{ iqn                     = $iqn                     }  }
                                if ($label)                  {   $MyBody += @{ vendor                  = $vendor                  }  }
                                if ($override_existing_alias){   $MyBody += @{ override_existing_alias = $override_existing_alias }  }
                            }
                'type2fc'   {   $MyAdd = 'storage-systems/device-type2/' + $SystemId + 'host-initiators'
                                $MyBody += [ordered]@{                         access_protocol         = $access_protocol            } 
                                if ($alias)                  {   $MyBody += @{ alias                   = $alias                   }  }
                                                                 $MyBody += @{ initiator_group_id      = $initiator_group_id         }  
                                if ($override_existing_alias){   $MyBody += @{ override_existing_alias = $override_existing_alias }  }
                                if ($wwpn)                   {   $MyBody += @{ vendor = $vendor                                   }  }
                            }
            }
        return ( Invoke-DSCCRestMethod -UriAdd $MyAdd - Method 'POST' -body $MyBody -whatifBoolean $WhatIf )
    }       
}   