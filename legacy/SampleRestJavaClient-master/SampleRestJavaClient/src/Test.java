// $codepro.audit.disable debuggingCode
/**
 * Nutanix Java SDK Test Example
 * 
 * @author Vamsi Krishna
 * @author Andre Leibovici
 * @version 1.0
 */
import java.util.Iterator;

import com.nutanix.prism.dto.alerts.AlertDTO;
import com.nutanix.prism.dto.appliance.configuration.ContainerDTO;
import com.nutanix.prism.dto.appliance.configuration.DiskDTO;
import com.nutanix.prism.dto.appliance.configuration.ManagementServerDTO;
import com.nutanix.prism.dto.appliance.configuration.NodeDTO;
import com.nutanix.prism.dto.dr.ProtectionDomainDTO;
import com.nutanix.prism.dto.stats.VMDTO;
import com.nutanix.prism.exception.alerts.AlertsAdministrationException;
import com.nutanix.prism.exception.appliance.configuration.ContainerAdministrationException;
import com.nutanix.prism.exception.appliance.configuration.DiskAdministrationException;
import com.nutanix.prism.exception.appliance.configuration.HostAdministrationException;
import com.nutanix.prism.exception.appliance.configuration.ManagementServerAdministrationException;
import com.nutanix.prism.exception.dr.BackupAndDrAdministrationException;
import com.nutanix.prism.exception.vmmanagement.VMAdministrationException;

/**
 * @author andreleibovici
 * @version $Revision: 1.0 $
 */
public class Test implements Cloneable {

	/**
	 * @param args
	 * @throws VMAdministrationException
	 * @throws DiskAdministrationException
	 * @throws HostAdministrationException
	 * @throws ContainerAdministrationException
	 * @throws BackupAndDrAdministrationException
	 * @throws ManagementServerAdministrationException
	 * @throws AlertsAdministrationException 
	 * @throws Exception
	 **/
	public static void main(String[] args) throws VMAdministrationException,
			DiskAdministrationException, HostAdministrationException,
			ContainerAdministrationException,
			BackupAndDrAdministrationException,
			ManagementServerAdministrationException, AlertsAdministrationException {

		/*
		 * Stablish connection with PRISM API
		 */
		final ServerConnectionsManager connMgr = ServerConnectionsManager
				.getInstance();
		connMgr.setUSERNAME("admin");
		connMgr.setPASSWORD("admin");
		connMgr.setSERVER("10.20.18.10");
		
		/*
		 * Instantiate PRISM objects
		 */
		final Iterator<VMDTO> iteratorVms = connMgr.getVMs(connMgr);	// VMs
		final Iterator<DiskDTO> iteratorDisks = connMgr.getDisks(connMgr);	// Disks
		final Iterator<NodeDTO> iteratorHosts = connMgr.getHosts(connMgr);	// Hosts
		final Iterator<ContainerDTO> iteratorContainers = connMgr	// Containers
				.getContainers(connMgr);
		final Iterator<ManagementServerDTO> iteratorManagementServers = connMgr	// Management Servers
				.getManagementServers(connMgr);
		final Iterator<ProtectionDomainDTO> iteratorBackupAndDrAdministration = connMgr	// Backup and DR
				.getProtectionDomains(connMgr);
		final Iterator<AlertDTO> iteratorAlerts = connMgr.getAlerts(10, false, false, connMgr); // Alerts

		/*
		 * Retrieve list of virtual machines and properties
		 */
		System.out.println();
		System.out.println("Virtual Machines");
		while (iteratorVms.hasNext()) {
			System.out.println(iteratorVms.next());
		}

		/*
		 * Retrieve list of disks and properties
		 */
		System.out.println();
		System.out.println("Disks");
		while (iteratorDisks.hasNext()) {
			System.out.println(iteratorDisks.next());
		}

		/*
		 * Retrieve list of hosts and properties
		 */
		System.out.println();
		System.out.println("Hosts");
		while (iteratorHosts.hasNext()) {
			System.out.println(iteratorHosts.next());
		}

		/*
		 * Retrieve list of containers and properties
		 */
		System.out.println();
		System.out.println("Containers");
		while (iteratorContainers.hasNext()) {
			System.out.println(iteratorContainers.next());
		}

		/*
		 * Retrieve list of management servers and properties
		 */
		System.out.println();
		System.out.println("Management Servers");
		while (iteratorManagementServers.hasNext()) {
			System.out.println(iteratorManagementServers.next());
		}

		/*
		 * Retrieve list of protection domains and protected vms
		 */
		System.out.println();
		System.out.println("Protection Domains");
		while (iteratorBackupAndDrAdministration.hasNext()) {
			System.out.println(iteratorBackupAndDrAdministration.next());
		}

		/*
		 * Retrieve list of protection domains and protected vms
		 */
		System.out.println();
		System.out.println("Alerts");
		while (iteratorAlerts.hasNext()) {
			System.out.println(iteratorAlerts.next());
		}
		
		/*
		 * Add VMs to Protection Domain
		 */
//		 String VMs[] = new String[] { "vmName" };
//		 connMgr.addVMstoProtectionDomain(VMs, "protectionDomainName", false, null, false,
//		 connMgr);
		
		/*
		 * Remove VMs from Protection Domain
		 */
//		 String VMs[] = new String[] { "vmName" };
//		 connMgr.removeVmsFromProtectionDomain(VMs, "protectionDomainName", connMgr);

	}

	/**
	 * Method toString.
	 * 
	 * @return String
	 */
	@Override
	public String toString() {
		return super.toString();
	}

	/**
	 * Method clone.
	 * 
	 * @return Object
	 * @throws CloneNotSupportedException
	 */
	@Override
	public Object clone() throws CloneNotSupportedException {
		return super.clone();
	}
}
