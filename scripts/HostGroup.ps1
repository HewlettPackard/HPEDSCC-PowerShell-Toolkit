function Get-DSCCHostGroup
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Host Group Collection    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager Host Groups Collections;
.PARAMETER HostGroupID
    If a single Host Group ID is specified the output will be limited to that single record.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-DSCCHostGroup

    id                               name           type                 hosts              systems
    --                               ----           ----                 -----              -------
    e987ef683c27403e96caa51816ddc72c TestHostGroup1 host-initiator-group TestHostInitiator1 {0006b878a5a008ec63000000000000000000000001, 2M202205GF}
    e987ef683c27403e9afaa51816ddc72c TestHostGroup2 host-initiator-group TestHostInitiator1 {0006b878a5a009def3000000000000000000000001, 2M202205GF}
    e987ef683c274cfed6caa51816ddc72c TestHostGroup3 host-initiator-group TestHostInitiator1 {0006b878cded08ec63000000000000000000000001, 2M202205VV}
.EXAMPLE
    PS:> Get-DSCCHostServiceHostGroup | convertto-json

    [       {   "associatedLinks":      [   {   "resourceUri": "string",
                                                "type": "string"
                                            }   ],
                "associatedSystems":    [   "string"    
                                        ],
                "comment": "host-group-comment",
                "consoleUri": "/data-ops-manager/host-initiator-groups/a8c087fa6e95dd22cdf402c64e4bbe61",
                "customerId": "string",
                "editStatus": "Delete_Failed",
                "generation": 0,
                "host":     [   {   "id": "6848ef683c27403e96caa51816ddc72c",
                                    "ipAddress": "15.212.100.100",
                                    "name": "host1"
                                }
                            ],
                "id": "e987ef683c27403e96caa51816ddc72c",
                "name": "host-group1",
                "requestUri": "/api/v1/host-initiator-groups/1",
                "systems":  [   "string"
                            ],
                "type": "string",
                "userCreated": true
            }

            {   "associatedLinks":      [   {   "resourceUri": "string",
                                                "type": "string"
                                            }   ],
                "associatedSystems":    [   "string"    
                                        ],
                "comment": "host-group-comment",
                "consoleUri": "/data-ops-manager/host-initiator-groups/a8c087fa6e95dd22cdf402c64e4bbe62",
                "customerId": "string",
                "editStatus": "Delete_Failed",
                "generation": 0,
                "host":     [   {   "id": "6848ef683c27403e96caa51816ddc72d",
                                    "ipAddress": "15.212.100.102",
                                    "name": "host2"
                                }
                            ],
                "id": "e987ef683c27403e96caa51816ddc72d",
                "name": "host-group1",
                "requestUri": "/api/v1/host-initiator-groups/2",
                "systems":  [   "string"
                            ],
                "type": "string",
                "userCreated": true
            }
    ]
.EXAMPLE
    PS:> Get-DSCCHostGroup -HostGroupId e987ef683c27403e96caa51816ddc72c

    id                               name           type                 hosts              systems
    --                               ----           ----                 -----              -------
    e987ef683c27403e96caa51816ddc72c TestHostGroup1 host-initiator-group TestHostInitiator1 {0006b878a5a008ec63000000000000000000000001, 2M202205GF}
.EXAMPLE
    PS:> Get-DSCCHostServiceHostGroup -Whatif
    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call
    
    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/host-initiator-groups
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJlvvD...qsbzuDCwEtWC-hem1BYx2Oz9IK0vh9itjsz-FwN3Um98AjSmKhDwZQ"
        }
    The Body of this call will be:
        "No Body"
.LINK
    The API call for this operation is file:///api/v1/host-initiator-groups
