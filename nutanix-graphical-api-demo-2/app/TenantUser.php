<?php

namespace DigitalFormula;

use Illuminate\Database\Eloquent\Model;

class TenantUser extends Model
{
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable
        = [
            'user_id',
            'tenant_id',
        ];

    /**
     * The database table used by the model.
     *
     * @var string
     */
    protected $table = 'tenants_users';
}
