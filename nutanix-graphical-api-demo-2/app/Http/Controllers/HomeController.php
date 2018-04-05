<?php

namespace DigitalFormula\Http\Controllers;

use Illuminate\Http\Request;
use DigitalFormula\Http\Requests;
use Sentinel;

class HomeController extends Controller
{

    /**
     * Protected variable for information about the current logged-in user
     *
     * @var
     */
    protected $user;

    /**
     * Constructor & ensure the entire controller has the appropriate middleware applied
     *
     */
    public function __construct()
    {
        $this->middleware( 'auth.sentry' );
        $this->user = Sentinel::getUser();
    }

    /**
     * @return \Illuminate\Contracts\View\Factory|\Illuminate\View\View
     */
    public function index()
    {
	    return view( 'home.index' );
    }

}
