<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateDateFormatsTable extends Migration {

    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create( 'date_formats', function( $table )
        {
            $table->engine = 'InnoDB';
            $table->increments( 'id' );
            $table->string( 'format', 20 );
            $table->string( 'description', 100 );
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop( 'date_formats' );
    }

}
