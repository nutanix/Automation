<?php

namespace DigitalFormula\Http\Controllers;

use Illuminate\Http\Request;
use GuzzleHttp;
use Sentinel;
use Log;

use DigitalFormula\Http\Requests;

class AjaxController extends Controller
{

	var $user;

	public function __construct()
	{
		$this->user = Sentinel::getUser();
	}

	/**
	 * Perform an AJAX POST request
	 * In this case, it's an API GET request to read cluster info
	 */
	public function postReadDemo() {

		try {

			$client = new \DigitalFormula\ApiRequest\ApiRequest(
				$_POST[ 'cluster-username' ],
				$_POST[ 'cluster-password' ],
				$_POST[ 'cvm-address' ],
				$_POST[ 'cluster-port' ],
				$_POST[ 'cluster-timeout' ],
				// '/PrismGateway/services/rest/v1',
				'/api/nutanix/v2.0',
				'GET',
				'v2.0'
			);

			/* get the response data in JSON format */
			// $containerInfo = $client->get( '/PrismGateway/services/rest/v1/containers/' )->json();
			$containerInfo = $client->get( '/api/nutanix/v2.0/storage_containers/' )->json();

			$containers = array();
			foreach ( $containerInfo[ 'entities' ] as $container ) {
				$containers[] = [
					'name' => $container[ 'name' ],
					'replicationFactor' => $container[ 'replication_factor' ],
					'compressionEnabled' => $container[ 'compression_enabled' ],
					'compressionDelay' => $container[ 'compression_delay_in_secs' ],
					'fingerprintOnWrite' => $container[ 'finger_print_on_write' ] == 'on' ? true : false,
					'onDiskDedup' => $container[ 'on_disk_dedup' ] == 'OFF' ? true : false,
				];
			}

			/* get the response data in JSON format */
			// $clusterInfo = $client->get( '/PrismGateway/services/rest/v1/cluster/' )->json();
			$clusterInfo = $client->get( '/api/nutanix/v2.0/cluster/' )->json();

			/* get some storage info so we can draw some graphs */
			$storage_info = [
				'ssd_used' => $clusterInfo[ 'usage_stats' ][ 'storage_tier.ssd.usage_bytes' ],
				'ssd_free' => $clusterInfo[ 'usage_stats' ][ 'storage_tier.ssd.free_bytes' ],
				'ssd_capacity' => $clusterInfo[ 'usage_stats' ][ 'storage_tier.ssd.capacity_bytes' ],
				'hdd_used' => $clusterInfo[ 'usage_stats' ][ 'storage_tier.das-sata.usage_bytes' ],
				'hdd_free' => $clusterInfo[ 'usage_stats' ][ 'storage_tier.das-sata.free_bytes' ],
				'hdd_capacity' => $clusterInfo[ 'usage_stats' ][ 'storage_tier.das-sata.capacity_bytes' ],
			];

			/* now that we've got all the info and arranged it nicely, return the JSON-formatted results back from the AJAX request */
			echo( json_encode( array(
				'result' => 'ok',
				'cluster-id' => $clusterInfo[ 'id' ],
				'cluster-name' => $clusterInfo[ 'name' ],
				'cluster-timezone' => $clusterInfo[ 'timezone' ],
				'cluster-numNodes' => $clusterInfo[ 'num_nodes' ],
				'cluster-enableShadowClones' => $clusterInfo[ 'enable_shadow_clones' ] === true ? "Yes" : "No",
				'cluster-blockZeroSn' => $clusterInfo[ 'block_serials' ][ 0 ],
				'cluster-IP' => $clusterInfo[ 'cluster_external_ipaddress' ] != '' ? $clusterInfo[ 'cluster_external_ipaddress' ] : 'No cluster IP configured',
				'cluster-nosVersion' => $clusterInfo[ 'version' ],
				'hypervisorTypes' => $clusterInfo[ 'hypervisor_types' ],
				'cluster-hasSED' => $clusterInfo[ 'has_self_encrypting_drive' ] ? 'Yes' : 'No',
				'cluster-numIOPS' => $clusterInfo[ 'stats' ][ 'num_iops' ] == 0 ? '0 IOPS ... awwww!  :)' : $clusterInfo[ 'stats' ][ 'num_iops' ] . ' IOPS',
				'containers' => $containers,
			) ) );

		}
		catch ( GuzzleHttp\Exception\RequestException $e ) {
			/* can't connect to CVM */
			echo( json_encode( array(
				'result' => 'failed',
				// 'message' => "An error occurred while connecting to the CVM at address $cvm_address.  Sorry about that.  Perhaps check your connection or credentials?"
				'message' => $e->getMessage()
			) ) );
		}
		catch ( Exception $e ) {
			/* something else happened that we weren't prepared for ... */
			echo( json_encode( array(
				'result' => 'failed',
				'message' => $e->getMessage()
				// 'message' => 'An unknown error has occurred.  Sorry about that.  Give it another go shortly.  :)'
			) ) );
		}

	}

