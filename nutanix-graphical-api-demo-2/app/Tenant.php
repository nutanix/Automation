<?php

namespace DigitalFormula;

use Illuminate\Database\Eloquent\Model;

class Tenant extends Model
{
    protected $fillable = [
        'name',
        'slug',
        'annotation',
    ];

    public function user() {
        return $this->hasMany( 'DigitalFormula\User' );
    }
}