#>   
[CmdletBinding()]
param(  [string]    $HostGroupId,        
        [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyAdd = 'host-initiator-groups'
        $SysColOnly = invoke-restmethodWhatIf -uri $MyUri -method Get -WhatIfBoolean $WhatIf
        $ReturnData = Invoke-RepackageObjectWithType -RawObject $SysColOnly -ObjectName "HostGroup"
        if ( $HostGroupID )
                {   Write-host "The results of the complete collection have been limited to just the supplied ID"
                    return ( $ReturnData | where-object { $_.id -eq $HostGroupId } )
                } 
            else 
                {   return $ReturnData
                }
    }       
}   
function Remove-DSCCHostGroup
{
<#
.SYNOPSIS
    Removes a HPE DSSC DOM Host Group.    
.DESCRIPTION
    Removes a HPE Data Services Cloud Console Data Operations Manager Host Group specified by ID;
.PARAMETER HostGroupID
    A single Host Group ID must be specified.
.PARAMETER force
    Will implement an API forcefull remove option instead of the default normal removal mechanism.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Remove-DSCCHostServiceHostGroup -HostGroupId e987ef683c27403e96caa51816ddc72c

    {   "message": "Successfully submitted",
        "status": "SUBMITTED",
        "taskUri": "/rest/vega/v1/tasks/4969a568-6fed-4915-bcd5-e4566a75e00c"
    }
.EXAMPLE
    PS:> Remove-DSCCHostServiceHostGroup -HostGroupID dafd3078fceb43f0bb5c3b8119e70cd6 -whatif

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
        instead you will see a preview of the RestAPI call
    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/Data-Ops-Manager-ProductType1-Volumes/host-initiator-groups/dafd3078fceb43f0bb5c3b8119e70cd6
    The Method of this call will be
        Delete
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6Iko3Tmtmc3M4eDNEaGN3NWtQcnRNVVp5R0g2TSIsInBpLmF0bSI6ImRlejAifQ.eyJjbGllbnRfaWQiOiIzZjIwODU4NS0zZGE2LTRiZjctOTRjYS00ZjMxMGQwOTYzYjUiLCJpc3MiOiJodHRwczovL3Nzby5jb21tb24uY2xvdWQuaHBlLmNvbSIsImF1ZCI6ImV4dGVybmFsX2FwaSIsInN1YiI6ImNocmlzLmxpb25ldHRpQGhwZS5jb20iLCJ1c2VyX2N0eCI6IjAwNTZiNzFlZWZjNDExZWJhMjY4NjJhZGI4NzdjMmQ4IiwiYXV0aF9zb3VyY2UiOiJjY3NfdG9rZW5fbWFuYWdlbWVudCIsInBsYXRmb3JtX2N1c3RvbWVyX2lkIjoiOGZmYzRiN2VlOWQyMTFlYjhjZWU2ZTEzYzA3MWVhMzciLCJpYXQiOjE2MzU5NTM2NzYsImFwcGxpY2F0aW9uX2luc3RhbmNlX2lkIjoiM2MxOGJkMDMtODMwNi00YzdjLTk0MmUtYzcwNGE0Yjg3NDRjIiwiZXhwIjoxNjM1OTYwODc2fQ.Yp7WTVGc0vU6sE3r8KPL4R0_sW4dB9ZvGijqwGwMpDBZ4SEz5688s-C2al1HLFnpZygPnQfSm1NWjxQgLeKSbf54gvxz7kMlhsRWtRW4vWIIPw5XHmKGVjqnGsVjdkcs8QmlBAg7eR5FcrU_b4HAIicmNV07U5rtC2LoUytT85JM20_6SEV1uZwGTWSlSs26JKNOeOEepW5BdmWrIX7DQibwzq_HUz2COF_hdVZCYCNt-pzigb8c6POr9s3RD-ZSal9naLDz0gCfVds-CKOZ5WHxijtnqG-qZ5KBvcXk22_JcfXAoA02u2o9xZ2z6UZh71yLlH9dXQ1KAahJ26k5lw"
        }
    The Body of this call will be:
        "No Body"