	/**
	 * Perform an AJAX POST request
	 * In this case, it's an API GET request to read cluster info
	 */
	public function postReadDemoV3() {

		try {

			$client = new \DigitalFormula\ApiRequest\ApiRequest(
				$_POST[ 'cluster-username' ],
				$_POST[ 'cluster-password' ],
				$_POST[ 'cvm-address' ],
				$_POST[ 'cluster-port' ],
				$_POST[ 'cluster-timeout' ],
				'/api/nutanix/v3/clusters/list',
				'POST',
				'v3'
			);

			$parameters = [
				'kind' => 'cluster',
			    'length' => 10,
			    'offset' => 0,
			    'filter' => ''
			];

			/* get the response data in JSON format */
			$clustersInfo = $client->post( '/api/nutanix/v3/clusters/list', $parameters )->json();

			foreach( $clustersInfo[ 'entities' ] as $cluster ) {
				$clusterUUID = $cluster[ 'metadata' ][ 'uuid' ];
			}

			/* get info about the current cluster */
			$clusterInfo = $client->get( '/api/nutanix/v3/clusters/' . $clusterUUID )->json();

			$clusterName = $clusterInfo[ 'status' ][ 'resources' ][ 'config' ];
            // $clusterName = $clusterInfo[ 'status' ][ 'resources' ][ 'config' ][ 'timezone' ];

//			$containers = array();
//			foreach ( $containerInfo[ 'entities' ] as $container ) {
//				$containers[] = [
//					'name' => $container[ 'name' ],
//					'replicationFactor' => $container[ 'replicationFactor' ],
//					'compressionEnabled' => $container[ 'compressionEnabled' ],
//					'compressionDelay' => $container[ 'compressionDelayInSecs' ],
//					'fingerprintOnWrite' => $container[ 'fingerPrintOnWrite' ] == 'on' ? true : false,
//					'onDiskDedup' => $container[ 'onDiskDedup' ] == 'OFF' ? true : false,
//				];
//			}
//
//			/* get the response data in JSON format */
//			$clusterInfo = $client->get( '/PrismGateway/services/rest/v1/cluster/' )->json();
//
//			/* get some storage info so we can draw some graphs */
//			$storage_info = [
//				'ssd_used' => $clusterInfo[ 'usageStats' ][ 'storage_tier.ssd.usage_bytes' ],
//				'ssd_free' => $clusterInfo[ 'usageStats' ][ 'storage_tier.ssd.free_bytes' ],
//				'ssd_capacity' => $clusterInfo[ 'usageStats' ][ 'storage_tier.ssd.capacity_bytes' ],
//				'hdd_used' => $clusterInfo[ 'usageStats' ][ 'storage_tier.das-sata.usage_bytes' ],
//				'hdd_free' => $clusterInfo[ 'usageStats' ][ 'storage_tier.das-sata.free_bytes' ],
//				'hdd_capacity' => $clusterInfo[ 'usageStats' ][ 'storage_tier.das-sata.capacity_bytes' ],
//			];

			/* now that we've got all the info and arranged it nicely, return the JSON-formatted results back from the AJAX request */
			echo( json_encode( array(
				'result' => 'ok',
				'cluster-name' => $clusterName
//				'cluster-timezone' => $clusterInfo[ 'timezone' ],
//				'cluster-numNodes' => $clusterInfo[ 'numNodes' ],
//				'cluster-enableShadowClones' => $clusterInfo[ 'enableShadowClones' ] === true ? "Yes" : "No",
//				'cluster-blockZeroSn' => $clusterInfo[ 'blockSerials' ][ 0 ],
//				'cluster-IP' => $clusterInfo[ 'clusterExternalIPAddress' ] != '' ? $clusterInfo[ 'clusterExternalIPAddress' ] : 'No cluster IP configured',
//				'cluster-nosVersion' => $clusterInfo[ 'version' ],
//				'hypervisorTypes' => $clusterInfo[ 'hypervisorTypes' ],
//				'cluster-hasSED' => $clusterInfo[ 'hasSelfEncryptingDrive' ] ? 'Yes' : 'No',
//				'cluster-numIOPS' => $clusterInfo[ 'stats' ][ 'num_iops' ] == 0 ? '0 IOPS ... awwww!  :)' : $clusterInfo[ 'stats' ][ 'num_iops' ] . ' IOPS',
//				'containers' => $containers,
			) ) );

		}
		catch ( GuzzleHttp\Exception\RequestException $e ) {
			/* can't connect to CVM */
			echo( json_encode( array(
				'result' => 'failed',
				// 'message' => "An error occurred while connecting to the CVM at address $cvm_address.  Sorry about that.  Perhaps check your connection or credentials?"
				'message' => $e->getMessage()
			) ) );
		}
		catch ( Exception $e ) {
			/* something else happened that we weren't prepared for ... */
			echo( json_encode( array(
				'result' => 'failed',
				'message' => $e->getMessage()
				// 'message' => 'An unknown error has occurred.  Sorry about that.  Give it another go shortly.  :)'
			) ) );
		}

	}

