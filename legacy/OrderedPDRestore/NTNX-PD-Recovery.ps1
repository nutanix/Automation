############################################################
##
## Script: Ordered PD Restore
## Author: Steven Poitras
## Description: Restore and power on PDs in desired order
## Language: PowerShell
##
############################################################
function NTNX-PD-Recovery {
<#
.NAME
	NTNX-PD-Recovery
.SYNOPSIS
	Recovery Nutanix PDs to target site and restore in specified order
.DESCRIPTION
	Recovery Nutanix PDs to target site and restore in specified order
.NOTES
	Authors:  The Dude
	
	Logs: C:\Users\<USERNAME>\AppData\Local\Temp\NutanixCmdlets\logs
.LINK
	www.nutanix.com
.EXAMPLE
    NTNX-PD-Recovery -pdToRestore "TestPD1","TestPD2" -pathPrefix "/mypath"
  	NTNX-PD-Recovery -pdToRestore "PD1","PD2","PD3" -pathPrefix "/mypath" -nxIP "99.99.99.99.99" -nxUser "admin" -vcIP "99.99.99.99.99" -vcUser "mydomain\admin"
#> 
	Param(
    	[parameter(mandatory=$true)][array]$pdToRestore,
		
		[parameter(mandatory=$true)]$pathPrefix,
		
		[parameter(mandatory=$false)]$nxIP,
		
		[parameter(mandatory=$false)]$nxUser,
		
		[parameter(mandatory=$false)]$nxPassword,
		
		[parameter(mandatory=$false)]$vcIP,
		
		[parameter(mandatory=$false)]$vcUser,
		
		[parameter(mandatory=$false)]$vcPassword,
		
		[parameter(mandatory=$false)][bool]$replaceVMs

	)
  	begin{
		# Clear window
		clear
		
		# Placeholder for VMs
		$global:restoredVMs = @()
		
		# Defaults
		[bool]$success = $true
		[int]$sleepTime = 10
		[int]$maxRetry = 5
		
		# If values not set use defaults
		if ($nxUser -eq $null) {
			Write-Host "No Nutanix user passed, using default..."
			$nxUser = "admin"
		}
		
		if ($replaceVMs -eq $null) {
			[bool]$replaceVMs = $false
		}
		
		# Make sure requried snappins are installed / loaded
		$loadedSnappins = Get-PSSnapin

		if ($loadedSnappins.name -notcontains "VMware.VimAutomation.Core") {
			Write-Host "PowerCLI snappin not installed or loaded, exiting..."
			break
		}

		if ($loadedSnappins.name -notcontains "NutanixCmdletsPSSnapin") {
			Write-Host "Nutanix snappin not installed or loaded, exiting..."
			break
		}
		
		# Check formatting for path prefix
		if ($pathPrefix.StartsWith("/") -eq $false) {
			Write-Host "Path prefix is not in format '/path', reformatting..."
			$pathPrefix = "/$pathPrefix"
		}
		
		# Check for connection and if not connected try to connect to Nutanix Cluster
		if ($nxIP -eq $null) { # Nutanix IP not passed, gather interactively
			$nxIP = Read-Host "Please enter a IP or hostname for the Nutanix cluter: "
		}

		if ($(Get-NutanixCluster -Servers $nxIP -ErrorAction SilentlyContinue).IsConnected -ne "True") {  # Not connected
			# If no password, get password for Nutanix user
			if ($nxPassword -eq $null) {
				$nxPassword = Read-Host "Please enter a password for Nutanix user ${nxUser}: " -AsSecureString
			}
			
			Write-Host "Connecting to Nutanix cluster ${nxIP} as ${nxUser}..."
			$nxServerObj = Connect-NutanixCluster -Server $nxIP -UserName $nxUser -Password $(if ($nxPassword.GetType().Name -eq "SecureString") `
				{([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($nxPassword)))} `
				else {$nxPassword}) -AcceptInvalidSSLCerts
		} else {  # Already connected to server
			Write-Host "Already connected to server ${nxIP}, continuing..."
		}

		# Check for connection and if not connected try to connect to vCenter Server
		if ($vcIP -eq $null) { # VC IP not passed, gather interactively
			$vcIP = Read-Host "Please enter a IP or hostname for the vCenter Server: "
		}
		
		if ($($global:DefaultVIServers | where {$_.Name -Match $vcIP}).IsConnected -ne "True") {
			# If no VC user passed prompt for username
			if ($vcUser -eq $null) {
				$vcUser = Read-Host "Please enter a admin user for vCenter: "
			}
			
			if ($vcPassword -eq $null) {
				$vcPassword = Read-Host "Please enter a password for vCenter user ${vcUser}: " -AsSecureString
			}
			
			# Connect to vCenter Server
			$vcServerObj = Connect-VIServer $vcIP -User $vcUser -Password $(if ($vcPassword.GetType().Name -eq "SecureString") `
				{([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($vcPassword)))} `
				else {$vcPassword})
		} else {  #Already connected to server
			Write-Host "Already connected to server ${vcIP}, continuing..."
		}
		
  	}
  	process{
		# Get PD objects once
		$pds = Get-NTNXProtectionDomain
		
		# Make sure input PDs exist
		$global:foundPDs = $pds |? {$pdToRestore -contains $_.name}
		$notFoundPDs = $pdToRestore |? {$global:foundPDs.name -notcontains $_}
		
		Write-Host "Found $($global:foundPDs.length) PDs of $($pdToRestore.length) expected!"
		
		if ($global:foundPDs.Length -lt $pdToRestore.length) {
			Write-Host "Could not find the following PDs: $($notFoundPDs -join ",") exiting..."
			$success = $false
			break
		}
		
		# For each PD restore and power on
		$global:foundPDs | %{
			$currentPD = $_
			Write-Host "Current Protection Domain: $($currentPD.name)"
			
			# Get Protection Domain VMs
			$pdVMs = $currentPD.vms
			Write-Host "Protection domains contains VMs: " $(($pdVMs | select -expand vmName) -join ",")
			
			# Check to see if any previously restored VMs exist similar name
			$existingVMs = @()
			
			# Create regex for searching for VMs
			[regex]$vmRegex = ‘(?i)(‘ + (($($pdVMs.vmName) |foreach {[regex]::escape($_)}) –join “|”) + ‘)'
			
			# Search for existing VMs
			$existingVMs = Get-NTNXVM | where {$_.vmName -match $vmRegex -And $_.vdiskFilePaths -match $pathPrefix}
			
			# If VMs exist at current path, exit
			if ($existingVMs.length -gt 0) {
				Write-Host "Found $($existingVMs.length) matching VMs at current path, exiting..."
				$success = $false
				return	
			}

			# Get PD snapshots
			$pdSnapshots = $currentPD | Get-NTNXProtectionDomainSnapshot -SortCriteria ascending
			
			if ($pdSnapshots.length -gt 0) {
				Write-Host "Protection domain has $($pdSnapshots.length) snapshots, selecting latest..."
			} else { # No snapshots
				Write-Host "Protection domain has 0 snapshots, exiting..."
				$success = $false
				break
			}

			# Try to restore PD using latest snapshot
			Write-Host "Restoring Protection domain $($currentPD.name)"
			Restore-NTNXEntity -Name $currentPD.name -PathPrefix $pathPrefix -Replace $replaceVMs -SnapshotId $pdSnapshots[0].snapshotId

			# Sleep for $sleepTime
			Write-Host "Sleeping for $sleepTime seconds to allow for PD restoration and VM registration..."
			sleep $sleepTime
			
			# Set retry counter
			[int]$retryInt = 1
			
			while ($retryInt -le $maxRetry) {
				$matchedVMs = Get-NTNXVM | where {$_.vmName -match $vmRegex -And $_.vdiskFilePaths -match $pathPrefix}
				
				Write-Host "Found VMs: $(($matchedVMs | select -expand vmName) -join ",")"
			
				# Try to get VM objects from PowerCLI for VMs in PD
				$vmObjects = Get-VM |? {$matchedVMs.vmName -eq $_.Name}
				
				Write-Host "Found the following VM objects in VC: $(($vmObjects | select -expand name) -join ",")"
				
				# If all VM objects are found
				if($vmObjects.length -ge $matchedVMs.length -and $vmObjects.length -ne 0) {
					Write-Host "$($vmObjects.length) VMs registered of $($matchedVMs.length) expected!"
					
					# Add VMs to aggregate array for cleanup later
					Write-Host "Adding $($vmObjects.length) objects to aggregate array..."
					$global:aggVMs += $vmObjects
					
					# Break loop
					break
				} else {
					# No VM objects found
					Write-Host "Attempt $retryInt/$maxRetry, sleeping for $sleepTime seconds to allow for VM registration..."
					$retryInt += 1
					sleep $sleepTime
				}
			}
			
		}
		
  	}
  	end{
		# Finish
		if ($success) {
    		Write-Host "Restored the following PDs: $(($global:foundPDs | select -expand name) -join ",")"
  		} else {
			# Something went wrong
			Write-Host "Something went wrong, please check console errors and logs"
		}
	}
}