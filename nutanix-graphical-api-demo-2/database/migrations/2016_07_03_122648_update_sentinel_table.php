<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class UpdateSentinelTable extends Migration
{

    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table( 'users', function ( Blueprint $table ) {
            $table->string( 'address_number' )->nullable();
            $table->string( 'address_street' )->nullable();
            $table->string( 'address_suburb' )->nullable();
            $table->string( 'address_state' )->nullable();
            $table->string( 'address_city' )->nullable();
            $table->string( 'address_postcode' )->nullable();
            $table->string( 'address_country', 2 );
            $table->string( 'phone' )->nullable();
        } );
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table( 'users', function ( Blueprint $table ) {
            $table->dropColumn( 'address_number' );
            $table->dropColumn( 'address_street' );
            $table->dropColumn( 'address_suburb' );
            $table->dropColumn( 'address_state' );
            $table->dropColumn( 'address_city' );
            $table->dropColumn( 'address_postcode' );
            $table->dropColumn( 'address_country' );
            $table->dropColumn( 'phone' );
        } );
    }

}
