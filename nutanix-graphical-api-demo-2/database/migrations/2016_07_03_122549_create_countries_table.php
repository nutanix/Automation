<?php

use Illuminate\Database\Migrations\Migration;

class CreateCountriesTable extends Migration {

    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        \Schema::create( 'countries', function( $table )
        {
            $table->increments( 'id' );
            $table->string( 'name' );
            $table->string( 'slug' );
            $table->text( 'currency', 3 );
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
        Schema::drop( 'countries' );
    }

}