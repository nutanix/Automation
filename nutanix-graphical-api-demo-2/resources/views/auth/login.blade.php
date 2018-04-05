@extends( 'layouts.fullscreen' )

@section( 'content' )

    <div class="row">
        <div class="col-md-8 col-md-offset-2">
            <div class="panel panel-default">
                <div class="panel-heading">Login</div>
                <div class="panel-body">

                    {!! Form::open( [ 'class' => 'form-horizontal', 'role' => 'form', 'method' => 'POST' ] ) !!}

                    {!! Form::token() !!}

                    <div class="form-group">
                        <div class="col-md-4">
                            {!! Form::label( 'email', Lang::get( 'ui.email' ) ) !!}
                        </div>
                        <div class="col-md-8">
                            {!! Form::text( 'email', old( 'email' ), array( 'class' => 'form-control' ) ) !!}
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="col-md-4">
                            {!! Form::label( 'password', Lang::get( 'ui.password' ) ) !!}
                        </div>
                        <div class="col-md-8">
                            {!! Form::password( 'password', array( 'class' => 'form-control' ) ) !!}
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="col-md-8 col-md-offset-4">
                            {!! Form::submit( Lang::get( 'ui.login'), [ 'class' => 'btn btn-primary', 'name' => 'submit-button' ] ) !!}
                        </div>
                    </div>

                    {!! Form::close() !!}

                </div>
            </div>
        </div>
    </div>

@endsection