	/**
	 * Perform an AJAX POST request
	 * In this case, it's an API POST request to create a Nutanix container
	 */
	public function postContainerDemo() {

		try {

			$client = new \DigitalFormula\ApiRequest\ApiRequest(
				$_POST[ 'cluster-username' ],
				$_POST[ 'cluster-password' ],
				$_POST[ 'cvm-address' ],
				$_POST[ 'cluster-port' ],
				$_POST[ 'cluster-timeout' ],
				// '/PrismGateway/services/rest/v1',
				'/api/nutanix/v2.0',
				'GET',
				'v2.0'
			);

			$storage_pools = $client->get( '/PrismGateway/services/rest/v1/storage_pools/' )->json();

			$spId = '';
			if ( $storage_pools[ 'metadata' ][ 'grandTotalEntities' ] > 0 ) {

				/* A storage pool has been found - we can carry on */
				$spId = $storage_pools[ 'entities' ][ 0 ][ 'id' ];

				if ( !$this->container_exists( $client, $_POST[ 'container-name' ] ) ) {

					$parameters = [
						'name' => $_POST[ 'container-name' ],
						'storagePoolId' => $spId
					];

					// $response = $client->post( '/PrismGateway/services/rest/v1/containers/', $parameters );
					$response = $client->post( '/api/nutanix/v2.0/storage_containers/', $parameters );

					/* return a successful result */
					echo( json_encode( array(
						'result' => 'ok',
					) ) );

				}
				else {
					echo( json_encode( array(
						'result' => 'failed',
						'message' => 'That container name is already in use.&nbsp;&nbsp;Please specify a different container name, then try again.'
					) ) );
				}

			}
			else {
				echo( json_encode( array(
					'result' => 'failed',
					'message' => "No storage pools were found in this cluster.&nbsp;&nbsp;:(&nbsp;&nbsp;Please create at least one storage pool, then try again."
				) ) );
			}

		}
		catch ( GuzzleHttp\Exception\RequestException $e ) {
			/* can't connect to CVM */
			echo( json_encode( array(
				'result' => 'failed',
				// 'message' => $e->getMessage()
				'message' => "An error occurred while creating the container.  Please confirm that you can connect to the CVM at address " . $_POST[ 'cvm-address-container' ] . ' and that you have permissions to make cluster changes, then try again.'
			) ) );
		}
		catch ( Exception $e ) {
			/* something else happened that we weren't prepared for ... */
			echo( json_encode( array(
				'result' => 'failed',
				'message' => 'An unknown error has occurred.  Sorry about that.  Give it another go shortly.  :)'
			) ) );
		}

	}

