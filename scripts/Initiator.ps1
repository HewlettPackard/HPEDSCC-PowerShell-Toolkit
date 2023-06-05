function Get-DSCCInitiator
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Initiators Collection    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager Initiators Collections;
.PARAMETER SystemID
    Ths command will return ALL of the Initiators unless a specific SystemID is specified. If the System
    Id is spefified, then only those that System matches will be returned
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-DSCCInitiator | convertTo-Json

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
    010814bed01b4258871fa834368c9796 c0:77:3f:58:5f:19:00:48 Host Path C0773F585F190048 (1:3:3) FC       initiator 
    01ca788a6b244069a295d86dee748867 c0:77:3f:58:5f:19:00:2e Host Path C0773F585F19002E (1:3:2) FC       initiator {2M2042059V}
.EXAMPLE
    PS:> Get-DSCCInitiator -SystemId 2M20260BM0
    
    id                               address                 name                               protocol type      systems
    --                               -------                 ----                               -------- ----      -------
    46eaf545bf80404d8e479ec8d6871c97 c0:77:3f:58:5f:19:00:0a Host Path C0773F585F19000A (1:3:2) FC       initiator {2M20260BM0}
.EXAMPLE
    PS:> Get-DSCCInitiator -WhatIf $true
    
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
{   if ( -not $SystemId )
            {   $ReturnCol= @()
                write-verbose "No SystemID was given, so running against all system IDs"
                # The following code will return a list of initiators that exist for EACH storage system detected. This is recursive
                    foreach ( $Sys in Get-DSCCStorageSystem )
                        {   write-verbose "Running discover on a singular System ID"
                            If ( ($Sys).id )
                                {   write-verbose "This systemID is valid."
                                    $ReturnCol += Get-DSCCInitiator -SystemId ($Sys).id -whatif $WhatIf
                                }
                        }
                # This block of code gets the Initiators that are not assigned to ANY system, and adds them to the results
                    $MyAdd = 'initiators'
                    $SysColOnly = Invoke-DSCCRestMethod -UriAdd $MyAdd -Method 'Get' -WhatIfBoolean $WhatIf
                    $BlankOnes = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Initiator"
                    $ReturnCol += ( $BlankOnes | where-object { $_.systems -like '' } )
                # The following return will sort for Uniqueness and return ALL of the Initiators
                return ( $ReturnCol | sort-object -Property id -unique )
            } 
        else
            {   # This block only runs if a specific SystemID is provided, and limits its results to ONLY that system ID.
                switch(Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId)
                    {   'device-type1'  {   $MyAdd = 'initiators'
                                            write-verbose "Getting a Type1 Initiator List $MyAdd"  
                                        }    
                        'device-type2'  {   $MyAdd = 'storage-systems/device-type2/'+$SystemId+'/host-initiators'
                                            write-verbose "Getting a Type2 Initiator List $MyAdd"
                                        }    
                        default         {   Write-warning "The System ID passed in does not register as a valid SystemId"
                                            return
                                        }                
                    }
                write-verbose "About to make main call to retrieve Initiators"
                $SysColOnly = Invoke-DSCCRestMethod -UriAdd $MyAdd -Method 'Get' -WhatIfBoolean $WhatIf
                $FilteredList = ( $SysColOnly | where-object { $_.systems -like $SystemId } )
                return Invoke-RepackageObjectWithType -RawObject $FilteredList -ObjectName "Initiator"
            }
}
}
function Remove-DSCCInitiator
{
<#
.SYNOPSIS
    Removes a HPE DSSC Initiator.    
.DESCRIPTION
    Removes a HPE Data Services Cloud Console Host specified by Initiator ID; If the 
    initiator is a Device-Type2, then it will read the initiator to determine which system to delete the initiator from, 
    otherwise it will send the command to the DSCC console, which works for initiators not assigned to individual storage
    systems, or those assigned to Device-Type1
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
param(  [Parameter( Mandatory )]        [string]    $InitiatorId,
                                        [switch]    $Force,
                                        [boolean]   $WhatIf=$false
    )
process

    {   $MyInitiator = Get-DSCCInitiator | where-object { $_.id -like $InitiatorId}
        $MyInitiatorId = $MyInitiator.id
        write-Verbose "MyInitiatorId = $MyInitiatorId"
        if ( $MyInitiatorId )
                {   $MySystemId = ($MyInitiator).Systems
                    if ( (Find-DSCCDeviceTypeFromStorageSystemID -SystemId $MySystemId) -like 'device-type2' ) 
                            {   # If its a Nimble, then the Initiator is located in a different place on the Array instead of DSCC
                                write-Verbose "Type2 System Detected"
                                $MyAdd = 'storage-systems/device-type2/'+$MySystemId+'/host-initiators/'+$MyInitiatorId
                                return ( Invoke-DSCCRestMethod -UriAdd $MyAdd -Method 'Delete' -WhatIfBoolean $WhatIf )
                            }
                        else                    
                            {   # This code block runs either if its a Type1 system, or if SystemId is blank
                                write-verbose "Type1 System Detected"
                                $MyAdd = 'initiators/' + $MyInitiatorID
                                $MyBody = ''
                                if ($Force) 
                                        {   $MyAdd += '?force=true'
                                        }
                                return ( Invoke-DSCCRestMethod -UriAdd $MyAdd -Method 'Delete' -Body ( $MyBody | convertto-json ) -WhatIfBoolean $WhatIf )
                            }
                }
            else 
                {   write-error "The initiatorId presented does not exist in the DSCC console."
                    return
                }
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
.PARAMETER DeviceType1
    This switch is used to tell the command that the end device is the specific device type, and to only allow the correct
    parameter set that matches this device type.
.PARAMETER DeviceType2
    This switch is used to tell the command that the end device is the specific device type, and to only allow the correct
    parameter set that matches this device type.
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
param(  
        [Parameter(ParameterSetName = 'type1'                   )]      [switch]    $DeviceType1,
        [Parameter(ParameterSetName = 'type2iscsi'              )]
        [Parameter(ParameterSetName = 'type2fc'                 )]      [switch]    $DeviceType2, 
        [Parameter(ParameterSetName = 'type2iscsi', Mandatory   )]
        [Parameter(ParameterSetName = 'type2fc',    Mandatory   )]      [string]    $SystemId,
        [Parameter(ParameterSetName = 'type2iscsi', Mandatory   )]
        [Parameter(ParameterSetName = 'type2fc'                 )]   
            [ValidateSet('fc','iscsi')]                                 [string]    $access_protocol,
        [Parameter(ParameterSetName = 'type2fc'                 )]      [string]    $alias,
        [Parameter(ParameterSetName = 'type2iscsi'              )]      [string]    $label,
        [Parameter(ParameterSetName = 'type2iscsi'              )]      [string]    $chapuser_id,
        [Parameter(ParameterSetName = 'type2iscsi', Mandatory   )]
        [Parameter(ParameterSetName = 'type2fc',    Mandatory   )]      [string]    $initiator_group_id,
        [Parameter(ParameterSetName = 'type2iscsi'              )]      [string]    $ip_address,
        [Parameter(ParameterSetName = 'type2iscsi', Mandatory   )]      [string]    $iqn,
        [Parameter(ParameterSetName = 'type2iscsi'              )]
        [Parameter(ParameterSetName = 'type2fc'                 )]      [boolean]   $override_existing_alias,
        [Parameter(ParameterSetName = 'type2fc',    Mandatory   )]      [string]    $wwpn,        
        [Parameter(parameterSetName = 'type1',      Mandatory   )]      [string]    $address,
        [Parameter(ParameterSetName = 'type1'                   )]      [string]    $driverVersion,
        [Parameter(ParameterSetName = 'type1'                   )]      [string]    $firmwareVersion,
        [Parameter(ParameterSetName = 'type1'                   )]      [string]    $hbaModel,
        [Parameter(ParameterSetName = 'type1'                   )]      [int]       $hostSpeed,
        [Parameter(ParameterSetName = 'type1'                   )]      [string]    $ipAddress,
        [Parameter(ParameterSetName = 'type1'                   )]      [string]    $name,  
        [Parameter(ParameterSetName = 'type1',      Mandatory   )]
            [ValidateSet('FC','iSCSI','NMVe')]                          [string]    $protocol,
        [Parameter(ParameterSetName = 'type1'                   )]      [string]    $vendor,
        [Parameter(ParameterSetName = 'type2iscsi'              )]                               
        [Parameter(ParameterSetName = 'type2fc'                 )]                               
        [Parameter(ParameterSetName = 'type1'                   )]      [boolean]    $WhatIf = $false
    )
process
    {   Switch($PSCmdlet.ParameterSetName)
            {   'type1'     {   $MyAdd = 'initiators'
                                $MyBody += [ordered]@{                    address           = $address         } 
                                if ($driverVerson)      {   $MyBody += @{ driverVersion     = $driverVersion   }  }
                                if ($firmwareVersion)   {   $MyBody += @{ firmwareVersion   = $firmwareVersion }  }
                                if ($hbaModel)          {   $MyBody += @{ hbaModel          = $hbaModel        }  }
                                if ($hostSpeed)         {   $MyBody += @{ hostSpeed         = $hostSpeed       }  }
                                if ($ipAddress)         {   $MyBody += @{ ipAddress         = $ipAddress       }  }
                                if ($name)              {   $MyBody += @{ name              = $name            }  }
                                                            $MyBody += @{ protocol          = $protocol        }
                                if ($vendor)            {   $MyBody += @{ vendor            = $vendor          }  }
                                if ( $DeviceType2 )     {   write-error "The Wrong Device Type was specified"
                                                            Return
                                                        }
                            }
                'type2iscsi'{   $MyAdd = 'storage-systems/device-type2/' + $SystemId + '/host-initiators'
                                $MyBody += [ordered]@{                        access_protocol             = $access_protocol            } 
                                if ($chapuser_id)               {   $MyBody += @{ chapuser_id             = $chapuser_id             }  }
                                                                    $MyBody += @{ initiator_group_id      = $initiator_group_id         }  
                                if ($ip_address)                {   $MyBody += @{ ip_address              = $ip_address              }  }
                                if ($iqn)                       {   $MyBody += @{ iqn                     = $iqn                     }  }
                                if ($label)                     {   $MyBody += @{ label                   = $label                   }  }
                                if ($override_existing_alias)   {   $MyBody += @{ override_existing_alias = $override_existing_alias }  }
                                if ( $DeviceType1 )             {   write-error "The Wrong Device Type was specified"
                                                                    Return
                                                                }
                            }
                'type2fc'   {   $MyAdd = 'storage-systems/device-type2/' + $SystemId + '/host-initiators'
                                $MyBody += [ordered]@{                            access_protocol         = $access_protocol            } 
                                if ($alias)                     {   $MyBody += @{ alias                   = $alias                   }  }
                                                                    $MyBody += @{ initiator_group_id      = $initiator_group_id         }  
                                if ($override_existing_alias )  {   $MyBody += @{ override_existing_alias = $override_existing_alias }  }
                                if ($wwpn)                      {   $MyBody += @{ vendor                  = $vendor                  }  }
                                if ( $DeviceType1 )             {   write-error "The Wrong Device Type was specified"
                                                                    Return
                                                                }
                            }
            }
        return ( Invoke-DSCCRestMethod -UriAdd $MyAdd -Method POST -body ($MyBody | convertto-json) -whatifBoolean $WhatIf )
    }       
}   