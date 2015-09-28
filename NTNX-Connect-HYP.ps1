############################################################
##
## Function: NTNX-Connect-HYP
## Author: Steven Poitras
## Description: Connect to Hypervisor manager function
## Language: PowerShell
##
############################################################
function NTNX-Connect-HYP {
<#
.NAME
	NTNX-Connect-HYP
.SYNOPSIS
	Connect to Hypervisor manager function
.DESCRIPTION
	Connect to Hypervisor manager function
.NOTES
	Authors:  thedude@nutanix.com
	
	Logs: C:\Users\<USERNAME>\AppData\Local\Temp\NutanixCmdlets\logs
.LINK
	www.nutanix.com
.EXAMPLE
    NTNX-Connect-HYP -IP "99.99.99.99.99" -User "BlahUser" -Type VC
#> 
	Param(
	    [parameter(mandatory=$true)][AllowNull()]$IP,
		
		[parameter(mandatory=$false)][AllowNull()]$Type,
		
		[parameter(mandatory=$false)][AllowNull()]$credential
	)

	begin{
		$hypType = "VC","SCVMM"
	
		# Make sure requried snappins are installed / loaded
		$loadedSnappins = Get-PSSnapin
		
		# If no IP passed prompt for IP
		if ([string]::IsNullOrEmpty($IP)) {
			$IP = Read-Host "Please enter a IP or hostname for the management Server"
		}
		
		# If no type passed prompt for type
		if ([string]::IsNullOrEmpty($Type)) {
			$Type = NTNX-Build-Menu -Title "Please select a management server type" -Data $hypType
		}
		
		# If values not set use defaults
		if ([string]::IsNullOrEmpty($credential)) {
			Write-Host "No admin credential passed, prompting for input..."
			$credential = (Get-Credential -Message "Please enter the vCenter Server credentials <admin/*******>")
		}

	}
	process {
		if ($Type -eq $hypType[0]) {
			# Make sure snappin is loaded
			if ($loadedSnappins.name -notcontains "VMware.VimAutomation.Core") {
				# Try to load snappin
				Add-PSSnapin VMware.VimAutomation.Core
				
				# Refresh list of loaded snappins
				$loadedSnappins = Get-PSSnapin
				
				if ($loadedSnappins.name -notcontains "VMware.VimAutomation.Core") {
					# Try to load snappin
					Write-Host "PowerCLI snappin not installed or loaded, exiting..."
					break
				}
			}	
			
			# Check if connection already exists
			if ($($global:DefaultVIServers | where {$_.Name -Match $IP}).IsConnected -ne "True") {
				# Connect to vCenter Server
				Write-Host "Connecting to vCenter Server ${IP} as ${credential.UserName}..."
				$connObj = Connect-VIServer $IP -User $($credential.UserName.Trim("\")) `
					-Password $(([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($credential.Password))))
			} else {  #Already connected to server
				Write-Host "Already connected to server ${IP}, continuing..."
			}
		} elseif ($Type -eq $hypType[1]) {
			# To be input
		}
		
	}
	end {
		$hypServerObj = New-Object PSCustomObject -Property @{
			IP = $IP
			Type = $Type
			Credential = $credential
			connObj = $connObj
		}
		
		return $hypServerObj
	}
}