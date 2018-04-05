<?php namespace DigitalFormula;

use Illuminate\Database\Eloquent\Model;

class Country extends Model {

	protected $guarded = array( 'id' );

	public static function getCountries()
	{
		return( Country::orderBy( 'name', 'asc' )->lists( 'name', 'slug' ) );
	}
	/* getCountries */

	public static function getCurrencies()
	{
		return( Country::orderBy( 'currency', 'asc' )->distinct()->lists( 'currency', 'currency' ) );
	}
	/* getCurrencies */

	public static function getCurrencyById( $id )
	{
		return( Country::where( 'id', '=', $id )->first()->currency );
	}
	/* getCurrencyById */

	public static function getCurrencyIdByCurrency( $currency )
	{
		return( Country::where( 'currency', '=', $currency )->first()->id );
	}
	/* getCurrencyIdByCurrency */

	public static function getCurrenciesFormatted()
	{
		$currency_list = array();
		foreach( Country::orderBy( 'currency', 'asc' )->get() as $country )
		{
			$currency_list[ $country->id ] = $country[ 'currency' ] . ' (' . $country[ 'name' ] . ')';
		}
		return( $currency_list );
	}
	/* getCurrenciesFormatted */

}
