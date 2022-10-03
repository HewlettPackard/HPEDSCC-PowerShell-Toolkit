function Get-DSCCVolumeSet
{
<#
.SYNOPSIS
    Returns the HPE DSSC Volume Set also known as the Volume Collection or Application Set   
.DESCRIPTION
    Returns the HPE Data DSSC Volume Set also known as the Volume Collection or Application Set   
.PARAMETER SystemID
    If a single Host Group ID is specified the output will be limited to that single record.
.PARAMETER VolumeSetId
    If a single Volume Set also known as the Volume Collection or Application Set  is specified the output will be limited to that single record.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.EXAMPLE
    PS:> Get-DSCCVolumeSet -SystemId 'MXN5442108'

    appSetType           id                               systemId   displayname domain appSetId name                        comment members                  kvPairsPresent
    ----------           --                               --------   ----------- ------ -------- ----                        ------- -------                  --------------
    Other                e20a01e1501ee881f524fd4849fb93fd MXN5442108 unknown     -             9 vvset_TestVolJPN01                  {}                                 True
    Microsoft SQL Server 4855490935ab5da04adcb7e77916daa7 MXN5442108 unknown     -            36 PROVVOLSETPRIMFC1639032805          {}                                 True
    Microsoft SQL Server a9207cb0fe766da3051e967b475df2ca MXN5442108 unknown     -            28 PROVVOLSETPRIMFC12345               {}                                 True
    Microsoft SQL Server bd5e6135b59db8b40ecf5754efcdc920 MXN5442108 unknown     -            12 vvset_Volume02                      {}                                 True
    Other                888365c15a2911b55781a06e9e49ba14 MXN5442108 unknown     -            10 vvset_TestVolJPN02                  {}                                 True
    Microsoft SQL Server f71a080a9828d59c2afb75c4697b81ae MXN5442108 unknown     -            14 vvset_jpnvol01                      {}                                 True
.EXAMPLE
    PS:> Get-DSCCVolumeSet -SystemId 'MXN5442108' -VolumeSetId 'e20a01e1501ee881f524fd4849fb93fd'

    appSetType id                               systemId   displayname domain appSetId name               comment members kvPairsPresent
    ---------- --                               --------   ----------- ------ -------- ----               ------- ------- --------------
    Other      e20a01e1501ee881f524fd4849fb93fd MXN5442108 unknown     -             9 vvset_TestVolJPN01         {}                True
.EXAMPLE
    PS:> Get-DSCCVolumeSet -SystemId 'MXN5442108' -VolumeSetId 'e20a01e1501ee881f524fd4849fb93fd' -WhatIf

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call
    The URI for this call will be
    https://scint-app.qa.cds.hpe.com/api/v1/storage-systems/device-type1/MXN5442108/applicationsets/e20a01e1501ee881f524fd4849fb93fd
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGciOiJSg3fQ.heb7m-censored-InAMGIZd-bQ8r39kfoT1-ihAl_3BYsc0torNMWQnjuBVm5OQ"
        }
    The Body of this call will be:
        "No Body"

WARNING: Null value sent to create object type.

.LINK
    The API call for this operation is file:///api/v1/storage-systems/{systemid}/device-type1/appplicationsets
    The API call for this operation is file:///api/v1/storage-systems/{systemid}/device-type1/volume-collections    
