<?php namespace DigitalFormula\Providers;

use Illuminate\Support\ServiceProvider;
use View;

class ComposerServiceProvider extends ServiceProvider {

	/**
	 * Bootstrap the application services.
	 *
	 * @return void
	 */
	public function boot()
	{
		//
	}

	/**
	 * Register the application services.
	 *
	 * @return void
	 */
	public function register()
	{
		View::composers( [
			'DigitalFormula\Http\ViewComposers\HomeComposer' => [ 'home.index' ],
		] );
	}

}
