<?php

require '../vendor/autoload.php';
require '../model/api-request.php';

try
{

	/* get some info about the containers available in the cluster */
	$call = new apiRequest(
		$_POST[ 'cluster_username' ],
		$_POST[ 'cluster_password' ],
		$_POST[ 'cluster_ip' ],
		'9440',
		10,
		'/PrismGateway/services/rest/v1/' . $_POST[ 'api_top_level_object' ]
	);

	$results = $call->doAPIRequest( null, 'GET' );

	/* now that we've got all the info and arranged it nicely, return the JSON-formatted results back from the AJAX request */
	echo( json_encode( array(
		'result' => 'ok',
	    'json' => $results
	) ) );

}
catch ( GuzzleHttp\Exception\RequestException $e )
{
	$cvm_address = $_POST[ 'cluster_ip' ];
	/* can't connect to CVM */
	echo( json_encode( array(
		'result' => 'failed',
		'message' => "An error occurred while connecting to the CVM at address $cvm_address.  Sorry about that.  Perhaps check your connection or credentials?"
	)));
}
catch( Exception $e )
{
	/* something else happened that we weren't prepared for ... */
	echo( json_encode( array(
		'result' => 'failed',
		'message' => 'An unknown error has occurred.  Sorry about that.  Give it another go shortly.  :)'
	)));
}