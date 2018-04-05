############################################################
##
## Script: Produce Nutanix PD Report
## Author: Steven Poitras
## Description: Produce Nutanix PD Report
## Language: PowerShell
##
############################################################
function NTNX-PD-Report {
    <#
    .NAME
    NTNX-PD-Report
    .SYNOPSIS
    This function does generated a report for Protection Domains
    .DESCRIPTION
    This function does generated a report for Protection Domains
    .NOTES
    Authors: The Dude
    .LINK
    www.nutanix.com
    .EXAMPLE
    NTNX-PD-Report -Clusters $clusters -OutputCSVLocation "X:\TESTING\" -CSVPrefix "testReport"
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
        
        # Create array to store results data
        $results = @()
        
        # Connect to each cluster
        $Clusters | %{
            $server = $_[0]
            $user = $_[1]
            $password = $_[2]
            
            Write-Host "Connecting to $server"
            Connect-NutanixCluster -Server $server -UserName $user -Password $password -AcceptInvalidSSLCerts
            
        }
        
        # Get list of VMs excluding Nutanix CVMs and vDisk objects
        $pds = Get-NTNXProtectionDomain
        $cgs = Get-NTNXProtectionDomainConsistencyGroup
        #$remoteSites = Get-NTNXRemoteSite
        
        Write-Host "Found $pds.length Protection Domains and $remoteSites.length Remote Sites"
        
        if ($CSVPrefix -eq $null) {
            $CSVPrefix = "Report"
        }
        
        $fOutputCSV = "$OutputCSVLocation$CSVPrefix-$(Get-Date -Format Hmm-M-d-yy).csv"
        
    }
    PROCESS {
        $pds | %{
            # For each PD
            $l_pd = $_
            $pdName = $l_pd.name
            [Decimal]$pdSize = [Math]::Round($l_pd.totalUserWrittenBytes / 1GB,3)
            
            Write-Progress -Activity "Getting stats for" `
                           -Status "PD $pdName" -PercentComplete (($pds.IndexOf($l_pd) / $pds.Length) * 100)
            
            $($cgs | where {
            $_.protectionDomainName -match $pdName}) | %{
                $l_cg = $_
                $cgName = $l_cg.consistencyGroupName
                $appConsistent = $l_cg.appConsistentSnapshots
                $vmCount = $l_cg.vmCount
                $fileCount = $l_cg.totalFileCount
                $cgSize = [Math]::Round($l_cg.totalFileSizeBytes / 1GB,3)
                
                $results += New-Object PSCustomObject -Property @{
                    PD_Name = $pdName
                    State = $(if ($l_pd.active -eq "True"){
                    "ACTIVE"} else {
                    "INACTIVE"})
                    Remote_Sites = $l_pd.remoteSiteNames
                    Next_Snapshot = $l_pd.nextSnapshotTimeUsecs
                    Pending_Replication = $l_pd.pendingReplicationCount
                    Current_Replication = $l_pd.ongoingReplicationCount
                    PD_Size_GB = $pdSize
                    CG_Name = $cgName
                    VM_Count = $vmCount
                    File_Count = $fileCount
                    CG_Size_GB = $cgSize
                }
            }
        }
        
    }
    END {
        # Append/write results to CSV
        Write-Host "Exporting results to CSV: $fOutputCSV"
        $results | Select-Object PD_Name, State, PD_Size_GB, CG_Name, CG_Size_GB, `
        VM_Count, File_Count, RemoteSites, Next_Snapshot,Pending_Replication, Current_Replication | `
        Export-Csv $fOutputCSV -NoTypeInformation -Append -Force
    }
}