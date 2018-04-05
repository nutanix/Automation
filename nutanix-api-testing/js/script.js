function textEntered( inputElement )
{
    return( $( inputElement ).val() != '' );
}

function showDialog( dialogElement )
{
    $( dialogElement ).dialog({
        resizable: false,
        height:220,
        width: 420,
        modal: true
    })
}

function getSerializedForm( formElement )
{
    return( $( formElement ).serialize() );
}

$( '#api_go' ).on( 'click', function(e) {
    if( textEntered( '#cluster_ip' ) && textEntered( '#cluster_username' ) && textEntered( '#cluster_password' ) && textEntered( '#api_top_level_object' ) )
    {

        /* Submit the request via AJAX */
        request = $.ajax({
            url: "/ajax/execute-api-call.php",
            type: "post",
            dataType: "json",
            data: getSerializedForm( '#api-form' )
        });

        request.success( function(data) {
            if( data.result == 'ok' )
            {
                dump = JSON.stringify( data.json, null, 4 );
                $( '#api_output' ).html( '<pre class="prettyprint">' + dump + '</pre>' );
            }
            else
            {
                $( '#api_output' ).html( '<div class="alert alert-danger">An unknown error occurred while processing this request.  Please check your input, then try again.</div>' );
            }
        });

        request.done(function (response, textStatus, jqXHR){
            /* nothing here, yet ... maybe later */
        });

        request.fail(function ( jqXHR, textStatus, errorThrown )
        {
            /* Display an error message */
            $( '#api_output' ).html( '<div class="alert alert-danger">An error occurred while processing this request.<br><br>Status: ' + textStatus + '<br>Error: ' + errorThrown + '</div>' );
        });

        e.preventDefault();

    }
    else
    {
        showDialog( "#dialog_missing_info" );
    }
    e.preventDefault();
});
