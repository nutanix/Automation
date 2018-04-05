<?php

use Illuminate\Database\Seeder;
use DigitalFormula\TenantUser;

class TenantsUsersTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $tenantUser = TenantUser::create( [
            'user_id' => 1,
            'tenant_id' => 1,
        ] );
    }
}
