function Get-DSCCHostGroup
{
<#
.SYNOPSIS
    Returns the HPE DSSC Host Group Collection    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Host Groups Collections;
.PARAMETER SystemId 
    This will limit the output to only a single SystemId, this parameter is only valid for Device-Type2. 
    With this parameter not set, the command will return ALL host groups.
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
    PS:> Get-DSCCHostGroup | where { $_.id -like 'e987ef683c27403e96caa51816ddc72c' }

    id                               name           type                 hosts              systems
    --                               ----           ----                 -----              -------
    e987ef683c27403e96caa51816ddc72c TestHostGroup1 host-initiator-group TestHostInitiator1 {0006b878a5a008ec63000000000000000000000001, 2M202205GF}
.EXAMPLE
    PS:> Get-DSCCHostGroup -Whatif
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
param(  [parameter( ValueFromPipeLineByPropertyName=$true )][Alias('id')]   [string]    $SystemId,
                                                                            [boolean]   $WhatIf=$false
    )
process
    {   $ReturnCol= @()
        write-verbose "No SystemID was given, so running against all system IDs"
        if ( -not $SystemId )
                {   foreach ( $Sys in Get-DSCCStorageSystem -devicetype Device-Type2 )
                        {   write-verbose "Running discover on a singular System ID"
                            If ( ($Sys).id )
                                {   $ReturnCol += Get-DSCCHostGroup -SystemId ($Sys).id  -WhatIf $WhatIf
                                }
                        }
                    $ReturnCol = invoke-DSCCRestMethod -UriAdd 'host-initiator-groups' -method Get -WhatIfBoolean $WhatIf
                    $ReturnFinal += Invoke-RepackageObjectWithType -RawObject $ReturnCol -ObjectName "HostGroup"
                } 
            else 
                {   $MyAdd = 'storage-systems/device-type2/'+$Systemid+'/host-groups'
                    $ReturnCol = invoke-DSCCRestMethod -UriAdd $MyAdd -method Get -WhatIfBoolean $WhatIf
                    $ReturnFinal = Invoke-RepackageObjectWithType -RawObject $ReturnCol -ObjectName "HostGroup"
                }

        return $ReturnCol
    }        
}   
function Remove-DSCCHostGroup
{
<#
.SYNOPSIS
    Removes a HPE DSSC Host Group.    
.DESCRIPTION
    Removes a HPE Data Services Cloud Console Host Group specified by ID;
.PARAMETER HostGroupID
    A single Host Group ID must be specified.
.PARAMETER force
    Only Valid for Device-Type1 Host Groups. Will implement an API forcefull remove option instead of the default normal removal mechanism.
.PARAMETER systemID
    Only Valid for Device-Type2 Host Groups. Must specify which system to remove the Host Group from.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Remove-DSCCHostServiceHostGroup -HostGroupId e987ef683c27403e96caa51816ddc72c -force

    This sample is how to delete a host group from DSCC for a Device-Type1 device. 
.EXAMPLE
    PS:> Remove-DSCCHostServiceHostGroup -HostGroupId e987ef683c27403e96caa51816ddc72c -systemId 003a78e8778c204dc2000000000000000000000001
    
    This sample is how to delete a host group from DSCC for a Device-Type1 device.
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
param(  [Parameter(ParameterSetName='DeviceType1', Mandatory)]
        [Parameter(ParameterSetName='DeviceType2', Mandatory)]  [string]    $HostGroupID,
        [Parameter(ParameterSetName='DeviceType2', Mandatory)]  [string]    $systemID,
        [Parameter(ParameterSetName='DeviceType1', Mandatory)]  [switch]    $Force,
                                                                [switch]    $WhatIf
    )
process
    {   $MyBody = ''
        switch(Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId)
        {   'device-type1'  {     
                            }    
            'device-type2'  {   $MyAdd = 'storage-systems/device-type2/'+$SystemId+'/host-groups/'+$HostGroupID
                                write-verbose "Detected a Device-Type2, "
                            }    
            default         {   $MyAdd = 'host-initiator-groups/' + $HostGroupID
                                write-verbose "Detected no Device Type, so no system ID must have been passed device, only using HostGroupID"
                                if ( $Force )
                                    {   $MyBody += ( @{ force = $true } | convertTo-json )
                                    } 
                            }                
        }
        return ( Invoke-DSCCRestMethod -UriAdd $MyAdd -Method 'Delete' -body ( $MyBody | convertto-json ) -WhatIfBoolean $WhatIf )
    }       
}   
Function New-DSCCHostGroup
{
<#
.SYNOPSIS
    Creates a HPE DSSC Host Group Record.    
.DESCRIPTION
    Creates a HPE Data Services Cloud Console Host Group Record;
.PARAMETER DeviceType1
    This switch is used to tell the command that the end device is the specific device type, and to only allow the correct
    parameter set that matches this device type.
.PARAMETER DeviceType2
    This switch is used to tell the command that the end device is the specific device type, and to only allow the correct
    parameter set that matches this device type.
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
    PS:> New-DSCCHostGroup -DeviceType2 -SystemId 003a78e8778c204dc2000000000000000000000001 -name test2 -access_protocol_iscsi -iscsi_initiator_id 527468f9e76c4f38acd1b3c050f49bf4

    This will create a new Host Group for a Alletra 6K or Nimble Storage type device, specified by the system ID, called Test2. 
    The command requires that you both name the Initiator Group, as well as supply the Initiator ID that you want to be a member of the group.

#>   
[CmdletBinding()]
param(  [Parameter(ParameterSetName='Type1')]                                                                       [switch]    $DeviceType1,

        [Parameter(ParameterSetName='Type2iscsi_useExisting')]
        [Parameter(ParameterSetName='Type2iscsi_createNew')]                                                           
        [Parameter(ParameterSetName='Type2fc_useExisting')]                                                                     
        [Parameter(ParameterSetName='Type2fc_createNew')]                                                           [switch]    $DeviceType2,

        [Parameter(ParameterSetName='Type1',Mandatory)]
        [Parameter(ParameterSetName='Type2fc_createNew',Mandatory)]
        [Parameter(ParameterSetName='Type2fc_useExisting',Mandatory)]
        [Parameter(ParameterSetName='Type2iscsi_useExisting',Mandatory)]
        [Parameter(ParameterSetName='Type2iscsi_createNew',Mandatory)]                                              [string]    $name,

        [Parameter(ParameterSetName='Type2iscsi_useExisting',Mandatory)]
        [Parameter(ParameterSetName='Type2iscsi_createNew',Mandatory)]
        [parameter(ParameterSetName='Type2fc_useExisting', ValueFromPipeLineByPropertyName=$true, Mandatory )]
        [parameter(ParameterSetName='Type2fc_createNew', ValueFromPipeLineByPropertyName=$true, Mandatory )]
        [Alias('id')]                                                                                               [string]    $SystemId,

        [Parameter(ParameterSetName='Type1')]                                                                       [string]    $comment,
        [Parameter(ParameterSetName='Type1')]                                                                       [array]     $hostIds,
        [Parameter(ParameterSetName='Type1')]                                                                       [array]     $hostsToCreate,
        [Parameter(ParameterSetName='Type1')]                                                                       [boolean]   $userCreated=$true,
        
        [Parameter(ParameterSetName='Type2iscsi_useExisting',Mandatory)]
        [Parameter(ParameterSetName='Type2iscsi_createNew',Mandatory)]                                              [switch]    $access_protocol_iscsi,

        [Parameter(ParameterSetName='Type2fc_createNew',Mandatory)]                                                 
        [Parameter(ParameterSetName='Type2fc_useExisting',Mandatory)]                                               [switch]    $access_protocol_fc,

        [Parameter(ParameterSetName='Type2iscsi_useExisting')]
        [Parameter(ParameterSetName='Type2iscsi_createNew')]
        [Parameter(ParameterSetName='Type2fc_useExisting')]                                                                     
        [Parameter(ParameterSetName='Type2fc_createNew')]                                                           [string]    $app_uuid,

        [Parameter(ParameterSetName='Type2iscsi_useExisting')]
        [Parameter(ParameterSetName='Type2iscsi_createNew')]
        [Parameter(ParameterSetName='Type2fc_useExisting')]                                                                     
        [Parameter(ParameterSetName='Type2fc_createNew')]                                                           [string]    $description,

        [Parameter(ParameterSetName='Type2fc_useExisting', Mandatory)]                                              [string]    $fc_initiator_id,
        [Parameter(ParameterSetName='Type2fc_createNew')]                                                           [string]    $fc_initiator_alias,
        [Parameter(ParameterSetName='Type2fc_createNew', Mandatory)]                                                [string]    $fc_initiator_wwpn,

        [Parameter(ParameterSetName='Type2iscsi_useExisting', Mandatory)]                                           [string]    $iscsi_initiator_id,
        [Parameter(ParameterSetName='Type2iscsi_createNew')]                                                        [string]    $iscsi_initiator_iqn,
        [Parameter(ParameterSetName='Type2iscsi_createNew')]                                                        [string]    $iscsi_initiator_ip,
        [Parameter(ParameterSetName='Type2iscsi_createNew')]                                                        [string]    $iscsi_initiator_label,

        [Parameter(ParameterSetName='Type2fc_useExisting')]
        [Parameter(ParameterSetName='Type2fc_createNew')]                                                                       $fc_tdz_ports,

        [Parameter(ParameterSetName='Type2iscsi_useExisting', Mandatory)]
        [Parameter(ParameterSetName='Type2iscsi_createNew', Mandatory)]
        [Parameter(ParameterSetName='Type2fc_useExisting', Mandatory)]
        [Parameter(ParameterSetName='Type2fc_createNew', Mandatory)]                                                [string]    $host_type,

        [Parameter(ParameterSetName='Type2iscsi_useExisting')]
        [Parameter(ParameterSetName='Type2iscsi_createNew')]                                                                    $target_subnets,
        
        [Parameter(ParameterSetName='Type1')]
        [Parameter(ParameterSetName='Type2fc_useExisting')]
        [Parameter(ParameterSetName='Type2fc_createNew')]
        [Parameter(ParameterSetName='Type2iscsi_useExisting')]
        [Parameter(ParameterSetName='Type2iscsi_createNew')]                                                        [boolean]   $WhatIf=$false
    )
process
    {   $MyBody  = [ordered]@{ name = $name }
        switch( $PsCmdlet.ParameterSetName )
            {   'Type1'         {   $MyAdd = 'host-initiator-groups'
                                    write-verbose "Creating a type1 device request using the API location $MyAdd"
                                    if ($comment)           {   $MyBody +=          @{ comment       = $comment       }  }
                                    if ($hostIds)           {   $MyBody +=          @{ hostIds       = $hostIds       }  }
                                    if ($hostsToCreate )    {   $MyBody +=          @{ hostsToCreate = $hostsToCreate }  }
                                                                $MyBody +=          @{ userCreated   = $userCreated      }
                                    if ( $DeviceType2 )     {   write-error "The Wrong Device Type was specified"
                                                                Return
                                                            }
                                }
                'Type2fc_useExisting'
                                {                               $MyBody +=          @{ access_protocol      = 'fc'           }
                                    if ($app_uuid)          {   $MyBody +=          @{ app_uuid             = $app_uuid      } }
                                    if ($description)       {   $MyBody +=          @{ description          = $description   } }
                                    if ($host_type)         {   $MyBody +=          @{ host_type            = $host_type     } }
                                                                $MyBody +=          @{ fc_initiators        = @( @{ id = $fc_initiators } ) }
                                    if ($fc_tdz_ports)      {   $MyBody +=          @{ fc_tdz_ports         = $fc_tdz_ports  } }
                                    $myAdd = 'storage-systems/device-type2/'+$SystemId+'/host-groups'
                                    write-verbose "Creating a type2 device request using the API location $MyAdd"
                                    if ( $DeviceType1 )     {   write-error "The Wrong Device Type was specified"
                                                                Return
                                                            }
                                }
                'Type2fc_createNew'
                                {                               $MyBody +=          @{ access_protocol      = 'fc'           }
                                    if ($app_uuid)          {   $MyBody +=          @{ app_uuid             = $app_uuid      } }
                                    if ($description)       {   $MyBody +=          @{ description          = $description   } }
                                    if ($host_type)         {   $MyBody +=          @{ host_type            = $host_type     } }
                                                                $MySub  =           @{ wwpn                 = $fc_initiator_wwpn } 
                                    if ($fc_initiator_alias){   $MySub  +=          @{ alias                = $fc_initiator_alias } }
                                                                $MyBody +=          @{ fc_initiators        = @( $MySub )    }
                                    if ($fc_tdz_ports)      {   $MyBody +=          @{ fc_tdz_ports         = $fc_tdz_ports  } }
                                    $myAdd = 'storage-systems/device-type2/'+$SystemId+'/host-groups'
                                    write-verbose "Creating a type2 device request using the API location $MyAdd"
                                    if ( $DeviceType1 )     {   write-error "The Wrong Device Type was specified"
                                                                Return
                                                            }
                                }
                'Type2iscsi_useExisting'    
                                {   $myAdd = 'storage-systems/device-type2/'+$SystemId+'/host-groups'
                                    write-verbose "Creating a type2 device request using the API location $MyAdd"
                                                                $MyBody +=          @{ access_protocol      = 'iscsi'          }
                                    if ($app_uuid)          {   $MyBody +=          @{ app_uuid             = $app_uuid      } }
                                    if ($description)       {   $MyBody +=          @{ description          = $description   } }
                                    if ($host_type)         {   $MyBody +=          @{ host_type            = $host_type     } }
                                    if ($iscsi_initiator_id){   $MyBody +=          @{ iscsi_initiators     = @( @{ id = $iscsi_initiator_id } )  } }
                                    if ($target_subnets)    {   $MyBody +=          @{ target_subnets       = $target_subnets } }
                                    if ( $DeviceType1 )     {   write-error "The Wrong Device Type was specified"
                                                                Return
                                                            }
                                }
                'Type2iscsi_createNew'    
                                {   $myAdd = 'storage-systems/device-type2/'+$SystemId+'/host-groups'
                                    write-verbose "Creating a type2 device request using the API location $MyAdd"
                                                            $MyBody +=            @{ access_protocol = 'iscsi'                }
                                    if ($app_uuid)          {   $MyBody +=        @{ app_uuid        = $app_uuid              } }
                                    if ($description)       {   $MyBody +=        @{ description     = $description           } }
                                    if ($host_type)         {   $MyBody +=        @{ host_type       = $host_type             } }
                                                                        $MySub =  @{ }
                                    if ( $iscsi_initiator_iqn )     {   $MySub += @{ iqn             = $iscsi_initiator_iqn   } }
                                    if ( $iscsi_initiator_ip )      {   $MySub += @{ ip              = $iscsi_initiator_ip    } }
                                    if ( $iscsi_initiator_label )   {   $MySub += @{ label           = $iscsi_initiator_label } }
                                    if ( -not ( $iscsi_initiator_iqn -or $iscsi_initiator_ip ) )
                                        {   write-error "When using a DeviceType2, and creating a Host Group for iSCSI, and createing a New Initiator to populate the group, either an IQN or an IP address must be presented"
                                            Return 
                                        }
                                                                        $MyBody +=       @{ iscsi_initiators     = @( $MySub )     } 
                                    if ($target_subnets)            {   $MyBody +=       @{ target_subnets       = $target_subnets } }
                                    if ( $DeviceType1 )     {   write-error "The Wrong Device Type was specified"
                                                                Return
                                                            }
                                }
        }
        return (Invoke-DSCCRestMethod -UriAdd $MyAdd -method 'POST' -body ($MyBody | convertto-json) -WhatIfBoolean $WhatIf)
    }      
} 
Function Set-DSCCHostGroup
{
<#
.SYNOPSIS
    Updates a HPE DSSC Host Group Record.    
.DESCRIPTION
    Creates a HPE Data Services Cloud Console Host Group Record;
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
    PS:> New-DSCCHostGroup -Address 100008F1EABFE61C -name Host1InitA -protocol FC

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
                                [Boolean]    $WhatIf=$false
    )
process
    {   $MyAdd = 'host-initiator-groups/' + $hostGroupID
                                    $MyBody += @{}
        if ($name)              {   $MyBody += @{ name          = $name}  }
        if ($updatedHosts)      {   $MyBody += @{ updatedHosts  = $updatedHosts }  }
        if ($updatedHosts)      {   $MyBody += @{ HostsToCreate = $hostsToCreate }  }
        return ( Invoke-DSCCRestMethod -UriAdd $MyAdd -body ( $MyBody | ConvertTo-json ) -Method 'Put' -WhatIfBoolean $WhatIf )
    }       
} 