	/**
	 * Perform an AJAX POST request
	 * In this case, it's an API POST request to create an AHV shell VM
	 */
	public function postShellVmDemo() {

		try
		{

			$client = new \DigitalFormula\ApiRequest\ApiRequest(
				$_POST[ 'cluster-username' ],
				$_POST[ 'cluster-password' ],
				$_POST[ 'cvm-address' ],
				$_POST[ 'cluster-port' ],
				$_POST[ 'cluster-timeout' ],
				// '/PrismGateway/services/rest/v1',
				'/api/nutanix/v2.0',
				'GET',
				'v2.0'
			);

			// $containers = $client->get( '/PrismGateway/services/rest/v1/containers' )->json();
			$containers = $client->get( '/api/nutanix/v2.0/storage_containers' )->json();

			$container_uuid = '';
			if( $containers[ 'metadata' ][ 'grand_total_entities' ] > 0 ) {

				/* A container has been found - we can carry on */
				$container_uuid = $containers[ 'entities' ][ 0 ][ 'storage_container_uuid' ];

				if( !$this->vm_exists( $client, $_POST[ 'server-name' ] ) )
				{

					$parameters = [];

					switch( $_POST[ 'server-profile' ] )
					{
						case 'exch':

							$parameters = [
								"description" => "Microsoft Exchange 2013 Mailbox, created by Nutanix API Demo",
								"num_vcpus" => 2,
								"name" => $_POST['server-name'],
								"memory_mb" => 8192,
								"vm_disks" => [
									[
										"is_cdrom" => false,
										"vm_disk_create" => [
											"size" => 128849018880,
											"storage_container_uuid" => $container_uuid
										]
									],
									[
										"is_cdrom" => false,
										"vm_disk_create" => [
											"size" => 536870912000,
											"storage_container_uuid" => $container_uuid
										]
									]
								]
							];

							break;
						case 'dc':

							$parameters = [
								"description" => "Domain Controller, created by Nutanix API Demo",
								"num_vcpus" => 1,
								"name" => $_POST['server-name'],
								"memory_mb" => 2048,
								"vm_disks" => [
									[
										"is_cdrom" => false,
										"vm_disk_create" => [
											"size" => 268435456000,
											"storage_container_uuid" => $container_uuid
										]
									]
								]
							];

							break;
						case 'lamp':

							$parameters = [
								"description" => "Web Server (LAMP), created by Nutanix API Demo",
								"num_vcpus" => 1,
								"name" => $_POST['server-name'],
								"memory_mb" => 4096,
								"vm_disks" => [
									[
										"is_cdrom" => false,
										"vm_disk_create" => [
											"size" => 42949672960,
											"storage_container_uuid" => $container_uuid
										]
									]
								]
							];

							break;
					}

					// $response = $client->post( '/api/nutanix/v0.8/vms/', $parameters );
					$response = $client->post( '/api/nutanix/v2.0/vms/', $parameters );

					/* return a successful result */
					echo(json_encode(array(
						'result' => 'ok',
					)));

				}
				else
				{
					echo( json_encode( array(
						'result' => 'failed',
						'message' => 'That VM name is already in use. Please specify a different VM name, then try again.'
					)));
				}

			}
			else
			{
				echo( json_encode( array(
					'result' => 'failed',
					'message' => "No containers were found in this cluster.&nbsp;&nbsp;:(&nbsp;&nbsp;Please create at least one cluster, then try again."
				)));
			}

		}
		catch ( GuzzleHttp\Exception\RequestException $e )
		{
			/* can't connect to CVM */
			echo( json_encode( array(
				'result' => 'failed',
				'message' => $e->getMessage()
				// 'message' => "An error occurred while creating the VM.&nbsp;&nbsp;Please confirm that you can connect to the CVM at address " . $_POST[ 'cvm-address-container' ] . ' and that you have permissions to make cluster changes, then try again.'
			)));
		}
		catch( Exception $e )
		{
			/* something else happened that we weren't prepared for ... */
			echo( json_encode( array(
				'result' => 'failed',
				'message' => 'An unknown error has occurred.&nbsp;&nbsp;Sorry about that.&nbsp;&nbsp;Give it another go shortly.&nbsp;&nbsp;:)'
			)));
		}

	}

