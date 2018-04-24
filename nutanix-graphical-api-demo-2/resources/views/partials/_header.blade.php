<!doctype html>

<html lang="en-us">

<head>
    <meta charset="utf-8">
    <link rel="stylesheet" type="text/css" href="{{ elixir( 'css/api_demos.css' ) }}"/>
    <link href='https://fonts.googleapis.com/css?family=Roboto:700' rel='stylesheet' type='text/css'>
    <link href='https://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>
    <title>Nutanix REST API Demos</title>
</head>

<body style="">

<nav class="navbar navbar-default" role="navigation">
    <div class="container-fluid">
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li class="active"><a href="http://www.nutanix.com" target="_blank" title="Nutanix.com">Nutanix.com</a>
                </li>
                <li><a href="http://www.nutanix.com/resources" target="_blank" title="Nutanix Resources">Nutanix
                        Resources</a></li>
                <li><a href="http://www.nutanix.com/products/features/management-and-analytics/programmatic-interface/"
                       target="_blank" title="" Nutanix REST API">Nutanix REST API</a></li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">What the ... ? <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a id="set-contrast" href="#">Adjust Contrast ;)</a></li>
                    </ul>
                </li>
                @if( Sentinel::check() )
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                       aria-expanded="false">{!! Sentinel::getUser()->email !!}<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li>
                            {{--<a href="#" title="Logout">{!! Sentinel::getUser()->tenant()->first()->name !!}</a> --}}
                            @foreach( $data[ 'tenants' ] as $tenant )
                                <a href="#">{!! $tenant[ 'name' ] !!}</a>
                            @endforeach
                        </li>
                        <li role="separator" class="divider"></li>
                        <li><a href="/auth/logout" title="Logout">Logout</a></li>
                    </ul>
                </li>
                @endif
                <li>
                    @if( Sentinel::check() )
                        <a href="/auth/logout" title="Logout">Logout</a>
                    @endif
                </li>
            </ul>
        </div>
    </div>
</nav>