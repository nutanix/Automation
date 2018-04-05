<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $this->call( 'DateFormatTableSeeder' );
        $this->call( 'CountryTableSeeder' );
        $this->call( 'SentinelTableSeeder' );
        $this->call( 'TenantsTableSeeder' );
        $this->call( 'TenantsUsersTableSeeder' );
    }
}
