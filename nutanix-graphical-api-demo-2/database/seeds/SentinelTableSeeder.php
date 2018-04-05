<?php

use Illuminate\Database\Seeder;

class SentinelTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $role = \Sentinel::getRoleRepository()->createModel()->create( [
            'name' => 'Administrator',
            'slug' => 'administrator',
        ] );

        $role = \Sentinel::getRoleRepository()->createModel()->create( [
            'name' => 'Standard',
            'slug' => 'standard',
        ] );

        $role = \Sentinel::getRoleRepository()->createModel()->create( [
            'name' => 'Premium',
            'slug' => 'premium',
        ] );

        $role              = \Sentinel::findRoleBySlug( 'administrator' );
        $role->permissions = [
            'site.administrator' => true,
            'account.premium' => false,
            'account.standard' => false,
        ];
        $role->save();

        $role              = \Sentinel::findRoleBySlug( 'premium' );
        $role->permissions = [
            'site.administrator' => false,
            'account.premium' => true,
            'account.standard' => false,
        ];
        $role->save();

        $role              = \Sentinel::findRoleBySlug( 'standard' );
        $role->permissions = [
            'site.administrator' => false,
            'account.premium' => false,
            'account.standard' => true,
        ];
        $role->save();

        $user = \Sentinel::registerAndActivate( [
            'first_name' => 'Jane',
            'last_name' => 'Johns',
            'email' => 'no-reply@acme.com',
            'address_country' => 'au',
            'password' => 'password',
        ] );

        $role = \Sentinel::findRoleByName( 'Administrator' );
        $role->users()->attach( $user );

        Log::info( 'Default user created', array( 'type' => 'User', 'detail' => 'no-reply@acme.com' ) );

    }
}
