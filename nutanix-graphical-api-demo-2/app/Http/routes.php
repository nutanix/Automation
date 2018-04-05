<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
|
*/

Route::get( '/', [ 'as' => 'home_path', 'uses' => 'HomeController@index' ] );

Route::get( 'auth/login', [ 'as' => 'login_path', 'uses' => 'AuthController@getLogin', 'middleware' => 'guest.sentry' ] );
Route::get( 'auth/logout', [ 'as' => 'logout_path', 'uses' => 'AuthController@getLogout' ] );

Route::controller( 'home', 'HomeController' );
Route::controller( 'ajax', 'AjaxController' );
Route::controller( 'auth', 'AuthController' );