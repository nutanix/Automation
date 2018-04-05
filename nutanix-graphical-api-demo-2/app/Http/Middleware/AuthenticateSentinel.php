<?php namespace DigitalFormula\Http\Middleware;

use Closure;
use Sentinel;
use Session;
use Request;

class AuthenticateSentinel
{

    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request $request
     * @param  \Closure $next
     * @return mixed
     */
    public function handle( $request, Closure $next )
    {
        if ( Sentinel::guest() ) {
            if ( $request->ajax() ) {
                return response( 'Unauthorized.', 401 );
            }
            else {
                flash()->error( 'This page requires authentication.  Please enter your credentials to continue.');
                return redirect()->guest( 'auth/login' );
            }
        }

        Session::put( 'back_to', Request::url() );

        return $next( $request );
    }

}