.LINK
#>   
[CmdletBinding()]
param(  [Parameter(Mandatory)]  [string]    $HostGroupID,
                                [switch]    $Force,
                                [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyAdd = 'host-initiator-groups/' + $HostGroupID
        $MyBody = ''
        if ( $Force )
                {   $MyBody += ( @{ force = $true } | convertTo-json )
                }
        return Invoke-DSCCRestMethodWhat -UriAdd $MyAdd -Method 'Delete' -body $MyBody -WhatIfBoolean $WhatIf
    }       
}   
Function New-DSCCHostGroup
{
<#
.SYNOPSIS
    Creates a HPE DSSC DOM Host Group Record.    
.DESCRIPTION
    Creates a HPE Data Services Cloud Console Data Operations Manager Host Group Record;
.PARAMETER comment
    Address of the initiator and is required.
.PARAMETER hostIds
    Either a single or multiple strings of the host Ids for this host group.
.PARAMETER hostsToCreate
    A Complex object that represents the hosts to be created. Either a HASH or a Array of HASHes
.PARAMETER name
    A required String that represents the name of the host.    
.PARAMETER userCreated
    This value will always be set to true to user submitted hosts.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.

.EXAMPLE
    PS:> New-DSCCHostServiceInitiator -Address 100008F1EABFE61C -name Host1InitA -protocol FC

    {   "associatedLinks":  [   {   "resourceUri": "string",
                                    "type": "string"
                                }
                            ],
        "associatedSystems":[   "string"
                            ],
        "comment": "host-group-comment",
        "consoleUri": "/data-ops-manager/host-initiator-groups/a8c087fa6e95dd22cdf402c64e4bbe61",
        "customerId": "string",
        "editStatus": "Delete_Failed",
        "generation": 0,
        "host":     [   {   "id": "6848ef683c27403e96caa51816ddc72c",
                            "ipAddress": "15.212.100.100",
                            "name": "host1"
                        }
                    ],
        "id": "d548ef683c27403e96caa51816ddc72c",
        "name": "host-group1",
        "systems":  [   "string"
                    ],
        "type": "string",
        "userCreated": true
    }
#>   
[CmdletBinding()]
param(  [Parameter(Mandatory=$true)]    [string]    $name,
                                        [string]    $comment,
                                        [array]     $hostIds,
                                        [array]     $hostsToCreate,
                                        [boolean]   $userCreated=$true,
                                        [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyAdd = 'host-initiator-groups'
                                    $MyBody  = [ordered]@{ name          = $name             }
        if ($comment)           {   $MyBody +=          @{ comment       = $comment       }  }
        if ($hostIds)           {   $MyBody +=          @{ hostIds       = $hostIds       }  }
        if ($hostsToCreate )    {   $MyBody +=          @{ hostsToCreate = $hostsToCreate }  }
                                    $MyBody +=          @{ userCreated   = $userCreated      }
        return Invoke-DSCCRestMethod -UriAdd $MyAdd -method 'POST' -body $MyBody -WhatIfBoolen $WhatIf
     }      
} 
Function Set-DSCCHostGroup
{
<#
.SYNOPSIS
    Updates a HPE DSSC DOM Host Group Initiator Record.    
.DESCRIPTION
    Creates a HPE Data Services Cloud Console Data Operations Manager Host Group Initiator Record;
.PARAMETER hostGroupId
    The host group initiator record to be modified.
.PARAMETER hostsToCreate
    A hash table of the host to create, or an array of hash tables of hosts to create.
.PARAMETER name
    Name of the Initiator.
.PARAMETER updatedHosts
    An hostId of hosts to replace, or an array hostId of hosts to replace.
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
param(  [Parameter(Mandatory)]  [string]    $hostGroupID,
                                [string]    $name,
                                [array]     $hostsToCreate,
                                [array]     $updatedHosts,
                                [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $MyAdd = 'host-initiator-groups/' + $hostGroupID
                                    $MyBody += @{}
        if ($name)              {   $MyBody += @{ name          = $name}  }
        if ($updatedHosts)      {   $MyBody += @{ updatedHosts  = $updatedHosts }  }
        if ($updatedHosts)      {   $MyBody += @{ HostsToCreate = $hostsToCreate }  }
        return Invoke-DSCCRestMethod -UriAdd $MyAdd -body ( $MyBody | ConvertTo-Json ) -Method 'Put' -WhatIfBoolean $WhatIf
    }       
} 