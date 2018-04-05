<?php

require '../vendor/autoload.php';

try {

	$client = new \DigitalFormula\ApiRequest\ApiRequest(
		$_POST[ 'cluster-username' ],
		$_POST[ 'cluster-password' ],
		$_POST[ 'cvm-address' ],
		$_POST[ 'cluster-port' ],
		$_POST[ 'cluster-timeout' ]
	);

	/* get the response data in JSON format */
	$containerInfo = $client->get( '/PrismGateway/services/rest/v1/containers/' )->json();

	$containers = array();
	foreach ( $containerInfo[ 'entities' ] as $container ) {
		$containers[] = [
			'name' => $container[ 'name' ],
			'replicationFactor' => $container[ 'replicationFactor' ],
			'compressionEnabled' => $container[ 'compressionEnabled' ],
			'compressionDelay' => $container[ 'compressionDelayInSecs' ],
			'compressionSpaceSaved' => \DigitalFormula\Formatting\Text::humanReadableFileSize( $container[ 'compressionSpaceSaved' ] ),
			'fingerprintOnWrite' => $container[ 'fingerPrintOnWrite' ] == 'on' ? true : false,
			'onDiskDedup' => $container[ 'onDiskDedup' ] == 'OFF' ? true : false,
		];
	}

	/* get the response data in JSON format */
	$clusterInfo = $client->get( '/PrismGateway/services/rest/v1/cluster/' )->json();

	/* get some storage info so we can draw some graphs */
	$storage_info = [
		'ssd_used' => $clusterInfo[ 'usageStats' ][ 'storage_tier.ssd.usage_bytes' ],
		'ssd_free' => $clusterInfo[ 'usageStats' ][ 'storage_tier.ssd.free_bytes' ],
		'ssd_capacity' => $clusterInfo[ 'usageStats' ][ 'storage_tier.ssd.capacity_bytes' ],
		'hdd_used' => $clusterInfo[ 'usageStats' ][ 'storage_tier.das-sata.usage_bytes' ],
		'hdd_free' => $clusterInfo[ 'usageStats' ][ 'storage_tier.das-sata.free_bytes' ],
		'hdd_capacity' => $clusterInfo[ 'usageStats' ][ 'storage_tier.das-sata.capacity_bytes' ],
	];

	/* now that we've got all the info and arranged it nicely, return the JSON-formatted results back from the AJAX request */
	echo( json_encode( array(
		'result' => 'ok',
		'cluster-id' => $clusterInfo[ 'id' ],
		'cluster-name' => $clusterInfo[ 'name' ],
		'cluster-timezone' => $clusterInfo[ 'timezone' ],
		'cluster-numNodes' => $clusterInfo[ 'numNodes' ],
		'cluster-enableShadowClones' => $clusterInfo[ 'enableShadowClones' ] === true ? "Yes" : "No",
		'cluster-blockZeroSn' => $clusterInfo[ 'blockSerials' ][ 0 ],
		'cluster-IP' => $clusterInfo[ 'clusterExternalIPAddress' ] != '' ? $clusterInfo[ 'clusterExternalIPAddress' ] : 'No cluster IP configured',
		'cluster-nosVersion' => $clusterInfo[ 'version' ],
		'hypervisorTypes' => $clusterInfo[ 'hypervisorTypes' ],
		'cluster-hasSED' => $clusterInfo[ 'hasSelfEncryptingDrive' ] ? 'Yes' : 'No',
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