function Get-DSCCHost
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Hosts Collection    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager Host Collections;
.PARAMETER HostID
    If a single Host ID is specified the output will be limited to that single record.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-DSCCHost | convertTo-Json

    {
    "id":  "733b0e0808c3469d8a8650974cac8847",
    "name":  "TestHostInitiator1",
    "ipAddress":  null,
    "fqdn":  null,
    "operatingSystem":  "Windows Server",
    "systems":  [
                    "0006b878a5a008ec63000000000000000000000001",
                    "2M202205GF"
                ],
    "associatedSystems":  [
                              "0006b878a5a008ec63000000000000000000000001"
                          ],
    "userCreated":  true,
    "hostGroups":  [
                       {
                           "id":  "3ea6d00cb589489c94d928f41ca5ad28",
                           "name":  "TestHostGroup1",
                           "userCreated":  true,
                           "systems":  "0006b878a5a008ec63000000000000000000000001 2M202205GF",
                           "markedForDelete":  false
                       }
                   ],
    "comment":  null,
    "protocol":  null,
    "customerId":  "ffc311463d8711ecbdd5428607ee1704",
    "type":  "host-initiator",
    "generation":  1638468553,
    "consoleUri":  "/data-ops-manager/host-initiators/733b0e0808c3469d8a8650974cac8847",
    "initiators":  [
                       {
                           "id":  "00bace011e774445b208858e2545a048",
                           "ipAddress":  null,
                           "address":  "c0:77:2f:58:5f:19:00:50",
                           "name":  "Host Path C0772F585F190050 (1:3:1)",
                           "protocol":  "FC",
                           "systems":  "0006b878a5a008ec63000000000000000000000001 2M202205GF"
                       }
                   ],
    "location":  null,
    "persona":  null,
    "subnet":  null,
    "markedForDelete":  false,
    "editStatus":  "Not_Applicable",
    "associatedLinks":  [
                            {
                                "type":  "initiators",
                                "resourceUri":  "/api/v1/initiators?filter=hostId in (733b0e0808c3469d8a8650974cac8847)"
                            },
                            {
                                "type":  "host-groups",
                                "resourceUri":  "/api/v1/host-initiator-groups?filter=hostId in (733b0e0808c3469d8a8650974cac8847)"
                            }
                        ],
    "model":  null,
    "contact":  null
}
.EXAMPLE
    PS:> Get-DSCCHost

    id                               name               operatingSystem protocol type
    --                               ----               --------------- -------- ----
    733b0e0808c3469d8a8650974cac8847 TestHostInitiator1 Windows Server           host-initiator
.EXAMPLE
    PS:> Get-DSCCHostServiceHost -HostID f0b1edd8f8984c8db9e596f25de0bdf4

    PS:> Get-DSCCHost

    id                               name               operatingSystem protocol type
    --                               ----               --------------- -------- ----
    f0b1edd8f8984c8db9e596f25de0bdf4 TestHostInitiator1 Windows Server           host-initiator
.LINK
    The API call for this operation is file:///api/v1/host-initiator-groups
