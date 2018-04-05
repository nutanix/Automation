<?php

/**
 * Return the shortened version of a string if it exceeds the specified max length
 *
 * @param $string
 * @param $max
 * @param $length
 * @return string
 */
function shorten( $string, $max = NULL )
{
    if( strlen( $string ) > $max )
    {
        return( substr( $string, 0, $max ) . ' ...' );
    }
    else
    {
        return( $string );
    }
}

/**
 * @param $text
 * @return bool|mixed|string
 */
function slugify( $text )
{
    /* replace non letter or digits by - */
    $text = preg_replace( '~[^\\pL\d]+~u', '-', $text );
    /* trim */
    $text = trim( $text, '-' );
    /* transliterate */
    $text = iconv( 'utf-8', 'us-ascii//TRANSLIT', $text );
    /* lowercase */
    $text = strtolower( $text );
    /* remove unwanted characters */
    $text = preg_replace( '~[^-\w]+~', '', $text );
    if ( empty( $text ) ) {
        return 'n-a';
    }
    return $text;
}

/* slugify */

/**
 * Generate a help section
 *
 * @param $section_name
 * @param int $li_count
 */
function help_section( $section_name, $li_count = 1 )
{
    echo( '<div class="help-wrapper">' );
    echo( '<div class="well well-sm">' );
    echo( '<div class="help-link">&raquo;&nbsp;' . Lang::get( 'ui.help_' . $section_name . '_question', array( 'sitename' => Lang::get( 'headings.sitename' ) ) ) );
    echo( '</div>' );
    echo( '<div class="help">' );
    echo( Lang::get( 'ui.help_' . $section_name . '_top', array( 'sitename' => Lang::get( 'headings.sitename' ) ) ) );
    echo( '<br>' );
    echo( '<ul>' );

    for ( $i = 1; $i <= $li_count; $i++ ) {
        echo( '<li>' . Lang::get( 'ui.help_' . $section_name . '_' . $i, array( 'sitename' => Lang::get( 'headings.sitename' ) ) ) . '</li>' );
    }

    echo( '</ul>' );
    echo( '</div>' );
    echo( '</div>' );
    echo( '</div>' );
}

/**
 * Return an array of month names
 *
 * @return array
 */
function months()
{
    return ( [ '01' => Lang::get( 'forms.january' ), '02' => Lang::get( 'forms.february' ), '03' => Lang::get( 'forms.march' ), '04' => Lang::get( 'forms.april' ), Lang::get( 'forms.may' ) => '05', '06' => Lang::get( 'forms.june' ), '07' => Lang::get( 'forms.july' ), '08' => Lang::get( 'forms.august' ), '09' => Lang::get( 'forms.september' ), '10' => Lang::get( 'forms.october' ), '11' => Lang::get( 'forms.november' ), '12' => Lang::get( 'forms.december' ) ] );
}

/**
 * Return an array of years by number
 */
function years()
{
    $years = [ ];
    for ( $i = \Carbon\Carbon::now()->year; $i <= \Carbon\Carbon::now()->year + 15; $i++ ) {
        $years[ ] = $i;
    }
    return ( $years );
}

/**
 * Build pagination links for the specified object type
 *
 * @param $object
 */
function pagination_links( $object )
{
    echo( '<div style="text-align: center;">Displaying ' . $object . 's ' . $data[ $object ]->toArray()[ "from" ] . ' to ' . $data[ $object ]->toArray()[ 'to' ] . ' of ' . $data[ $object ]->total() . '</div>' );
    echo( '<div style="text-align: center;">' . $data[ $object ]->render() . '</div>' );
}

/**
 * Specify which logo image we're currently using
 *
 * @return string
 */
function logo_image()
{
    return 'logo-2015.04.09.png';
}