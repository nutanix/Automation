############################################################
##
## Function: NTNX-Connect-NTNX
## Author: Steven Poitras
## Description: Connect to NTNX function
## Language: PowerShell
##
############################################################
function NTNX-Connect-NTNX {
<#
.NAME
	NTNX-Connect-NTNX
.SYNOPSIS
	Connect to NTNX function
.DESCRIPTION
	Connect to NTNX function
.NOTES
	Authors:  thedude@nutanix.com
	
	Logs: C:\Users\<USERNAME>\AppData\Local\Temp\NutanixCmdlets\logs
.LINK
	www.nutanix.com
.EXAMPLE
    NTNX-Connect-NTNX -IP "99.99.99.99.99" -User "BlahUser"
#> 
	Param(
	    [parameter(mandatory=$true)][AllowNull()]$ip,
		
		[parameter(mandatory=$false)][AllowNull()]$credential
	)

	begin{
		# Make sure requried snappins are installed / loaded
		$loadedSnappins = Get-PSSnapin
		
		if ($loadedSnappins.name -notcontains "NutanixCmdletsPSSnapin") {
			Write-Host "Nutanix snappin not installed or loaded, trying to load..."
			
			# Try to load snappin
			Add-PSSnapin NutanixCmdletsPSSnapin
			
			# Refresh list of loaded snappins
			$loadedSnappins = Get-PSSnapin
			
			if ($loadedSnappins.name -notcontains "NutanixCmdletsPSSnapin") {
				Write-Host "Nutanix snappin not installed or loaded, exiting..."
				break
			}
		}
		
		# If values not set use defaults
		if ([string]::IsNullOrEmpty($credential.UserName)) {
			Write-Host "No Nutanix user passed, using default..."
			$credential = (Get-Credential -Message "Please enter the Nutanix Prism credentials <admin/*******>")
		}

	}
	process {
		# Check for connection and if not connected try to connect to Nutanix Cluster
		if ([string]::IsNullOrEmpty($IP)) { # Nutanix IP not passed, gather interactively
			$IP = Read-Host "Please enter a IP or hostname for the Nutanix cluter"
		}
		
		# If not connected, try connecting
		if ($(Get-NutanixCluster -Servers $IP -ErrorAction SilentlyContinue).IsConnected -ne "True") {  # Not connected
			Write-Host "Connecting to Nutanix cluster ${IP} as $($credential.UserName.Trim("\")) ..."
			$connObj = Connect-NutanixCluster -Server $IP -UserName $($credential.UserName.Trim("\")) `
				-Password $(([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($credential.Password)))) -AcceptInvalidSSLCerts -F
		} else {  # Already connected to server
			Write-Host "Already connected to server ${IP}, continuing..."
		}
	}
	end {
		$nxServerObj = New-Object PSCustomObject -Property @{
			IP = $IP
			Credential = $credential
			connObj = $connObj
		}
		
		return $nxServerObj
	}
}