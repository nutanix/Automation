<?php

use Illuminate\Database\Seeder;
use DigitalFormula\DateFormat;

class DateFormatTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $prefix = Config::get( 'database.connections.mysql.prefix' );
        DB::table( 'date_formats' )->truncate();

        $dateFormats = array(
            array( 'format' => 'Y-m-d', 'description' => 'Y-m-d e.g. 2014-01-01' ),
            array( 'format' => 'd-m-Y', 'description' => 'd-m-Y e.g. 01-01-2014' ),
            array( 'format' => 'm-d-Y', 'description' => 'm-d-Y e.g. 01-01-2014' ),
            array( 'format' => 'Y/m/d', 'description' => 'Y/m/d e.g. 2014/01/01' ),
            array( 'format' => 'd/m/Y', 'description' => 'd/m/Y e.g. 01/01/2014' ),
            array( 'format' => 'm/d/Y', 'description' => 'm/d/Y e.g. 01/01/2014' ),
            array( 'format' => 'M d, Y', 'description' => 'M d, Y e.g. Jan 1, 2014' ),
        );

        foreach ( $dateFormats as $format ) {
            DateFormat::create( array( 'format' => $format[ 'format' ], 'description' => $format[ 'description' ] ) );
            Log::info( 'DB seed successful', array( 'type' => 'Date format', 'detail' => $format[ 'format' ] ) );
        }
    }
}
