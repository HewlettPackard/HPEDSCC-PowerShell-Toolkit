function Get-DSCCHostServiceHostGroup
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
    PS:> Get-DSCCHostServiceHostGroup

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
    PS:> Get-DSCCHostServiceHostGroup -HostGroupId e987ef683c27403e96caa51816ddc72c

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
    ]
.EXAMPLE
    PS:> Get-DSCCHostServiceHostGroup -Whatif
    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call
    
    The URI for this call will be
        https://scalpha-app.qa.cds.hpe.com/api/v1/host-initiator-groups
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IlVISWxNQVF3ZWJzSGUtVU82ZlA3Smo3SmU0RSIsInBpLmF0bSI6ImRlejAifQ.eyJjbGllbnRfaWQiOiIzZjIwODU4NS0zZGE2LTRiZjctOTRjYS00ZjMxMGQwOTYzYjUiLCJpc3MiOiJodHRwczovL3Nzby5jb21tb24uY2xvdWQuaHBlLmNvbSIsImF1ZCI6ImV4dGVybmFsX2FwaSIsInN1YiI6ImNocmlzLmxpb25ldHRpQGhwZS5jb20iLCJ1c2VyX2N0eCI6IjAwNTZiNzFlZWZjNDExZWJhMjY4NjJhZGI4NzdjMmQ4IiwiYXV0aF9zb3VyY2UiOiJjY3NfdG9rZW5fbWFuYWdlbWVudCIsInBsYXRmb3JtX2N1c3RvbWVyX2lkIjoiOGZmYzRiN2VlOWQyMTFlYjhjZWU2ZTEzYzA3MWVhMzciLCJpYXQiOjE2MzU4OTQ2MjcsImFwcGxpY2F0aW9uX2luc3RhbmNlX2lkIjoiM2MxOGJkMDMtODMwNi00YzdjLTk0MmUtYzcwNGE0Yjg3NDRjIiwiZXhwIjoxNjM1OTAxODI3fQ.H83l6MVbh104S2rqjmFVlMS5JCvb1YjV2X5qh1s1HK0axEwczkhfyaz_CIN4tt-CoSpZLD6RfBZFSscoJwSGeOto682ELzBegBtgSyor2L1K6RisFbIP87OfDYIb4i-Y9rSyvDaWefGQ2WW95pD-0DVNHY4K8FWAJeC2krMihdQeLsR9MufxKDd-fT8wX29uZ-bGqrkWDE9jCjvi0s9cXBfHGPT_mvn9qqZhTtfEbVeQulUNmBOI4nmVJ0o4TR1a5mFchgrd2YHqZHlilbfeU9oAHewIFQRgqsbzuDCwEtWC-hem1BYx2Oz9IK0vh9itjsz-FwN3Um98AjSmKhDwZQ"
        }
    The Body of this call will be:
        "No Body"
.EXAMPLE
    PS:> Get-DSCCHostServiceHostGroup | format-table 

    id                               name                   comment userCreated customerId                       type                 generation consoleUr                                                                                                                                             i
    --                               ----                   ------- ----------- ----------                       ----                 ---------- ---------
    5d76f4bf4b4446bcb925fb8525446598 SC1P1G14-HostGroup-win                True 0056b71eefc411eba26862adb877c2d8 host-initiator-group 1635311078 /data-...
    66706371723041448f165c2657e7d0da p2g1wingroup                          True 0056b71eefc411eba26862adb877c2d8 host-initiator-group 1634592044 /data-...
    fe44e2b685cc45a7a7e14e3825857785 SC1P1G19-HostGroup-win                True 0056b71eefc411eba26862adb877c2d8 host-initiator-group 1635311133 /data-...
    1f854f054cec4b3a83dc14cadeb63404 SC1P2G17-HostGroup-win                True 0056b71eefc411eba26862adb877c2d8 host-initiator-group 1635338147 /data-...
    bd4ff4f421bb48e19663abb1d1490b70 SC1P3G14-HostGroup-win                True 0056b71eefc411eba26862adb877c2d8 host-initiator-group 1635311970 /data-...
    dafd3078fceb43f0bb5c3b8119e70cd6 SC1P3G5-HostGroup-Win                 True 0056b71eefc411eba26862adb877c2d8 host-initiator-group 1635343998 /data-...
.LINK
    The API call for this operation is file:///api/v1/host-initiator-groups
#>   
[CmdletBinding()]
param(  [string]    $HostGroupId,        
        [switch]    $WhatIf
     )
