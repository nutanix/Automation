<?php

use Illuminate\Database\Migrations\Migration;

class CreateLogsTable extends Migration {

    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create( 'logs', function( $table )
        {
            $table->engine = 'InnoDB';
            $table->increments( 'id' );
            $table->string( 'php_sapi_name', 255 );
            $table->string( 'level', 255 );
            $table->text( 'message' );
            $table->text( 'context' );
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
        Schema::drop( 'logs' );
    }

}