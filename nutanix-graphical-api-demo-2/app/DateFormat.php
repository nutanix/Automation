<?php namespace DigitalFormula;

use Illuminate\Database\Eloquent\Model;

class DateFormat extends Model {

	protected $guarded = array( 'id' );

	public static function allFormatsRaw()
	{
		return(
		DB::table( 'date_formats' )
			->orderBy( 'date_formats.id', 'asc' )
		);
	}
	/* allFormatsRaw */

	public static function getDateFormats()
	{
		return( DateFormat::orderBy( 'id', 'asc' )->lists( 'description', 'format' ) );
	}
	/* getDateFormats */

}
