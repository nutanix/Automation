

# Feature "Active Directory Module for Windows Powershell" has to be installed on the machine where the script is executed


Add-PSSnapin -Name McliPSSnapIn
Add-PSSnapin -Name NutanixCmdletsPSSnapin

# Connecting to the Nutanix AHV Cluster and the Citrix PVS server

Connect-NTNXCluster 10.68.64.55 -AcceptInvalidSSLCerts
Mcli-Run SetupConnection -p server=XXX.XXX.XXX.XXX, port=54321
 	
# Create VMs in AHV

			
		##########################
		##	Get inputs & Defaults
		##########################
		
		# Get vms array once
		$vmid = Get-NTNXVM
		
		# Create array for clone tasks
		$cloneTasks = @()

        # Get available images
            if ($vmid.vmName -contains $image.vmName) {
            Write-Host "Image found!"
            Write-Host "$($vmid.vmName)"
        }

        # Select Image
		if ([string]::IsNullOrEmpty($image)) {
			$image = Read-Host "Please enter an image name "
		}		

		# Get VM prefix if not passed
		if ([string]::IsNullOrEmpty($prefix)) {
			$prefix = Read-Host "Please enter a name prefix and int structure [e.g. myClones-###] "
		}
		
		# Get starting int if not passed
		if ([string]::IsNullOrEmpty($startInt)) {
			$startInt = Read-Host "Please enter a starting int [e.g. 1] "
		}
		
		# If ints aren't formatted
		if ($prefix -notmatch '#') {
			$length = 3
		} else {
			$length = [regex]::matches($prefix,"#").count
			
			# Remove # from prefix
			$prefix = $prefix.Trim('#')
		}
		
		# Get VM quantity if not passed
		if ([string]::IsNullOrEmpty($quantity)) {
			$quantity = Read-Host "Please enter the desired quantity of VMs to be provisioned "
		}
		

		1..$quantity | %{
			
			$l_formattedInt = "{0:D$length}" -f $($_+$startInt-1)
			
			$l_formattedName = "$prefix$l_formattedInt"
			
			Write-Host "Creating clone $l_formattedName"
			
			# Create clone spec

            
			$spec = New-NTNXObject -Name VMCloneSpecDTO
			$spec.name = $l_formattedName
			
            foreach ($p in $vmid) {
			$task = Clone-NTNXVirtualMachine -Vmid $p -SpecList $spec
			
			$cloneTasks += $task
			
		}
}



# PARAMETERS

#  hostname of one PVS Server

$pvshost ="PVSServerHostname"

# Parameters which have to be edited according to environment - check for correct silo name

$description= "Description of the vDisk"
$OU="OU=computers,DC=contoso,DC=local"

# Parameters which have to be edited according to PVS Device Collection
$collection= "PVS Device Collection Name"
$site_1= "PVS Site 1"

# Get the VM Names, the MAC addresses and create targets in PVS

$vmid = get-ntnxvm
 
 foreach ($p in $vmid) {
    $mac = get-ntnxvmnic -vmid $p
    $p.vmName
    $mac.macAddress
    Mcli-Add Device -r deviceName=$($p.vmName), collectionName=Collection, siteName=Site, deviceMac=$($mac.macAddress)
}
