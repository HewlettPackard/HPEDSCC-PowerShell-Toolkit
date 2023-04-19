# HPE Data Storage Cloud Console PowerShell Toolkit

This PowerShell module is designed to monitor and manage your on-premises HPE storage connected to a Data Storage Cloud Console GreenLake infrastructure. Some PowerShell toolkits exist that currently manage both HPE Nimble Storage/Alletra 6K, as well as 3PAR, Primera and Alletra 9K storage, but these PowerShell toolkits are designed to monitor and manage one storage target at a time, and use the target arrays local native RestAPI to do it.

Using the DSCC PowerShell toolkit, you are able to use a combined single RestAPI (which means single toolkit), but your commands are functional across any or all of the target arrays at the same time. For example, you want to create a new Volume. You may need to log into each target array individually to determine the best array to place this new volume, but DSCC will allow you to query all the target devices from a single command and select the appropriate array. Additionally, when you want to register your server's HBAs with a Target Device, you only need to do it once to the DSCC and it's available to all target arrays.

## Installing the toolkit

To install the HPE DSCC PowerShell Toolkit follow the simple steps below.

Download the DSCC Toolkit to your local machine, and right click on the ZIP file and ensure that 'blocked' is NOT checked.

Extract the zip file to the following location: `C:\Windows\System32\WindowsPowerShell\v1.0\Modules\HPEDSCC`

Ensure that the HPEDSCC.psm1 file exists in the above directory.

Open a PowerShell Window and use the command `PS:> Import-Module HPEDSCC`

## Prerequisite for setting up API Access

Open your GreenLake account and go to Manage Roles, and click on the option for API.

From the API screen, create new API Account, choose a name that you will remember such as PowerShellAccess.

Record both the Client_ID and Client_Secret as they will be needed. You will also need to know which Region you are in (USA, EU, Asia).

## GreenLake Limitations

Some limits exist that you should be aware of:

- Each GreenLake account may have up to 5 API Accounts.
- If the API option is not shown, you may need to use an account with escalated privileges.
- Once the Client_Secret has been given to you, it is no longer retrievable, so don't lose it.
- Once a Token has been generated, it is only valid for 2 hours.
- Creating a new token immediately invalidates the last token

## Using the PowerShell Toolkit to connect to GreenLake

The following command is used to make this initial connection:  
`PS:> Connect-DSCC -Client_Id 'put_client_id_here' -Client_Secret 'put_client_secret_here' -GreenlakeType USA`

Once this command runs it will create a set of global variables that represent the default header, including the retrieved Access Token, which are then used by all further commands.

Additionally an option called '-AutoRenew' now exists with the Connect-DSCC command which will allow the toolkit to reconnect on demand using the same Client ID and Client Secret offered. This is not saved, and expires as soon as the PowerShell session is closed.

Click to see the [documentation on this RestAPI](https://console-us1.data.cloud.hpe.com/doc/api/v1/).