	/**
	 * Perform an AJAX POST request
	 * In this case, it's an API POST request to deploy a complete VM using Cloud-Init
	 */
	public function postDeployVmDemo() {

		try {

			$client = new \DigitalFormula\ApiRequest\ApiRequest(
				$_POST[ 'cluster-username' ],
				$_POST[ 'cluster-password' ],
				$_POST[ 'cvm-address' ],
				'9440',
				3,
				// '/PrismGateway/services/rest/v1',
				'/api/nutanix/v2.0',
				'GET',
				'v2.0'
			);

			// $containers = $client->get( '/PrismGateway/services/rest/v1/containers' )->json();
			$containers = $client->get( '/api/nutanix/v2.0/storage_containers' )->json();

			$container_uuid = '';

			if ( $containers[ 'metadata' ][ 'grand_total_entities' ] > 0 ) {

				/* A container has been found - we can carry on */
				$container_uuid = $containers[ 'entities' ][ 0 ][ 'storage_container_uuid' ];
				
				Log::info( 'Container UUID:' );
				Log::info( $container_uuid );

				if ( !$this->vm_exists( $client, $_POST[ 'server-name-custom' ] ) ) {

					$parameters = [ ];

					$parameters = [
						"description" => "Web Server (LAMP), created by Nutanix API Demo",
						"num_vcpus" => 1,
						"name" => $_POST[ 'server-name-custom' ],
						"memory_mb" => 4096,
						"vm_nics" => [
							[
								"network_uuid" => $_POST[ 'net-uuid' ],
								"request_ip" => true
							]
						],
						"vm_disks" => [
							[
								"is_cdrom" => false,
								"vm_disk_clone" => [
									"disk_address" => [
										"device_bus" => "SCSI",
										"vmdisk_uuid" => $_POST[ 'disk-uuid' ],
										"storage_container_uuid" => $container_uuid
									]
								]
							],
							[
								"is_cdrom" => false,
								"vm_disk_create" => [
									"size" => 128849018880,
									"storage_container_uuid" => $container_uuid
								]
							]
						],
						"vm_customization_config" => [
							"datasource_type" => "Config_Drive_V2",
							"userdata_path" => "adsf:///" . $_POST[ 'container-name' ] . "/web-server.yaml"
						]
					];

					// $response = $client->post( '/PrismGateway/services/rest/v1/vms/', $parameters );
					$response = $client->post( '/api/nutanix/v2.0/vms/', $parameters );

					sleep( 3 );

					/* power on the VM */
					$vm = $this->get_vm( $client, $_POST[ 'server-name-custom' ], 'v2.0' );
					
					$parameters = [
						'logicalTimestamp' => $vm[ 'vm_logical_timestamp' ],
						'uuid' => $vm[ 'uuid' ],
						'transition' => 'ON'
					];

					// $vm = $this->get_vm( $client, $_POST[ 'server-name-custom' ], 'v2.0' );

					// $powerOnResponse = $client->post( '/api/nutanix/v0.8/vms/' . $vm[ 'vmId' ] . '/power_op/on', $parameters );
					$powerOnResponse = $client->post( '/api/nutanix/v2.0/vms/' . $vm[ 'uuid' ] . '/set_power_state', $parameters );

					/* return a successful result */
					echo( json_encode( array(
						'result' => 'ok',
						'message' => $response
					) ) );

				}
				else {
					echo( json_encode( array(
						'result' => 'failed',
						'message' => 'That VM name is already in use. Please specify a different VM name, then try again.'
					) ) );
				}

			}
			else {
				echo( json_encode( array(
					'result' => 'failed',
					'message' => "No containers were found in this cluster.&nbsp;&nbsp;:(&nbsp;&nbsp;Please create at least one cluster, then try again."
				) ) );
			}

		}
		catch ( GuzzleHttp\Exception\RequestException $e ) {
			/* can't connect to CVM */
			echo( json_encode( array(
				'result' => 'failed',
				'message' => $e->getTraceAsString()
				// 'message' => "An error occurred while creating the VM.&nbsp;&nbsp;Please confirm that you can connect to the CVM at address " . $_POST[ 'cvm-address-container' ] . ' and that you have permissions to make cluster changes, then try again.'
			) ) );
		}
		catch ( Exception $e ) {
			/* something else happened that we weren't prepared for ... */
			echo( json_encode( array(
				'result' => 'failed',
				'message' => 'An unknown error has occurred.&nbsp;&nbsp;Sorry about that.&nbsp;&nbsp;Give it another go shortly.&nbsp;&nbsp;:)'
			) ) );
		}

	}

