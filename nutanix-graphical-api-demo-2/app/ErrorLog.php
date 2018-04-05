<?php namespace DigitalFormula;

use Illuminate\Database\Eloquent\Model;

class ErrorLog extends Model {

	protected $guarded = array( 'id' );
	protected $table = 'logs';

}