#>   
[CmdletBinding()]
param(  [string]    $HostID,
        [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyAdd = 'host-initiators'
        $SysColOnly = Invkoe-DSCCRestMethod -UriAdd $MyAdd -method Get -WhatIfBoolean $WhatIf
        $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "Host"
        if ( $HostID )
                    {   Write-verbose "The results of the complete collection have been limited to just the supplied ID"
                        return ( $ReturnData | where-object { $_.id -eq $HostId } )
                    } 
                else 
                    {   return $ReturnData
                    }
    }       
}   
function Remove-DSCCHost
{
<#
.SYNOPSIS
    Removes a HPE DSSC DOM Host.    
.DESCRIPTION
    Removes a HPE Data Services Cloud Console Data Operations Manager Host specified by ID;
.PARAMETER HostGroupID
    A single Host ID must be specified.
.PARAMETER force
    Will implement an API forcefull remove option instead of the default normal removal mechanism.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Remove-HPEDSCCDOMHostServiceHostGroup -HostId e987ef683c27403e96caa51816ddc72c

    taskUri                              status    message
    -------                              ------    -------
    2899825b-0ac9-4145-9c6a-e1860db615b4 SUBMITTED
.EXAMPLE
    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://fleetscale-app.qa.cds.hpe.com/api/v1/host-initiators/b0a2e29f7f384b5181cabb262afa8c16
    The Method of this call will be
        Delete
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciOiJ-wuFoaq8XP9gcnvSSgwKnTJ_g318BZMk7KXcgWaskk2go93DKPZtl_30wn5B6UIDGwHKqrcuD8V4Mbw"
        }
    The Content-Type is set to
        application/json
    The Body of this call will be:
        "{\r\n    \"force\":  true\r\n}"
.LINK
#>   
[CmdletBinding()]
param(  [Parameter(Mandatory)]  [string]    $HostID,
                                [switch]    $Force,
                                [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyAdd = 'host-initiators/' + $HostID
        if ($Force)
            {   $MyBody = ( @{force=$true} | convertto-json )
            }
        return Invoke-DSCCRestMethod -UriAdd $MyAdd -Method 'Delete' -body $MyBody -WhatIfBoolean $WhatIf
    }       
}   
function Get-DSCCHostVolume
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Volumes that a Host can see    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager volumes visible to a specified Host;
.PARAMETER HostID
    A single Host ID is required.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-DSCCHostServiceHostVolume -HostId e1839c72fef8784f2c77194efb8b2620
    
    {   "iops": 4702,
        "latencyMs": 1.2,
        "pathCount": 2,
        "resourceUri": "/v1/storage-systems/device-type1/7CE738P06J/volumes/e1839c72fef8784f2c77194efb8b2620",
        "systemId": "7CE751P312",
        "throughputKbps": 477219.2,
        "volumeName": "test-vv"
    }
.EXAMPLE
    PS:> Get-DSCCHostServiceHostVolume | convertTo-Json
    [   {   "iops": 4702,
            "latencyMs": 1.2,
            "pathCount": 2,
            "resourceUri": "/v1/storage-systems/device-type1/7CE738P06J/volumes/e1839c72fef8784f2c77194efb8b2620",
            "systemId": "7CE751P312",
            "throughputKbps": 477219.2,
            "volumeName": "test-vv"
        }
    ],
.EXAMPLE
    PS:> Get-DSCCHostServiceHostVolume -HostId f0b1edd8f8984c8db9e596f25de0bdf4
    
    WARNING: You have selected the What-IF option, so the call will note be made to the array,
        instead you will see a preview of the RestAPI call
    
    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/host-initiators/f0b1edd8f8984c8db9e596f25de0bdf4/volumes
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6Iko3Tmtmc3M4eDNEaGN3NWtQcnRNVVp5R0g2TSIsInBpLmF0bSI6ImRlejAifQ.eyJjbGllbnRfaWQiOiIzZjIwODU4NS0zZGE2LTRiZjctOTRjYS00ZjMxMGQwOTYzYjUiLCJpc3MiOiJodHRwczovL3Nzby5jb21tb24uY2xvdWQuaHBlLmNvbSIsImF1ZCI6ImV4dGVybmFsX2FwaSIsInN1YiI6ImNocmlzLmxpb25ldHRpQGhwZS5jb20iLCJ1c2VyX2N0eCI6IjAwNTZiNzFlZWZjNDExZWJhMjY4NjJhZGI4NzdjMmQ4IiwiYXV0aF9zb3VyY2UiOiJjY3NfdG9rZW5fbWFuYWdlbWVudCIsInBsYXRmb3JtX2N1c3RvbWVyX2lkIjoiOGZmYzRiN2VlOWQyMTFlYjhjZWU2ZTEzYzA3MWVhMzciLCJpYXQiOjE2MzU5NTM2NzYsImFwcGxpY2F0aW9uX2luc3RhbmNlX2lkIjoiM2MxOGJkMDMtODMwNi00YzdjLTk0MmUtYzcwNGE0Yjg3NDRjIiwiZXhwIjoxNjM1OTYwODc2fQ.Yp7WTVGc0vU6sE3r8KPL4R0_sW4dB9ZvGijqwGwMpDBZ4SEz5688s-C2al1HLFnpZygPnQfSm1NWjxQgLeKSbf54gvxz7kMlhsRWtRW4vWIIPw5XHmKGVjqnGsVjdkcs8QmlBAg7eR5FcrU_b4HAIicmNV07U5rtC2LoUytT85JM20_6SEV1uZwGTWSlSs26JKNOeOEepW5BdmWrIX7DQibwzq_HUz2COF_hdVZCYCNt-pzigb8c6POr9s3RD-ZSal9naLDz0gCfVds-CKOZ5WHxijtnqG-qZ5KBvcXk22_JcfXAoA02u2o9xZ2z6UZh71yLlH9dXQ1KAahJ26k5lw"
        }
    The Body of this call will be:
        "No Body"