	/**
	 * Perform an AJAX POST request
	 * In this case, it is an API GET request to read cluster details
	 */
	public function postLoadClusterDetails() {

		try {

			$client = new \DigitalFormula\ApiRequest\ApiRequest(
				$_POST[ 'cluster-username' ],
				$_POST[ 'cluster-password' ],
				$_POST[ 'cvm-address' ],
				$_POST[ 'cluster-port' ],
				$_POST[ 'cluster-timeout' ],
				// '/PrismGateway/services/rest/v1',
				'/api/nutanix/v2.0',
				'GET',
				'v2.0'
			);
			
			/* get the response data in JSON format */
			// $containerInfo = $client->get( '/PrismGateway/services/rest/v1/containers/' )->json();
			$containerInfo = $client->get( '/api/nutanix/v2.0/storage_containers/' )->json();

			$containers = array();
			foreach ( $containerInfo[ 'entities' ] as $container ) {
				$containers[] = [
					'name' => $container[ 'name' ],
					'id' => $container[ 'storage_container_uuid' ]
				];
			}

			// $netInfo = $client->get( '/api/nutanix/v0.8/networks' )->json();
			$netInfo = $client->get( '/api/nutanix/v2.0/networks' )->json();

			$networks = array();
			foreach ( $netInfo[ 'entities' ] as $network ) {
				$networks[] = [
					'name' => $network[ 'name' ],
					'vlanId' => $network[ 'vlan_id' ],
					'vlanUuid' => $network[ 'uuid' ]
				];
			}

			/* get the response data in JSON format */
			// $vdInfo = $client->get( '/PrismGateway/services/rest/v1/virtual_disks/' )->json();
			$vdInfo = $client->get( '/api/nutanix/v2.0/virtual_disks/' )->json();

			$virtual_disks = array();
			foreach ( $vdInfo[ 'entities' ] as $vd ) {
				$virtual_disks[] = [
					'uuid' => $vd[ 'uuid' ],
					'vm_name' => $vd[ 'attached_vmname' ] != null ? $vd[ 'attached_vmname' ] : '&middot;&nbsp;Acropolis Image&nbsp;&middot;'
				];
			}

			/* now that we've got all the info and arranged it nicely, return the JSON-formatted results back from the AJAX request */
			echo( json_encode( array(
				'result' => 'ok',
				'containers' => $containers,
				'virtual_disks' => $virtual_disks,
				'networks' => $networks
			) ) );

		}
		catch ( GuzzleHttp\Exception\RequestException $e ) {
			/* can't connect to CVM */
			echo( json_encode( array(
				'result' => 'failed',
				'message' => "An error occurred while connecting to the CVM at address $cvm_address.  Sorry about that.  Perhaps check your connection or credentials?"
				// 'message' => $e->getMessage()
			) ) );
		}
		catch ( Exception $e ) {
			/* something else happened that we weren't prepared for ... */
			echo( json_encode( array(
				'result' => 'failed',
				// 'message' => $e->getMessage()
				'message' => 'An unknown error has occurred.  Sorry about that.  Give it another go shortly.  :)'
			) ) );
		}

	}

