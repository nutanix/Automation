/**
 * Nutanix Java SDK Test Example
 * 
 * @author Vamsi Krishna
 * @author Andre Leibovici
 * @version 1.0
 */
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.net.ssl.TrustManager;

import org.apache.cxf.common.util.Base64Utility;
import org.apache.cxf.configuration.jsse.TLSClientParameters;
import org.apache.cxf.jaxrs.client.Client;
import org.apache.cxf.jaxrs.client.JAXRSClientFactory;
import org.apache.cxf.jaxrs.client.WebClient;
import org.apache.cxf.transport.http.HTTPConduit;
import org.apache.cxf.transports.http.configuration.HTTPClientPolicy;
import org.codehaus.jackson.jaxrs.JacksonJsonProvider;

import com.nutanix.prism.dto.alerts.AlertDTO;
import com.nutanix.prism.dto.appliance.configuration.ContainerDTO;
import com.nutanix.prism.dto.appliance.configuration.DiskDTO;
import com.nutanix.prism.dto.appliance.configuration.ManagementServerDTO;
import com.nutanix.prism.dto.appliance.configuration.NodeDTO;
import com.nutanix.prism.dto.dr.AddVMsToPdRequestDTO;
import com.nutanix.prism.dto.dr.ProtectionDomainDTO;
import com.nutanix.prism.dto.health.check.HealthStatus;
import com.nutanix.prism.dto.stats.VMDTO;
import com.nutanix.prism.exception.alerts.AlertsAdministrationException;
import com.nutanix.prism.exception.appliance.configuration.ContainerAdministrationException;
import com.nutanix.prism.exception.appliance.configuration.DiskAdministrationException;
import com.nutanix.prism.exception.appliance.configuration.HostAdministrationException;
import com.nutanix.prism.exception.appliance.configuration.ManagementServerAdministrationException;
import com.nutanix.prism.exception.dr.BackupAndDrAdministrationException;
import com.nutanix.prism.exception.vmmanagement.VMAdministrationException;
import com.nutanix.prism.services.alerts.AlertsAdministration;
import com.nutanix.prism.services.appliance.configuration.ContainerAdministration;
import com.nutanix.prism.services.appliance.configuration.DiskAdministration;
import com.nutanix.prism.services.appliance.configuration.HostAdministration;
import com.nutanix.prism.services.appliance.configuration.ManagementServerAdministration;
import com.nutanix.prism.services.dr.BackupAndDrAdministration;
import com.nutanix.prism.services.vmmanagement.VMAdministration;

/**
 * @author andreleibovici
 * @version $Revision: 1.0 $
 */
public final class ServerConnectionsManager implements Cloneable {

	/**
	 * Field USERNAME
	 */
	private String username = null;

	/**
	 * Field PASSWORD
	 */
	private String password = null;

	/**
	 * Field SERVER
	 */
	private String serverhost = null;

	/**
	 * Field REST_BASE_PATH. (value is
	 * ""https://{0}:9440/PrismGateway/services/rest/v1"")
	 */
	public static final String REST_BASE_PATH = "https://{0}:9440/PrismGateway/services/rest/v1";

	/**
	 * Field DEFAULT_CONNECTION_TIMEOUT.
	 */
	public static final int DEFAULT_CONNECTION_TIMEOUT = 10 * 1000; // 10 secs

	/**
	 * Field DEFAULT_INVOCATION_TIMEOUT.
	 */
	public static final int DEFAULT_INVOCATION_TIMEOUT = 180 * 1000; // 3 min

	/**
	 * Field ServerConnectionsManager.
	 */
	private static ServerConnectionsManager ServerConnectionsManager;

	/**
	 * for testing purpose only, do not use
	 * 
	 * @param mock
	 *            the mock object
	 */
	public static void setServerConnectionManager(ServerConnectionsManager mock) {
		ServerConnectionsManager = mock;
	}

	/**
	 * Method getInstance.
	 * 
	 * @return ServerConnectionsManager
	 **/
	public static synchronized ServerConnectionsManager getInstance() {
		if (null == ServerConnectionsManager) {
			ServerConnectionsManager = new ServerConnectionsManager();
		}
		return ServerConnectionsManager;
	}