process
    {   $MyURI = $BaseURI + 'host-initiator-groups'
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyUri -headers $MyHeaders -method Get
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyUri -headers $MyHeaders -method Get
                }
        if ( $HostGroupID )
                {   Write-host "The results of the complete collection have been limited to just the supplied ID"
                    return ( ($SysColOnly).items | where-object { $_.id -eq $HostGroupId } )
                } 
            else 
                {   return ( ($SysColOnly).items )
                }
    }       
}   
function Get-DSCCHostServiceHost
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
    PS:> Get-DSCCHostServiceHost | convertTo-Json

    [   {   "associatedLinks": [],
            "associatedSystems": [],
            "comment": "comment1",
            "consoleUri": "/data-ops-manager/host-initiators/0951b6508ec9f8747f08daf68925d81d",
            "contact": "sanjay@hpe.com",
            "customerId": "string",
            "editStatus": "Delete_Failed",
            "fqdn": "host1.hpe.com",
            "generation": 0,
            "hostGroups": [],
            "hostInitiators": [],
            "id": "6848ef683c27403e96caa51816ddc72c",
            "ipAddress": "15.212.100.100",
            "location": "India",
            "model": "model1",
            "name": "host1",
            "operatingSystem": "Windows",
            "persona": "AIX-Legacy",
            "protocol": "protocol1",
            "subnet": "255.255.255.0",
            "systems": [],
            "type": "string",
            "userCreated": true
        }
    ]
.EXAMPLE
    PS:> Get-DSCCHostServiceHost -HostID f0b1edd8f8984c8db9e596f25de0bdf4

    The results of the complete collection have been limited to just the supplied ID
        id                : f0b1edd8f8984c8db9e596f25de0bdf4
        name              : SC1P3G5-HOST-WIN
        ipAddress         :
        fqdn              :
        operatingSystem   : Windows Server
        systems           :
        associatedSystems :
        userCreated       : True
        hostGroups        : {@{id=dafd3078fceb43f0bb5c3b8119e70cd6; name=SC1P3G5-HostGroup-Win; userCreated=True; systems=; markedForDelete=False}}
        comment           :
        protocol          :
        customerId        : 0056b71eefc411eba26862adb877c2d8
        type              : host-initiator
        generation        : 1635343998
        consoleUri        : /data-ops-manager/host-initiators/f0b1edd8f8984c8db9e596f25de0bdf4
        initiators        : {@{id=8baba81d439d4cf88ecf0c6635eeee66; ipAddress=; address=c0:77:1f:58:5f:19:00:50; name=Host Path C0771F585F190050 (0:3:3);
                            protocol=FC; systems=System.Object[]}, @{id=f81f636716d1498dbe53e6ab1f9deaff; ipAddress=; address=c0:77:1f:58:5f:19:00:02;
                            name=Host Path C0771F585F190002 (0:3:2); protocol=FC; systems=System.Object[]}}
        location          :
        persona           :
        subnet            :
        markedForDelete   : False
        editStatus        : Not_Applicable
        associatedLinks   : {@{type=initiators; resourceUri=/api/v1/initiators?filter=hostId in (f0b1edd8f8984c8db9e596f25de0bdf4)}, @{type=host-groups;
                            resourceUri=/api/v1/host-initiator-groups?filter=hostId in (f0b1edd8f8984c8db9e596f25de0bdf4)}}
        model             :
        contact           :
