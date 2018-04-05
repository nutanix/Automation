<?php namespace DigitalFormula\Providers;

use DateTime;
use Illuminate\Support\ServiceProvider;
use DigitalFormula\ErrorLog;
use Log;
use Queue;

class LogServiceProvider extends ServiceProvider {

	/**
	 * Bootstrap the application services.
	 *
	 * @return void
	 */
	public function boot()
	{
		// Log to the database asynchronously
		Log::listen( function( $level, $message, $context ) {

			// Save the php sapi and date, because the closure needs to be serialized
			$apiName = php_sapi_name();
			$date = new DateTime;

			Queue::push( function() use ( $level, $message, $context, $apiName, $date ) {
				ErrorLog::create(
					array	(
						'php_sapi_name' => $apiName,
						'level' => $level,
						'message' => $message,
						'context' => json_encode( $context )
					)
				);
			});

		});
	}

	/**
	 * Register the application services.
	 *
	 * @return void
	 */
	public function register()
	{
		//
	}

}
