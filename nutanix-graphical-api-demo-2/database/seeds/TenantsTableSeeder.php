<?php

use Illuminate\Database\Seeder;
use DigitalFormula\Tenant;

class TenantsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $prefix = Config::get( 'database.connections.mysql.prefix' );
        DB::table( 'tenants' )->truncate();

        $tenants = array(
            array( 'name' => 'The Main Customer', 'annotation' => 'The single main customer that exists in this environment' )
        );

        foreach ( $tenants as $tenant ) {
            Tenant::create( array( 'name' => $tenant[ 'name' ], 'annotation' => $tenant[ 'annotation' ], 'slug' => slugify( $tenant[ 'name' ] ) ) );
            Log::info( 'DB seed successful', array( 'type' => 'Tenant', 'detail' => $tenant[ 'name' ] ) );
        }
    }
}
