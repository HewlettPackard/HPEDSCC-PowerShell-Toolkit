# DSCC
HPE Data Storage Cloud Console PoswerShell Toolkit
This powershell module is designed to monitor and manage your on-premisis HPE storage connected to a Data Storage Cloud Console GreenLake infrastructure. 
There exists PowerShell Toolkits that currently manage both HPE Nimble Storage/Alletra 6K, as well as 3PAR, Primera and Alletra 9K storage, but these 
powershell toolkits are designed to monitor and manage one storage target at a time, and uses the target arrays local native RestAPI to do it. 
<p>Using the DSCC PowerShell toolkit you are able to use a combined single RestAPI (which means single toolkit), but your commands are functional 
across any or all of the target arrays at the same time. i.e. I want to create a new Volume, I may need to log into each target array individually 
to determine the best array to place this new volume, but DSCC will allow me query all the target devices from a single command and select the 
appropriate array. Additionally when I want to register my servers HBAs with a Target Device, I only need to do it once to the DSCC and its available 
to all target arrays. 

It Install the HPE DSCC PowerShell Toolkit follow the below simple steps.
1. Download the DSCC Toolkit to your local machine, and right click on the ZIP file and ensure that 'blocked' is NOT checked
2. Extract the zip file to the following location; <code>C:\Windows\System32\WindowsPowerShell\v1.0\Modules\HPEDSCC</code>
3. Ensure that the <code>HPEDSCC.psm1</code> file lives at the above directory
4. Open a PowerShell Window and use the command <code>PS:> Import-Module HPEDSCC</code>

Prerequisite for setting up API Access
1. Open your Greenlake account and go to Manage Roles, and click on the option for API
2. From the API screen, create new API Account, choose a name that you will remember such as PowerShellAccess
3. Record both the Client_ID and Client_Secret as they will be needed
4. You will also need to know which Region you are in (USA, EU, Asia). 

GreenLake Limitations; Some limits exist to be away of; 
1. Each Greenlake account may have up to 5 API Accounts. 
2. if the API option is not shown, you may need to use an account with escalated privedges.
3. Once the Client_Secret has been given to you, it is no longer retrievable, so dont lose it.
4. Once a Token has been generated, it is only valid for 2 hours, creating of a new token immediately invalidates the last token

Using the PowerShell Toolkit to connect to Greenlake
The following command is used to make this initial connection;
<P><code>PS:> Connect-DSCC -Client_Id 'put_client_id_here' -Client_Secret 'put_client_secret_here' -GreenlakeType USA</code>
<P>Once this commnad runs it will create a set of global variables that represent the default header which includes the retrieved 
Access Token which are then used by all further commands.