	/**
	 * Method getRestService.
	 * 
	 * @param server
	 *            String
	 * @param username
	 *            String
	 * @param password
	 *            String
	 * @param classType
	 *            Class<T>
	 * 
	 * @return T
	 */
	private <T> T getRestService(final String server, final String username,
			final String password, final Class<T> classType) {
		if (null == server) {
			return null;
		}

		final String url = MessageFormat.format(REST_BASE_PATH, server);

		final List<Object> providers = new ArrayList<Object>();
		providers.add(new JacksonJsonProvider());

		final T proxy = JAXRSClientFactory.create(url, classType, providers);
		final Client client = WebClient.client(proxy);

		final String encodedCredential = Base64Utility.encode(String.format(
				"%s:%s", username, password).getBytes());
		final String authorizationHeader = String.format("Basic %s",
				encodedCredential);
		client.header("Authorization", authorizationHeader);
		configureHttpConduit(WebClient.getConfig(client).getHttpConduit());

		return proxy;
	}

	/**
	 * Method getDiskAdminRef
	 * 
	 * @return DiskAdministration
	 */
	private DiskAdministration getDiskAdminRef() {
		return getRestService(serverhost, username, password,
				DiskAdministration.class);
	}

	/**
	 * Method getHostAdminRef.
	 * 
	 * @return HostAdministration
	 */
	private HostAdministration getHostAdminRef() {
		return getRestService(serverhost, username, password,
				HostAdministration.class);
	}

	/**
	 * Method getContainerAdminRef
	 * 
	 * @return ContainerAdministration
	 */
	private ContainerAdministration getContainerAdminRef() {
		return getRestService(serverhost, username, password,
				ContainerAdministration.class);
	}

	/**
	 * Method getManagementServerAdminRef
	 * 
	 * @return ManagementServerAdministration
	 */
	private ManagementServerAdministration getManagementServerAdminRef() {
		return getRestService(serverhost, username, password,
				ManagementServerAdministration.class);
	}

	/**
	 * 
	 * @return VMAdministration
	 */
	private VMAdministration getVMAdministration() {
		return getRestService(serverhost, username, password,
				VMAdministration.class);
	}

	/**
	 * 
	 * @return BackupAndDrAdministration
	 */
	private BackupAndDrAdministration getBackupAndDrAdministration() {
		return getRestService(serverhost, username, password,
				BackupAndDrAdministration.class);
	}

	/**
	 * 
	 * @return AlertService
	 */
	private AlertsAdministration getAlertService() {
		return getRestService(serverhost, username, password,
				AlertsAdministration.class);
	}

	/**
	 * Method getAlerts
	 * 
	 * @param count
	 * @param resolved
	 * @param acknowledged
	 * @param connMgr
	 * @return Iterator<AlertDTO>
	 * @throws AlertsAdministrationException
	 */
	public Iterator<AlertDTO> getAlerts(int count, boolean resolved,
			boolean acknowledged, ServerConnectionsManager connMgr)
			throws AlertsAdministrationException {
		final AlertsAdministration ref = connMgr.getAlertService();
		final List<AlertDTO> alerts = ref.getAlerts(null, null, count,
				resolved, acknowledged).getEntities();
		final Iterator<AlertDTO> iteratorAlerts = alerts.iterator();
		return iteratorAlerts;
	}

	/**
	 * Method getDisks
	 * 
	 * @param connMgr
	 * @return Iterator<DiskDTO>
	 * @throws DiskAdministrationException
	 */
	public Iterator<DiskDTO> getDisks(ServerConnectionsManager connMgr)
			throws DiskAdministrationException {
		final DiskAdministration ref = connMgr.getDiskAdminRef();
		final Collection<DiskDTO> disks = ref.getDisks(null, null, null)
				.getEntities();
		final Iterator<DiskDTO> iteratorDisks = disks.iterator();
		return iteratorDisks;
	}

