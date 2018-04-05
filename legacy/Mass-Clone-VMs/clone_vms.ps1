param( [Parameter(Mandatory=$True)][String]$vcenter, [Parameter(Mandatory=$True)][String]$cluster, [String] $base_clone = "Win7-View-Gold", [Int] $clone_count = 400, [bool] $vaai = $true, [bool] $wait_for_ips = $false)
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vcenter

$cluster = Get-Cluster | where {
$_.name -eq $cluster}
$hosts = Get-VMHost -Location $cluster
$source_vm = Get-VM -Location $cluster | where {
$_.name -like $base_clone } | Get-View
$clone_folder = $source_vm.parent
$clone_spec = new-object Vmware.Vim.VirtualMachineCloneSpec
$clone_spec.Location = new-object Vmware.Vim.VirtualMachineRelocateSpec
$clone_spec.Location.Transform = [Vmware.Vim.VirtualMachineRelocateTransformation]::flat
if ($vaai) {
    Write-Host "Cloning VM $base_clone using VAAI."
    $clone_spec.Location.DiskMoveType = [Vmware.Vim.VirtualMachineRelocateDiskMoveOptions]::moveAllDiskBackingsAndAllowSharing
}else {
    Write-Host "Cloning VM $base_clone without VAAI."
    $clone_spec.Location.DiskMoveType = [Vmware.Vim.VirtualMachineRelocateDiskMoveOptions]::createNewChildDiskBacking
    $clone_spec.Snapshot = $source_vm.Snapshot.CurrentSnapshot
}

Write-Host "Creating $clone_count VMs from VM: $base_clone"

# Create VMs.
$global:creation_start_time = Get-Date
for($i=1; $i -le $clone_count; $i++){
    $clone_name = "Windows7-bootstorm-$i"
    $clone_spec.Location.host = $hosts[$i % $hosts.count].Id
    $source_vm.CloneVM_Task( $clone_folder, $clone_name, $clone_spec ) | Out-Null
}

# Wait for all VMs to finish being cloned.
$VMs = Get-VM -Location $cluster -Name "Windows7-bootstorm-*"
while($VMs.count -lt $clone_count){
    $count = $VMs.count
    Write-Host "Waiting for VMs to finish creation. Only $count have been created so far..."
    Start-Sleep -s 5
    $VMs = Get-VM -Location $cluster -Name "Windows7-bootstorm-*"
}

Write-Host "Powering on VMs"
# Power on newly created VMs.
$global:power_on_start_time = Get-Date
Start-VM -RunAsync "Windows7-bootstorm-*" | Out-Null

$booted_clones = New-Object System.Collections.ArrayList
#$waiting_clones = New-Object System.Collections.ArrayList
while($booted_clones.count -lt $clone_count){
    # Wait until all VMs are booted.
    $clones = Get-VM -Location $cluster -Name "Windows7-bootstorm-*"
    foreach ($clone in $clones){
        if((-not $booted_clones.contains($clone.Name)) -and ($clone.PowerState -eq "PoweredOn")){
            if($wait_for_ips){
                $ip = $clone.Guest.IPAddress[0]
                if ($ip){
                    Write-Host "$clone.Name started with ip: $ip"
                    $booted_clones.add($clone.Name)
                }
            }
            else{
                $booted_clones.add($clone.Name)
            }
        }
    }
}

$global:total_runtime = $(Get-Date) - $global:creation_start_time
$global:power_on_runtime = $(Get-Date) - $global:power_on_start_time

Write-Host "Total time elapsed to boot $clone_count VMs: $global:power_on_runtime"
Write-Host "Total time elapsed to clone and boot $clone_count VMs: $global:total_runtime"
<span style="font-family: Consolas, Monaco, monospace;">