<?php

/* pData class definition */
class pData
{
    var $Data;
    var $DataDescription;

    function __construct()
    {
        $this->Data                           = "";
        $this->DataDescription                = "";
        $this->DataDescription["Position"]    = "Name";
        $this->DataDescription["Format"]["X"] = "number";
        $this->DataDescription["Format"]["Y"] = "number";
        $this->DataDescription["Unit"]["X"]   = NULL;
        $this->DataDescription["Unit"]["Y"]   = NULL;
    }

    function ImportFromCSV($FileName,$Delimiter=",",$DataColumns=-1,$HasHeader=FALSE,$DataName=-1)
    {
        $handle = @fopen($FileName,"r");
        if ($handle)
        {
            $HeaderParsed = FALSE;
            while (!feof($handle))
            {
                $buffer = fgets($handle, 4096);
                $buffer = str_replace(chr(10),"",$buffer);
                $buffer = str_replace(chr(13),"",$buffer);
                $Values = split($Delimiter,$buffer);

                if ( $buffer != "" )
                {
                    if ( $HasHeader == TRUE && $HeaderParsed == FALSE )
                    {
                        if ( $DataColumns == -1 )
                        {
                            $ID = 1;
                            foreach($Values as $key => $Value)
                            { $this->SetSerieName($Value,"Serie".$ID); $ID++; }
                        }
                        else
                        {
                            $SerieName = "";

                            foreach($DataColumns as $key => $Value)
                                $this->SetSerieName($Values[$Value],"Serie".$Value);
                        }
                        $HeaderParsed = TRUE;
                    }
                    else
                    {
                        if ( $DataColumns == -1 )
                        {
                            $ID = 1;
                            foreach($Values as $key => $Value)
                            { $this->AddPoint(intval($Value),"Serie".$ID); $ID++; }
                        }
                        else
                        {
                            $SerieName = "";
                            if ( $DataName != -1 )
                                $SerieName = $Values[$DataName];

                            foreach($DataColumns as $key => $Value)
                                $this->AddPoint($Values[$Value],"Serie".$Value,$SerieName);
                        }
                    }
                }
            }
            fclose($handle);
        }
    }

    function AddPoint($Value,$Serie="Serie1",$Description="")
    {
        if (is_array($Value) && count($Value) == 1)
            $Value = $Value[0];

        $ID = 0;
        for($i=0;$i<=count($this->Data);$i++)
        { if(isset($this->Data[$i][$Serie])) { $ID = $i+1; } }

        if ( count($Value) == 1 )
        {
            $this->Data[$ID][$Serie] = $Value;
            if ( $Description != "" )
                $this->Data[$ID]["Name"] = $Description;
            elseif (!isset($this->Data[$ID]["Name"]))
                $this->Data[$ID]["Name"] = $ID;
        }
        else
        {
            foreach($Value as $key => $Val)
            {
                $this->Data[$ID][$Serie] = $Val;
                if (!isset($this->Data[$ID]["Name"]))
                    $this->Data[$ID]["Name"] = $ID;
                $ID++;
            }
        }
    }

    function AddSerie($SerieName="Serie1")
    {
        if ( !isset($this->DataDescription["Values"]) )
        {
            $this->DataDescription["Values"][] = $SerieName;
        }
        else
        {
            $Found = FALSE;
            foreach($this->DataDescription["Values"] as $key => $Value )
                if ( $Value == $SerieName ) { $Found = TRUE; }

            if ( !$Found )
                $this->DataDescription["Values"][] = $SerieName;
        }
    }

    function AddAllSeries()
    {
        unset($this->DataDescription["Values"]);

        if ( isset($this->Data[0]) )
        {
            foreach($this->Data[0] as $Key => $Value)
            {
                if ( $Key != "Name" )
                    $this->DataDescription["Values"][] = $Key;
            }
        }
    }

    function RemoveSerie($SerieName="Serie1")
    {
        if ( !isset($this->DataDescription["Values"]) )
            return(0);

        $Found = FALSE;
        foreach($this->DataDescription["Values"] as $key => $Value )
        {
            if ( $Value == $SerieName )
                unset($this->DataDescription["Values"][$key]);
        }
    }

    function SetAbsciseLabelSerie($SerieName = "Name")
    {
        $this->DataDescription["Position"] = $SerieName;
    }

    function SetSerieName($Name,$SerieName="Serie1")
    {
        $this->DataDescription["Description"][$SerieName] = $Name;
    }

    function SetXAxisName($Name="X Axis")
    {
        $this->DataDescription["Axis"]["X"] = $Name;
    }

    function SetYAxisName($Name="Y Axis")
    {
        $this->DataDescription["Axis"]["Y"] = $Name;
    }

    function SetXAxisFormat($Format="number")
    {
        $this->DataDescription["Format"]["X"] = $Format;
    }

    function SetYAxisFormat($Format="number")
    {
        $this->DataDescription["Format"]["Y"] = $Format;
    }

    function SetXAxisUnit($Unit="")
    {
        $this->DataDescription["Unit"]["X"] = $Unit;
    }

    function SetYAxisUnit($Unit="")
    {
        $this->DataDescription["Unit"]["Y"] = $Unit;
    }

    function SetSerieSymbol($Name,$Symbol)
    {
        $this->DataDescription["Symbol"][$Name] = $Symbol;
    }

    function removeSerieName($SerieName)
    {
        if ( isset($this->DataDescription["Description"][$SerieName]) )
            unset($this->DataDescription["Description"][$SerieName]);
    }

    function removeAllSeries()
    {
        foreach($this->DataDescription["Values"] as $Key => $Value)
            unset($this->DataDescription["Values"][$Key]);
    }

    function GetData()
    {
        return($this->Data);
    }

    function GetDataDescription()
    {
        return($this->DataDescription);
    }
}