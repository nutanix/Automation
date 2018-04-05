############################################################
##
## Script: Produce Nutanix vDisk Report
## Author: Steven Poitras
## Description: Produce Nutanix vDisk Report
## Language: PowerShell
##
############################################################
function NTNX-vDisk-Report {
    <#
    .NAME
    NTNX-vDisk-Report
    .SYNOPSIS
    This function creates generated a report per VM/vDisk
    .DESCRIPTION
    This function creates generated a report per VM/vDisk
    .NOTES
    Authors: The Dude
    .LINK
    www.nutanix.com
    .EXAMPLE
    NTNX-vDisk-Report -Clusters $clusters -OutputCSVLocation "X:\TESTING\" -CSVPrefix "testReport"
    #>
    Param(
    
    [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
    [array]$Clusters,
    
    [Parameter(Mandatory=$True)]
    [string]$OutputCSVLocation,
    
    [Parameter(Mandatory=$False)]
    [string]$CSVPrefix
    )
    
    BEGIN {
        # Don't need to get CVM stats
        $cvmPostfix = "-CVM"
        
        # Create array to store results data
        $results = @()
        
        # Connect to each cluster
        $Clusters | %{
            $server = $_[0]
            $user = $_[1]
            $password = $_[2]
            
            Write-Host "Connecting to $server"
            Connect-NutanixCluster -Server $server -UserName $user -Password $(if ($password.GetType().Name -eq "SecureString") `
            {
            ([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)))} `
            else {
            $password}) -AcceptInvalidSSLCerts
            
        }
        
        # Get list of VMs excluding Nutanix CVMs and vDisk objects
        $vms = Get-NTNXVM | where {
        $_.vmName -notmatch $cvmPostfix}
        $vdisks = Get-NTNXVDisk
        
        Write-Host "Found $vms.length VMs and $vdisks.length vDisks"
        
        if ($CSVPrefix -eq $null) {
            $CSVPrefix = "Report"
        }
        
        # Output CSV
        $fOutputCSV = "$OutputCSVLocation$CSVPrefix-$(Get-Date -Format Hmm-M-d-yy).csv"
        
        # Get list of containers
        $containers = Get-NTNXContainer
    }
    PROCESS {
        $vms | %{
            # For each VM
            $l_vm = $_
            $vmName = $l_vm.vmName
            $vDiskNames = $l_vm.vdiskNames
            
            Write-Progress -Activity "Getting stats for" `
                           -Status "VM: $vmName with vDisks: $vDiskNames" -PercentComplete (($vms.IndexOf($l_vm) / $vms.Length) * 100)
            
            $vDiskNames | %{
                # For each vDisk
                $l_vDiskName = $_
                $l_vDisk = $vdisks | where {
                $_.name -match $l_vDiskName}
                
                $l_container = $containers | where {
                $_.id -match $l_vDisk.containerId}
                
                [string]$vDiskName = $l_vDisk.nfsFileName
                [string]$container = $l_vDisk.containerName
                $replicationFactor = $l_container.replicationFactor
                [Double]$usedCap = [Math]::Round($l_vDisk.usedLogicalSizeBytes / 1GB,3)
                [string]$snapshots = $l_vDisk.snapshots
                [string]$pdName = $l_vm.protectionDomainName
                [string]$cgName = $l_vm.consistencyGroupName
                [string]$compression = $l_container.compressionEnabled
                [string]$fingerprint = $(if ($l_vDisk.fingerPrintOnWrite -match "none") {
                "Use container setting"} else {
                $l_vDisk.fingerPrintOnWrite})
                [string]$diskDedup = $(if ($l_vDisk.onDiskDedup -match "none"){
                "Use container setting"} else {
                $l_vDisk.onDiskDedup})
                [string]$conFingerprint = $l_container.fingerPrintOnWrite
                [string]$conDiskDedup = $l_container.onDiskDedup
                
            }
            
            # Add object to results array
            $results += New-Object PSCustomObject -Property @{
                VM_Name = $vmName
                vDisk_Name = $vDiskName
                Container = $container
                Replication_Factor = $replicationFactor
                Used_Capacity_in_GB = $usedCap
                Snapshots = $snapshots
                PD_Name = $pdName
                CG_Name = $cgName
                vDisk_Fingerprinting = $fingerprint
                vDisk_On_Disk_Dedup = $diskDedup
                Container_Compression = $compression
                Container_Fingerprinting = $conFingerprint
                Container_On_Disk_Dedup = $conDiskDedup
            }
            
        }
    }
    END {
        # Append/write results to CSV
        Write-Host "Exporting results to CSV: $fOutputCSV"
        $results | Select-Object VM_Name, vDisk_Name, Container, Replication_Factor, `
        Used_Capacity_in_GB, Container_Compression, Container_Fingerprinting, `
        vDisk_Fingerprinting,vDisk_On_Disk_Dedup, Container_On_Disk_Dedup, `
        PD_Name, CG_Name, Snapshots |
        Export-Csv $fOutputCSV -NoTypeInformation -Append -Force
    }
}