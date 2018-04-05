<?php

function createPieChart( $chart_data, $filename )
{
	$pChart_path = '../libraries/pChart';

	$data_set = new pData;

	$data_set->AddPoint( $chart_data[ 'data' ], "Series1" );
	$data_set->AddPoint( $chart_data[ 'labels' ], "Series2" );
	$data_set->AddAllSeries();
	$data_set->SetAbsciseLabelSerie( "Series2" );

	/* create the graph */
	$chart = new pChart( 500, 200 );
	$chart->loadColorPalette( $pChart_path . "/tones/blue_soft_tones.txt" );
	$chart->setFontProperties( $pChart_path . "/fonts/tahoma.ttf", 8 );
	$chart->drawBasicPieGraph( $data_set->GetData(), $data_set->GetDataDescription(), 120, 100, 70, PIE_PERCENTAGE, 255, 255, 218 );
	$chart->drawPieLegend( 230, 15, $data_set->GetData(), $data_set->GetDataDescription(), 250, 250, 250 );

	return ( $chart->Render( 'charts/' . $filename ) );
}
/* createPieChart */