<?php namespace DigitalFormula\Http\ViewComposers;

use Illuminate\Contracts\View\View;
// use DigitalFormula\Country;
// use DigitalFormula\DateFormat;
use Sentinel;
use Config;
use Lang;

class HomeComposer
{

	/**
	 * Information about the current logged in user
	 *
	 * @var
	 */
	protected $user;

	/**
	 * Create a new profile composer.
	 *
	 */
	public function __construct()
	{
		$this->user = Sentinel::getUser();
	}

	/**
	 * Bind data to the view.
	 *
	 * @param  View $view
	 * @return void
	 */
	public function compose( View $view )
	{
		$view->with( 'data', [
			'tenants' => $this->user->tenants()
		] );
	}

}