	/**
	 * Perform an AJAX POST request
	 * In this case, it is an API GET request to return the raw JSON output from a GET request
	 */
	public function postRawRequest() {

		try {

			$client = new \DigitalFormula\ApiRequest\ApiRequest(
				$_POST[ 'cluster-username' ],
				$_POST[ 'cluster-password' ],
				$_POST[ 'cvm-address' ],
				$_POST[ 'cluster-port' ],
				$_POST[ 'cluster-timeout' ],
				'',
				$_POST[ 'request-type' ],
				'v3'
			);

			$rawJSON = '';

			/* based on the type of request, the request needs to be either GET or POST */
			switch( strtolower( $_POST[ 'request-type' ] ) ) {
				case 'get':
					$rawJSON = $client->get( $_POST[ 'api-object' ] )->json();
					break;
				case 'post':
					/* get the requested parameters, if any have been specified */
					$parameters = $_POST[ 'api-parameters' ];
					// $parameters = json_encode( [ 'kind' => 'cluster', 'length' => 10, 'offset' => 0, 'filter' => '' ] );
					/* send the request */
					$rawJSON = $client->post( $_POST[ 'api-object' ], $parameters, false )->json();
					break;
			}

			// $rawJSON = $client->post( $_POST[ 'api-object' ], json_encode( [ 'kind' => 'cluster', 'length' => 10, 'offset' => 0, 'filter' => '' ] ) )->json();

			/* now that we've got all the info and arranged it nicely, return the JSON-formatted results back from the AJAX request */
			echo( json_encode( array(
				'result' => 'ok',
				'json' => $rawJSON,
			) ) );

		}
		catch ( GuzzleHttp\Exception\RequestException $e ) {
			/* can't connect to CVM */
			echo( json_encode( array(
				'result' => 'failed',
				// 'message' => "An error occurred while connecting to the CVM at address $cvm_address.  Sorry about that.  Perhaps check your connection or credentials?"
				'message' => $e->getMessage()
			) ) );
		}
		catch ( Exception $e ) {
			/* something else happened that we weren't prepared for ... */
			echo( json_encode( array(
				'result' => 'failed',
				'message' => $e->getMessage()
				// 'message' => 'An unknown error has occurred.  Sorry about that.  Give it another go shortly.  :)'
			) ) );
		}

	}

	/**
	 *
	 * Check to see if a specified container exists
	 *
	 * @param $client
	 * @param $containerName
	 * @return bool
	 */
	private static function container_exists( $client, $containerName ) {
		// $containers = $client->get( '/PrismGateway/services/rest/v1/containers/' )->json();
		$containers = $client->get( '/api/nutanix/v2.0/storage_containers/' )->json();

		if ( $containers[ 'metadata' ][ 'grand_total_entities' ] == 0 ) {
			return false;
		}

		if ( $containers[ 'metadata' ][ 'grand_total_entities' ] > 0 ) {
			foreach ( $containers[ 'entities' ] as $container ) {
				if ( $container[ 'name' ] == $containerName ) {
					return true;
				}
			}
			return false;
		}
	}

	/**
	 * Check to see if a VM name is already taken
	 *
	 * @param $client
	 * @param $vmName
	 * @return bool
	 */
	private static function vm_exists($client, $vmName )
	{

		// $vms = $client->get( '/PrismGateway/services/rest/v1/vms' )->json();
		$vms = $client->get( '/api/nutanix/v2.0/vms' )->json();

		if( $vms[ 'metadata' ][ 'grand_total_entities' ] > 0 )
		{
			foreach( $vms[ 'entities' ] as $vm )
			{
				if( $vm[ 'name' ] == $vmName )
				{
					return true;
				}
			}
			return false;
		}
	}

	/**
	 * Get all properties for an existing VM, or return null if the VM doesn't exist
	 *
	 * @param $client
	 * @param $vmName
	 * @param $apiVersion
	 * @return null
	 */
	private static function get_vm( $client, $vmName, $apiVersion = 'v2.0' )
	{

		switch( $apiVersion ) {
			case 'v2.0':
				$apiPath = '/api/nutanix/v2.0/vms';
				break;
			case 'v1':
				$apiPath = '/PrismGateway/services/rest/v1/vms';
				break;
			case 'v0.8':
				$apiPath = '/api/nutanix/v0.8/vms';
				break;
			default:
				return null;
		}

		$vms = $client->get( $apiPath )->json();
		
		Log::info( 'VMs:' );
		Log::info( json_encode( $vms['metadata'] ) );

		if ( $vms[ 'metadata' ][ 'grand_total_entities' ] > 0 ) {
			foreach ( $vms[ 'entities' ] as $vm ) {
				switch( $apiVersion ) {
					case 'v2.0':
						if ( $vm[ 'name' ] == $vmName ) {
							return $vm;
						}
						break;
					case 'v1':
						if ( $vm[ 'vmName' ] == $vmName ) {
							return $vm;
						}
						break;
					case 'v0.8':
						if ( $vm[ 'config' ][ 'name' ] == $vmName ) {
							return $vm;
						}
						break;
				}
			}
			return null;
		}
		else {
			return null;
		}

	}

}
