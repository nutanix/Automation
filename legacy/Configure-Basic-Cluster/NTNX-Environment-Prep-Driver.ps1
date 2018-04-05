############################################################
##
## Script: Configure basic Nutanix cluster using
##		NTNX-Environment-Prep function
## Author: Steven Poitras
## Description: Configure basic Nutanix cluster using
##		NTNX-Environment-Prep function
## Language: PowerCLI
##
############################################################
# PARAMS

# Array structure
#Storage Pool: @(SERVER,TYPE,NAME)
#Container: @(SERVER,TYPE,NAME,RF,COMP,COMP_DELAY,FINGERPRINT,DISKDEDUP)
$environmentArray = @(
	@("10.3.140.67","SP","sp1"),
	@("10.3.140.67","CTR","77CTR-COMP-01",2,$true,600,'NONE',$false),
	@("10.3.140.67","CTR","77CTR-CCACHE-01",2,$false,$null,'ON',$false),
	@("10.3.140.67","CTR","77CTR-DDUP-01",2,$false,$null,'ON',$true)
)

# Validate connection to cluster, if not connect
if ($(Get-NTNXCluster -Servers $server).length -eq 0) { #No Connection
	Write-Host "Connection doesn't exist"
	
	if ($user -eq $null) { # Use defaults
		$user = "admin"
		$password = "admin"
	}
			
	# Create connection
	Connect-NutanixCluster -Server $server -UserName $user -Password $password -AcceptInvalidSSLCerts
} else {
	Write-Host "Connection exists"
}

$environmentArray | %{
	$l_Arr = $_
	$f_server = $l_Arr[0]
	$f_type = $l_Arr[1]
	$f_name = $l_Arr[2]
	$f_rf = $l_Arr[3]
	$f_comp = $l_Arr[4]
	$f_compDelay = $l_Arr[5]
	$f_fingerprinting = $l_Arr[6]
	$f_diskDedup = $l_Arr[7]
	
	if ($f_type -eq "SP") {
		NTNX-Prep-Environment -server $f_server -type $f_type -name $f_name 
	}
	
	elseif ($f_type -eq "CTR"){
		if ($f_comp) {
			NTNX-Prep-Environment -server $f_server -type $f_type -name $f_name -rf $f_rf -compress -compressionDelay $f_compDelay
		} elseif ($f_fingerprinting) {
			if ($f_diskDedup) {
				NTNX-Prep-Environment -server $f_server -type $f_type -name $f_name -rf $f_rf -fingerprinting $f_fingerprinting -OnDiskDedup
			} else {
				NTNX-Prep-Environment -server $f_server -type $f_type -name $f_name -rf $f_rf -fingerprinting $f_fingerprinting
			}
		}
	}
	
	else {
		#Wrong type specified
	}
}