.EXAMPLE
    PS:> Get-DSCCHostServiceHost | format-table

        id                               name              ipAddress fqdn operatingSystem systems associatedSystems userCreated hostGroups
        --                               ----              --------- ---- --------------- ------- ----------------- ----------- ----------
        01900903981142db9e62658a1bfe9743 SC1P1G14-Host-win                Windows Server                                   True {@{id=5d76f4bf4b4446bcb925f...
        40f9f14f4daa410dbf882c8746ec8f76 SC1P2G17-Host-win                Windows Server                                   True {@{id=1f854f054cec4b3a83dc1...
        41af9bd31d5049cea1f0a16801d96876 SC1P1G19-Host-win                Windows Server                                   True {@{id=fe44e2b685cc45a7a7e14...
        5e9769d7005240a591513ade156b8016 p2g1win                          Windows Server                                   True {@{id=66706371723041448f165...
        abe7039eb3cd4e6c8fb5cd9dfe64cfd5 SC1P3G14-Host-win                VMware (ESXi)                                    True {@{id=bd4ff4f421bb48e19663a...
        f0b1edd8f8984c8db9e596f25de0bdf4 SC1P3G5-HOST-WIN                 Windows Server                                   True {@{id=dafd3078fceb43f0bb5c3...
.LINK
    The API call for this operation is file:///api/v1/host-initiator-groups
#>   
[CmdletBinding()]
param(  [string]    $HostID,
        [switch]    $WhatIf
     )
process
    {   $MyURI = $BaseURI + 'host-initiators'
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyUri -headers $MyHeaders -method Get
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyUri -headers $MyHeaders -method Get
                }
        if ( $HostID )
                {   Write-host "The results of the complete collection have been limited to just the supplied ID"
                    return ( ($SysColOnly).items | where-object { $_.id -eq $HostId } )
                } 
            else 
                {   return ( ($SysColOnly).items )
                }
    }       
}   
function Get-DSCCHostServiceInitiator
{
<#
.SYNOPSIS
    Returns the HPE DSSC DOM Initiators Collection    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Data Operations Manager Initiators Collections;
.PARAMETER InitiatorID
    If a single Host ID is specified the output will be limited to that single record.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-HPEDSCCDOMHostServiceInitiator | convertTo-Json

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
    PS:> Get-DSCCHostServiceInitiator | format-table

    id                               ipAddress    address                                        name                                           driverVersion
    --                               ---------    -------                                        ----                                           ----------
    14b7c95d763143958d7fa3532582ed7e              c0:77:2f:58:5f:19:00:22                        Host Path C0772F585F190022 (1:3:4)
    446496e623ed4384b3a54e87914f3937              c0:77:2f:58:5f:19:00:38                        Host Path C0772F585F190038 (1:3:3)
    af19deb870fb4cc6a0d916a47189f5c6              c0:77:2f:58:5f:19:00:2c                        Host Path C0772F585F19002C (0:3:3)
    37095798d17b4110a6c0236af7016a77              c0:77:3f:58:5f:19:00:24                        Host Path C0773F585F190024 (0:3:3)
    2c4b078075f94634a1c68e36bef17607 192.10.206.1 iqn.1998-01.com.vmware:pod1esx2g20esx-6e53383a iqn.1998-01.com.vmware:pod1esx2g20esx-6e53383a
    9f5cd54548e24c6b8f6a99009df399ce              c0:77:3f:58:5f:19:00:30                        Host Path C0773F585F190030 (1:3:1)
    b3250508a3c3422cb4f4905daf411395 192.10.26.2  iqn.1998-01.com.vmware:pod2esx1g2esx-653383a   iqn.1998-01.com.vmware:pod2esx1g2esx-653383a
    767f6230b76f42e58d337f664a3b83ec              c0:77:3f:58:5f:19:00:4a                        Host Path C07
.EXAMPLE
    PS:> Get-DSCCHostServiceInitiator -InitiatorID 46eaf545bf80404d8e479ec8d6871c97

    The results of the complete collection have been limited to just the supplied ID
        id              : 46eaf545bf80404d8e479ec8d6871c97
        ipAddress       :
        address         : c0:77:2f:58:5f:19:00:0e
        name            : Host Path C0772F585F19000E (0:3:4)
        driverVersion   :
        firmwareVersion :
        vendor          :
        hbaModel        :
        hostSpeed       : 0
        protocol        : FC
        customerId      : 0056b71eefc411eba26862adb877c2d8
        type            : initiator
        generation      : 1634566691
        hosts           : {}
        systems         :
        associatedLinks : {}
.EXAMPLE
    PS:> Get-DSCCHostServiceInitiator -InitiatorID 46eaf545bf80404d8e479ec8d6871c97  -WhatIf
    
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
param(  [string]    $InitiatorID,
        [switch]    $WhatIf
     )
process
    {   $MyURI = $BaseURI + 'initiators'
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyUri -headers $MyHeaders -method Get
                }   
            else 
                {   $SysColOnly = invoke-restmethod -uri $MyUri -headers $MyHeaders -method Get
                }
        if ( $InitiatorID )
                {   Write-host "The results of the complete collection have been limited to just the supplied ID"
                    return ( ($SysColOnly).items | where-object { $_.id -eq $InitiatorID } )
                } 
            else 
                {   return ( ($SysColOnly).items )
                }
    }                
}   
function Get-DSCCHostServiceHostVolume
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
    {   $MyURI = $BaseURI + 'host-initiators/' + $HostID + '/volumes'
        if ( $WhatIf )
                {   $SysColOnly = invoke-restmethodWhatIf -uri $MyUri -headers $MyHeaders -method Get
                }   
            else     
                {   $SysColOnly = invoke-restmethod -uri $MyUri -headers $MyHeaders -method Get
                }
        return $SysColOnly 
    }       
} 
function Remove-DSCCHostServiceHostGroup
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
    {   $MyURI = $BaseURI + 'host-initiator-groups/' + $HostGroupID
        if ( $Force )
                {   $LocalBody += @{force=true}
                }
        if ( $Whatif )
                {   return Invoke-RestMethodWhatIf -Uri $MyUri -Method 'Delete' -headers $MyHeaders -body $LocalBody
                } 
            else 
                {   return Invoke-RestMethod -uri $MyUri -Headers $MyHeaders -Method Delete -body $LocalBody
                }
    }       
}   
function Remove-DSCCHostServiceHost
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

    {   "message": "Successfully submitted",
        "status": "SUBMITTED",
        "taskUri": "/rest/vega/v1/tasks/4969a568-6fed-4915-bcd5-e4566a75e00c"
    }
.LINK
#>   
[CmdletBinding()]
param(  [Parameter(Mandatory)]  [string]    $HostID,
                                [switch]    $Force,
                                [switch]    $WhatIf
     )
process
    {   $MyURI = $BaseURI + 'host-initiators/' + $HostID
        $LocalBody=''
        if ($Force)
                {   $LocalBody = @{force=$true}
                } 
        if ($Whatif)
                {   return Invoke-RestMethodWhatIf -uri $MyUri -method 'Delete' -headers $MyHeaders -body $LocalBody
                } 
            else 
                {   return Invoke-RestMethod -uri $MyUri -method 'Delete' -headers $MyHeaders -body $LocalBody
                }
    }       
}   
function Remove-DSCCHostServiceInitiator
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
    {   $MyURI = $BaseURI + 'initiators/' + $InitiatorID
        $LocalBody = ''
        if ($Force)
                {   $LocalBody = @{force=$true}
                }
        if ($Whatif)
                {   return Invoke-RestMethodWhatIf -uri $MyUri -Headers $MyHeaders -Method 'Delete' -body $LocalBody
                } 
            else 
                {   return Invoke-RestMethod -uri $MyUri -Headers $MyHeaders -Method 'Delete' -body $LocalBody
                }
    }       
}   
Function New-DSCCHostServiceInitiator
{
<#
.SYNOPSIS
    Creates a HPE DSSC DOM Initiator Record.    
.DESCRIPTION
    Creates a HPE Data Services Cloud Console Data Operations Manager Host Initiator Record;
.PARAMETER Address
    Address of the initiator and is required.
.PARAMETER driverVersion
    Driver Version of the Host Initiator.
.PARAMETER firmwareVersion
    Firmware Version of the Host Initiator.
.PARAMETER hbaModel
    Host bus adaptor model of the host initiator.
.PARAMETER HostSpeed
    Host Speed.
.PARAMETER ipAddress
    IP Address of the Initiator.
.PARAMETER name
    Name of the Initiator.
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
                                        [int64]     $HostSpeed,
                                        [string]    $ipAddress,
                                        [string]    $name,  
        [Parameter(Mandatory)]  
        [ValidateSet('FC','iSCSI','NMVe')][string]    $protocol,
        [Parameter(Mandatory)]          [string]    $vendor,
                                        [switch]    $WhatIf
     )
process
    {   $MyURI = $BaseURI + 'initiators'
                                    $MyBody += @{ address = $address} 
        if ($driverVerson)      {   $MyBody += @{ driverVersion = $driverVersion}  }
        if ($firmwareVersion)   {   $MyBody += @{ firmwareVersion = $firmwareVersion }  }
        if ($hbaModel)          {   $MyBody += @{ hbaModel = $hbaModel}  }
        if ($HostSpeed)         {   $MyBody += @{ HostSpeed = $HostSpeed}  }
        if ($ipAddress)         {   $MyBody += @{ ipAddress = $ipAddress}  }
        if ($name)              {   $MyBody += @{ name = $name}  }
                                    $MyBody += @{ protocol = $protocol }
        if ($vendor)            {   $MyBody += @{ vendor = $vendor}  }
        if ($driverVerson)      {   $MyBody += @{ driverVersion = $driverVersion}  }
        
        if ($Whatif)
                {   return Invoke-RestMethodWhatIf -uri $MyUri -method 'Put' -headers $MyHeaders -body $MyBody
                } 
            else 
                {   return Invoke-RestMethod -uri $MyUri -method 'Put' -headers $MyHeaders -body $MyBody
                }
    }       
}   
Function New-DSCCHostServiceHost
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
                                                $hostGroupIds,
                                                $initiatorIds,
                                                $initiatorsToCreate,
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
    {   $MyURI = $BaseURI + 'Data-Ops-Manager-ProductType1-Volumes/host-initiators'
        if ($comment)               {   $MyBody += @{ comment = $comment }  }
        if ($contact)               {   $MyBody += @{ contact = $contact }  }
        if ($fqdn)                  {   $MyBody += @{ fqdn = $fqdn }  }
        if ($hostGroupIds)          {   $MyBody += @{ hostGroupIds = $hostGroupIds }  }
        if ($initiatorIds)          {   $MyBody += @{ initiatorIds = $initiatorIds }  }
        if ($initiatorsToCreate )   {   $MyBody += @{ initiatorsToCreate = $initiatorsToCreate }  }
        if ($ipAddress)             {   $MyBody += @{ ipAddress = $ipAddress }  }
        if ($location)              {   $MyBody += @{ location = $location }  }
        if ($model)                 {   $MyBody += @{ model = $model }  }
                                        $MyBody += @{ operatingSystem = $operatingSystem }
        if ($persona)               {   $MyBody += @{ persona = $persona }  }
        if ($protocol)              {   $MyBody += @{ protocol = $protocol }  }
        if ($subnet)                {   $MyBody += @{ subnet = $subnet }  }
                                        $MyBody += @{ userCreated = $userCreated }
        if ($Whatif)
                {   return Invoke-RestMethodWhatIf -uri $MyUri -method 'Put' -headers $MyHeaders -body $MyBody
                } 
            else 
                {   return Invoke-RestMethod -uri $MyUri -method 'Put' -headers $MyHeaders -body $MyBody
                }
     }      
} 
Function New-DSCCHostServiceHostGroup
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
param(                          [string]    $comment,
                                            $hostIds,
                                            $hostsToCreate,
        [Parameter(Mandatory)]  [string]    $name,
                                [boolean]   $userCreated=$true,
                                [switch]    $WhatIf
     )
process
    {   $MyURI = $BaseURI + 'host-initiator-groups'
                                    $MyBody  = @{ name = $name }
        if ($comment)           {   $MyBody += @{ comment = $comment }  }
        if ($hostIds)           {   $MyBody += @{ hostIds = $hostIds }  }
        if ($hostsToCreate )    {   $MyBody += @{ hostsToCreate = $hostsToCreate }  }
                                    $MyBody += @{ userCreated = $userCreated }
        if ($Whatif)
                {   return Invoke-RestMethodWhatIf -uri $MyUri -method 'Put' -headers $MyHeaders -body $MyBody
                } 
            else 
                {   return Invoke-RestMethod -uri $MyUri -method 'Put' -headers $MyHeaders -body $MyBody
                }
     }      
} 
Function Set-DSCCHostServiceHostGroup
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
                                            $hostsToCreate,
                                            $updatedHosts,
                                [switch]    $WhatIf
     )
process
    {   $MyURI = $BaseURI + 'host-initiator-groups/' + $hostGroupID
                                    $MyBody += @{} 
        if ($name)              {   $MyBody += @{ name = $name}  }
        if ($updatedHosts)      {   $MyBody += @{ updatedHosts = $updatedHosts }  }
        if ($updatedHosts)      {   $MyBody += @{ HostsToCreate = $hostsToCreate }  }
        
        if ($Whatif)
                {   return Invoke-RestMethodWhatIf -uri $MyUri -Header $MyHeaders -body $MyBody -Method 'Put'
                } 
            else 
                {   return Invoke-RestMethod -uri $MyUri -Header $MyHeaders -body $MyBody -Method 'Put'
                }
    }       
} 
Function Set-DSCCHostServiceHost
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
                                            $initiatorsToCreate,
                                            $updatedInitiators,
                                [switch]    $WhatIf
     )
process
    {   $MyURI = $BaseURI + 'host-initiator/' + $hostID
                                        $MyBody += @{} 
        if ($name)                  {   $MyBody += @{ name = $name}  }
        if ($updatedInitiators)     {   $MyBody += @{ updatedInitiators  = $updatedInitiators }  }
        if ($initiatorsToCreate)    {   $MyBody += @{ initiatorsToCreate = $initiatorsToCreate }  }
        if ($Whatif)
                {   return Invoke-RestMethodWhatIf -uri $MyUri -Headers $MyHeaders -body $MyBody -Method 'Put'
                } 
            else 
                {   return Invoke-RestMethod -uri $MyUri -Headers $MyHeaders -body $MyBody -Method 'Put'
                }
    }       
} 
