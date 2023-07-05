function Get-DSCCAccessControl
{
<#
.SYNOPSIS
    Returns the DSCC Authz Access Controls.    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Access Controls information; 
    This is part of the API today however it is likely that the command returns no valuable information. 
    The command is included to satisfy completeness and work once this capability is implemented.
    If none of the parameters such as create, read, update, or delete are selected, then the default command will
    return the results of all of these combined.
.PARAMETER resourceType
    If unset, the command will return ALL values that are exposed via Get-DSCCResourceType. 
    Otherwise you can request any individual permission.
.PARAMETER create
    If this switch is used, the  command will return the specific permissions for this account regarding create operations.
.PARAMETER read
    If this switch is used, the  command will return the specific permissions for this account regarding create operations.
.PARAMETER update
    If this switch is used, the  command will return the specific permissions for this account regarding create operations.

.PARAMETER delete
    If this switch is used, the  command will return the specific permissions for this account regarding create operations.

.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE
    PS:> Get-DSCCAccessControl

    warning: This command may take a minute or two to complete, as it will interate ALL permissions.
.EXAMPLE
    PS:> Get-DSCCAccessControl -resourceType volume -create -read

    volume.read
    volume.create

    If the permission is allows, it will return the name of the permission otherwise it will return nothing.
.EXAMPLE
    PS:> Get-DSCCAccessControl -resourceType volume

    volume.read
    volume.create
    volume.update
    volume.delete

    If no permission types are specified like 'read' or 'create', it will attempt to detect all the available permissions for that resource type.
.EXAMPLE
    PS:> Get-DSCCAccessControl -resourceType volume -whatIf

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://scint-app.qa.cds.hpe.com/api/v1/access-controls?permission=volume.create&permission=volume.read&permission=volume.update&permission=volume.delete
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGcsONZZjviVT71xz0...iGDDefq_9NEzKX-CsC2dLww8WglRiODredKeRORGKIkesKew"
        }
    The Body of this call will be:
        "No Body"
.LINK
    More details about the operation of this API can be found at https://console-us1.data.cloud.hpe.com/doc/api/v1/ under authz.
#>   
[CmdletBinding(DefaultParameterSetName=('Unspecified'))]
param(  [parameter( ValueFromPipeLineByPropertyName=$true, Mandatory, ParameterSetName = 'ByResourceId' )]
        [string]    $resourceType,
        [parameter( ParameterSetName = 'ByResourceId' )]
        [switch]      $create,
        [parameter( ParameterSetName = 'ByResourceId' )]
        [switch]      $read,
        [parameter( ParameterSetName = 'ByResourceId' )]
        [switch]      $update,
        [parameter( ParameterSetName = 'ByResourceId' )]
        [switch]      $delete,
        [switch]      $whatIf
    )
process
{   if ( $resourceType )
            {   $AddString='access-controls?'
                if ( $create )                          {   $AddString += "permission=$resourceType.create"   }
                if ( $read)                             {   if ( -not $Addstring.EndsWith('?') )    
                                                                {   $AddString += '&'               }
                                                            $AddString += "permission=$resourceType.read"     }
                if ( $update)                           {   if ( -not $Addstring.EndsWith('?') )    
                                                                {   $AddString += '&'               }
                                                            $AddString += "permission=$resourceType.update"   }
                if ( $delete)                           {   if ( -not $Addstring.EndsWith('?') )    
                                                                {   $AddString += '&'               
                                                                }
                                                            $AddString += "permission=$resourceType.delete"   }
                if ( $AddString -eq 'access-controls?' ){   $AddString += "permission=$resourceType.create&permission=$resourceType.read&permission=$resourceType.update&permission=$resourceType.delete" }
                $ReturnObj = Invoke-DSCCRestMethod -uriAdd $AddString -method 'Get' -WhatIfBoolean $WhatIf
                [string]$MyData = $ReturnObj
                write-verbose "looking for $resourceType"
                # The following only succeeds if the permisson is found. If it is found, return the name of the permission, if not found, instead of returning items=@(), we want to return nothing.
                if ( $MyData.indexof($resourceType) )
                        {   write-verbose 'index not found, so return nothing.'
                            return
                        }
                else    {   write-verbose 'index found, so return data must exist.'
                            return ( $ReturnObj )
                        }
            }
        else 
            {   $ReturnData = foreach ( $val in (Get-DSCCResourceType) ) { Get-DSCCAccessControl -resourceType $val } 
                return $ReturnData
            }
}       
}   
function Get-DSCCResourceType
{
<#
.SYNOPSIS
    Returns the DSCC Authz Resource Types.    
.DESCRIPTION
    Returns the HPE Data Services Cloud Console Resource Types information;
    This can be helpful to discover what permissions you have access to; 
    These resource types can be feed into the Get-DSCCAccessControl to discover you individual levels of permissions
.PARAMETER WhatIf
    This option shows you the command that will be sent to the DSCC, will include the URI being sent to, the Header, Method, and the Body of the message.
.EXAMPLE
    PS:> Get-DSCCResourceType

    This will retun all of the object types that you may or may not have 
    .EXAMPLE
    PS:> Get-DSCCResourceType -whatIf

    WARNING: You have selected the What-IF option, so the call will note be made to the array,
    instead you will see a preview of the RestAPI call

    The URI for this call will be
        https://scint-app.qa.cds.hpe.com/api/v1/resource-types
    The Method of this call will be
        Get
    The Header for this call will be :
        {   "Authorization":  "Bearer eyJhbGcsONZZjviVT71xz0...iGDDefq_9NEzKX-CsC2dLww8WglRiODredKeRORGKIkesKew"
        }
    The Body of this call will be:
        "No Body"
.LINK
    More details about the operation of this API can be found at https://console-us1.data.cloud.hpe.com/doc/api/v1/ under authz.
#>   
[CmdletBinding()]
param(  [switch]    $whatIf
    )
process
{   return ( Invoke-DSCCRestMethod -uriadd 'resource-types' -method 'Get' -whatifBoolean $WhatIf ) 
}       
}   