#>   
[CmdletBinding()]
param(  [Parameter(ValueFromPipeLineByPropertyName=$true,Mandatory=$true )][Alias('id')]    [string]    $SystemId,  
        [alias('ApplicationSetId','VolumeCollectionId')]                                    [string]    $VolumeSetId,    
                                                                                            [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        switch ( $devicetype )
            {   'device-type1'  {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/applicationsets'
                                    if ( $VolumeSetId )
                                            {   $MyAdd = $MyAdd + '/' + $VolumeSetId
                                            }
                                    $SysColOnly = @()  
                                    $MyCol = invoke-Dsccrestmethod -uriadd $MyAdd -method Get -whatifBoolean $WhatIf    
                                    $ReturnData = Invoke-RepackageObjectWithType -RawObject $MyCol -ObjectName ( "VolumeSet")
                                    return $ReturnData
                                }
                'device-type2'  {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/volume-collections' 
                                    if ( $VolumeSetId )
                                        {   $MyAdd = $MyAdd + '/' + $VolumeSetId
                                        }
                                    $MyCol = invokeDscc-restmethod -uriadd $MyAdd -method Get    
                                    $ReturnData = Invoke-RepackageObjectWithType -RawObject $MyCol -ObjectName "VolumeSet"
                                    return $ReturnData          
                                }
            }     
    }       
}   
function Remove-DSCCVolumeSet
{
<#
.SYNOPSIS
    Removes a HPE DSSC Volume Set also known as the Volume Collection or Application Set    
.DESCRIPTION
    Removes a HPE Data Services Cloud Console Volume Set also known as the Volume Collection or Application Set.
.PARAMETER SystemID
    A single System ID is specified and required.
.PARAMETER AccessControlRecordID
    A single Application Set ID is specified and required.
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
#>    
[CmdletBinding()]
param(  [Parameter(ValueFromPipeLineByPropertyName=$true,Mandatory=$true )][Alias('id')]    [string]    $SystemId,  
        [Parameter(Mandatory=$true)][alias('ApplicationSetId','VolumeCollectionId')]        [string]    $VolumeSetId,    
                                                                                            [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        switch ( $devicetype )
            {   'device-type1'  {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/applicationsets' + '/' + $VolumeSetId
                                    return invoke-DSCCRestmethod -uriadd $MyAdd -method Delete -whatifBoolean $WhatIf
                                }
                'device-type2'  {   $MyAdd = 'storage-systems/' + $DeviceType + '/' + $SystemId + '/volume-collections' + '/' + $VolumeSetId
                                    return invoke-DSCCRestmethod -uriadd $MyAdd -method Delete -whatifBoolean $WhatIf
                                }
            }     
    }       
}     
Function New-DSCCVolumeSet
{
<#
.SYNOPSIS
    Creates a HPE DSSC Volume Collection or Application Set    
.DESCRIPTION
    Creates a HPE Data Services Cloud Console Data Operations Manager Volume Collection or Application Set.
.PARAMETER SystemID
    A single System ID is specified and required.
.PARAMETER appSetBuisnessUnit
    This paramentere is only valid for device-type1 type storage systems.  App set business unit
.PARAMETER appSetComments
    This paramentere is only valid for device-type1 type storage systems. 
.PARAMETER appSetImportance
    This paramentere is only valid for device-type1 type storage systems. 
.PARAMETER appSetName
    This paramentere is only valid for device-type1 type storage systems. 
.PARAMETER appSetType
    This paramentere is only valid for device-type1 type storage systems. 
.PARAMETER members
    This paramentere is only valid for device-type1 type storage systems. volumes list
.PARAMETER name
    This paramentere is only valid for device-type2 type storage systems. 
.PARAMETER agentHostname
    This paramentere is only valid for device-type2 type storage systems. Generic backup agent hostname. 
    Custom port number can be specified with agent hostname using \":\". String of up to 64 alphanumeric 
    characters, - and . and : are allowed after first character.
.PARAMETER agentHostname
    This paramentere is only valid for device-type2 type storage systems. Generic backup agent username. 
    String of up to 64 alphanumeric characters, - and . and : are allowed after first character.
.PARAMETER agentUsername
    This paramentere is only valid for device-type2 type storage systems. If the application is running 
    within a Windows cluster environment, this is the cluster name. String of up to 64 alphanumeric 
    characters, - and . and : are allowed after first character.
.PARAMETER appClusterName
    This paramentere is only valid for device-type2 type storage systems. Application ID running on the server. 
    Application ID can only be specified if application synchronization is \"vss\". Possible values: 'inval',
    'exchange','exchange_dag','hyperv','sql2005','sql2005','sql2012','sql2014','sql2016','sql2017'.
.PARAMETER appId
    This paramentere is only valid for device-type1 type storage systems. If the application is running 
    within a Windows cluster environment, this is the cluster name. String of up to 64 alphanumeric 
    characters, - and . and : are allowed after first character.
.PARAMETER appServer
    This paramentere is only valid for device-type2 type storage systems. Application server hostname. 
    String of up to 64 alphanumeric characters, - and . and : are allowed after first character. 
.PARAMETER appServiceName
    This paramentere is only valid for device-type2 type storage systems. If the application is running
     within a Windows cluster environment then this is the instance name of the service running within the 
     cluster environment. String of up to 64 alphanumeric characters, - and . and : are allowed after first character.
.PARAMETER appSync
    This paramentere is only valid for device-type2 type storage systems. Application Synchronization. 
    Possible values: 'none','vss','vmware','generic'
.PARAMETER description
    This paramentere is only valid for device-type2 type storage systems. Text description of volume 
    collection. String of up to 255 printable ASCII characters.
.PARAMETER isStandaloneVolColl
    This paramentere is only valid for device-type1 type storage systems. boolean Indicates whether this 
    is a standalone volume collection. Possible values: 'true', 'false'.
.PARAMETER prottmplId
    This paramentere is only valid for device-type1 type storage systems. Identifier of the protection 
    template whose attributes will be used to create this volume collection. This attribute is only used 
    for input when creating a volume collection and is not outputed. A 42 digit hexadecimal number.
.PARAMETER replicationType
    This paramentere is only valid for device-type1 type storage systems. Type of replication configured 
    for the volume collection. Default value is periodic_snapshot. Possible values are 'periodic_snapshot' and 'synchronous'.
.PARAMETER vcenterHostname
    This paramentere is only valid for device-type1 type storage systems. VMware vCenter hostname. Custom 
    port number can be specified with vCenter hostname using \":\". String of up to 64 alphanumeric 
    characters, - and . and : are allowed after first character.
.PARAMETER vcenterUsername
    This paramentere is only valid for device-type1 type storage systems. Application VMware vCenter username. 
    String of up to 80 alphanumeric characters, beginning with a letter. It can include ampersand (@), 
    backslash (), dash (-), period (.), and underscore (_).
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.LINK
    The API call for this operation is file:///api/v1/storage-systems/{systemid}/device-type1/access-control-records
#>   
[CmdletBinding()]
param(  [Parameter(ValueFromPipeLineByPropertyName=$true,Mandatory=$true,ParameterSetName=('device-type1','device-type2'))]
                                                                                                [Alias('id')]   [string]    $SystemId,
        [Parameter(ParameterSetName=('device-type1') )]                                                         [string]    $appSetBuisnessUnit,
        [Parameter(ParameterSetName=('device-type1','device-type2'))] [Alias('appSetComments')]                 [string]    $description,
        [Parameter(Mandatory=$true,ParameterSetName=('device-type1','device-type2'))][Alias('appSetName')]      [string]    $name,
        [Parameter(Mandatory=$true,ParameterSetName=('device-type1') )]                                         [string]    $appSetType,
        [Parameter(ParameterSetName=('device-type1') )]                                                         [string]    $appSetImportance,
        [Parameter(ParameterSetName=('device-type1') )]                                                         [string[]]  $members,

        [Parameter(ParameterSetName=('device-type2') )]                                                         [string]    $agentHostname,
        [Parameter(ParameterSetName=('device-type2') )]                                                         [string]    $agentUsername,
        [Parameter(ParameterSetName=('device-type2') )]                                                         [string]    $appClusterName,
        [Parameter(ParameterSetName=('device-type2') )][ValidateSet('inval','exchange','exchange_dag','hyperv','sql2005','sql2005','sql2012','sql2014','sql2016','sql2017')]
                                                                                                                [string]    $appId,
        [Parameter(ParameterSetName=('device-type2') )]                                                         [string]    $appServer,
        [Parameter(ParameterSetName=('device-type2') )]                                                         [string]    $appServiceName,
        [Parameter(ParameterSetName=('device-type2') )][ValidateSet('none','vss','vmware','generic')]           [string]    $appSync,
        [Parameter(ParameterSetName=('device-type2') )]                                                         [boolean]   $isStandaloneVolColl,
        [Parameter(ParameterSetName=('device-type2') )]                                                         [string]    $prottmplId,
        [Parameter(ParameterSetName=('device-type2') )][ValidateSet('periodic_snapshot','synchronous')]         [string]    $replicationType,
        [Parameter(ParameterSetName=('device-type2') )]                                                         [string]    $vcenterHostname,
        [Parameter(ParameterSetName=('device-type2') )]                                                         [string]    $vcenterUsername,
                                                                                                                [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        switch ( $devicetype )
            {   'device-type1'  {   $MyAdd = 'storage-systems/' + $devicetype + '/' + $SystemId + '/applicationsets'
                                    $MyBody =  @{}
                                    if ($appSetBuisnessUnit)    {   $MyBody += @{ appSetBuisnessUnit    = $appSetBuisnessUnit }    }
                                    if ($decription)            {   $MyBody += @{ appSetComments        = $description }           }
                                    if ($appSetImportance )     {   $MyBody += @{ appSetImportance      = $appSetImportance }      }
                                                                    $MyBody += @{ appSetName            = $name                    }  
                                                                    $MyBody += @{ appSetType            = $appSetType              }
                                    if ($members)               {   $MyBody += @{ members               = $members }               }
                                    return 
                                }
                'device-type2'  {   $MyAdd = 'storage-systems/' + $devicetype + '/' + $SystemId + '/volume-collections'
                                                                    $MyBody =  @{ name                  = $name                     }
                                    if ($agentHostname)         {   $MyBody += @{ agent_hostname        = $agentHostname }          }
                                    if ($agentUsername)         {   $MyBody += @{ agent_username        = $agentUsername }          }
                                    if ($appClusterName )       {   $MyBody += @{ app_cluster_ame       = $appClusterName}          }
                                    if ($appId)                 {   $MyBody += @{ app_id                = $appId }                  }
                                    if ($appServer)             {   $MyBody += @{ app_server            = $appServer }              }
                                    if ($appServiceName)        {   $MyBody += @{ app_service_name      = $appServiceName }         }
                                    if ($description)           {   $MyBody += @{ description           = $description }            }
                                    if ($isStandaloneVolColl )  {   $MyBody += @{ is_standalone_volcoll = $isStandaloneVolColl }    }
                                    if ($prottmplId)            {   $MyBody += @{ prottmpl_id           = $prottmplId }             }
                                    if ($replicationType )      {   $MyBody += @{ replication_type      = $replicationType }        }
                                    if ($vcenterHostname )      {   $MyBody += @{ vcenter_hostname      = $vcenterHostname }        }
                                    if ($vcenterUsername )      {   $MyBody += @{ vcenter_username      = $vcenterUsername }        }
                                }
            }
        return Invoke-DSCCRestMethod -uriadd $MyAdd -method 'POST' -body ( $MyBody | ConvertTo-Json ) -whatifBoolean $WhatIf
    }      
} 
Function Set-DSCCVolumeSet
{
<#
.SYNOPSIS
    Creates a HPE DSSC Volume Collection or Application Set    
.DESCRIPTION
    Creates a HPE Data Services Cloud Console Data Operations Manager Volume Collection or Application Set.
.PARAMETER SystemID
    A single System ID is specified and required.
.PARAMETER appSetId
    A Single Application Set ID is required and only valid for device-type1 storage systems.
.PARAMETER volumeCollectionId
    A Single volume Collection ID is required and only valid for device-type2 storage systems.
.PARAMETER appSetBuisnessUnit
    This paramentere is only valid for device-type1 type storage systems.  App set business unit
.PARAMETER appSetComments
    This paramentere is only valid for device-type1 type storage systems. 
.PARAMETER appSetImportance
    This paramentere is only valid for device-type1 type storage systems. 
.PARAMETER appSetName
    This paramentere is only valid for device-type1 type storage systems. 
.PARAMETER appSetType
    This paramentere is only valid for device-type1 type storage systems. 
.PARAMETER members
    This paramentere is only valid for device-type1 type storage systems. volumes list
.PARAMETER name
    This paramentere is only valid for device-type2 type storage systems. 
.PARAMETER agentHostname
    This paramentere is only valid for device-type1 type storage systems. Generic backup agent hostname. 
    Custom port number can be specified with agent hostname using \":\". String of up to 64 alphanumeric 
    characters, - and . and : are allowed after first character.
.PARAMETER agentHostname
    This paramentere is only valid for device-type1 type storage systems. Generic backup agent username. 
    String of up to 64 alphanumeric characters, - and . and : are allowed after first character.
.PARAMETER agentUsername
    This paramentere is only valid for device-type1 type storage systems. If the application is running 
    within a Windows cluster environment, this is the cluster name. String of up to 64 alphanumeric 
    characters, - and . and : are allowed after first character.
.PARAMETER appClusterName
    This paramentere is only valid for device-type1 type storage systems. Application ID running on the server. 
    Application ID can only be specified if application synchronization is \"vss\". Possible values: 'inval',
    'exchange','exchange_dag','hyperv','sql2005','sql2005','sql2012','sql2014','sql2016','sql2017'.
.PARAMETER appId
    This paramentere is only valid for device-type1 type storage systems. If the application is running 
    within a Windows cluster environment, this is the cluster name. String of up to 64 alphanumeric 
    characters, - and . and : are allowed after first character.
.PARAMETER appServer
    This paramentere is only valid for device-type1 type storage systems. Application server hostname. 
    String of up to 64 alphanumeric characters, - and . and : are allowed after first character. 
.PARAMETER appServiceName
    This paramentere is only valid for device-type1 type storage systems. If the application is running
     within a Windows cluster environment then this is the instance name of the service running within the 
     cluster environment. String of up to 64 alphanumeric characters, - and . and : are allowed after first character.
.PARAMETER appSync
    This paramentere is only valid for device-type1 type storage systems. Application Synchronization. 
    Possible values: 'none','vss','vmware','generic'
.PARAMETER description
    This paramentere is only valid for device-type1 type storage systems. Text description of volume 
    collection. String of up to 255 printable ASCII characters.
.PARAMETER isStandaloneVolColl
    This paramentere is only valid for device-type1 type storage systems. boolean Indicates whether this 
    is a standalone volume collection. Possible values: 'true', 'false'.
.PARAMETER prottmplId
    This paramentere is only valid for device-type1 type storage systems. Identifier of the protection 
    template whose attributes will be used to create this volume collection. This attribute is only used 
    for input when creating a volume collection and is not outputed. A 42 digit hexadecimal number.
.PARAMETER vcenterHostname
    This paramentere is only valid for device-type1 type storage systems. VMware vCenter hostname. Custom 
    port number can be specified with vCenter hostname using \":\". String of up to 64 alphanumeric 
    characters, - and . and : are allowed after first character.
.PARAMETER vcenterUsername
    This paramentere is only valid for device-type1 type storage systems. Application VMware vCenter username. 
    String of up to 80 alphanumeric characters, beginning with a letter. It can include ampersand (@), 
    backslash (), dash (-), period (.), and underscore (_).
.PARAMETER WhatIf
    The WhatIf directive will show you the RAW RestAPI call that would be made to DSCC instead of actually sending the request.
    This option is very helpful when trying to understand the inner workings of the native RestAPI calls that DSCC uses.
.LINK
    The API call for this operation is file:///api/v1/storage-systems/{systemid}/device-type1/access-control-records
#>   
[CmdletBinding()]
param(  [Parameter(ValueFromPipeLineByPropertyName=$true,Mandatory=$true,ParameterSetName=('device-type1','device-type2'))]
                                                                                                [Alias('id')]       [string]    $SystemId,

        [Parameter(Mandatory=$true,ParameterSetName=('device-type1','device-type2') )][Alias('applicationSetId')]  [string]    $volumeCollectionId,                                               
        [Parameter(ParameterSetName=('device-type1') )]                                                             [string]    $appSetBuisnessUnit,
        [Parameter(ParameterSetName=('device-type1','device-type2'))][Alias('appSetComment')]                      [string]    $description,
        [Parameter(ParameterSetName=('device-type1','device-type2'))][Alias('appSetName')]                         [string]    $name,
        [Parameter(ParameterSetName=('device-type1') )]                                                             [string]    $appSetType,
        [Parameter(ParameterSetName=('device-type1') )]                                                             [string[]]  $addMembers,
        [Parameter(ParameterSetName=('device-type1') )]                                                             [string[]]  $removeMembers,
        [Parameter(ParameterSetName=('device-type2') )]                                                             [string]    $agentHostname,
        [Parameter(ParameterSetName=('device-type2') )]                                                             [string]    $agentUsername,
        [Parameter(ParameterSetName=('device-type2') )]                                                             [string]    $appClusterName,
        [Parameter(ParameterSetName=('device-type2') )][ValidateSet('inval','exchange','exchange_dag','hyperv','sql2005','sql2005','sql2012','sql2014','sql2016','sql2017')]
                                                                                                                    [string]    $appId,
        [Parameter(ParameterSetName=('device-type2') )]                                                             [string]    $appServer,
        [Parameter(ParameterSetName=('device-type2') )]                                                             [string]    $appServiceName,
        [Parameter(ParameterSetName=('device-type2') )][ValidateSet('none','vss','vmware','generic')]               [string]    $appSync,
        [Parameter(ParameterSetName=('device-type2') )]                                                             [boolean]   $isStandaloneVolColl,
        [Parameter(ParameterSetName=('device-type2') )]                                                             [string]    $prottmplId,
        [Parameter(ParameterSetName=('device-type2') )]                                                             [string]    $vcenterHostname,
        [Parameter(ParameterSetName=('device-type2') )]                                                             [string]    $vcenterUsername,
                                                                                                                    [switch]    $WhatIf
     )
process
    {   Invoke-DSCCAutoReconnect
        $DeviceType = ( Find-DSCCDeviceTypeFromStorageSystemID -SystemId $SystemId )
        switch ( $devicetype )
            {   'device-type1'  {   $MyAdd = 'storage-systems/' + $devicetype + '/' + $SystemId + '/applicationsets/' + $volumeCollectionId
                                    $MyBody =  @{}
                                    if ($appSetBuisnessUnit)    {   $MyBody += @{ appSetBuisnessUnit    = $appSetBuisnessUnit }    }
                                    if ($description)           {   $MyBody += @{ appSetComments        = $description }           }
                                    if ($name )                 {   $MyBody += @{ appSetName            = $name }                  }
                                    if ($removeMembers )        {   $MyBody += @{ removeMembers         = $removeMembers }         } 
                                    if ($addMembers )           {   $MyBody += @{ addMembers            = $addMembers }            }
                                    return 
                                }
                'device-type2'  {   $MyAdd = 'storage-systems/' + $devicetype + '/' + $SystemId + '/volume-collections/' + $volumeCollectionId
                                    if ($name)                  {   $MyBody =  @{ name                  = $name }                   }   
                                    if ($agentHostname)         {   $MyBody += @{ agent_hostname        = $agentHostname }          }
                                    if ($agentUsername)         {   $MyBody += @{ agent_username        = $agentUsername }          }
                                    if ($appClusterName)        {   $MyBody += @{ app_cluster_ame       = $appClusterName }         }
                                    if ($appId)                 {   $MyBody += @{ app_id                = $appId }                  }
                                    if ($appServer)             {   $MyBody += @{ app_server            = $appServer }              }
                                    if ($appServiceName)        {   $MyBody += @{ app_service_name      = $appServiceName }         }
                                    if ($description)           {   $MyBody += @{ description           = $description }            }
                                    if ($isStandaloneVolColl)   {   $MyBody += @{ is_standalone_volcoll = $isStandaloneVolColl }    }
                                    if ($prottmplId)            {   $MyBody += @{ prottmpl_id           = $prottmplId }             }
                                    if ($vcenterHostname )      {   $MyBody += @{ vcenter_hostname      = $vcenterHostname }        }
                                    if ($vcenterUsername )      {   $MyBody += @{ vcenter_username      = $vcenterUsername }        }
                                }
            }
        return Invoke-DSCCRestMethod -uriadd $MyAdd -method 'PUT' -body ( $MyBody | ConvertTo-Json ) -whatifBoolean $WhatIf
     }      
} 
