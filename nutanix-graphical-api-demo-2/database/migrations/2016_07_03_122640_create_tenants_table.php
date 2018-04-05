<?php

use Illuminate\Database\Migrations\Migration;

class CreateTenantsTable extends Migration {

    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        \Schema::create( 'tenants', function( $table )
        {
            $table->increments( 'id' );
            $table->string( 'name' );
            $table->string( 'slug' );
            $table->string( 'annotation' );
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
        Schema::drop( 'tenants' );
    }

}