	/**
	 * Method getHosts
	 * 
	 * @param connMgr
	 * @return Iterator<NodeDTO>
	 * @throws HostAdministrationException
	 */
	public Iterator<NodeDTO> getHosts(ServerConnectionsManager connMgr)
			throws HostAdministrationException {
		final HostAdministration ref1 = connMgr.getHostAdminRef();
		final List<NodeDTO> hosts = ref1.getHosts(null, null, null)
				.getEntities();
		final Iterator<NodeDTO> iteratorHosts = hosts.iterator();
		return iteratorHosts;
	}

	/**
	 * Method getHostsHealthCheckSummary
	 * 
	 * @param connMgr
	 * @return Map<HealthStatus, Integer>
	 * @throws HostAdministrationException
	 */
	@SuppressWarnings("unused")
	private Map<HealthStatus, Integer> getHostsHealthSummary(
			final ServerConnectionsManager connMgr)
			throws HostAdministrationException {
		final HostAdministration ref1 = connMgr.getHostAdminRef();
		final Map<HealthStatus, Integer> healthSummary = ref1
				.getHealthCheckSummaryForHosts(null, false).getHealthSummary();
		return healthSummary;
	}

	/**
	 * Method getProtectionDomainsHealthSummary
	 * 
	 * @param connMgr
	 * @return healthSummary
	 * @throws BackupAndDrAdministrationException
	 */
	@SuppressWarnings("unused")
	private Map<HealthStatus, Integer> getProtectionDomainsHealthSummary(
			final ServerConnectionsManager connMgr)
			throws BackupAndDrAdministrationException {
		final BackupAndDrAdministration ref = connMgr
				.getBackupAndDrAdministration();
		final Map<HealthStatus, Integer> healthSummary = ref
				.getHealthCheckSummaryForProtectionDomains(null, false)
				.getHealthSummary();
		return healthSummary;
	}

	/**
	 * Method getContainers
	 * 
	 * @param connMgr
	 * @return Iterator<ContainerDTO>
	 * @throws ContainerAdministrationException
	 */
	public Iterator<ContainerDTO> getContainers(ServerConnectionsManager connMgr)
			throws ContainerAdministrationException {
		final ContainerAdministration ref2 = connMgr.getContainerAdminRef();
		final List<ContainerDTO> containers = ref2.getContainers(null, null,
				null).getEntities();
		final Iterator<ContainerDTO> iteratorContainers = containers.iterator();
		return iteratorContainers;
	}

	/**
	 * Method getManagementServers
	 * 
	 * @param connMgr
	 * @return Iterator<ManagementServerDTO>
	 * @throws ManagementServerAdministrationException
	 */
	public Iterator<ManagementServerDTO> getManagementServers(
			ServerConnectionsManager connMgr)
			throws ManagementServerAdministrationException {
		final ManagementServerAdministration ref3 = connMgr
				.getManagementServerAdminRef();
		final List<ManagementServerDTO> managementServers = ref3
				.getManagementServers(null);
		final Iterator<ManagementServerDTO> iteratorManagementServers = managementServers
				.iterator();
		return iteratorManagementServers;
	}

	/**
	 * Method getVMs
	 * 
	 * @param connMgr
	 * @return Iterator<VMDTO>
	 * @throws VMAdministrationException
	 */
	public Iterator<VMDTO> getVMs(ServerConnectionsManager connMgr)
			throws VMAdministrationException {
		final VMAdministration ref4 = connMgr.getVMAdministration();
		final List<VMDTO> vms = ref4.getVMs(null, null, null).getEntities();
		final Iterator<VMDTO> iteratorVms = vms.iterator();
		return iteratorVms;
	}

	/**
	 * Method getProtectionDomains
	 * 
	 * @param connMgr
	 * @return Iterator<ProtectionDomainDTO>
	 * @throws BackupAndDrAdministrationException
	 */
	public Iterator<ProtectionDomainDTO> getProtectionDomains(
			ServerConnectionsManager connMgr)
			throws BackupAndDrAdministrationException {
		final BackupAndDrAdministration bcdr = connMgr
				.getBackupAndDrAdministration();
		final List<ProtectionDomainDTO> backupAndDrAdministration = bcdr
				.getProtectionDomains(null, true);
		final Iterator<ProtectionDomainDTO> iteratorBackupAndDrAdministration = backupAndDrAdministration
				.iterator();
		return iteratorBackupAndDrAdministration;
	}

