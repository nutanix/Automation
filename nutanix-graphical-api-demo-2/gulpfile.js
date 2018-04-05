var elixir = require('laravel-elixir');

/*
 |--------------------------------------------------------------------------
 | Elixir Asset Management
 |--------------------------------------------------------------------------
 |
 | Elixir provides a clean, fluent API for defining some basic Gulp tasks
 | for your Laravel application. By default, we are compiling the Sass
 | file for our application, as well as publishing vendor resources.
 |
 */

elixir(function(mix) {

    elixir.config.sourcemaps = false;

    mix.sass( [
       'resources/assets/sass/master.scss',
    ], 'resources/assets/sass/compiled' );

    mix.styles( [
        'resources/assets/sass/compiled/app.css',
        'resources/assets/sass/vendor/bootstrap.min.css',
        'resources/assets/sass/vendor/font-awesome/font-awesome.css',
        'resources/assets/sass/vendor/smoothness/jquery-ui-1.10.1.custom.css',
        'resources/assets/sass/overrides/bootstrap.css',
    ], 'public/css/api_demos.css', 'resources/assets/sass' );

    mix.scripts( [
        'resources/assets/js/vendor/jquery-2.1.3.js',
        'resources/assets/js/vendor/jquery-ui.js',
        'resources/assets/js/vendor/bootstrap.js',
        'resources/assets/js/vendor/classie.js',
        'resources/assets/js/vendor/modernizr.custom.js',
        'resources/assets/js/vendor/run_prettify.js',
        'resources/assets/js/script.js'
    ], 'public/js/api_demos.js', 'resources/assets/js' );

    mix.version( [
        'public/css/api_demos.css',
        'public/js/api_demos.js'
    ])

});