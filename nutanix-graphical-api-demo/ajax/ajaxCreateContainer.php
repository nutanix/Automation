<?php

require '../vendor/autoload.php';

/**
 * Check to see if a container name is already taken
 *
 * @param $containerName
 * @return bool
 */
function containerExists( $client, $containerName )
{

	$containers = $client->get( '/PrismGateway/services/rest/v1/containers/' )->json();

	if ( $containers[ 'metadata' ][ 'grandTotalEntities' ] == 0 ) {
		return false;
	}

	if ( $containers[ 'metadata' ][ 'grandTotalEntities' ] > 0 ) {
		foreach ( $containers[ 'entities' ] as $container ) {
			if ( $container[ 'name' ] == $containerName ) {
				return true;
			}
		}
		return false;
	}
}

try {

	$client = new \DigitalFormula\ApiRequest\ApiRequest(
		$_POST[ 'cluster-username' ],
		$_POST[ 'cluster-password' ],
		$_POST[ 'cvm-address' ],
		$_POST[ 'cluster-port' ],
		$_POST[ 'cluster-timeout' ]
	);

	$storage_pools = $client->get( '/PrismGateway/services/rest/v1/storage_pools/' )->json();

	$spId = '';
	if ( $storage_pools[ 'metadata' ][ 'grandTotalEntities' ] > 0 ) {

		/* A storage pool has been found - we can carry on */
		$spId = $storage_pools[ 'entities' ][ 0 ][ 'id' ];

		if ( !containerExists( $client, $_POST[ 'container-name' ] ) ) {

			$parameters = [
				'name' => $_POST[ 'container-name' ],
				'storagePoolId' => $spId
			];

			$response = $client->post( '/PrismGateway/services/rest/v1/containers/', $parameters );

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