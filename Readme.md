HPE Data Storage Cloud Console PoswerShell Toolkit This powershell module is designed to monitor and manage your on-premisis HPE storage connected to a Data Storage Cloud Console GreenLake infrastructure. There exists PowerShell Toolkits that currently manage both HPE Nimble Storage/Alletra 6K, as well as 3PAR, Primera and Alletra 9K storage, but these powershell toolkits are designed to monitor and manage one storage target at a time, and uses the target arrays local native RestAPI to do it.

Using the DSCC PowerShell toolkit you are able to use a combined single RestAPI (which means single toolkit), but your commands are functional across any or all of the target arrays at the same time. i.e. I want to create a new Volume, I may need to log into each target array individually to determine the best array to place this new volume, but DSCC will allow me query all the target devices from a single command and select the appropriate array. Additionally when I want to register my servers HBAs with a Target Device, I only need to do it once to the DSCC and its available to all target arrays.

It Install the HPE DSCC PowerShell Toolkit follow the below simple steps.

Download the DSCC Toolkit to your local machine, and right click on the ZIP file and ensure that 'blocked' is NOT checked
Extract the zip file to the following location; <code>C:\Windows\System32\WindowsPowerShell\v1.0\Modules\HPEDSCC</code>
Ensure that the HPEDSCC.psm1 file lives at the above directory
Open a PowerShell Window and use the command <code>PS:> Import-Module HPEDSCC</code>
Prerequisite for setting up API Access

Open your Greenlake account and go to Manage Roles, and click on the option for API
From the API screen, create new API Account, choose a name that you will remember such as PowerShellAccess
Record both the Client_ID and Client_Secret as they will be needed
You will also need to know which Region you are in (USA, EU, Asia).
GreenLake Limitations; Some limits exist to be away of;

Each Greenlake account may have up to 5 API Accounts.
if the API option is not shown, you may need to use an account with escalated privedges.
Once the Client_Secret has been given to you, it is no longer retrievable, so dont lose it.
Once a Token has been generated, it is only valid for 2 hours, creating of a new token immediately invalidates 
the last token The Client_ID/Client_Secret popup will look like the following graphic;
Client

Using the PowerShell Toolkit to connect to Greenlake The following command is used to make this initial connection;
<code>PS:> Connect-DSCC -Client_Id 'put_client_id_here' -Client_Secret 'put_client_secret_here' -GreenlakeType USA</code>


Once this commnad runs it will create a set of global variables that represent the default header which includes the retrieved 
Access Token which are then used by all further commands.

Additionally an option called '-AutoRenew' now exists with the Connect-DSCC command which will allow the toolkit to reconnect 
on demand using the came client ID and Client Secret offered. This is not saved, and expires as soon as the PowerShell session is closed.

The documenation on this RestAPI can be found at https://console-us1.data.cloud.hpe.com/doc/api/v1/
