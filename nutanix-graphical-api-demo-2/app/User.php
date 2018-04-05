<?php namespace DigitalFormula;

use Cartalyst\Sentinel\Users\EloquentUser;
use Config;
use DigitalFormula\TenantUser;
use DigitalFormula\Tenant;

class User extends EloquentUser
{

	/**
	 * The attributes that are mass assignable.
	 *
	 * @var array
	 */
	protected $fillable
		= [
			'email',
			'first_name',
			'last_name',
			'password',
			'address_number',
			'address_street',
			'address_suburb',
			'address_state',
			'address_city',
			'address_postcode',
			'address_country',
			'phone',
			'stripe_id'
		];

	/**
	 * The database table used by the model.
	 *
	 * @var string
	 */
	protected $table = 'users';

	/**
	 * The attributes excluded from the model's JSON form.
	 *
	 * @var array
	 */
	protected $hidden = [ 'password', 'remember_token' ];

	public function __construct()
	{
		parent::__construct();
	}

	/**
	 * Get details about the tenants this user belongs to
	 *
	 * @return array
     */
	public function tenants()
	{
		$tenants_users = TenantUser::where( 'user_id', '=', $this->id )->get();
		$tenant_list = [];
		foreach( $tenants_users as $tenant_user )
		{
			$tenant = Tenant::where( 'id', '=', $tenant_user->tenant_id )->first();
			$tenant_list[] = [
				'id' => $tenant->id,
				'slug' => $tenant->slug,
				'name' => $tenant->name,
				'annotation' => $tenant->annotation
			];
		}
		return $tenant_list;
	}
	
}
