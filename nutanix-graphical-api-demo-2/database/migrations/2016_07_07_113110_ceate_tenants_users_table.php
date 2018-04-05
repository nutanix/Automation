<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CeateTenantsUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        \Schema::create( 'tenants_users', function( $table )
        {
            $table->integer( 'user_id' )->unsigned();
            $table->integer( 'tenant_id' )->unsigned();
            $table->nullableTimestamps();
            $table->engine = 'InnoDB';
            $table->primary(['user_id', 'tenant_id']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop( 'tenants_users' );
    }
}
