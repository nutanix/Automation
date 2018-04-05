<?php

/**
 * Information about the current API request
 *
 * Class apiRequest
 */
class apiRequest
{

	/**
	 * The username to use during the connection
	 */
	var $username;

	/**
	 * The password to use during the connection
	 */
	var $password;

	/**
	 * The path for the actual API request
	 */
	var $requestPath;

	/**
	 * The IP address of the CVM
	 */
	var $cvmAddress;

	/**
	 * The port to connect on
	 */
	var $cvmPort;

	/**
	 * The timeout period i.e. how long to wait before the request is considered failed
	 */
	var $connectionTimeout;

	/**
	 * Is this a GET or POST request?
	 */
	var $method;

	/**
	 * @param string $username
	 * @param string $password
	 * @param $requestPath
	 * @param $cvmAddress
	 * @param string $cvmPort
	 * @param int $connectionTimeout
	 * @param string $method
	 */
	public function __construct( $username, $password, $cvmAddress, $cvmPort = '9440', $connectionTimeout = 3, $requestPath, $method = 'GET' )
	{
		$this->username = $username;
		$this->password = $password;
		$this->requestPath = $requestPath;
		$this->cvmAddress = $cvmAddress;
		$this->cvmPort = $cvmPort;
		$this->connectionTimeout = $connectionTimeout;
		$this->method = $method;
	}

	/**
	 * Process an API request
	 * Supports both GET and POST requests
	 *
	 * @param $parameters
	 * @param $method
	 * @return mixed
	 */
	public function doAPIRequest( $parameters, $method )
	{

		$client = new GuzzleHttp\Client();

		$request = $client->createRequest(
			$method,
			sprintf( "https://%s:%s%s",
				$this->cvmAddress,
				$this->cvmPort,
				$this->requestPath
			),
			[
				'config' => [
					'curl' => [
						CURLOPT_HTTPAUTH => CURLAUTH_BASIC,
						CURLOPT_USERPWD => $this->username . ':' . $this->password,
						CURLOPT_SSL_VERIFYHOST => false,
						CURLOPT_SSL_VERIFYPEER => false
					],
					'verify' => false,
					'timeout' => $this->connectionTimeout,
					'connect_timeout' => $this->connectionTimeout,
				],
				'headers' => [
					"Accept" => "application/json",
					"Content-Type" => "application/json"
				],
				'body' => json_encode( $parameters )
			]
		);

		$response = $client->send($request);

		/* return the response data in JSON format */
		return( $response->json() );

	}

}