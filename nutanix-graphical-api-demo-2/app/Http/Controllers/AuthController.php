<?php

namespace DigitalFormula\Http\Controllers;

use Illuminate\Http\Request;
use DigitalFormula\Http\Requests;
use DigitalFormula\Http\Requests\LoginRequest;
use Session;
use Sentinel;
use Activation;
use Log;
use Lang;

class AuthController extends Controller
{

    /**
     * Show the login form
     *
     * @return \Illuminate\View\View|\View
     */
    public function getLogin()
    {
        return view( 'auth.login' );
    }

    /**
     * Process a login attempt
     */
    public function postLogin( LoginRequest $request )
    {
        $user = Sentinel::findByCredentials( [ 'login' => $request->email ] );

        if ( $user ) {
            $user = Sentinel::findById( $user->id );
            if ( Activation::completed( $user ) ) {
                $userValidation = Sentinel::validateCredentials( $user, [ 'email' => $request[ 'email' ], 'password' => $request[ 'password' ] ] );

                if ( $userValidation ) {
                    Sentinel::login( $user );
                    if( Session::has( 'back_to' ) )
                    {
                        return redirect( Session::get( 'back_to' ) );
                    }
                    else
                    {
                        return redirect( route( 'home_path') );
                    }
                }
                else {
                    return redirect( '/auth/login' )
                        ->withInput( $request->only( 'email', 'remember' ) )
                        ->withErrors( [
                            'email' => Lang::get( 'ui.user_not_found' ),
                        ] );
                }
            }
            else {
                return redirect( '/auth/login' )
                    ->withInput( $request->only( 'email', 'remember' ) )
                    ->withErrors( [
                        'email' => Lang::get( 'ui.user_not_found' ),
                    ] );
            }
        }
        else {
            return redirect( '/auth/login' )
                ->withInput( $request->only( 'email', 'remember' ) )
                ->withErrors( [
                    'email' => Lang::get( 'ui.user_not_found' ),
                ] );
        }
    }

    /**
     * Logout the active user
     */
    public function getLogout()
    {
        Sentinel::logout();
        return redirect( route( 'login_path' ) );
    }

}
