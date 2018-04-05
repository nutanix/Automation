############################################################
##
## Script: Configure basic Nutanix cluster
## Author: Steven Poitras
## Description: Configure basic Nutanix cluster
## Language: PowerCLI
##
############################################################
function NTNX-Prep-Environment {
<#
.NAME
	NTNX-Prep-Environment
.SYNOPSIS
	Prep Nutanix environment including the creation of storage pools and containers
.DESCRIPTION
    Prep Nutanix environment including the creation of storage pools and containers
.NOTES
	Authors:  The Dude
.LINK
	www.nutanix.com
.EXAMPLE
  NTNX-Prep-Environment -server "99.99.99.99.99" -name "sp1" -type "SP"
  NTNX-Prep-Environment -server "99.99.99.99.99"  -type "CTR" -name "testCTR4" -compress -compressionDelay 600 -rf 2
  NTNX-Prep-Environment -server "99.99.99.99.99" -type "CTR" -name "testCTR5" -rf 2 -onDiskDedup
#> 
	Param(
    	[parameter(mandatory=$true)]$server,
		
		[parameter(mandatory=$true)]$name,
		
		[parameter(mandatory=$true)][ValidateSet("SP","CTR")]$type,
			
		[parameter(mandatory=$false)][ValidateSet(2,3)][int]$rf,
			
		[parameter(mandatory=$false)][switch]$compress,
			
		[parameter(mandatory=$false)][int]$compressionDelay,
			
		[parameter(mandatory=$false)][ValidateSet("ON","OFF","NONE")]$fingerprinting,
			
		[parameter(mandatory=$false)][switch]$onDiskDedup

	)
  	begin{
		# If on disk dedup is desired, make sure fingerprinting is enabled
		if ($onDiskDedup.isPresent) {
			Write-Host "On disk dedup requested, ensuring fingerprinting is enabled"
			$fingerprinting = "ON"
		} elseif ($fingerprinting -eq $null) {
			Write-Host "Fingerpringing not set, setting to default"
			$fingerprinting = "NONE"
		}
		
		if ($compress.isPresent) {
			Write-Host "Compression is requested"
			[bool]$compress = $true
			if (!$compressionDelay) {
				$compressionDelay = 0 # No delay passed, set to 0 (inline)
			}
		} else {
			[bool]$compress = $false
		}
		
		if ($rf -eq $null) {
			Write-Host 	"Replication factor not set, setting to default"
			$rf = 2
		}
		
		Write-Host "Running with params:
			Server = $server
			Name = $name
			Type = $type
			RF = $rf
			Compress = $(if ($compress) {"YES"})
			Compression Delay = $compressionDelay
			Fingerprinting = $fingerprinting
			On-Disk Dedup = $(if ($onDiskDedup) {"YES"})"
			
		$argString = "-ReplicationFactor $rf $(if ($compress) {"-CompressionEnabled $true -CompressionDelayInSecs $compressionDelay"}) $(if ($fingerprinting) {"-FingerPrintOnWrite $fingerprinting"}) $(if ($onDiskDedup) {"-OnDiskDedup"})"
		
		Write-Host "Requested command arguments: "$argString
		
  	}
  	process{
		if ($type -eq "SP" -and $(Get-NTNXStoragePool).length -eq 0) { # Type is Storage Pool
		
			# Create new storage pool
			New-NTNXStoragePool -Name $spName -Disks $((Get-NTNXDisk | select -expand id) -join ",")
			
		} 
		
		elseif ($type -eq "CTR") { # Type is Container
			
			# Make sure storage pool exists
			$sp = Get-NTNXStoragePool
			
			Write-Host "Storage pool exists with ID: " $sp[0].id
			
			if (!$sp) {
			
				# No Storage Pool exists
				return
			}
			
			$results = $(New-NTNXContainer -Name $name -StoragePoolId $sp[0].id -ReplicationFactor $rf -CompressionEnabled $compress -FingerPrintOnWrite $fingerprinting $(if ($diskDedupEnabled -eq "true") {"-OnDiskDedup"}))
				
		}
  	}
  	end{
    	write-host "Return results"
    	return $results
  	}
}