.EXAMPLE
    PS:> # The following example snippet returns ALL volumes for all hosts, since HostID is required
    PS:> ForEach($HostItem in Get-DSCCHostServicehost) { Get-DSCCHostServiceHostVolume -HostID ($HostItem).id }
#>   
[CmdletBinding()]
param(  [string]    $HostID,
        [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyAdd = 'host-initiators/' + $HostID + '/volumes'
        $ReturnData = Invoke-DSCCRestMethod -UriAdd $MyAdd -Method Get -WhatIfBoolean $WhatIf
        if ( $HostID )
                {   Write-verbose "The results of the complete collection have been limited to just the supplied ID"
                    return ( $ReturnData | where-object { $_.id -eq $HostId } )
                } 
            else 
                {   return $ReturnData
                }
    }       
} 
Function New-DSCCHost
{
<#
.SYNOPSIS
    Creates a HPE DSSC DOM Host Record.    
.DESCRIPTION
    Creates a HPE Data Services Cloud Console Data Operations Manager Host Record;
.PARAMETER comment
    Address of the initiator and is required.
.PARAMETER contact
    A string representing the contact
.PARAMETER firmwareVersion
    Firmware Version of the Host.
.PARAMETER fqdn
    The Fully Qualified Domain Name of the host.
.PARAMETER hostGroupIds
    Either a single or multiple strings of the host Group Ids for this host.
.PARAMETER initiatorIds
    Either a single or multiple strings of the initiator Ids for this host.
.PARAMETER initiatorsToCreate
    A Complex object that represents the initiators to be created. Either a HASH or a Array of HASHes
.PARAMETER ipAddress
    IP Address of the Host.
.PARAMETER location
    A String that represents the location of the host.    
.PARAMETER model
    A String that represents the model of the host.    
.PARAMETER name
    A required String that represents the name of the host.    
.PARAMETER operatingSystems
    Host operating system. Possible Values are: - AIX - Apple - Citrix Hypervisor(XenServer) - HP-UX - IBM VIO Server - 
    InForm - NetApp/ONTAP - OE Linux UEK - OpenVMS - Oracle VM x86 - RHE Linux - RHE Virtualization - Solaris - 
    SuSE Linux - SuSE Virtualization - Ubuntu - VMware (ESXi) - Windows Server
.PARAMETER persona
    The string representing the persona of the host.
.PARAMETER protocol
    THe protocol the host is employing.
.PARAMETER subnet
    THe subnet for the host.
.PARAMETER protocol
    The protocol that the host is employing
.PARAMETER userCreated
    This value will always be set to true to user submitted hosts.
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
param(                              [string]    $comment,
                                    [string]    $contact,
                                    [string]    $fqdn,
                                    [array]     $hostGroupIds,
                                    [array]     $initiatorIds,
                                    [array]     $initiatorsToCreate,
                                    [string]    $ipAddress,  
                                    [string]    $location,
                                    [string]    $model,
        [Parameter(Mandatory)]      [string]    $name,
        [Parameter(Mandatory)][ValidateSet('AIX','Apple','Citrix Hypervisor(XenServer)','HP-UX','IBM VIO Server','InForm','NetApp/ONTAP','OE Linux UEK','Oracle VM x86','RHE Linux','RHE Virtualization','Solaris','SuSE Linux','Ubuntu','VMware (ESXi)','Windows Server')]
                                    [string]    $operatingSystem,
                                    [string]    $persona,
                                    [string]    $protocol,
                                    [string]    $subnet,
                                    [boolean]   $userCreated=$true,
                                    [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyAdd = 'host-initiators'
                                        $MyBody= [ordered]@{}
        if ($comment)               {   $MyBody += @{ comment = $comment                        }  }
        if ($contact)               {   $MyBody += @{ contact = $contact                        }  }
        if ($fqdn)                  {   $MyBody += @{ fqdn = $fqdn                              }  }
        if ($hostGroupIds)          {   $MyBody += @{ hostGroupIds = $hostGroupIds              }  }
        if ($initiatorIds)          {   $MyBody += @{ initiatorIds = $initiatorIds              }  }
                            else    {   $MyBody += @{ initiatorIds = $( $null )                 }  }
        if ($initiatorsToCreate )   {   $MyBody += @{ initiatorsToCreate = $initiatorsToCreate  }  }
        if ($ipAddress)             {   $MyBody += @{ ipAddress = $ipAddress                    }  }
        if ($location)              {   $MyBody += @{ location = $location                      }  }
        if ($model)                 {   $MyBody += @{ model = $model                            }  }
                                        $MyBody += @{ name = $name                                 }
                                        $MyBody += @{ operatingSystem = $operatingSystem           }
        if ($persona)               {   $MyBody += @{ persona = $persona                        }  }
        if ($protocol)              {   $MyBody += @{ protocol = $protocol                      }  }
        if ($subnet)                {   $MyBody += @{ subnet = $subnet                          }  }
                                        $MyBody += @{ userCreated = $userCreated                   }
        return Invoke-DSCCRestMethod -uri $MyUri -method 'POST' -body ( $MyBody | convertTo-json ) -WhatIfBoolean $WhatIf
    }      
} 
Function Set-DSCCHost
{
<#
.SYNOPSIS
    Updates a HPE DSSC DOM Host Initiator Record.    
.DESCRIPTION
    Updates a HPE Data Services Cloud Console Data Operations Manager Host Initiator Record;
.PARAMETER hostId
    The host initiator record to be modified.
.PARAMETER InitiatorsToCreate
    A hash table of the Initiators to create, or an array of hash tables of initiators to create.
.PARAMETER name
    Name of the Host.
.PARAMETER updatedInitiators
    An InitiatorId of initiators to replace, or an array InitiatorIds of hosts to replace.
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
param(  [Parameter(Mandatory)]  [string]    $hostID,
                                [string]    $name,  
                                [array]     $initiatorsToCreate,
                                [array]     $updatedInitiators,
                                [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyAdd = 'host-initiator/' + $hostID
                                        $MyBody += @{} 
        if ($name)                  {   $MyBody += @{ name = $name                              }  }
        if ($updatedInitiators)     {   $MyBody += @{ updatedInitiators  = $updatedInitiators   }  }
        if ($initiatorsToCreate)    {   $MyBody += @{ initiatorsToCreate = $initiatorsToCreate  }  }
        return Invoke-DSCCRestMethod -uri $MyUri -body $MyBody -Method 'PUT' -WhatIfBoolean $WhatIf
    }       
} 
