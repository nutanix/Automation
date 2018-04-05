@include( 'partials._header' )

<div class="row">
    <div class="col-md-12">
        <div class="container-fluid">
            @include( 'vendor.flash.message' )
            @if ($errors->any())
                <div class="alert alert-danger">
                    <ul>{!! implode('', $errors->all('<li style="color:red">:message</li>')) !!}</ul>
                </div>
            @endif
            @yield( 'content' )
        </div>
    </div>
</div>

@include( 'partials._dialogs' )
@include( 'partials._footer' )