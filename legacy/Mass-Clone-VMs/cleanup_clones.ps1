param([Parameter(Mandatory=$True)][String]$vcenter, [String] $base_clone = "Win7-View-Gold", [Int] $clone_count = 400, [bool] $vaai = $true)
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vcenter
Write-Host "Cleaning up after test run"
Write-Host "Powering off $clone_count VMs"
Stop-VM -RunAsync -Confirm:$false "Windows7-bootstorm-*" | Out-Null
Write-Host "Deleting $clone_count VMs"
Remove-VM -RunAsync -Confirm:$false -DeletePermanently:$true "Windows7-bootstorm-*" | Out-Null
Write-Host "Cleanup complete"