	/**
	 * Method addVMstoProtectionDomain
	 * 
	 * @param vMs
	 * @param protectionDomain
	 * @param setAppConsistentSnapshots
	 * @param setConsistencyGroupName
	 * @param setIgnoreDupOrMissingVms
	 * @param connMgr
	 * @throws BackupAndDrAdministrationException
	 */
	public void addVMstoProtectionDomain(String vMs[], String protectionDomain,
			Boolean setAppConsistentSnapshots, String setConsistencyGroupName,
			Boolean setIgnoreDupOrMissingVms, ServerConnectionsManager connMgr)
			throws BackupAndDrAdministrationException {
		final List<String> list = Arrays.asList(vMs);
		final AddVMsToPdRequestDTO vMsToPd = new AddVMsToPdRequestDTO();
		vMsToPd.setNames(list);
		vMsToPd.setAppConsistentSnapshots(setAppConsistentSnapshots);
		vMsToPd.setConsistencyGroupName(setConsistencyGroupName);
		vMsToPd.setIgnoreDupOrMissingVms(setIgnoreDupOrMissingVms);
		final com.nutanix.prism.services.dr.BackupAndDrAdministration bcdr = connMgr
				.getBackupAndDrAdministration();
		bcdr.addVmsByNamesToProtectionDomain(protectionDomain, vMsToPd);
	}

	/**
	 * Method removeVmsFromProtectionDomain
	 * 
	 * @param vMs
	 * @param protectionDomain
	 * @param connMgr
	 * @throws BackupAndDrAdministrationException
	 */
	public void removeVmsFromProtectionDomain(String vMs[],
			String protectionDomain, ServerConnectionsManager connMgr)
			throws BackupAndDrAdministrationException {
		final List<String> list = Arrays.asList(vMs);
		final com.nutanix.prism.services.dr.BackupAndDrAdministration bcdr = connMgr
				.getBackupAndDrAdministration();
		bcdr.removeVmsFromProtectionDomain(protectionDomain, list);
	}

	/**
	 * Method configureHttpConduit.
	 * 
	 * @param conduit
	 *            HTTPConduit
	 */
	private void configureHttpConduit(final HTTPConduit conduit) {
		// TLS Client parameters
		final TLSClientParameters tlsClientParameters = new TLSClientParameters();
		// Disable common name check on certificate.
		tlsClientParameters.setDisableCNCheck(true);
		// Create a trust manager that does not validate any certificate chains.
		tlsClientParameters
				.setTrustManagers(new TrustManager[] { new NullTrustManager() });
		conduit.setTlsClientParameters(tlsClientParameters);

		final HTTPClientPolicy httpClientPolicy = new HTTPClientPolicy();
		httpClientPolicy.setConnectionTimeout(DEFAULT_CONNECTION_TIMEOUT);
		httpClientPolicy.setReceiveTimeout(DEFAULT_INVOCATION_TIMEOUT);
		conduit.setClient(httpClientPolicy);
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

	/**
	 * Method getUSERNAME.
	 * 
	 * @return String
	 */
	public String getUSERNAME() {
		return username;
	}

	/**
	 * Method setUSERNAME.
	 * 
	 * @param uSERNAME
	 *            String
	 */
	public void setUSERNAME(String uSERNAME) {
		username = uSERNAME;
	}

	/**
	 * Method getPASSWORD.
	 * 
	 * @return String
	 */
	public String getPASSWORD() {
		return password;
	}

	/**
	 * Method setPASSWORD.
	 * 
	 * @param pASSWORD
	 *            String
	 */
	public void setPASSWORD(String pASSWORD) {
		password = pASSWORD;
	}

	/**
	 * Method getSERVER.
	 * 
	 * @return String
	 */
	public String getSERVER() {
		return serverhost;
	}

	/**
	 * Method setSERVER.
	 * 
	 * @param sERVER
	 *            String
	 */
	public void setSERVER(String sERVER) {
		serverhost = sERVER;
	}

}
