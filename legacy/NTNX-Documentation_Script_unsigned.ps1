#Requires -Version 3.0
#This File is in Unicode format.  Do not edit in an ASCII editor.

#region Support

<#
.SYNOPSIS
    Creates a complete inventory of a Nutanix configuration using Microsoft Word 2010 or 2013.
.DESCRIPTION
    Creates a complete inventory of a Nutanix Cluster configuration using Microsoft Word and PowerShell.
    Creates an output file named after the Nutanix Cluster Configuration.
    Document includes a Cover Page, Table of Contents and Footer.
    Includes support for the following language versions of Microsoft Word:
        Catalan
        Danish
        Dutch
        English
        Finnish
        French
        German
        Norwegian
        Portuguese
        Spanish
        Swedish
        
    If you find issues with saving the final document or table layout is messed up please use the X86 version of Powershell!

.PARAMETER CompanyName
    Company Name to use for the Cover Page.  
    Default value is contained in HKCU:\Software\Microsoft\Office\Common\UserInfo\CompanyName or
    HKCU:\Software\Microsoft\Office\Common\UserInfo\Company, whichever is populated on the 
    computer running the script.
    This parameter has an alias of CN.
    If either registry key does not exist and this parameter is not specified, the report will
    not contain a Company Name on the cover page.
.PARAMETER CoverPage
    What Microsoft Word Cover Page to use.
    (default cover pages in Word en-US)
    Valid input is:
        Alphabet (Word 2010. Works)
        Annual (Word 2010. Doesn't work well for this report)
        Austere (Word 2010. Works)
        Austin (Word 2010/2013. Doesn't work in 2013, mostly works in 2010 but Subtitle/Subject & Author fields need to me moved after title box is moved up)
        Banded (Word 2013. Works)
        Conservative (Word 2010. Works)
        Contrast (Word 2010. Works)
        Cubicles (Word 2010. Works)
        Exposure (Word 2010. Works if you like looking sideways)
        Facet (Word 2013. Works)
        Filigree (Word 2013. Works)
        Grid (Word 2010/2013.Works in 2010)
        Integral (Word 2013. Works)
        Ion (Dark) (Word 2013. Top date doesn't fit, box needs to be manually resized or font changed to 8 point)
        Ion (Light) (Word 2013. Top date doesn't fit, box needs to be manually resized or font changed to 8 point)
        Mod (Word 2010. Works)
        Motion (Word 2010/2013. Works if top date is manually changed to 36 point)
        Newsprint (Word 2010. Works but date is not populated)
        Perspective (Word 2010. Works)
        Pinstripes (Word 2010. Works)
        Puzzle (Word 2010. Top date doesn't fit, box needs to be manually resized or font changed to 14 point)
        Retrospect (Word 2013. Works)
        Semaphore (Word 2013. Works)
        Sideline (Word 2010/2013. Doesn't work in 2013, works in 2010)
        Slice (Dark) (Word 2013. Doesn't work)
        Slice (Light) (Word 2013. Doesn't work)
        Stacks (Word 2010. Works)
        Tiles (Word 2010. Date doesn't fit unless changed to 26 point)
        Transcend (Word 2010. Works)
        ViewMaster (Word 2013. Works)
        Whisp (Word 2013. Works)
    Default value is Sideline.
    This parameter has an alias of CP.
.PARAMETER UserName
    User name to use for the Cover Page and Footer.
    Default value is contained in $env:username
    This parameter has an alias of UN.
.PARAMETER PDF
    SaveAs PDF file instead of DOCX file.
    This parameter is disabled by default.
    The PDF file is roughly 5X to 10X larger than the DOCX file.
.PARAMETER Text
    Creates a formatted text file with a .txt extension.
    This parameter is disabled by default.
    This parameter is reserved for a future update and not output is generated at this time.
.PARAMETER MSWord
    SaveAs DOCX file
    This parameter is set True if no other output format is selected.
.PARAMETER HTML
    Creates an HTML file with an .html extension.
    This parameter is disabled by default.
    This parameter is reserved for a future update and not output is generated at this time.
.PARAMETER AddDateTime
    Adds a date time stamp to the end of the file name.
    Time stamp is in the format of yyyy-MM-dd_HHmm.
    June 1, 2014 at 6PM is 2014-06-01_1800.
    Output filename will be ReportName_2014-06-01_1800.docx (or .pdf).
    This parameter is disabled by default.
.PARAMETER nxIP
    IP address of the Nutanix node you're making a connection too.
.PARAMETER nxUser
    Username for the connection to the Nutanix node
.PARAMETER nxPassword
    Password for the connection to the Nutanix node
.PARAMETER Full
    Runs a full inventory on alerts and events.
    This parameter is disabled by default - only a summary is run when this parameter is not specified.
.EXAMPLE
    PS C:\PSScript > .\Nutanix_Script_v1_0.ps1
    
    Will use all default values.
    HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName="Carl Webster" or
    HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Carl Webster"
    $env:username = Administrator

    Carl Webster for the Company Name.
    Sideline for the Cover Page format.
    Administrator for the User Name.
.EXAMPLE
    PS C:\PSScript > .\Nutanix_Script_v1_0.ps1 -PDF
    
    Will use all default values and save the document as a PDF file.
    HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName="Carl Webster" or
    HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Carl Webster"
    $env:username = Administrator

    Carl Webster for the Company Name.
    Sideline for the Cover Page format.
    Administrator for the User Name.
.EXAMPLE
    PS C:\PSScript > .\Nutanix_Script_v1_0.ps1 -TEXT
    
    Will use all default values and save the document as a formatted text file.
    HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName="Carl Webster" or
    HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Carl Webster"
    $env:username = Administrator

    Carl Webster for the Company Name.
    Sideline for the Cover Page format.
    Administrator for the User Name.
.EXAMPLE
    PS C:\PSScript > .\Nutanix_Script_v1_0.ps1 -HTML
    
    Will use all default values and save the document as an HTML file.
    HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName="Carl Webster" or
    HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Carl Webster"
    $env:username = Administrator

    Carl Webster for the Company Name.
    Sideline for the Cover Page format.
    Administrator for the User Name.
.EXAMPLE
    PS C:\PSScript .\Nutanix_Script_v1_0.ps1 -CompanyName "Carl Webster Consulting" -CoverPage "Mod" -UserName "Carl Webster"

    Will use:
        Carl Webster Consulting for the Company Name.
        Mod for the Cover Page format.
        Carl Webster for the User Name.
.EXAMPLE
    PS C:\PSScript .\Nutanix_Script_v1_0.ps1 -CN "Carl Webster Consulting" -CP "Mod" -UN "Carl Webster"

    Will use:
        Carl Webster Consulting for the Company Name (alias CN).
        Mod for the Cover Page format (alias CP).
        Carl Webster for the User Name (alias UN).
.EXAMPLE
    PS C:\PSScript > .\Nutanix_Script_v1_0.ps1 -AddDateTime
    
    Will use all default values.
    HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName="Carl Webster" or
    HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Carl Webster"
    $env:username = Administrator

    Carl Webster for the Company Name.
    Sideline for the Cover Page format.
    Administrator for the User Name.

    Adds a date time stamp to the end of the file name.
    Time stamp is in the format of yyyy-MM-dd_HHmm.
    June 1, 2014 at 6PM is 2014-06-01_1800.
    Output filename will be Script_Template_2014-06-01_1800.docx
.EXAMPLE
    PS C:\PSScript > .\Nutanix_Script_v1_0.ps1 -PDF -AddDateTime
    
    Will use all default values and save the document as a PDF file.
    HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName="Carl Webster" or
    HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Carl Webster"
    $env:username = Administrator

    Carl Webster for the Company Name.
    Sideline for the Cover Page format.
    Administrator for the User Name.

    Adds a date time stamp to the end of the file name.
    Time stamp is in the format of yyyy-MM-dd_HHmm.
    June 1, 2014 at 6PM is 2014-06-01_1800.
    Output filename will be Script_Template_2014-06-01_1800.PDF
.EXAMPLE
    PS C:\PSScript > .\Nutanix_Script_v1_0.ps1 -nxIP "99.99.99.99.99" -nxUser "admin"
.INPUTS
    None.  You cannot pipe objects to this script.
.OUTPUTS
    No objects are output from this script.  
    This script creates a Word, PDF, Formatted Text or HTML document.
.NOTES
    NAME: Nutanix_Documentation_Script_v1.ps1
    VERSION: 1.0
    AUTHOR: Kees Baggerman with help from Carl Webster, Michael B. Smith, Iain Brighton, Jeff Wouters, Barry Schiffer
    LASTEDIT: January 20, 2015
#>

#endregion Support

#region script template
#thanks to @jeffwouters and Michael B. Smith for helping me with these parameters
[CmdletBinding(SupportsShouldProcess = $False, ConfirmImpact = "None", DefaultParameterSetName = "WordOrPDF") ]

Param(
    [parameter(ParameterSetName="WordOrPDF",Mandatory=$False )]
    [Alias("CN")]
    [ValidateNotNullOrEmpty()]
    [string]$CompanyName="",
   
    [parameter(ParameterSetName="WordOrPDF", Mandatory=$False ) ]
    [Alias("CP")]
    [ValidateNotNullOrEmpty()]
    [string]$CoverPage="Sideline",
 
    [parameter(ParameterSetName="WordOrPDF", Mandatory=$False ) ]
    [Alias("UN")]
    [ValidateNotNullOrEmpty()]
    [string]$UserName=$env:username,
 
    [parameter(ParameterSetName="WordOrPDF", Mandatory=$False ) ]
    [Switch]$PDF=$False,
 
    [parameter(ParameterSetName="Text",Mandatory=$False ) ]
    [Switch]$Text=$False,
 
    [parameter(ParameterSetName="WordOrPDF", Mandatory=$False ) ]
    [Switch]$MSWord=$False,
 
    [parameter(ParameterSetName="HTML", Mandatory=$False ) ]
    [Switch]$HTML=$False,
 
    [parameter(Mandatory=$False ) ]
    [Switch]$AddDateTime=$False,
 
    [parameter(Mandatory=$False)]
    [Switch]$Full=$False,
   
    # Nutanix cluster IP address
    [Parameter(Mandatory = $true)]
    [Alias('IP')] [string] $nxIP,
     
    # Nutanix cluster username
    [Parameter(Mandatory = $true)]
    [Alias('User')] [string] $nxUser,
    # Nutanix cluster password
    [Parameter(Mandatory = $true)]
    [Alias('Password')] [string] $nxPassword
   
)
 
#kees@nutanix.com
#@kbaggerman on Twitter
#http://blog.myvirtualvision.com
#Created on Januari 20, 2015

Set-StrictMode -Version 2

#force -verbose on
$PSDefaultParameterValues = @{"*:Verbose"=$True}
$SaveEAPreference = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'

If($PDF -eq $Null)
{
    $PDF = $False
}
If($Text -eq $Null)
{
    $Text = $False
}
If($MSWord -eq $Null)
{
    $MSWord = $False
}
If($HTML -eq $Null)
{
    $HTML = $False
}
If($AddDateTime -eq $Null)
{
    $AddDateTime = $False
}

If(!(Test-Path Variable:PDF))
{
    $PDF = $False
}
If($Full -eq $Null)
{
    $Full = $False
}
If(!(Test-Path Variable:Text))
{
    $Text = $False
}
If(!(Test-Path Variable:MSWord))
{
    $MSWord = $False
}
If(!(Test-Path Variable:HTML))
{
    $HTML = $False
}If(!(Test-Path Variable:Full))
{
    $Full = $False
}
If(!(Test-Path Variable:AddDateTime))
{
    $AddDateTime = $False
}

If($MSWord -eq $Null)
{
    If($Text -or $HTML -or $PDF)
    {
        $MSWord = $False
    }
    Else
    {
        $MSWord = $True
    }
}

If($MSWord -eq $False -and $PDF -eq $False -and $Text -eq $False -and $HTML -eq $False)
{
    $MSWord = $True
}

Write-Verbose "$(Get-Date): Testing output parameters"

If($MSWord)
{
    Write-Verbose "$(Get-Date): MSWord is set"
}
ElseIf($PDF)
{
    Write-Verbose "$(Get-Date): PDF is set"
}
ElseIf($Text)
{
    Write-Verbose "$(Get-Date): Text is set"
}
ElseIf($HTML)
{
    Write-Verbose "$(Get-Date): HTML is set"
}
Else
{
    $ErrorActionPreference = $SaveEAPreference
    Write-Verbose "$(Get-Date): Unable to determine output parameter"
    If($MSWord -eq $Null)
    {
        Write-Verbose "$(Get-Date): MSWord is Null"
    }
    ElseIf($PDF -eq $Null)
    {
        Write-Verbose "$(Get-Date): PDF is Null"
    }
    ElseIf($Text -eq $Null)
    {
        Write-Verbose "$(Get-Date): Text is Null"
    }
    ElseIf($HTML -eq $Null)
    {
        Write-Verbose "$(Get-Date): HTML is Null"
    }
    Else
    {
        Write-Verbose "$(Get-Date): MSWord is $($MSWord)"
        Write-Verbose "$(Get-Date): PDF is $($PDF)"
        Write-Verbose "$(Get-Date): Text is $($Text)"
        Write-Verbose "$(Get-Date): HTML is $($HTML)"
    }
    Write-Error "Unable to determine output parameter.  Script cannot continue"
    Exit
}
If($Full)
{
    Write-Warning ""
    Write-Warning "Full-Run is set. This will create a full inventory and will take a significant amount of time."
    Write-Warning ""
}

If($MSWord -or $PDF)
{
    #try and fix the issue with the $CompanyName variable
    $CoName = $CompanyName
    Write-Verbose "$(Get-Date): CoName is $($CoName)"
    
    #the following values were attained from 
    #http://groovy.codehaus.org/modules/scriptom/1.6.0/scriptom-office-2K3-tlb/apidocs/
    #http://msdn.microsoft.com/en-us/library/office/aa211923(v=office.11).aspx
    [int]$wdAlignPageNumberRight = 2
    [long]$wdColorGray15 = 14277081
    [long]$wdColorGray05 = 15987699 
    [int]$wdMove = 0
    [int]$wdSeekMainDocument = 0
    [int]$wdSeekPrimaryFooter = 4
    [int]$wdStory = 6
    [int]$wdColorRed = 255
    [int]$wdColorBlack = 0
    [int]$wdWord2010 = 14
    [int]$wdWord2013 = 15
    [int]$wdFormatDocumentDefault = 16
    [int]$wdFormatPDF = 17
    #http://blogs.technet.com/b/heyscriptingguy/archive/2006/03/01/how-can-i-right-align-a-single-column-in-a-word-table.aspx
    #http://msdn.microsoft.com/en-us/library/office/ff835817%28v=office.15%29.aspx
    [int]$wdAlignParagraphLeft = 0
    [int]$wdAlignParagraphCenter = 1
    [int]$wdAlignParagraphRight = 2
    #http://msdn.microsoft.com/en-us/library/office/ff193345%28v=office.15%29.aspx
    [int]$wdCellAlignVerticalTop = 0
    [int]$wdCellAlignVerticalCenter = 1
    [int]$wdCellAlignVerticalBottom = 2
    #http://msdn.microsoft.com/en-us/library/office/ff844856%28v=office.15%29.aspx
    [int]$wdAutoFitFixed = 0
    [int]$wdAutoFitContent = 1
    [int]$wdAutoFitWindow = 2
    #http://msdn.microsoft.com/en-us/library/office/ff821928%28v=office.15%29.aspx
    [int]$wdAdjustNone = 0
    [int]$wdAdjustProportional = 1
    [int]$wdAdjustFirstColumn = 2
    [int]$wdAdjustSameWidth = 3

    [int]$PointsPerTabStop = 36
    [int]$Indent0TabStops = 0 * $PointsPerTabStop
    [int]$Indent1TabStops = 1 * $PointsPerTabStop
    [int]$Indent2TabStops = 2 * $PointsPerTabStop
    [int]$Indent3TabStops = 3 * $PointsPerTabStop
    [int]$Indent4TabStops = 4 * $PointsPerTabStop

    # http://www.thedoctools.com/index.php?show=wt_style_names_english_danish_german_french
    [int]$wdStyleHeading1 = -2
    [int]$wdStyleHeading2 = -3
    [int]$wdStyleHeading3 = -4
    [int]$wdStyleHeading4 = -5
    [int]$wdStyleNoSpacing = -158
    [int]$wdTableGrid = -155

    #http://groovy.codehaus.org/modules/scriptom/1.6.0/scriptom-office-2K3-tlb/apidocs/org/codehaus/groovy/scriptom/tlb/office/word/WdLineStyle.html
    [int]$wdLineStyleNone = 0
    [int]$wdLineStyleSingle = 1

    [int]$wdHeadingFormatTrue = -1
    [int]$wdHeadingFormatFalse = 0 

    [string]$RunningOS = (Get-WmiObject -class Win32_OperatingSystem -EA 0).Caption
}

Function SetWordHashTable
{
    Param([string]$CultureCode)
    $hash = @{}
        
    # DE and FR translations for Word 2010 by Vladimir Radojevic
    # Vladimir.Radojevic@Commerzreal.com

    # DA translations for Word 2010 by Thomas Daugaard
    # Citrix Infrastructure Specialist at edgemo A/S

    # CA translations by Javier Sanchez 
    # CEO & Founder 101 Consulting

    #ca - Catalan
    #da - Danish
    #de - German
    #en - English
    #es - Spanish
    #fi - Finnish
    #fr - French
    #nb - Norwegian
    #nl - Dutch
    #pt - Portuguese
    #sv - Swedish

    Switch ($CultureCode)
    {
        'ca-'   {
                $hash.($($CultureCode)) = @{
                    'Word_TableOfContents' = 'Taula automática 2'
                }
            }

        'da-'   {
                $hash.($($CultureCode)) = @{
                    'Word_TableOfContents' = 'Automatisk tabel 2'
                }
            }

        'de-'   {
                $hash.($($CultureCode)) = @{
                    'Word_TableOfContents' = 'Automatische Tabelle 2'
                }
            }

        'en-'   {
                $hash.($($CultureCode)) = @{
                    'Word_TableOfContents'  = 'Automatic Table 2'
                }
            }

        'es-'   {
                $hash.($($CultureCode)) = @{
                    'Word_TableOfContents' = 'Tabla automática 2'
                }
            }

        'fi-'   {
                $hash.($($CultureCode)) = @{
                    'Word_TableOfContents' = 'Automaattinen taulukko 2'
                }
            }

        'fr-'   {
                $hash.($($CultureCode)) = @{
                    'Word_TableOfContents' = 'Sommaire Automatique 2'
                }
            }

        'nb-'   {
                $hash.($($CultureCode)) = @{
                    'Word_TableOfContents' = 'Automatisk tabell 2'
                }
            }

        'nl-'   {
                $hash.($($CultureCode)) = @{
                    'Word_TableOfContents' = 'Automatische inhoudsopgave 2'
                }
            }

        'pt-'   {
                $hash.($($CultureCode)) = @{
                    'Word_TableOfContents' = 'Sumário Automático 2'
                }
            }

        'sv-'   {
                $hash.($($CultureCode)) = @{
                    'Word_TableOfContents' = 'Automatisk innehållsförteckning2'
                }
            }

        Default {$hash.('en-') = @{
                    'Word_TableOfContents'  = 'Automatic Table 2'
                }
            }
    }

    $Script:myHash = $hash.$CultureCode

    If($Script:myHash -eq $Null)
    {
        $Script:myHash = $hash.('en-')
    }

    $Script:myHash.Word_NoSpacing = $wdStyleNoSpacing
    $Script:myHash.Word_Heading1 = $wdStyleheading1
    $Script:myHash.Word_Heading2 = $wdStyleheading2
    $Script:myHash.Word_Heading3 = $wdStyleheading3
    $Script:myHash.Word_Heading4 = $wdStyleheading4
    $Script:myHash.Word_TableGrid = $wdTableGrid
}

Function GetCulture
{
    Param([int]$WordValue)
    
    #codes obtained from http://support.microsoft.com/kb/221435
    #http://msdn.microsoft.com/en-us/library/bb213877(v=office.12).aspx
    $CatalanArray = 1027
    $DanishArray = 1030
    $DutchArray = 2067, 1043
    $EnglishArray = 3081, 10249, 4105, 9225, 6153, 8201, 5129, 13321, 7177, 11273, 2057, 1033, 12297
    $FinnishArray = 1035
    $FrenchArray = 2060, 1036, 11276, 3084, 12300, 5132, 13324, 6156, 8204, 10252, 7180, 9228, 4108
    $GermanArray = 1031, 3079, 5127, 4103, 2055
    $NorwegianArray = 1044, 2068
    $PortugueseArray = 1046, 2070
    $SpanishArray = 1034, 11274, 16394, 13322, 9226, 5130, 7178, 12298, 17418, 4106, 18442, 19466, 6154, 15370, 10250, 20490, 3082, 14346, 8202
    $SwedishArray = 1053, 2077

    #ca - Catalan
    #da - Danish
    #de - German
    #en - English
    #es - Spanish
    #fi - Finnish
    #fr - French
    #nb - Norwegian
    #nl - Dutch
    #pt - Portuguese
    #sv - Swedish

    Switch ($WordValue)
    {
        {$CatalanArray -contains $_} {$CultureCode = "ca-"}
        {$DanishArray -contains $_} {$CultureCode = "da-"}
        {$DutchArray -contains $_} {$CultureCode = "nl-"}
        {$EnglishArray -contains $_} {$CultureCode = "en-"}
        {$FinnishArray -contains $_} {$CultureCode = "fi-"}
        {$FrenchArray -contains $_} {$CultureCode = "fr-"}
        {$GermanArray -contains $_} {$CultureCode = "de-"}
        {$NorwegianArray -contains $_} {$CultureCode = "nb-"}
        {$PortugueseArray -contains $_} {$CultureCode = "pt-"}
        {$SpanishArray -contains $_} {$CultureCode = "es-"}
        {$SwedishArray -contains $_} {$CultureCode = "sv-"}
        Default {$CultureCode = "en-"}
    }
    
    Return $CultureCode
}

Function ValidateCoverPage
{
    Param([int]$xWordVersion, [string]$xCP, [string]$CultureCode)
    
    $xArray = ""
    
    Switch ($CultureCode)
    {
        'ca-'   {
                If($xWordVersion -eq $wdWord2013)
                {
                    $xArray = ("Austin", "En bandes", "Faceta", "Filigrana",
                    "Integral", "Ió (clar)", "Ió (fosc)", "Línia lateral",
                    "Moviment", "Quadrícula", "Retrospectiu", "Sector (clar)",
                    "Sector (fosc)", "Semàfor", "Visualització", "Whisp")
                }
                ElseIf($xWordVersion -eq $wdWord2010)
                {
                    $xArray = ("Alfabet", "Anual", "Austin", "Conservador",
                    "Contrast", "Cubicles", "Diplomàtic", "Exposició",
                    "Línia lateral", "Mod", "Mosiac", "Moviment", "Paper de diari",
                    "Perspectiva", "Piles", "Quadrícula", "Sobri",
                    "Transcendir", "Trencaclosques")
                }
            }

        'da-'   {
                If($xWordVersion -eq $wdWord2013)
                {
                    $xArray = ("BevægElse", "Brusen", "Ion (lys)", "Filigran",
                    "Retro", "Semafor", "Visningsmaster", "Integral",
                    "Facet", "Gitter", "Stribet", "Sidelinje", "Udsnit (lys)",
                    "Udsnit (mørk)", "Ion (mørk)", "Austin")
                }
                ElseIf($xWordVersion -eq $wdWord2010)
                {
                    $xArray = ("BevægElse", "Moderat", "Perspektiv", "Firkanter",
                    "Overskrid", "Alfabet", "Kontrast", "Stakke", "Fliser", "Gåde",
                    "Gitter", "Austin", "Eksponering", "Sidelinje", "Enkel",
                    "Nålestribet", "Årlig", "Avispapir", "Tradionel")
                }
            }

        'de-'   {
                If($xWordVersion -eq $wdWord2013)
                {
                    $xArray = ("Semaphor", "Segment (hell)", "Ion (hell)",
                    "Raster", "Ion (dunkel)", "Filigran", "Rückblick", "Pfiff",
                    "ViewMaster", "Segment (dunkel)", "Verbunden", "Bewegung",
                    "Randlinie", "Austin", "Integral", "Facette")
                }
                ElseIf($xWordVersion -eq $wdWord2010)
                {
                    $xArray = ("Alphabet", "Austin", "Bewegung", "Durchscheinend",
                    "Herausgestellt", "Jährlich", "Kacheln", "Kontrast", "Kubistisch",
                    "Modern", "Nadelstreifen", "Perspektive", "Puzzle", "Randlinie",
                    "Raster", "Schlicht", "Stapel", "Traditionell", "Zeitungspapier")
                }
            }

        'en-'   {
                If($xWordVersion -eq $wdWord2013)
                {
                    $xArray = ("Austin", "Banded", "Facet", "Filigree", "Grid",
                    "Integral", "Ion (Dark)", "Ion (Light)", "Motion", "Retrospect",
                    "Semaphore", "Sideline", "Slice (Dark)", "Slice (Light)", "ViewMaster",
                    "Whisp")
                }
                ElseIf($xWordVersion -eq $wdWord2010)
                {
                    $xArray = ("Alphabet", "Annual", "Austere", "Austin", "Conservative",
                    "Contrast", "Cubicles", "Exposure", "Grid", "Mod", "Motion", "Newsprint",
                    "Perspective", "Pinstripes", "Puzzle", "Sideline", "Stacks", "Tiles", "Transcend")
                }
            }

        'es-'   {
                If($xWordVersion -eq $wdWord2013)
                {
                    $xArray = ("Whisp", "Vista principal", "Filigrana", "Austin",
                    "Slice (luz)", "Faceta", "Semáforo", "Retrospectiva", "Cuadrícula",
                    "Movimiento", "Cortar (oscuro)", "Línea lateral", "Ion (oscuro)",
                    "Ion (claro)", "Integral", "Con bandas")
                }
                ElseIf($xWordVersion -eq $wdWord2010)
                {
                    $xArray = ("Alfabeto", "Anual", "Austero", "Austin", "Conservador",
                    "Contraste", "Cuadrícula", "Cubículos", "Exposición", "Línea lateral",
                    "Moderno", "Mosaicos", "Movimiento", "Papel periódico",
                    "Perspectiva", "Pilas", "Puzzle", "Rayas", "Sobrepasar")
                }
            }

        'fi-'   {
                If($xWordVersion -eq $wdWord2013)
                {
                    $xArray = ("Filigraani", "Integraali", "Ioni (tumma)",
                    "Ioni (vaalea)", "Opastin", "Pinta", "Retro", "Sektori (tumma)",
                    "Sektori (vaalea)", "Vaihtuvavärinen", "ViewMaster", "Austin",
                    "Kiehkura", "Liike", "Ruudukko", "Sivussa")
                }
                ElseIf($xWordVersion -eq $wdWord2010)
                {
                    $xArray = ("Aakkoset", "Askeettinen", "Austin", "Kontrasti",
                    "Laatikot", "Liike", "Liituraita", "Mod", "Osittain peitossa",
                    "Palapeli", "Perinteinen", "Perspektiivi", "Pinot", "Ruudukko",
                    "Ruudut", "Sanomalehtipaperi", "Sivussa", "Vuotuinen", "Ylitys")
                }
            }

        'fr-'   {
                If($xWordVersion -eq $wdWord2013)
                {
                    $xArray = ("ViewMaster", "Secteur (foncé)", "Sémaphore",
                    "Rétrospective", "Ion (foncé)", "Ion (clair)", "Intégrale",
                    "Filigrane", "Facette", "Secteur (clair)", "À bandes", "Austin",
                    "Guide", "Whisp", "Lignes latérales", "Quadrillage")
                }
                ElseIf($xWordVersion -eq $wdWord2010)
                {
                    $xArray = ("Mosaïques", "Ligne latérale", "Annuel", "Perspective",
                    "Contraste", "Emplacements de bureau", "Moderne", "Blocs empilés",
                    "Rayures fines", "Austère", "Transcendant", "Classique", "Quadrillage",
                    "Exposition", "Alphabet", "Mots croisés", "Papier journal", "Austin", "Guide")
                }
            }

        'nb-'   {
                If($xWordVersion -eq $wdWord2013)
                {
                    $xArray = ("Austin", "BevegElse", "Dempet", "Fasett", "Filigran",
                    "Integral", "Ion (lys)", "Ion (mørk)", "Retrospekt", "Rutenett",
                    "Sektor (lys)", "Sektor (mørk)", "Semafor", "Sidelinje", "Stripet",
                    "ViewMaster")
                }
                ElseIf($xWordVersion -eq $wdWord2010)
                {
                    $xArray = ("Alfabet", "Årlig", "Avistrykk", "Austin", "Avlukker",
                    "BevegElse", "Engasjement", "Enkel", "Fliser", "Konservativ",
                    "Kontrast", "Mod", "Perspektiv", "Puslespill", "Rutenett", "Sidelinje",
                    "Smale striper", "Stabler", "Transcenderende")
                }
            }

        'nl-'   {
                If($xWordVersion -eq $wdWord2013)
                {
                    $xArray = ("Austin", "Beweging", "Facet", "Filigraan", "Gestreept",
                    "Integraal", "Ion (donker)", "Ion (licht)", "Raster",
                    "Segment (Light)", "Semafoor", "Slice (donker)", "Spriet",
                    "Terugblik", "Terzijde", "ViewMaster")
                }
                ElseIf($xWordVersion -eq $wdWord2010)
                {
                    $xArray = ("Aantrekkelijk", "Alfabet", "Austin", "Bescheiden",
                    "Beweging", "Blikvanger", "Contrast", "Eenvoudig", "Jaarlijks",
                    "Krantenpapier", "Krijtstreep", "Kubussen", "Mod", "Perspectief",
                    "Puzzel", "Raster", "Stapels",
                    "Tegels", "Terzijde")
                }
            }

        'pt-'   {
                If($xWordVersion -eq $wdWord2013)
                {
                    $xArray = ("Animação", "Austin", "Em Tiras", "Exibição Mestra",
                    "Faceta", "Fatia (Clara)", "Fatia (Escura)", "Filete", "Filigrana",
                    "Grade", "Integral", "Íon (Claro)", "Íon (Escuro)", "Linha Lateral",
                    "Retrospectiva", "Semáforo")
                }
                ElseIf($xWordVersion -eq $wdWord2010)
                {
                    $xArray = ("Alfabeto", "Animação", "Anual", "Austero", "Austin", "Baias",
                    "Conservador", "Contraste", "Exposição", "Grade", "Ladrilhos",
                    "Linha Lateral", "Listras", "Mod", "Papel Jornal", "Perspectiva", "Pilhas",
                    "Quebra-cabeça", "Transcend")
                }
            }

        'sv-'   {
                If($xWordVersion -eq $wdWord2013)
                {
                    $xArray = ("Austin", "Band", "Fasett", "Filigran", "Integrerad", "Jon (ljust)",
                    "Jon (mörkt)", "Knippe", "Rutnät", "RörElse", "Sektor (ljus)", "Sektor (mörk)",
                    "Semafor", "Sidlinje", "VisaHuvudsida", "Återblick")
                }
                ElseIf($xWordVersion -eq $wdWord2010)
                {
                    $xArray = ("Alfabetmönster", "Austin", "Enkelt", "Exponering", "Konservativt",
                    "Kontrast", "Kritstreck", "Kuber", "Perspektiv", "Plattor", "Pussel", "Rutnät",
                    "RörElse", "Sidlinje", "Sobert", "Staplat", "Tidningspapper", "Årligt",
                    "Övergående")
                }
            }

        Default {
                    If($xWordVersion -eq $wdWord2013)
                    {
                        $xArray = ("Austin", "Banded", "Facet", "Filigree", "Grid", "Integral",
                        "Ion (Dark)", "Ion (Light)", "Motion", "Retrospect", "Semaphore",
                        "Sideline", "Slice (Dark)", "Slice (Light)", "ViewMaster", "Whisp")
                    }
                    ElseIf($xWordVersion -eq $wdWord2010)
                    {
                        $xArray = ("Alphabet", "Annual", "Austere", "Austin", "Conservative",
                        "Contrast", "Cubicles", "Exposure", "Grid", "Mod", "Motion", "Newsprint",
                        "Perspective", "Pinstripes", "Puzzle", "Sideline", "Stacks", "Tiles", "Transcend")
                    }
                }
    }
    
    If($xArray -contains $xCP)
    {
        $xArray = $Null
        Return $True
    }
    Else
    {
        $xArray = $Null
        Return $False
    }
}

Function CheckWordPrereq
{
    If((Test-Path  REGISTRY::HKEY_CLASSES_ROOT\Word.Application) -eq $False)
    {
        $ErrorActionPreference = $SaveEAPreference
        Write-Host "`n`n`t`tThis script directly outputs to Microsoft Word, please install Microsoft Word`n`n"
        Exit
    }

    #find out our session (usually "1" except on TS/RDC or Citrix)
    $SessionID = (Get-Process -PID $PID).SessionId
    
    #Find out if winword is running in our session
    [bool]$wordrunning = ((Get-Process 'WinWord' -ea 0)|?{$_.SessionId -eq $SessionID}) -ne $Null
    If($wordrunning)
    {
        $ErrorActionPreference = $SaveEAPreference
        Write-Host "`n`n`tPlease close all instances of Microsoft Word before running this report.`n`n"
        Exit
    }
}

Function ValidateCompanyName
{
    [bool]$xResult = Test-RegistryValue "HKCU:\Software\Microsoft\Office\Common\UserInfo" "CompanyName"
    If($xResult)
    {
        Return Get-RegistryValue "HKCU:\Software\Microsoft\Office\Common\UserInfo" "CompanyName"
    }
    Else
    {
        $xResult = Test-RegistryValue "HKCU:\Software\Microsoft\Office\Common\UserInfo" "Company"
        If($xResult)
        {
            Return Get-RegistryValue "HKCU:\Software\Microsoft\Office\Common\UserInfo" "Company"
        }
        Else
        {
            Return ""
        }
    }
}

#http://stackoverflow.com/questions/5648931/test-if-registry-value-exists
# This Function just gets $True or $False
Function Test-RegistryValue($path, $name)
{
    $key = Get-Item -LiteralPath $path -EA 0
    $key -and $Null -ne $key.GetValue($name, $Null)
}

# Gets the specified registry value or $Null if it is missing
Function Get-RegistryValue($path, $name)
{
    $key = Get-Item -LiteralPath $path -EA 0
    If($key)
    {
        $key.GetValue($name, $Null)
    }
    Else
    {
        $Null
    }
}

Function line
#function created by Michael B. Smith, Exchange MVP
#@essentialexchange on Twitter
#http://TheEssentialExchange.com
#for creating the formatted text report
#created March 2011
#updated March 2014
{
    Param( [int]$tabs = 0, [string]$name = '', [string]$value = '', [string]$newline = "`r`n", [switch]$nonewline )
    While( $tabs -gt 0 ) { $Global:Output += "`t"; $tabs--; }
    If( $nonewline )
    {
        $Global:Output += $name + $value
    }
    Else
    {
        $Global:Output += $name + $value + $newline
    }
}
    
Function WriteWordLine
#Function created by Ryan Revord
#@rsrevord on Twitter
#Function created to make output to Word easy in this script
#updated 27-Mar-2014 to include font name, font size, italics and bold options
{
    Param([int]$style=0, 
    [int]$tabs = 0, 
    [string]$name = '', 
    [string]$value = '', 
    [string]$fontName=$Null,
    [int]$fontSize=0,
    [bool]$italics=$False,
    [bool]$boldface=$False,
    [Switch]$nonewline)
    
    #Build output style
    [string]$output = ""
    Switch ($style)
    {
        0 {$Script:Selection.Style = $myHash.Word_NoSpacing}
        1 {$Script:Selection.Style = $myHash.Word_Heading1}
        2 {$Script:Selection.Style = $myHash.Word_Heading2}
        3 {$Script:Selection.Style = $myHash.Word_Heading3}
        4 {$Script:Selection.Style = $myHash.Word_Heading4}
        Default {$Script:Selection.Style = $myHash.Word_NoSpacing}
    }
    
    #build # of tabs
    While($tabs -gt 0)
    { 
        $output += "`t"; $tabs--; 
    }
 
    If(![String]::IsNullOrEmpty($fontName)) 
    {
        $Script:Selection.Font.name = $fontName
    } 

    If($fontSize -ne 0) 
    {
        $Script:Selection.Font.size = $fontSize
    } 
 
    If($italics -eq $True) 
    {
        $Script:Selection.Font.Italic = $True
    } 
 
    If($boldface -eq $True) 
    {
        $Script:Selection.Font.Bold = $True
    } 

    #output the rest of the parameters.
    $output += $name + $value
    $Script:Selection.TypeText($output)
 
    #test for new WriteWordLine 0.
    If($nonewline)
    {
        # Do nothing.
    } 
    Else 
    {
        $Script:Selection.TypeParagraph()
    }
}

Function _SetDocumentProperty 
{
    #jeff hicks
    Param([object]$Properties,[string]$Name,[string]$Value)
    #get the property object
    $prop = $properties | ForEach { 
        $propname=$_.GetType().InvokeMember("Name","GetProperty",$Null,$_,$Null)
        If($propname -eq $Name) 
        {
            Return $_
        }
    } #ForEach

    #set the value
    $Prop.GetType().InvokeMember("Value","SetProperty",$Null,$prop,$Value)
}

Function AbortScript
{
    $Script:Word.quit()
    Write-Verbose "$(Get-Date): System Cleanup"
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Script:Word) | Out-Null
    If(Test-Path variable:global:word)
    {
        Remove-Variable -Name word -Scope Global
    }
    [gc]::collect() 
    [gc]::WaitForPendingFinalizers()
    Write-Verbose "$(Get-Date): Script has been aborted"
    $ErrorActionPreference = $SaveEAPreference
    Exit
}

Function FindWordDocumentEnd
{
    #return focus to main document    
    $Script:Doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument
    #move to the end of the current document
    $Script:Selection.EndKey($wdStory,$wdMove) | Out-Null
}

<#
.Synopsis
    Add a table to a Microsoft Word document
.DESCRIPTION
    This function adds a table to a Microsoft Word document from either an array of
    Hashtables or an array of PSCustomObjects.

    Using this function is quicker than setting each table cell individually but can
    only utilise the built-in MS Word table autoformats. Individual tables cells can
    be altered after the table has been appended to the document (a table reference
    is returned).
.EXAMPLE
    AddWordTable -Hashtable $HashtableArray

    This example adds table to the MS Word document, utilising all key/value pairs in
    the array of hashtables. Column headers will display the key names as defined.
    Note: the columns might not be displayed in the order that they were defined. To
    ensure columns are displayed in the required order utilise the -Columns parameter.
.EXAMPLE
    AddWordTable -Hashtable $HashtableArray -List

    This example adds table to the MS Word document, utilising all key/value pairs in
    the array of hashtables. No column headers will be added, in a ListView format.
    Note: the columns might not be displayed in the order that they were defined. To
    ensure columns are displayed in the required order utilise the -Columns parameter.
.EXAMPLE
    AddWordTable -CustomObject $PSCustomObjectArray

    This example adds table to the MS Word document, utilising all note property names
    the array of PSCustomObjects. Column headers will display the note property names.
    Note: the columns might not be displayed in the order that they were defined. To
    ensure columns are displayed in the required order utilise the -Columns parameter.
.EXAMPLE
    AddWordTable -Hashtable $HashtableArray -Columns FirstName,LastName,EmailAddress

    This example adds a table to the MS Word document, but only using the specified
    key names: FirstName, LastName and EmailAddress. If other keys are present in the
    array of Hashtables they will be ignored.
.EXAMPLE
    AddWordTable -CustomObject $PSCustomObjectArray -Columns FirstName,LastName,EmailAddress -Headers "First Name","Last Name","Email Address"

    This example adds a table to the MS Word document, but only using the specified
    PSCustomObject note properties: FirstName, LastName and EmailAddress. If other note
    properties are present in the array of PSCustomObjects they will be ignored. The
    display names for each specified column header has been overridden to display a
    custom header. Note: the order of the header names must match the specified columns.
#>
Function AddWordTable
{
    [CmdletBinding()]
    Param
    (
        # Array of Hashtable (including table headers)
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='Hashtable', Position=0)]
        [ValidateNotNullOrEmpty()] [System.Collections.Hashtable[]] $Hashtable,
        # Array of PSCustomObjects
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='CustomObject', Position=0)]
        [ValidateNotNullOrEmpty()] [PSCustomObject[]] $CustomObject,
        # Array of Hashtable key names or PSCustomObject property names to include, in display order.
        # If not supplied then all Hashtable keys or all PSCustomObject properties will be displayed.
        [Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] [string[]] $Columns = $null,
        # Array of custom table header strings in display order.
        [Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] [string[]] $Headers = $null,
        # AutoFit table behavior.
        [Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] [int] $AutoFit = -1,
        # List view (no headers)
        [Switch] $List,
        # Grid lines
        [Switch] $NoGridLines,
        # Built-in Word table formatting style constant
        # Would recommend only $wdTableFormatContempory for normal usage (possibly $wdTableFormatList5 for List view)
        [Parameter(ValueFromPipelineByPropertyName=$true)] [int] $Format = 0
    )

    Begin 
    {
        Write-Debug ("Using parameter set '{0}'" -f $PSCmdlet.ParameterSetName);
        ## Check if -Columns wasn't specified but -Headers were (saves some additional parameter sets!)
        If(($Columns -eq $null) -and ($Headers -ne $null)) 
        {
            Write-Warning "No columns specified and therefore, specified headers will be ignored.";
            $Columns = $null;
        }
        ElseIf(($Columns -ne $null) -and ($Headers -ne $null)) 
        {
            ## Check if number of specified -Columns matches number of specified -Headers
            If($Columns.Length -ne $Headers.Length) 
            {
                Write-Error "The specified number of columns does not match the specified number of headers.";
            }
        } ## end elseif
    } ## end Begin

    Process
    {
        ## Build the Word table data string to be converted to a range and then a table later.
        [System.Text.StringBuilder] $WordRangeString = New-Object System.Text.StringBuilder;

        Switch ($PSCmdlet.ParameterSetName) 
        {
            'CustomObject' 
            {
                If($Columns -eq $null) 
                {
                    ## Build the available columns from all availble PSCustomObject note properties
                    [string[]] $Columns = @();
                    ## Add each NoteProperty name to the array
                    ForEach($Property in ($CustomObject | Get-Member -MemberType NoteProperty)) 
                    { 
                        $Columns += $Property.Name; 
                    }
                }

                ## Add the table headers from -Headers or -Columns (except when in -List(view)
                If(-not $List) 
                {
                    Write-Debug ("$(Get-Date): `t`tBuilding table headers");
                    If($Headers -ne $null) 
                    {
                        [ref] $null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $Headers));
                    }
                    Else 
                    { 
                        [ref] $null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $Columns));
                    }
                }

                ## Iterate through each PSCustomObject
                Write-Debug ("$(Get-Date): `t`tBuilding table rows");
                ForEach($Object in $CustomObject) 
                {
                    $OrderedValues = @();
                    ## Add each row item in the specified order
                    ForEach($Column in $Columns) 
                    { 
                        $OrderedValues += $Object.$Column; 
                    }
                    ## Use the ordered list to add each column in specified order
                    [ref] $null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $OrderedValues));
                } ## end foreach
                Write-Debug ("$(Get-Date): `t`t`tAdded '{0}' table rows" -f ($CustomObject.Count));
            } ## end CustomObject

            Default 
            {   ## Hashtable
                If($Columns -eq $null) 
                {
                    ## Build the available columns from all available hashtable keys. Hopefully
                    ## all Hashtables have the same keys (they should for a table).
                    $Columns = $Hashtable[0].Keys;
                }

                ## Add the table headers from -Headers or -Columns (except when in -List(view)
                If(-not $List) 
                {
                    Write-Debug ("$(Get-Date): `t`tBuilding table headers");
                    If($Headers -ne $null) 
                    { 
                        [ref] $null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $Headers));
                    }
                    Else 
                    {
                        [ref] $null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $Columns));
                    }
                }
                
                ## Iterate through each Hashtable
                Write-Debug ("$(Get-Date): `t`tBuilding table rows");
                ForEach($Hash in $Hashtable) 
                {
                    $OrderedValues = @();
                    ## Add each row item in the specified order
                    ForEach($Column in $Columns) 
                    { 
                        $OrderedValues += $Hash.$Column; 
                    }
                    ## Use the ordered list to add each column in specified order
                    [ref] $null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $OrderedValues));
                } ## end foreach

                Write-Debug ("$(Get-Date): `t`t`tAdded '{0}' table rows" -f $Hashtable.Count);
            } ## end default
        } ## end switch

        ## Create a MS Word range and set its text to our tab-delimited, concatenated string
        Write-Debug ("$(Get-Date): `t`tBuilding table range");
        $WordRange = $Script:Doc.Application.Selection.Range;
        $WordRange.Text = $WordRangeString.ToString();

        ## Create hash table of named arguments to pass to the ConvertToTable method
        $ConvertToTableArguments = @{ Separator = [Microsoft.Office.Interop.Word.WdTableFieldSeparator]::wdSeparateByTabs; }

        ## Negative built-in styles are not supported by the ConvertToTable method
        If($Format -ge 0) 
        {
            $ConvertToTableArguments.Add("Format", $Format);
            $ConvertToTableArguments.Add("ApplyBorders", $true);
            $ConvertToTableArguments.Add("ApplyShading", $true);
            $ConvertToTableArguments.Add("ApplyFont", $true);
            $ConvertToTableArguments.Add("ApplyColor", $true);
            If(!$List) 
            { 
                $ConvertToTableArguments.Add("ApplyHeadingRows", $true); 
            }
            $ConvertToTableArguments.Add("ApplyLastRow", $true);
            $ConvertToTableArguments.Add("ApplyFirstColumn", $true);
            $ConvertToTableArguments.Add("ApplyLastColumn", $true);
        }

        ## Invoke ConvertToTable method - with named arguments - to convert Word range to a table
        ## See http://msdn.microsoft.com/en-us/library/office/aa171893(v=office.11).aspx
        Write-Debug ("$(Get-Date): `t`tConverting range to table");
        ## Store the table reference just in case we need to set alternate row coloring
        $WordTable = $WordRange.GetType().InvokeMember(
            "ConvertToTable",                               # Method name
            [System.Reflection.BindingFlags]::InvokeMethod, # Flags
            $null,                                          # Binder
            $WordRange,                                     # Target (self!)
            ([Object[]]($ConvertToTableArguments.Values)),  ## Named argument values
            $null,                                          # Modifiers
            $null,                                          # Culture
            ([String[]]($ConvertToTableArguments.Keys))     ## Named argument names
        );

        ## Implement grid lines (will wipe out any existing formatting
        If($Format -lt 0) 
        {
            Write-Debug ("$(Get-Date): `t`tSetting table format");
            $WordTable.Style = $Format;
        }

        ## Set the table autofit behavior
        If($AutoFit -ne -1) 
        { 
            $WordTable.AutoFitBehavior($AutoFit); 
        }

        #the next line causes the heading row to flow across page breaks
        $WordTable.Rows.First.Headingformat = $wdHeadingFormatTrue;

        If(!$NoGridLines) 
        {
            $WordTable.Borders.InsideLineStyle = $wdLineStyleSingle;
            $WordTable.Borders.OutsideLineStyle = $wdLineStyleSingle;
        }

        Return $WordTable;

    } ## end Process
}

<#
.Synopsis
    Sets the format of one or more Word table cells
.DESCRIPTION
    This function sets the format of one or more table cells, either from a collection
    of Word COM object cell references, an individual Word COM object cell reference or
    a hashtable containing Row and Column information.

    The font name, font size, bold, italic , underline and shading values can be used.
.EXAMPLE
    SetWordCellFormat -Hashtable $Coordinates -Table $TableReference -Bold

    This example sets all text to bold that is contained within the $TableReference
    Word table, using an array of hashtables. Each hashtable contain a pair of co-
    ordinates that is used to select the required cells. Note: the hashtable must
    contain the .Row and .Column key names. For example:
    @ { Row = 7; Column = 3 } to set the cell at row 7 and column 3 to bold.
.EXAMPLE
    $RowCollection = $Table.Rows.First.Cells
    SetWordCellFormat -Collection $RowCollection -Bold -Size 10

    This example sets all text to size 8 and bold for all cells that are contained
    within the first row of the table.
    Note: the $Table.Rows.First.Cells returns a collection of Word COM cells objects
    that are in the first table row.
.EXAMPLE
    $ColumnCollection = $Table.Columns.Item(2).Cells
    SetWordCellFormat -Collection $ColumnCollection -BackgroundColor 255

    This example sets the background (shading) of all cells in the table's second
    column to red.
    Note: the $Table.Columns.Item(2).Cells returns a collection of Word COM cells objects
    that are in the table's second column.
.EXAMPLE
    SetWordCellFormat -Cell $Table.Cell(17,3) -Font "Tahoma" -Color 16711680

    This example sets the font to Tahoma and the text color to blue for the cell located
    in the table's 17th row and 3rd column.
    Note: the $Table.Cell(17,3) returns a single Word COM cells object.
#>
Function SetWordCellFormat 
{
    [CmdletBinding(DefaultParameterSetName='Collection')]
    Param (
        # Word COM object cell collection reference
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ParameterSetName='Collection', Position=0)] [ValidateNotNullOrEmpty()] $Collection,
        # Word COM object individual cell reference
        [Parameter(Mandatory=$true, ParameterSetName='Cell', Position=0)] [ValidateNotNullOrEmpty()] $Cell,
        # Hashtable of cell co-ordinates
        [Parameter(Mandatory=$true, ParameterSetName='Hashtable', Position=0)] [ValidateNotNullOrEmpty()] [System.Collections.Hashtable[]] $Coordinates,
        # Word COM object table reference
        [Parameter(Mandatory=$true, ParameterSetName='Hashtable', Position=1)] [ValidateNotNullOrEmpty()] $Table,
        # Font name
        [Parameter()] [AllowNull()] [string] $Font = $null,
        # Font color
        [Parameter()] [AllowNull()] $Color = $null,
        # Font size
        [Parameter()] [ValidateNotNullOrEmpty()] [int] $Size = 0,
        # Cell background color
        [Parameter()] [AllowNull()] $BackgroundColor = $null,
        # Force solid background color
        [Switch] $Solid,
        [Switch] $Bold,
        [Switch] $Italic,
        [Switch] $Underline
    )

    Begin 
    {
        Write-Debug ("Using parameter set '{0}'." -f $PSCmdlet.ParameterSetName);
    }

    Process 
    {
        Switch ($PSCmdlet.ParameterSetName) 
        {
            'Collection' {
                ForEach($Cell in $Collection) 
                {
                    If($BackgroundColor -ne $null) { $Cell.Shading.BackgroundPatternColor = $BackgroundColor; }
                    If($Bold) { $Cell.Range.Font.Bold = $true; }
                    If($Italic) { $Cell.Range.Font.Italic = $true; }
                    If($Underline) { $Cell.Range.Font.Underline = 1; }
                    If($Font -ne $null) { $Cell.Range.Font.Name = $Font; }
                    If($Color -ne $null) { $Cell.Range.Font.Color = $Color; }
                    If($Size -ne 0) { $Cell.Range.Font.Size = $Size; }
                    If($Solid) { $Cell.Shading.Texture = 0; } ## wdTextureNone
                } # end foreach
            } # end Collection
            'Cell' 
            {
                If($Bold) { $Cell.Range.Font.Bold = $true; }
                If($Italic) { $Cell.Range.Font.Italic = $true; }
                If($Underline) { $Cell.Range.Font.Underline = 1; }
                If($Font -ne $null) { $Cell.Range.Font.Name = $Font; }
                If($Color -ne $null) { $Cell.Range.Font.Color = $Color; }
                If($Size -ne 0) { $Cell.Range.Font.Size = $Size; }
                If($BackgroundColor -ne $null) { $Cell.Shading.BackgroundPatternColor = $BackgroundColor; }
                If($Solid) { $Cell.Shading.Texture = 0; } ## wdTextureNone
            } # end Cell
            'Hashtable' 
            {
                ForEach($Coordinate in $Coordinates) 
                {
                    $Cell = $Table.Cell($Coordinate.Row, $Coordinate.Column);
                    If($Bold) { $Cell.Range.Font.Bold = $true; }
                    If($Italic) { $Cell.Range.Font.Italic = $true; }
                    If($Underline) { $Cell.Range.Font.Underline = 1; }
                    If($Font -ne $null) { $Cell.Range.Font.Name = $Font; }
                    If($Color -ne $null) { $Cell.Range.Font.Color = $Color; }
                    If($Size -ne 0) { $Cell.Range.Font.Size = $Size; }
                    If($BackgroundColor -ne $null) { $Cell.Shading.BackgroundPatternColor = $BackgroundColor; }
                    If($Solid) { $Cell.Shading.Texture = 0; } ## wdTextureNone
                }
            } # end Hashtable
        } # end switch
    } # end process
}

<#
.Synopsis
    Sets alternate row colors in a Word table
.DESCRIPTION
    This function sets the format of alternate rows within a Word table using the
    specified $BackgroundColor. This function is expensive (in performance terms) as
    it recursively sets the format on alternate rows. It would be better to pick one
    of the predefined table formats (if one exists)? Obviously the more rows, the
    longer it takes :'(

    Note: this function is called by the AddWordTable function if an alternate row
    format is specified.
.EXAMPLE
    SetWordTableAlternateRowColor -Table $TableReference -BackgroundColor 255

    This example sets every-other table (starting with the first) row and sets the
    background color to red (wdColorRed).
.EXAMPLE
    SetWordTableAlternateRowColor -Table $TableReference -BackgroundColor 39423 -Seed Second

    This example sets every other table (starting with the second) row and sets the
    background color to light orange (weColorLightOrange).
#>
Function SetWordTableAlternateRowColor 
{
    [CmdletBinding()]
    Param (
        # Word COM object table reference
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)] [ValidateNotNullOrEmpty()] $Table,
        # Alternate row background color
        [Parameter(Mandatory=$true, Position=1)] [ValidateNotNull()] [int] $BackgroundColor,
        # Alternate row starting seed
        [Parameter(ValueFromPipelineByPropertyName=$true, Position=2)] [ValidateSet('First','Second')] [string] $Seed = 'First'
    )

    Process 
    {
        $StartDateTime = Get-Date;
        Write-Debug ("{0}: `t`tSetting alternate table row colors.." -f $StartDateTime);

        ## Determine the row seed (only really need to check for 'Second' and default to 'First' otherwise
        If($Seed.ToLower() -eq 'second') 
        { 
            $StartRowIndex = 2; 
        }
        Else 
        { 
            $StartRowIndex = 1; 
        }

        For($AlternateRowIndex = $StartRowIndex; $AlternateRowIndex -lt $Table.Rows.Count; $AlternateRowIndex += 2) 
        { 
            $Table.Rows.Item($AlternateRowIndex).Shading.BackgroundPatternColor = $BackgroundColor;
        }

        ## I've put verbose calls in here we can see how expensive this functionality actually is.
        $EndDateTime = Get-Date;
        $ExecutionTime = New-TimeSpan -Start $StartDateTime -End $EndDateTime;
        Write-Debug ("{0}: `t`tDone setting alternate row style color in '{1}' seconds" -f $EndDateTime, $ExecutionTime.TotalSeconds);
    }
}

Function ShowScriptOptions
{
    Write-Verbose "$(Get-Date): "
    Write-Verbose "$(Get-Date): "
    Write-Verbose "$(Get-Date): Company Name : $($Script:CoName)"
    Write-Verbose "$(Get-Date): Cover Page   : $($CoverPage)"
    Write-Verbose "$(Get-Date): User Name    : $($UserName)"
    Write-Verbose "$(Get-Date): Save As PDF  : $($PDF)"
    Write-Verbose "$(Get-Date): Save As TEXT : $($TEXT)"
    Write-Verbose "$(Get-Date): Save As WORD : $($MSWORD)"
    Write-Verbose "$(Get-Date): Save As HTML : $($HTML)"
    Write-Verbose "$(Get-Date): Add DateTime : $($AddDateTime)"
    Write-Verbose "$(Get-Date): Filename1    : $($Script:FileName1)"
    If($PDF)
    {
        Write-Verbose "$(Get-Date): Filename2    : $($Script:FileName2)"
    }
    Write-Verbose "$(Get-Date): OS Detected  : $($RunningOS)"
    Write-Verbose "$(Get-Date): PSUICulture  : $($PSUICulture)"
    Write-Verbose "$(Get-Date): PSCulture    : $($PSCulture)"
    Write-Verbose "$(Get-Date): Word version : $($Script:WordProduct)"
    Write-Verbose "$(Get-Date): Word language: $($Script:WordLanguageValue)"
    Write-Verbose "$(Get-Date): PoSH version : $($Host.Version)"
    Write-Verbose "$(Get-Date): "
    Write-Verbose "$(Get-Date): Script start : $($Script:StartTime)"
    Write-Verbose "$(Get-Date): "
    Write-Verbose "$(Get-Date): "
}

Function validStateProp( [object] $object, [string] $topLevel, [string] $secondLevel )
{
    #function created 8-jan-2014 by Michael B. Smith
    if( $object )
    {
        If( ( gm -Name $topLevel -InputObject $object ) )
        {
            If( ( gm -Name $secondLevel -InputObject $object.$topLevel ) )
            {
                Return $True
            }
        }
    }
    Return $False
}

Function SetupWord
{
    Write-Verbose "$(Get-Date): Setting up Word"
    
    # Setup word for output
    Write-Verbose "$(Get-Date): Create Word comObject.  Ignore the next message."
    $Script:Word = New-Object -comobject "Word.Application" -EA 0

    If(!$? -or $Script:Word -eq $Null)
    {
        Write-Warning "The Word object could not be created.  You may need to repair your Word installation."
        $ErrorActionPreference = $SaveEAPreference
        Write-Error "`n`n`t`tThe Word object could not be created.  You may need to repair your Word installation.`n`n`t`tScript cannot continue.`n`n"
        Exit
    }

    Write-Verbose "$(Get-Date): Determine Word language value"
    If( ( validStateProp $Script:Word Language Value__ ) )
    {
        [int]$Script:WordLanguageValue = [int]$Script:Word.Language.Value__
    }
    Else
    {
        [int]$Script:WordLanguageValue = [int]$Script:Word.Language
    }

    If(!($Script:WordLanguageValue -gt -1))
    {
        $ErrorActionPreference = $SaveEAPreference
        Write-Error "`n`n`t`tUnable to determine the Word language value.`n`n`t`tScript cannot continue.`n`n"
        AbortScript
    }
    Write-Verbose "$(Get-Date): Word language value is $($Script:WordLanguageValue)"
    
    $Script:WordCultureCode = GetCulture $Script:WordLanguageValue
    
    SetWordHashTable $Script:WordCultureCode
    
    [int]$Script:WordVersion = [int]$Script:Word.Version
    If($Script:WordVersion -eq $wdWord2013)
    {
        $Script:WordProduct = "Word 2013"
    }
    ElseIf($Script:WordVersion -eq $wdWord2010)
    {
        $Script:WordProduct = "Word 2010"
    }
    Else
    {
        $ErrorActionPreference = $SaveEAPreference
        Write-Error "`n`n`t`tYou are running an untested or unsupported version of Microsoft Word.`n`n`t`tScript will end.`n`n`t`tPlease send info on your version of Word to webster@carlwebster.com`n`n"
        AbortScript
    }

    #only validate CompanyName if the field is blank
    If([String]::IsNullOrEmpty($CoName))
    {
        Write-Verbose "$(Get-Date): Company name is blank.  Retrieve company name from registry."
        $TmpName = ValidateCompanyName
        
        If([String]::IsNullOrEmpty($TmpName))
        {
            Write-Warning "`n`n`t`tCompany Name is blank so Cover Page will not show a Company Name."
            Write-Warning "`n`t`tCheck HKCU:\Software\Microsoft\Office\Common\UserInfo for Company or CompanyName value."
            Write-Warning "`n`t`tYou may want to use the -CompanyName parameter if you need a Company Name on the cover page.`n`n"
        }
        Else
        {
            $Script:CoName = $TmpName
            Write-Verbose "$(Get-Date): Updated company name to $($Script:CoName)"
        }
    }

    If($Script:WordCultureCode -ne "en-")
    {
        Write-Verbose "$(Get-Date): Check Default Cover Page for $($WordCultureCode)"
        [bool]$CPChanged = $False
        Switch ($Script:WordCultureCode)
        {
            'ca-'   {
                    If($CoverPage -eq "Sideline")
                    {
                        $CoverPage = "Línia lateral"
                        $CPChanged = $True
                    }
                }

            'da-'   {
                    If($CoverPage -eq "Sideline")
                    {
                        $CoverPage = "Sidelinje"
                        $CPChanged = $True
                    }
                }

            'de-'   {
                    If($CoverPage -eq "Sideline")
                    {
                        $CoverPage = "Randlinie"
                        $CPChanged = $True
                    }
                }

            'es-'   {
                    If($CoverPage -eq "Sideline")
                    {
                        $CoverPage = "Línea lateral"
                        $CPChanged = $True
                    }
                }

            'fi-'   {
                    If($CoverPage -eq "Sideline")
                    {
                        $CoverPage = "Sivussa"
                        $CPChanged = $True
                    }
                }

            'fr-'   {
                    If($CoverPage -eq "Sideline")
                    {
                        If($Script:WordVersion -eq $wdWord2013)
                        {
                            $CoverPage = "Lignes latérales"
                            $CPChanged = $True
                        }
                        Else
                        {
                            $CoverPage = "Ligne latérale"
                            $CPChanged = $True
                        }
                    }
                }

            'nb-'   {
                    If($CoverPage -eq "Sideline")
                    {
                        $CoverPage = "Sidelinje"
                        $CPChanged = $True
                    }
                }

            'nl-'   {
                    If($CoverPage -eq "Sideline")
                    {
                        $CoverPage = "Terzijde"
                        $CPChanged = $True
                    }
                }

            'pt-'   {
                    If($CoverPage -eq "Sideline")
                    {
                        $CoverPage = "Linha Lateral"
                        $CPChanged = $True
                    }
                }

            'sv-'   {
                    If($CoverPage -eq "Sideline")
                    {
                        $CoverPage = "Sidlinje"
                        $CPChanged = $True
                    }
                }
        }

        If($CPChanged)
        {
            Write-Verbose "$(Get-Date): Changed Default Cover Page from Sideline to $($CoverPage)"
        }
    }

    Write-Verbose "$(Get-Date): Validate cover page $($CoverPage) for culture code $($Script:WordCultureCode)"
    [bool]$ValidCP = $False
    
    $ValidCP = ValidateCoverPage $Script:WordVersion $CoverPage $Script:WordCultureCode
    
    If(!$ValidCP)
    {
        $ErrorActionPreference = $SaveEAPreference
        Write-Verbose "$(Get-Date): Word language value $($Script:WordLanguageValue)"
        Write-Verbose "$(Get-Date): Culture code $($Script:WordCultureCode)"
        Write-Error "`n`n`t`tFor $($Script:WordProduct), $($CoverPage) is not a valid Cover Page option.`n`n`t`tScript cannot continue.`n`n"
        AbortScript
    }

    ShowScriptOptions

    $Script:Word.Visible = $False

    #http://jdhitsolutions.com/blog/2012/05/san-diego-2012-powershell-deep-dive-slides-and-demos/
    #using Jeff's Demo-WordReport.ps1 file for examples
    Write-Verbose "$(Get-Date): Load Word Templates"

    [bool]$Script:CoverPagesExist = $False
    [bool]$BuildingBlocksExist = $False

    $Script:Word.Templates.LoadBuildingBlocks()
    #word 2010/2013
    $BuildingBlocksCollection = $Script:Word.Templates | Where {$_.name -eq "Built-In Building Blocks.dotx"}

    Write-Verbose "$(Get-Date): Attempt to load cover page $($CoverPage)"
    $part = $Null

    $BuildingBlocksCollection | 
    ForEach{
        If ($_.BuildingBlockEntries.Item($CoverPage).Name -eq $CoverPage) 
        {
            $BuildingBlocks = $_
        }
    }        

    If($BuildingBlocks -ne $Null)
    {
        $BuildingBlocksExist = $True

        Try 
        {
            $part = $BuildingBlocks.BuildingBlockEntries.Item($CoverPage)
        }

        Catch
        {
            $part = $Null
        }

        If($part -ne $Null)
        {
            $Script:CoverPagesExist = $True
        }
    }

    If(!$Script:CoverPagesExist)
    {
        Write-Verbose "$(Get-Date): Cover Pages are not installed or the Cover Page $($CoverPage) does not exist."
        Write-Warning "Cover Pages are not installed or the Cover Page $($CoverPage) does not exist."
        Write-Warning "This report will not have a Cover Page."
    }

    Write-Verbose "$(Get-Date): Create empty word doc"
    $Script:Doc = $Script:Word.Documents.Add()
    If($Script:Doc -eq $Null)
    {
        Write-Verbose "$(Get-Date): "
        $ErrorActionPreference = $SaveEAPreference
        Write-Error "`n`n`t`tAn empty Word document could not be created.`n`n`t`tScript cannot continue.`n`n"
        AbortScript
    }

    $Script:Selection = $Script:Word.Selection
    If($Script:Selection -eq $Null)
    {
        Write-Verbose "$(Get-Date): "
        $ErrorActionPreference = $SaveEAPreference
        Write-Error "`n`n`t`tAn unknown error happened selecting the entire Word document for default formatting options.`n`n`t`tScript cannot continue.`n`n"
        AbortScript
    }

    #set Default tab stops to 1/2 inch (this line is not from Jeff Hicks)
    #36 = .50"
    $Script:Word.ActiveDocument.DefaultTabStop = 36

    #Disable Spell and Grammar Check to resolve issue and improve performance (from Pat Coughlin)
    Write-Verbose "$(Get-Date): Disable grammar and spell checking"
    #bug reported 1-Apr-2014 by Tim Mangan
    #save current options first before turning them off
    $Script:CurrentGrammarOption = $Script:Word.Options.CheckGrammarAsYouType
    $Script:CurrentSpellingOption = $Script:Word.Options.CheckSpellingAsYouType
    $Script:Word.Options.CheckGrammarAsYouType = $False
    $Script:Word.Options.CheckSpellingAsYouType = $False

    If($BuildingBlocksExist)
    {
        #insert new page, getting ready for table of contents
        Write-Verbose "$(Get-Date): Insert new page, getting ready for table of contents"
        $part.Insert($Script:Selection.Range,$True) | Out-Null
        $Script:Selection.InsertNewPage()

        #table of contents
        Write-Verbose "$(Get-Date): Table of Contents - $($myHash.Word_TableOfContents)"
        $toc = $BuildingBlocks.BuildingBlockEntries.Item($myHash.Word_TableOfContents)
        If($toc -eq $Null)
        {
            Write-Verbose "$(Get-Date): "
            Write-Verbose "$(Get-Date): Table of Content - $($myHash.Word_TableOfContents) could not be retrieved."
            Write-Warning "This report will not have a Table of Contents."
        }
        Else
        {
            $toc.insert($Script:Selection.Range,$True) | Out-Null
        }
    }
    Else
    {
        Write-Verbose "$(Get-Date): Table of Contents are not installed."
        Write-Warning "Table of Contents are not installed so this report will not have a Table of Contents."
    }

    #set the footer
    Write-Verbose "$(Get-Date): Set the footer"
    [string]$footertext = "Report created by $username"

    #get the footer
    Write-Verbose "$(Get-Date): Get the footer and format font"
    $Script:Doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekPrimaryFooter
    #get the footer and format font
    $footers = $Script:Doc.Sections.Last.Footers
    ForEach ($footer in $footers) 
    {
        If($footer.exists) 
        {
            $footer.range.Font.name = "Calibri"
            $footer.range.Font.size = 8
            $footer.range.Font.Italic = $True
            $footer.range.Font.Bold = $True
        }
    } #end ForEach
    Write-Verbose "$(Get-Date): Footer text"
    $Script:Selection.HeaderFooter.Range.Text = $footerText

    #add page numbering
    Write-Verbose "$(Get-Date): Add page numbering"
    $Script:Selection.HeaderFooter.PageNumbers.Add($wdAlignPageNumberRight) | Out-Null

    FindWordDocumentEnd
    Write-Verbose "$(Get-Date):"
    #end of Jeff Hicks 
}

Function UpdateDocumentProperties
{
    Param([string]$AbstractTitle, [string]$SubjectTitle)
    #Update document properties
    If($MSWORD -or $PDF)
    {
        If($Script:CoverPagesExist)
        {
            Write-Verbose "$(Get-Date): Set Cover Page Properties"
            _SetDocumentProperty $Script:Doc.BuiltInDocumentProperties "Company" $Script:CoName
            _SetDocumentProperty $Script:Doc.BuiltInDocumentProperties "Title" $Script:title
            _SetDocumentProperty $Script:Doc.BuiltInDocumentProperties "Author" $username

            _SetDocumentProperty $Script:Doc.BuiltInDocumentProperties "Subject" $SubjectTitle

            #Get the Coverpage part
            $cp = $Script:Doc.CustomXMLParts | Where {$_.NamespaceURI -match "coverPageProps$"}

            #get the abstract XML part
            $ab = $cp.documentelement.ChildNodes | Where {$_.basename -eq "Abstract"}

            #set the text
            If([String]::IsNullOrEmpty($Script:CoName))
            {
                [string]$abstract = $AbstractTitle
            }
            Else
            {
                [string]$abstract = "$($AbstractTitle) for $Script:CoName"
            }

            $ab.Text = $abstract

            $ab = $cp.documentelement.ChildNodes | Where {$_.basename -eq "PublishDate"}
            #set the text
            [string]$abstract = (Get-Date -Format d).ToString()
            $ab.Text = $abstract

            Write-Verbose "$(Get-Date): Update the Table of Contents"
            #update the Table of Contents
            $Script:Doc.TablesOfContents.item(1).Update()
            $cp = $Null
            $ab = $Null
            $abstract = $Null
        }
    }
}

Function SaveandCloseDocumentandShutdownWord
{
    #bug fix 1-Apr-2014
    #reset Grammar and Spelling options back to their original settings
    $Script:Word.Options.CheckGrammarAsYouType = $Script:CurrentGrammarOption
    $Script:Word.Options.CheckSpellingAsYouType = $Script:CurrentSpellingOption

    Write-Verbose "$(Get-Date): Save and Close document and Shutdown Word"
    If($Script:WordVersion -eq $wdWord2010)
    {
        #the $saveFormat below passes StrictMode 2
        #I found this at the following two links
        #http://blogs.technet.com/b/bshukla/archive/2011/09/27/3347395.aspx
        #http://msdn.microsoft.com/en-us/library/microsoft.office.interop.word.wdsaveformat(v=office.14).aspx
        If($PDF)
        {
            Write-Verbose "$(Get-Date): Saving as DOCX file first before saving to PDF"
        }
        Else
        {
            Write-Verbose "$(Get-Date): Saving DOCX file"
        }
        If($AddDateTime)
        {
            $Script:FileName1 += "_$(Get-Date -f yyyy-MM-dd_HHmm).docx"
            If($PDF)
            {
                $Script:FileName2 += "_$(Get-Date -f yyyy-MM-dd_HHmm).pdf"
            }
        }
        $saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatDocumentDefault")
        $Script:Doc.SaveAs([REF]$Script:FileName1, [ref]$SaveFormat)
        If($PDF)
        {
            Write-Verbose "$(Get-Date): Now saving as PDF"
            $saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatPDF")
            $Script:Doc.SaveAs([REF]$Script:FileName2, [ref]$saveFormat)
        }
    }
    ElseIf($Script:WordVersion -eq $wdWord2013)
    {
        If($PDF)
        {
            Write-Verbose "$(Get-Date): Saving as DOCX file first before saving to PDF"
        }
        Else
        {
            Write-Verbose "$(Get-Date): Saving DOCX file"
        }
        If($AddDateTime)
        {
            $Script:FileName1 += "_$(Get-Date -f yyyy-MM-dd_HHmm).docx"
            If($PDF)
            {
                $Script:FileName2 += "_$(Get-Date -f yyyy-MM-dd_HHmm).pdf"
            }
        }
        Write-Verbose "$(Get-Date): Running Word 2013 and detected operating system $($RunningOS)"
        #$saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatDocumentDefault")
        $Script:Doc.SaveAs2([REF]$Script:FileName1, [ref]$wdFormatDocumentDefault)
        If($PDF)
        {
            Write-Verbose "$(Get-Date): Now saving as PDF"
            #$saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatPDF")
            $Script:Doc.SaveAs([REF]$Script:FileName2, [ref]$wdFormatPDF)
        }
    }

    Write-Verbose "$(Get-Date): Closing Word"
    $Script:Doc.Close()
    $Script:Word.Quit()
    If($PDF)
    {
        Write-Verbose "$(Get-Date): Deleting $($Script:FileName1) since only $($Script:FileName2) is needed"
        Remove-Item $Script:FileName1
    }
    Write-Verbose "$(Get-Date): System Cleanup"
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Script:Word) | Out-Null
    If(Test-Path variable:global:word)
    {
        Remove-Variable -Name word -Scope Global
    }
    $SaveFormat = $Null
    [gc]::collect() 
    [gc]::WaitForPendingFinalizers()
}

Function SaveandCloseTextDocument
{
    If($AddDateTime)
    {
        $Script:FileName1 += "_$(Get-Date -f yyyy-MM-dd_HHmm).txt"
    }

    Write-Output $Global:Output | Out-File $Script:Filename1
}

Function SaveandCloseHTMLDocument
{
    If($AddDateTime)
    {
        $Script:FileName1 += "_$(Get-Date -f yyyy-MM-dd_HHmm).html"
    }
}

Function SetFileName1andFileName2
{
    Param([string]$OutputFileName)
    $pwdpath = $pwd.Path

    If($pwdpath.EndsWith("\"))
    {
        #remove the trailing \
        $pwdpath = $pwdpath.SubString(0, ($pwdpath.Length - 1))
    }

    #set $filename1 and $filename2 with no file extension
    If($AddDateTime)
    {
        [string]$Script:FileName1 = "$($pwdpath)\$($OutputFileName)"
        If($PDF)
        {
            [string]$Script:FileName2 = "$($pwdpath)\$($OutputFileName)"
        }
    }

    If($MSWord -or $PDF)
    {
        CheckWordPreReq

        If(!$AddDateTime)
        {
            [string]$Script:FileName1 = "$($pwdpath)\$($OutputFileName).docx"
            If($PDF)
            {
                [string]$Script:FileName2 = "$($pwdpath)\$($OutputFileName).pdf"
            }
        }

        SetupWord
    }
    ElseIf($Text)
    {
        If(!$AddDateTime)
        {
            [string]$Script:FileName1 = "$($pwdpath)\$($OutputFileName).txt"
        }
    }
    ElseIf($HTML)
    {
        If(!$AddDateTime)
        {
            [string]$Script:FileName1 = "$($pwdpath)\$($OutputFileName).html"
        }
    }
}


#Script begins

$script:startTime = Get-Date

If($TEXT)
{
    $global:output = ""
}

<#
###The function SetFileName1andFileName2 needs your script output filename
SetFileName1andFileName2 "Script_Template"

###change title for your report
[string]$Script:Title = "This is the Report Title"
#>
#endregion script template

#region file name and title name
#The function SetFileName1andFileName2 needs your script output filename
SetFileName1andFileName2 "Nutanix Documentation Script"

#change title for your report
[string]$Script:Title = "Nutanix Documentation Script $CoName"
#endregion file name and title name

#region Loading cmdlets

# Copyright (c) 2014 Nutanix Inc. All rights reserved.
#
# Author : isha.singhal@nutanix.com
#
# Description: Script to Import all the cmdlets to powershell.

Param (
# The prefix to be added to all Nutanix cmdlet nouns to resolve name clashes
# with cmdlets from other libraries.
[Parameter(Mandatory = $False)]
[string] $nounPrefix = "NTNX"
)

# Get the path of the directory where current script is located.
# This is needed to get the path of Modules directory
# Modules folder has all the built DLLs.
# Each DLL in the module folder is placed inside a folder. This folder has the
# same name as the name of the DLL. This is structure in which powershell
# looks for all the DLLs.
$PSScriptLocation = Split-Path -Parent -Path $MyInvocation.MyCommand.Path

# Get the location of the Modules folder of the compiled DLLs. The modules
# folder lies in powershell\import_modules. Thus to get the path of
# modules folder we need two level of "..".
$dllPath = $PSScriptLocation + "\..\..\Modules"

# Get the installutil directory at runtime according to the installed .NET
# framework. installutil is used to register the snapin permanently on the
# user's system.
$installUtilDir = $( `
    [System.Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory())
$installUtilDir += "\installutil"
Set-Alias installutil  $installUtilDir
installUtil $dllPath\NutanixCmdletsPSSnapin.dll >> ""

# Check if installUtil is found or not. If not then give an appropriate message
# and exit.
if (Test-Path $installUtilDir)
{
    Write-Host "Installutil path could not be found."
    Write-Host ".NET Framework might be broken on your system."
    Write-Host "Please repair .NET Framework and try again."
    Exit
}

# Check if the Nutanix snapin is already added in this Powershell session.
# If not, then add the snapin.
$loaded = Get-PSSnapin -Name NutanixCmdletsPSSnapin `
    -ErrorAction SilentlyContinue | % {$_.Name}
if ($loaded -eq $null)
{
    Add-PSSnapin NutanixCmdletsPSSnapin
}

# Function to check if the type is enum and if the type is found to be enum,
# array of enum values is returned.
function getEnumValues($type)
{
    if ($type.IsEnum)
    {
        $values = [System.Enum]::GetValues($type)
    }

    return $values
}

$global:originalFunction = $function:TabExpansion

# This function is called by powershell by default whenever tab is pressed. Thus
# it is extended to support the tab expansion for enum values.
function global:TabExpansion
{
    # Tab expansion function in Powershell expects two parameters, line and
    # lastWord. The first parameter is the full line typed by the user and
    # second parameter is the last word/letter typed by user before pressing
    # tab. Thus if user types "Get-NTNXAlert -i" and presses tab, then first
    # parameter is the complete line : "Get-NTNXAlert -i" and the second
    # parameter is "i".
    param($line, $lastWord)

    $originalRes = & $global:originalFunction $line $lastWord

    # If the inbuilt tab expansion function returns some value then return
    # that value.
    if ($originalRes)
    {
        return $originalRes
    }

    # Tokenize the whole line entered by the user and get each token as type
    # "token" in powershell. This is needed to get complete line which was
    # entered by the user, tokenized in form of powershell tokens so that we can
    # check the type of the last token etc.
    $tokens = [System.Management.Automation.PSParser]::Tokenize( `
        $line, [ref] $null)

    if ($tokens)
    {
        $lastVal = $tokens[$tokens.count - 1]

        $startVal = ""

        # Check the type of the last token.
        switch($lastVal.Type)
        {
            # If the last token is CommandParameter type then just store it
            # directly.
            'CommandParameter'
            {
                $paramToken = $lastVal
            }

            # If the last token is CommandArgument, then the parameter name will
            # be the second last entry in the "tokens" array.
            'CommandArgument'
            {
                if($lastWord)
                {
                    $startVal = $lastWord

                    $prevToken = $tokens[$tokens.count - 2]
                    if ($prevToken.Type -eq 'CommandParameter')
                    {
                        $paramToken = $prevToken
                    }
                }
            }
        }

        # If user pressed tab after entering the parameter name then we need to
        # check if the parameter is of type enum or list of type enum. For doing
        # this we need to extract the cmdlet name from the list of tokens.
        if ($paramToken)
        {
            [int]$groupLevel = 0
            for($i = $tokens.Count-1; $i -ge 0; $i--)
            {
                $currentToken = $tokens[$i]
                if (($currentToken.Type -eq 'Command') -and `
                    ($groupLevel -eq 0) )
                {
                    $cmdletToken = $currentToken
                    break;
                }

                if ($currentToken.Type -eq 'GroupEnd')
                {
                   $groupLevel += 1
                }

                if ($currentToken.Type -eq 'GroupStart')
                {
                    $groupLevel -= 1
                }
            }

            if ($cmdletToken)
            {
                # Get the complete definition of the cmdlet for which user
                # pressed tab.
                $cmdlet = Get-Command $cmdletToken.Content
                $parameter = `
                    $cmdlet.Parameters[$paramToken.Content.Replace('-','')]

                $parameterType = $parameter.ParameterType

                # Get the vaues of the enum type if the parameter was of type
                # enum or list/array of type enum.
                if ($parameterType.IsEnum)
                {
                    $values = getEnumValues($parameterType)
                }
                elseif ($parameterType.IsArray)
                {
                    $elementType = $parameterType.GetElementType()
                    $values = getEnumValues($elementType)
                }
                elseif ($parameterType.Name.Contains("List"))
                {
                    $genericType = $parameterType.GetGenericArguments()[0]
                    $values = getEnumValues($genericType)
                }

                if($values)
                {
                    if ($startVal)
                    {
                        return ($values | where { $_ -like "${startVal}*" })
                    }
                    else
                    {
                        return $values
                    }
                }
            }
        }
    }
}




#endregion Loading cmdlets completed

#region Nutanix Connection 
## Steven Potrais - Connecting to the Nutanix node

$nxServerObj = Connect-NutanixCluster -Server $nxIP -UserName $nxUser -Password $nxPassword -AcceptInvalidSSLCerts
 
# Connect-NutanixCluster -Server 1.1.1.1 -UserName admin -Password admin -AcceptInvalidSSLCerts

#endregion Nutanix Connection Complete

#region Nutanix chaptercounters
$Chapters = 1
$Chapter = 0
#endregion Nutanix chaptercounters

#region Nutanix Cluster Configuration

$Chapter++
Write-Verbose "$(Get-Date): Chapter $Chapter/$Nutanix Cluster Information"
WriteWordLine 1 0 "Nutanix Cluster Information"

WriteWordLine 3 0 "Nutanix Cluster Configuration"

 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $ClusterConfigs = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($ClusterConfig in Get-NTNXCluster) {
    ## IB - Add each enumerated object to the array
    $ClusterConfigs += @{
        "ID" = $ClusterConfig.id;
        "Uuid" = $ClusterConfig.clusterUuid;
        "Name" = $ClusterConfig.name;
        "External IP" = $ClusterConfig.clusterExternalIPAddress;
        "TimeZone" = $ClusterConfig.timezone;
        "Support Type" = $ClusterConfig.supportVerbosityType;
        "Number of Nodes" = $ClusterConfig.numNodes;
        "Serials" = $ClusterConfig.blockSerials;
        "Version" = $ClusterConfig.version;
        "External Subnet" = $ClusterConfig.externalSubnet;
        "Internal Subnet" = $ClusterConfig.internalSubnet;
        "Lockdown enabled" = $ClusterConfig.enableLockDown;
        "Remote Login Enabled" = $ClusterConfig.enablePasswordRemoteLoginToCluster;
        "Fingerprint Cache %" = $ClusterConfig.fingerprintContentCachePercentage;
        "Shadow Clones Enabled" = $ClusterConfig.enableShadowClones;
        "Name Servers" = $ClusterConfig.nameServers;
        "NTP Servers" = $ClusterConfig.ntpServers;
        "Hypervisors" = $ClusterConfig.hypervisorTypes;
        "Multicluster" = $ClusterConfig.multicluster;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $ClusterConfigs;
    Columns = "ID","Uuid","Name","External IP","Timezone","Serials";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "

$Params = $null    
$Params = @{       
   
    
    Hashtable = $ClusterConfigs;
    Columns = "ID","External Subnet","Internal Subnet","Lockdown Enabled","Remote Login Enabled","Fingerprint Cache %";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "

$Params = $null    
$Params = @{       
   
    
    Hashtable = $ClusterConfigs;
    Columns = "ID","Shadow Clones Enabled","Name Servers","NTP Servers","Hypervisors","Multicluster","Number of Nodes";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "
#endregion Nutanix Cluster Configuration

#region Nutanix Cluster Alerts and Events

    If($Full)
    {

WriteWordLine 3 0 "Nutanix Cluster Alerts"


<#
.Synopsis
    Resolves a Nutanix Cluster message
#>
function Get-NTNXMultiClusterAlertMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [System.Object[]] $NTNXMultiClusterAlert
    )
    process {
        foreach ($alert in $NTNXMultiClusterAlert) {
            $message = $alert.Message;
            for ($i = 0; $i -lt ($alert.contextTypes).Count; $i++) {
                ## Don't replace any text with an empty key!
                if (-not [System.String]::IsNullOrEmpty($alert.contextTypes[$i])) {
                    ## Replace the key with the associated text.
                    $message = $message.Replace("{$($alert.contextTypes[$i])}", $alert.contextValues[$i]);
                } #end if
            } #end for
            Write-Output $message;
        } #end foreach
    } #end process
} #end function Get-NTNXMultiClusterAlertMessage
 
$alerts = NTNXMultiClusterAlert; 
 
## Create an empty array of hashtables to store each table row
[System.Collections.Hashtable[]] $Messages = @();
## Enumerate each alert
foreach ($message in (Get-NTNXMultiClusterAlertMessage –NTNXMultiClusterAlert $alerts)) {
 if ($messages.Resolved -eq $false) {
    ## Add each individual alert as an individual hashtable
    $Messages += @{ Message = $message; }
}
}
 
 
$Params = $null   
$Params = @{      
    Hashtable = $Messages;
    Format = -235;
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 "Note: If this (sub) chapter is empty there are no critical alerts"


WriteWordLine 3 0 "Nutanix Cluster Events"

<#
.Synopsis
    Resolves a Nutanix Cluster Event message
#>
function Get-NTNXMultiClusterEventMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [System.Object[]] $NTNXMultiClusterEvent
    )
    process {
        foreach ($alert in $NTNXMultiClusterEvent) {
            $message = $alert.Message;
            for ($i = 0; $i -lt ($alert.contextTypes).Count; $i++) {
                ## Don't replace any text with an empty key!
                if (-not [System.String]::IsNullOrEmpty($alert.contextTypes[$i])) {
                    ## Replace the key with the associated text.
                    $message = $message.Replace("{$($alert.contextTypes[$i])}", $alert.contextValues[$i]);
                } #end if
            } #end for
            Write-Output $message;
        } #end foreach
    } #end process
} #end function Get-NTNXMultiClusterEventMessage
 
$alerts = Get-NTNXMultiClusterEvent; 
 
## Create an empty array of hashtables to store each table row
[System.Collections.Hashtable[]] $Messages = @();
## Enumerate each alert
foreach ($message in (Get-NTNXMultiClusterEventMessage –NTNXMultiClusterEvent $alerts)) {
  if ($messages.Resolved -eq $false) {
    ## Add each individual alert as an individual hashtable
    $Messages += @{ Message = $message; }
}
}
 
 
$Params = $null   
$Params = @{      
    Hashtable = $Messages;
    Format = -235;
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 "Note: If this (sub) chapter is empty there are no critical alerts"

}

#endregion Nutanix Cluster Alerts and Events

#region Nutanix Licensing Configuration

$Chapter++
Write-Verbose "$(Get-Date): Chapter $Chapter/$Nutanix Licensing Information"
WriteWordLine 1 0 "Nutanix Licensing Information"

WriteWordLine 3 0 "Nutanix Cluster Licensing"

 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $ClusterLicenseConfigs = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($ClusterLicenseConfig in Get-NTNXClusterLicenseInfo) {
    ## IB - Add each enumerated object to the array
    $ClusterLicenseConfigs += @{
        "CLuster Uuid" = $ClusterLicenseConfig.cluster_uuid;
        "Standby Mode" = $ClusterLicenseConfig.standby_mode;
        "Signature" = $ClusterLicenseConfig.signature;
        "Block Serial List" = $ClusterLicenseConfig.block_serial_list;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $ClusterLicenseConfigs;
    
    
    Columns = "Cluster Uuid","Standby Mode","Signature","Block Serial List";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;


WriteWordLine 0 0 " "

WriteWordLine 3 0 "Nutanix Licensing"

 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $LicensingConfigs = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($LicensingConfig in Get-NTNXLicense) {
    ## IB - Add each enumerated object to the array
    $LicensingConfigs += @{
        "Category" = $LicensingConfig.category;
        "Expiry" = $LicensingConfig.clusterExpiryUsecs;
        "standbyMode" = $LicensingConfig.standbyMode;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $LicensingConfigs;
    
    
    Columns = "Category","Expiry","standbyMode";
    ## IB - You only need quote the values if they contain spaces.
    
    
   
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "

WriteWordLine 3 0 "Nutanix License Allowance"

 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $LicAllowanceConfigs = @();

 
## IB - Loop through each returned rackable unit/object
foreach ($LicAllowanceConfig in Get-NTNXLicenseAllowance) {
 if ($LicAllowanceConfig.Value -like "Nutanix.Prism.DTO.License.AllowancesDTO") { 
    ## IB - Add each enumerated object to the array
    $LicAllowanceConfigs += @{
        "Key" = $LicAllowanceConfig.Key;
        "Value" = "Enabled";
    };
} # end foreach

else { 

    ## IB - Add each enumerated object to the array
    $LicAllowanceConfigs += @{
        "Key" = $LicAllowanceConfig.Key;
        "Value" = $LicAllowanceConfig.Value;
}
}
}
$Params = $null    
$Params = @{       
   
    
    Hashtable = $LicAllowanceConfigs;
    Columns = "Key","Value";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "


#endregion Nutanix Licensing Configuration

#region Nutanix Rackable Unit Information

$Chapter++
Write-Verbose "$(Get-Date): Chapter $Chapter/$Nutanix System Information"
WriteWordLine 2 0 "Nutanix System Information"

WriteWordLine 3 0 "Nutanix System Information"
 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $rackableUnits = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($rackableUnit in Get-NTNXRackableUnit ) {
    ## IB - Add each enumerated object to the array
    $rackableUnits += @{
        ID = $rackableUnit.Id;
        Model = $rackableUnit.Model;
        Location = $rackableUnit.Location;
        Serial = $rackableUnit.Serial;
        Positions = $rackableUnit.Positions;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $rackableUnits;   
    Columns = "ID","Model","Location","Serial","Positions";  
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "


#endregion Nutanix Rackable Unit Information

#region Nutanix Remote Support Settings


WriteWordLine 3 0 "Remote Support Setting"

## IB - Create a typed arrayof Hashtables
[System.Collections.Hashtable[]] $RemoteSupportConfigs = @();

 
## IB - Loop through each returned rackable unit/object
foreach ($RemoteSupportConfig in Get-NTNXRemoteSupportSetting) {
 if ($RemoteSupportConfig.Enable -like "Nutanix.Prism.DTO.Appliance.Configuration.TimedBoolDTO") { 
    ## IB - Add each enumerated object to the array
    $RemoteSupportConfigs += @{
        "Enabled" = "True";
        "Details" = "Enabled";
    };
} # end foreach

else { 

    ## IB - Add each enumerated object to the array
    $RemoteSupportConfigs += @{
        "Enabled" = $RemoteSupportConfig.enable;
        "Detail" = $RemoteSupportConfig.tunnelDetails;
}
}
}
$Params = $null    
$Params = @{       
   
    
    Hashtable = $RemoteSupportConfigs;
    Columns = "Enabled","Details";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;
 
WriteWordLine 0 0 " "

#endregion Remote Support Settings

#region Nutanix SMTP Settings

WriteWordLine 3 0 "SMTP Settings"

## IB - Rather than repeatedly calling the Get-NTXRackableUnit cmdlet, we'll store the value
$SMTPSetting = Get-NTNXSmtpServer;
$Params = $null    
$Params = @{       
    Hashtable = @( ## IB - The -Hashtable parameter needs an array of hashtables. Note the @( and not @{
        @{         ## IB - This is a hash table. As it's the first, it'll be the first row in the table
            "SMTP Server" = $SMTPSetting.address;
            "Port" = $SMTPSetting.port;
            "User Name" = $SMTPSetting.username;
            "Secure Mode" = $SMTPSetting.secureMode;
            "Email Address" = $SMTPSetting.fromEmailAddress;
        })

    
    
    Columns = "SMTP Server","Port","User Name","Secure Mode","Email Address";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
 
FindWordDocumentEnd;
 
WriteWordLine 0 0 " "

#endregion SMTP Settings

#region Nutanix SNMP Settings

 WriteWordLine 3 0 "SNMP Settings"

## IB - Rather than repeatedly calling the Get-NTXRackableUnit cmdlet, we'll store the value
 $SNMPSetting = Get-NTNXSnmpInfo;
 $SNMPTrap = Get-NTNXSnmpTrap;
 $SNMPUser = Get-NTNXSNMPUser;

 $Params = $null    
 $Params = @{       
    Hashtable = @( ## IB - The -Hashtable parameter needs an array of hashtables. Note the @( and not @{
        @{         ## IB - This is a hash table. As it's the first, it'll be the first row in the table
            "SNMP Enabled" = $SNMPSetting.enabled;
            "Trap" = $SNMPTrap
            "User Name" = $SNMPUser;
        })

    
    Columns = "SNMP Enabled","Trap","User Name";   
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
 
FindWordDocumentEnd;
 
WriteWordLine 0 0 " "

#endregion SNMP Settings

#region Nutanix Host Configuration

$Chapter++
Write-Verbose "$(Get-Date): Chapter $Chapter/$Nutanix IP Configuration"
WriteWordLine 3 0 "Nutanix IP Configuration"
 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $hostconfigs = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($hostconfig in Get-NTNXHost) {
    ## IB - Add each enumerated object to the array
    $hostconfigs += @{
        "Name" = $hostconfig.Name;
        "Model" = $hostconfig.blockModel;
        "CVM" = $hostconfig.serviceVMExternalIP;
        "Hypervisor IP" = $hostconfig.hypervisorAddress;
        "IPMI Address" = $hostconfig.ipmiAddress;
        "State" = $hostconfig.State;
        "Serial" = $hostconfig.Serial;
        "Block Serial" = $hostconfig.blockSerial;
        "MetaDataStatus" = $hostconfig.metadataStoreStatus;
        "CPU Model" = $hostconfig.cpuModel;
        "Number of CPU Cores" = $hostconfig.numCpuCores;
        "Number of CPU Sockets" = $hostconfig.numCpuSockets;
        "CPU in Hz" = $hostconfig.cpuFrequencyInHz;
        "Memory in GB" = [math]::truncate($hostconfig.memoryCapacityInBytes /1GB);
        "Hypervisor" = $hostconfig.hypervisorFullName;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $hostconfigs;   
    Columns = "Name","Model","CVM","Hypervisor IP","IPMI Address","State";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "

WriteWordLine 3 0 "Nutanix Serial Configuration"

$Params = $null    
$Params = @{       
   
    
    Hashtable = $hostconfigs;
    Columns = "Name","Serial","Block Serial","MetaDataStatus";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "

WriteWordLine 3 0 "Nutanix CPU Configuration"

$Params = $null    
$Params = @{       
   
    
    Hashtable = $hostconfigs;
    Columns = "Name","CPU Model","Number of CPU Cores","Number of CPU Sockets","CPU in Hz";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "

WriteWordLine 3 0 "Nutanix Memory Configuration"

$Params = $null    
$Params = @{       
   
    
    Hashtable = $hostconfigs; 
    Columns = "Name","Memory In GB";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "

#endregion Nutanix Host Configuration

#region Nutanix Host Alerts and Events

    If($Full)
    {

WriteWordLine 3 0 "Nutanix Alerts"


<#
.Synopsis
    Resolves a Nutanix host alert message
#>
function Get-NTNXHostAlertMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [System.Object[]] $NTNXHostAlert
    )
    process {
        foreach ($alert in $NTNXHostAlert) {
            $message = $alert.Message;
            for ($i = 0; $i -lt ($alert.contextTypes).Count; $i++) {
                ## Don't replace any text with an empty key!
                if (-not [System.String]::IsNullOrEmpty($alert.contextTypes[$i])) {
                    ## Replace the key with the associated text.
                    $message = $message.Replace("{$($alert.contextTypes[$i])}", $alert.contextValues[$i]);
                } #end if
            } #end for
            Write-Output $message;
        } #end foreach
    } #end process
} #end function Get-NTNXHostAlertMessage
 
$alerts = NTNXHostAlert; 
 
## Create an empty array of hashtables to store each table row
[System.Collections.Hashtable[]] $Messages = @();
## Enumerate each alert
foreach ($message in (Get-NTNXHostAlertMessage –NTNXHostAlert $alerts)) {
 if ($messages.Resolved -eq $false) {
    ## Add each individual alert as an individual hashtable
    $Messages += @{ Message = $message; }
}
} 
 
$Params = $null   
$Params = @{      
    Hashtable = $Messages;
    Format = -235;
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 "Note: If this (sub) chapter is empty there are no critical alerts"


WriteWordLine 0 0 " "

WriteWordLine 3 0 "Nutanix Events"


<#
.Synopsis
    Resolves a Nutanix host event message
#>
function Get-NTNXHostEventMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [System.Object[]] $NTNXHostEvent
    )
    process {
        foreach ($alert in $NTNXHostEvent) {
            $message = $alert.Message;
            for ($i = 0; $i -lt ($alert.contextTypes).Count; $i++) {
                ## Don't replace any text with an empty key!
                if (-not [System.String]::IsNullOrEmpty($alert.contextTypes[$i])) {
                    ## Replace the key with the associated text.
                    $message = $message.Replace("{$($alert.contextTypes[$i])}", $alert.contextValues[$i]);
                } #end if
            } #end for
            Write-Output $message;
        } #end foreach
    } #end process
} #end function Get-NTNXHostEventMessage
 
$alerts = Get-NTNXHostEvent; 
 
## Create an empty array of hashtables to store each table row
[System.Collections.Hashtable[]] $Messages = @();
## Enumerate each alert
foreach ($message in (Get-NTNXHostEventMessage –NTNXHostEvent $alerts)) {
 if ($messages.Resolved -eq $false) {
    ## Add each individual alert as an individual hashtable
    $Messages += @{ Message = $message; }
}
}
 
 
$Params = $null   
$Params = @{      
    Hashtable = $Messages;
    Format = -235;
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 "Note: If this (sub) chapter is empty there are no critical alerts"



WriteWordLine 0 0 " "
}

#endregion Nutanix Host Alerts and Events

#region Nutanix Harware Alerts

    If($Full)
    {
$Chapter++
Write-Verbose "$(Get-Date): Chapter $Chapter/$Nutanix Host Alerts"
WriteWordLine 1 0 "Nutanix Host Alerts"

WriteWordLine 3 0 "Nutanix Hardware Alerts"

<#
.Synopsis
    Resolves a Nutanix hardware alert message
#>
function Get-NTNXHardwareAlertMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [System.Object[]] $NTNXHardwareAlert
    )
    process {
        foreach ($alert in $NTNXHardwareAlert) {
            $message = $alert.Message;
            for ($i = 0; $i -lt ($alert.contextTypes).Count; $i++) {
                ## Don't replace any text with an empty key!
                if (-not [System.String]::IsNullOrEmpty($alert.contextTypes[$i])) {
                    ## Replace the key with the associated text.
                    $message = $message.Replace("{$($alert.contextTypes[$i])}", $alert.contextValues[$i]);
                } #end if
            } #end for
            Write-Output $message;
        } #end foreach
    } #end process
} #end function Get-NTNXHardwareAlertMessage
 
$alerts = Get-NTNXHardwareAlert; 
 
## Create an empty array of hashtables to store each table row
[System.Collections.Hashtable[]] $Messages = @();
## Enumerate each alert
foreach ($message in (Get-NTNXHardwareAlertMessage –NTNXHardwareAlert $alerts)) {
 #if ($messages.Resolved -eq $false) {
    ## Add each individual alert as an individual hashtable
    $Messages += @{ Message = $message; }
}
#}
 
 
$Params = $null   
$Params = @{      
    Hashtable = $Messages;
    Format = -235;
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 "Note: If this (sub) chapter is empty there are no critical alerts"

WriteWordLine 0 0 " "

WriteWordLine 3 0 "Nutanix Critical Alerts"

<#
.Synopsis
    Resolves a Nutanix hardware alert message
#>
function Get-NTNXAlertMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [System.Object[]] $NTNXAlert
    )
    process {
        foreach ($alert in $NTNXAlert) {
            $message = $alert.Message;
            for ($i = 0; $i -lt ($alert.contextTypes).Count; $i++) {
                ## Don't replace any text with an empty key!
                if (-not [System.String]::IsNullOrEmpty($alert.contextTypes[$i])) {
                    ## Replace the key with the associated text.
                    $message = $message.Replace("{$($alert.contextTypes[$i])}", $alert.contextValues[$i]);
                } #end if
            } #end for
            Write-Output $message;
        } #end foreach
    } #end process
} #end function Get-NTNXAlertMessage
 
$alerts = Get-NTNXAlert; 
 
## Create an empty array of hashtables to store each table row
[System.Collections.Hashtable[]] $Messages = @();
## Enumerate each alert
foreach ($message in (Get-NTNXAlertMessage –NTNXAlert $alerts)) {
 #if ($messages.Resolved -eq $false) {
    ## Add each individual alert as an individual hashtable
    $Messages += @{ Message = $message; }
}
#}
 
 
$Params = $null   
$Params = @{      
    Hashtable = $Messages;
    Format = -235;
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 "Note: If this (sub) chapter is empty there are no critical alerts"

WriteWordLine 0 0 " "

WriteWordLine 3 0 "Nutanix Metadata Alerts"

 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $MDAlerts = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($MDAlert in Get-NTNXAlertMetadata) {
    ## IB - Add each enumerated object to the array
    $MDAlerts += @{
        "Severity" = $MDAlert.severity;
        "Message" = $MDAlert.message;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $MDAlerts;
    Columns = "Severity","Message";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 "Note: If this (sub) chapter is empty there are no critical alerts"
}
WriteWordLine 0 0 " "


WriteWordLine 0 0 " "

#endregion Nutanix Host Alerts

#region Nutanix Authentication

$Chapter++
Write-Verbose "$(Get-Date): Chapter $Chapter/$Nutanix Authentication"
WriteWordLine 1 0 "Nutanix Authentication"

WriteWordLine 3 0 "Nutanix Authentication Configuration"

 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $AuthConfigs = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($AuthConfig in Get-NTNXAuthConfigDirectory) {
    ## IB - Add each enumerated object to the array
    $AuthConfigs += @{
        "Directory Type" = $AuthConfig.directoryType;
        "Connection" = $AuthConfig.connectionType;
        "URL" = $AuthConfig.directoryURL;
        "Domain" = $AuthConfig.domain;
         "Name" = $AuthConfig.name;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $AuthConfigs;
    Columns = "Directory Type","Connection","URL","Domain","Name";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "


#endregion Nutanix Authentication Configuration

#region Nutanix General Info

$Chapter++
Write-Verbose "$(Get-Date): Chapter $Chapter/$Nutanix General Info"
WriteWordLine 1 0 "Nutanix General Info"

WriteWordLine 3 0 "Nutanix Cmdlets Info"

 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $CmdLets = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($CmdLet in Get-NutanixCmdletsInfo) {
    ## IB - Add each enumerated object to the array
    $CmdLets += @{
        "Version" = $CmdLet.version;
        "Build Version" = $CmdLet.BuildVersion;
        "REST API Version" = $CmdLet.RestAPIVersion;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $CmdLets;
    Columns = "Version","Build Version","REST API Version";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "


#endregion Nutanix General Info

#region Nutanix Storage Pool Information

$Chapter++
Write-Verbose "$(Get-Date): Chapter $Chapter/$Nutanix Storage Pool Information"
WriteWordLine 1 0 "Nutanix Storage Pool Information"

WriteWordLine 3 0 "Nutanix Storage Pool"

 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $StoragePools = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($StoragePool in Get-NTNXStoragePool) {
    ## IB - Add each enumerated object to the array
    $StoragePools += @{
        "ID" = $StoragePool.id;
        "Name" = $StoragePool.name;
        "Capacity in GB" =  [math]::truncate($StoragePool.capacity /1GB);
        "Reserved Capacity in GB" =  [math]::truncate($StoragePool.reservedCapacity /1GB);
        "ILM Threshold" = $StoragePool.ilmDownMigratePctThreshold;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $StoragePools;
    Columns = "ID","Name","Capacity in GB","Reserved Capacity in GB","ILM Threshold";
   
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "

#endregion Nutanix Storage Pools

#region Nutanix Storage Pool Events

    If($Full)
    {
WriteWordLine 3 0 "Nutanix Storage Pool Events"

<#
.Synopsis
    Resolves a Nutanix Store Pool Events message
#>
function Get-NTNXStoragePoolEventMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [System.Object[]] $NTNXStoragePoolEvent
    )
    process {
        foreach ($alert in $NTNXStoragePoolEvent) {
            $message = $alert.Message;
            for ($i = 0; $i -lt ($alert.contextTypes).Count; $i++) {
                ## Don't replace any text with an empty key!
                if (-not [System.String]::IsNullOrEmpty($alert.contextTypes[$i])) {
                    ## Replace the key with the associated text.
                    $message = $message.Replace("{$($alert.contextTypes[$i])}", $alert.contextValues[$i]);
                } #end if
            } #end for
            Write-Output $message;
        } #end foreach
    } #end process
} #end function Get-NTNXStoragePoolEventMessage
 
$alerts = Get-NTNXStoragePoolEvent; 
 
## Create an empty array of hashtables to store each table row
[System.Collections.Hashtable[]] $Messages = @();
## Enumerate each alert
foreach ($message in (Get-NTNXStoragePoolEventMessage –NTNXStoragePoolEvent $alerts)) {
 if ($messages.Resolved -eq $false) {
    ## Add each individual alert as an individual hashtable
    $Messages += @{ Message = $message; }
}
}
 
 
$Params = $null   
$Params = @{      
    Hashtable = $Messages;
    Format = -235;
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 "Note: If this (sub) chapter is empty there are no critical alerts"

WriteWordLine 0 0 " "
}
WriteWordLine 0 0 " "


#endregion Nutanix Storage Pool Events

#region Nutanix Container Information

$Chapter++
Write-Verbose "$(Get-Date): Chapter $Chapter/$Nutanix Container Information"
WriteWordL
ine 1 0 "Container Information"

WriteWordLine 3 0 "Nutanix Containers"

 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $Containers = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($Container in Get-NTNXContainer) {
    ## IB - Add each enumerated object to the array
    $Containers += @{
        "Name" = $Container.name;
        "Pool ID" = $Container.storagePoolId;
        "Marked for removal" = $Container.markedForRemoval;
        "Max Capacity in GB" = [math]::truncate($Container.maxCapacity /1GB);
        "Explicit Reserved in GB" = [math]::truncate($Container.totalExplicitReservedCapacity /1GB);
        "Implicit Reserved in GB" = [math]::truncate($Container.totalImplicitReservedCapacity /1GB);
        "RF" = $Container.replicationFactor;
        "OpLog RF" = $Container.oplogReplicationFactor;
        "Provisioned Capacity in GB" = [math]::truncate($Container.provisionedCapacity /1GB);
        "Fingerprint on Write" = $Container.fingerPrintOnWrite;
        "On Disk Dedup" = $Container.onDiskDedup;
        "Compression enabled" = $Container.compressionEnabled;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $Containers;
    Columns = "Name","Pool ID","Marked for removal","Max Capacity in GB","Explicit Reserved in GB","Implicit Reserved in GB";
    Format = -235; ## IB - Word constant for Light Grid Accent 5 (getcould use -207 for Accent 3 (grey))
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "

$Params = $null    
$Params = @{       
   
    
    Hashtable = $Containers;
    Columns = "Name","RF","OpLog RF","Provisioned Capacity in GB","Fingerprint on Write","On Disk Dedup","Compression enabled";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "

WriteWordLine 3 0 "Nutanix NFS Datastores"

 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $DataStores = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($DataStore in Get-NTNXNfsDatastore) {
    ## IB - Add each enumerated object to the array
    $DataStores += @{
        "Name" = $DataStore.containerName;
        "Container" = $DataStore.containerId;
        "Host ID" = $DataStore.HostId;
        "Host IP" = $DataStore.hostIpAddress;
        "Total capacity in GB" =  [math]::truncate($DataStore.capacity /1GB);
        "Free Space in GB" =  [math]::truncate($DataStore.freeSpace /1GB);
#        "VMs" = $DataStore.vmNames;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $DataStores;
    Columns = "Name","Container","Host ID","Host IP","Total capacity in GB","Free Space in GB";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
 }
 $Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "


#endregion Nutanix Container Configuration

#region Nutanix Disk Configuration

$Chapter++
Write-Verbose "$(Get-Date): Chapter $Chapter/$Nutanix Disk Information"
WriteWordLine 1 0 "Nutanix Disk Information"

WriteWordLine 3 0 "Nutanix Disk Configuration"

 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $DiskConfigs = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($DiskConfig in Get-NTNXDisk) {
    ## IB - Add each enumerated object to the array
    $DiskConfigs += @{
        "ID" = $DiskConfig.id;
        "Mount Path" = $DiskConfig.mountPath;
        "Disk Size in GB" =  [math]::truncate($DiskConfig.diskSize /1GB);
        "Hostname" = $DiskConfig.hostName;
        "CVM IP" = $DiskConfig.cvmIpAddress;
        "Tier Name" = $DiskConfig.storageTierName;
        "Removal" = $DiskConfig.markedForRemoval;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $DiskConfigs;
    Columns = "ID","Mount Path","Disk Size in GB","Hostname","CVM IP","Tier Name","Removal";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;


WriteWordLine 0 0 " "

#endregion Nutanix Disk Configuration

#region Nutanix Disk Alerts and Events

    If($Full)
    {

WriteWordLine 3 0 "Nutanix Disk Alerts"

<#
.Synopsis
    Resolves a Nutanix Disk Alerts
#>
function Get-NTNXDiskAlertMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [System.Object[]] $NTNXDiskAlert
    )
    process {
        foreach ($alert in $NTNXDiskAlert) {
            $message = $alert.Message;
            for ($i = 0; $i -lt ($alert.contextTypes).Count; $i++) {
                ## Don't replace any text with an empty key!
                if (-not [System.String]::IsNullOrEmpty($alert.contextTypes[$i])) {
                    ## Replace the key with the associated text.
                    $message = $message.Replace("{$($alert.contextTypes[$i])}", $alert.contextValues[$i]);
                } #end if
            } #end for
            Write-Output $message;
        } #end foreach
    } #end process
} #end function Get-NTNXDiskAlertMessage
 
$alerts = Get-NTNXDiskAlert; 
 
## Create an empty array of hashtables to store each table row
[System.Collections.Hashtable[]] $Messages = @();
## Enumerate each alert
foreach ($message in (Get-NTNXDiskAlertMessage –NTNXDiskAlert $alerts)) {
 #if ($messages.Resolved -eq $false) {
    ## Add each individual alert as an individual hashtable
    $Messages += @{ Message = $message; }
}
#}
 
 
$Params = $null   
$Params = @{      
    Hashtable = $Messages;
    Format = -235;
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 "Note: If this (sub) chapter is empty there are no critical alerts"


WriteWordLine 3 0 "Nutanix Disk Events"


<#
.Synopsis
    Resolves a Nutanix Disk Event message
#>
function Get-ntnxdiskeventMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [System.Object[]] $ntnxdiskevent
    )
    process {
        foreach ($alert in $ntnxdiskevent) {
            $message = $alert.Message;
            for ($i = 0; $i -lt ($alert.contextTypes).Count; $i++) {
                ## Don't replace any text with an empty key!
                if (-not [System.String]::IsNullOrEmpty($alert.contextTypes[$i])) {
                    ## Replace the key with the associated text.
                    $message = $message.Replace("{$($alert.contextTypes[$i])}", $alert.contextValues[$i]);
                } #end if
            } #end for
            Write-Output $message;
        } #end foreach
    } #end process
} #end function Get-ntnxdiskeventMessage
 
$alerts = Get-ntnxdiskevent; 
 
## Create an empty array of hashtables to store each table row
[System.Collections.Hashtable[]] $Messages = @();
## Enumerate each alert
foreach ($message in (Get-ntnxdiskeventMessage –ntnxdiskevent $alerts)) {
 #if ($messages.Resolved -eq $false) {
    ## Add each individual alert as an individual hashtable
    $Messages += @{ Message = $message; }
}
#}
 
 
$Params = $null   
$Params = @{      
    Hashtable = $Messages;
    Format = -235;
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 "Note: If this (sub) chapter is empty there are no critical alerts"

}

#endregion Nutanix Disk Alerts and Events

#region Nutanix Health

$Chapter++
Write-Verbose "$(Get-Date): Chapter $Chapter/$Nutanix Events"
WriteWordLine 1 0 "Nutanix Health"

WriteWordLine 3 0 "Nutanix Health Check"

 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $HealthChecks = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($HealthCheck in Get-NTNXHealthCheck) {
    ## IB - Add each enumerated object to the array
    $HealthChecks += @{
        "ID" = $HealthCheck.id;
        "Name" = $HealthCheck.name;
        "Description" = $HealthCheck.description;
        "Causes" = $HealthCheck.causes;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $HealthChecks;
    Columns = "ID","Name","Description","Causes";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "


    If($Full)
    {
WriteWordLine 3 0 "Nutanix Events"

<#
.Synopsis
    Resolves a Nutanix Event message
#>
function Get-NTNXEventMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [System.Object[]] $NTNXEvent
    )
    process {
        foreach ($alert in $NTNXEvent) {
            $message = $alert.Message;
            for ($i = 0; $i -lt ($alert.contextTypes).Count; $i++) {
                ## Don't replace any text with an empty key!
                if (-not [System.String]::IsNullOrEmpty($alert.contextTypes[$i])) {
                    ## Replace the key with the associated text.
                    $message = $message.Replace("{$($alert.contextTypes[$i])}", $alert.contextValues[$i]);
                } #end if
            } #end for
            Write-Output $message;
        } #end foreach
    } #end process
} #end function Get-NTNXEventMessage
 
$alerts = Get-NTNXEvent; 
 
## Create an empty array of hashtables to store each table row
[System.Collections.Hashtable[]] $Messages = @();
## Enumerate each alert
foreach ($message in (Get-NTNXEventMessage –NTNXEvent $alerts)) {
 if ($messages.Resolved -eq $false) {
    ## Add each individual alert as an individual hashtable
    $Messages += @{ Message = $message; }
}
}
 
 
$Params = $null   
$Params = @{      
    Hashtable = $Messages;
    Format = -235;
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 "Note: If this (sub) chapter is empty there are no critical alerts"

}

WriteWordLine 0 0 " "

#endregion Nutanix Health Configuration

#region Nutanix vDisk Information

$Chapter++
Write-Verbose "$(Get-Date): Chapter $Chapter/$Nutanix vDisk Information"
WriteWordLine 1 0 "Nutanix vDisk Information"

WriteWordLine 3 0 "Nutanix vDisks"

 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $vDisks = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($vDisk in Get-NTNXVDisk) {
    ## IB - Add each enumerated object to the array
    $vDisks += @{
        "Container Name" = $vDisk.ContainerName;
        "Pool Name" = $vDisk.storagePoolName;
        "NFS File" = $vDisk.nfsFile;
        "Snapshot" = $vDisk.snapshot;
        "Dedup" = $vDisk.OnDiskDedup;
        "NFS File Name" = $vDisk.nfsFileName;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $vDisks;
    
    
    Columns = "Container Name","Pool Name","NFS File","Snapshot","Dedup","NFS File Name";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "

WriteWordLine 0 0 " "

#endregion Nutanix vDisk Information

#region Nutanix Protection Domains

$Chapter++
Write-Verbose "$(Get-Date): Chapter $Chapter/$Nutanix Protection Domains"
WriteWordLine 1 0 "Nutanix Protection Domains"

WriteWordLine 3 0 "Nutanix Protection Domain"

 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $ProtDomains = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($ProtDomain in Get-NTNXProtectionDomain) {
    ## IB - Add each enumerated object to the array
    $ProtDomains += @{
        "Name" = $ProtDomain.name;
        "Active" = $ProtDomain.active;
        "Pending Replications" = $ProtDomain.pendingReplicationCount;
        "Current Replication" = $ProtDomain.ongoingReplicationCount;
        "Removal" = $ProtDomain.markedForRemoval;
        "Written Bytes" = $ProtDomain.totalUserWrittenBytes;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $ProtDomains;
    Columns = "Name","Active","Pending Replications","Current Replication","Removal","Written Bytes";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "

WriteWordLine 3 0 "Nutanix Protection Domain Consistency Group"

 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $PDCGroups = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($PDCGroup in Get-NTNXProtectionDomainConsistencyGroup) {
    ## IB - Add each enumerated object to the array
    $PDCGroups += @{
        "Name" = $PDCGroup.protectionDomainName;
        "Group Name" = $PDCGroup.consistencyGroupName;
        "Snapshots" = $PDCGroup.withinSnapshot;
        "App Consistent Snapshots" = $PDCGroup.appConsistentSnapshots;
        "Removal" = $PDCGroup.markedForRemoval;
        "VMs" = $PDCGroup.vmCount;
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $PDCGroups;
    Columns = "Name","Group Name","Snapshots","App Consistent Snapshots","Removal","VMs";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "

WriteWordLine 3 0 "Nutanix Protection Domain Snapshots"
 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $PSnapshots = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($PSnapshot in Get-NTNXProtectionDomainSnapshot) {
    ## IB - Add each enumerated object to the array
    $PSnapshots += @{
        "Name" = $PSnapshot.protectionDomainName;
        "Snapshot ID" = $PSnapshot.snapshotID;
        "Create Time" = $PSnapshot.snapshotCreateTimeUsecs;
        "Expiry Time" = $PSnapshot.snapshotExpiryTimeUsecs;
        "Conistency Groups" = $PSnapshot.consistencyGroups;
        "Size" =  [math]::truncate($PSnapshot.SizeInBytes /1GB);
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $PSnapshots;
    Columns = "Name","Snapshot ID","Create Time","Expiry Time","Size","Conistency Groups";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;


WriteWordLine 0 0 " "


WriteWordLine 3 0 "Nutanix Protection Domain Unprotected VMs"
 
## IB - Create a typed array of Hashtables
[System.Collections.Hashtable[]] $PSUnProtVMs = @();
 
## IB - Loop through each returned rackable unit/object
foreach ($PSUnProtVM in Get-NTNXUnprotectedVm) {
    ## IB - Add each enumerated object to the array
    $PSUnProtVMs += @{
        "Name" = $PSUnProtVM.vmName;
        "OS" =  $PSUnProtVM.guestOperatingSystem;
        "Memory in GB" = $PSUnProtVM.memoryCapacityInBytes / 1GB;
        "Res. Memory in GB" = $PSUnProtVM.memoryReservedCapacityInBytes /1GB;
        "vCPUs" = $PSUnProtVM.numVCpus;
        "Res. Hz" = $PSUnProtVM.cpuReservedinHz;
        "NICs" = $PSUnProtVM.numNetworkAdapters;
        "vDisk" = $PSUnProtVM.nutanixVirtualDisks;
        "Disk Capacity in GB" = [math]::truncate($PSUnProtVM.diskCapacityInBytes / 1GB);
    };
} # end foreach
 
$Params = $null    
$Params = @{       
   
    
    Hashtable = $PSUnProtVMs;
    Columns = "Name","OS","Memory in GB","Res. Memory in GB","vCPUs","Res. HZ","NICs","Disk Capacity in GB";
    Format = -235; 
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 " "

#endregion Nutanix Protection Domain Information

#region Nutanix Protection Domain Alerts and Events

    If($Full)
    {
WriteWordLine 3 0 "Nutanix Protection Domain Alerts"


<#
.Synopsis
    Resolves a Nutanix Protection Domain alert message
#>
function Get-NTNXProtectionDomainAlertMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [System.Object[]] $NTNXProtectionDomainAlert
    )
    process {
        foreach ($alert in $NTNXProtectionDomainAlert) {
            $message = $alert.Message;
            for ($i = 0; $i -lt ($alert.contextTypes).Count; $i++) {
                ## Don't replace any text with an empty key!
                if (-not [System.String]::IsNullOrEmpty($alert.contextTypes[$i])) {
                    ## Replace the key with the associated text.
                    $message = $message.Replace("{$($alert.contextTypes[$i])}", $alert.contextValues[$i]);
                } #end if
            } #end for
            Write-Output $message;
        } #end foreach
    } #end process
} #end function Get-NTNXProtectionDomainAlertMessage
 
$alerts = Get-NTNXProtectionDomainAlert; 
 
## Create an empty array of hashtables to store each table row
[System.Collections.Hashtable[]] $Messages = @();
## Enumerate each alert
foreach ($message in (Get-NTNXProtectionDomainAlertMessage –NTNXProtectionDomainAlert $alerts)) {
 #if ($messages.Resolved -eq $false) {
    ## Add each individual alert as an individual hashtable
    $Messages += @{ Message = $message; }
}
#}
 
 
$Params = $null   
$Params = @{      
    Hashtable = $Messages;
    Format = -235;
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 "Note: If this (sub) chapter is empty there are no critical alerts"


WriteWordLine 0 0 " "

WriteWordLine 3 0 "Nutanix Protection Domain Events"

<#
.Synopsis
    Resolves a Nutanix Protection Domain Event message
#>
function Get-NTNXProtectionDomainEventMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [System.Object[]] $NTNXProtectionDomainEvent
    )
    process {
        foreach ($alert in $NTNXProtectionDomainEvent) {
            $message = $alert.Message;
            for ($i = 0; $i -lt ($alert.contextTypes).Count; $i++) {
                ## Don't replace any text with an empty key!
                if (-not [System.String]::IsNullOrEmpty($alert.contextTypes[$i])) {
                    ## Replace the key with the associated text.
                    $message = $message.Replace("{$($alert.contextTypes[$i])}", $alert.contextValues[$i]);
                } #end if
            } #end for
            Write-Output $message;
        } #end foreach
    } #end process
} #end function Get-NTNXProtectionDomainEventMessage
 
$alerts = Get-NTNXProtectionDomainEvent; 
 
## Create an empty array of hashtables to store each table row
[System.Collections.Hashtable[]] $Messages = @();
## Enumerate each alert
foreach ($message in (Get-NTNXProtectionDomainEventMessage –NTNXProtectionDomainEvent $alerts)) {
 #if ($messages.Resolved -eq $false) {
    ## Add each individual alert as an individual hashtable
    $Messages += @{ Message = $message; }
}
#}
 
 
$Params = $null   
$Params = @{      
    Hashtable = $Messages;
    Format = -235;
    AutoFit = $wdAutoFitContent;
}
$Table = AddWordTable @Params -NoGridLines;
FindWordDocumentEnd;

WriteWordLine 0 0 "Note: If this (sub) chapter is empty there are no critical alerts"

WriteWordLine 0 0 " "
}
WriteWordLine 0 0 " "

#endregion Nutanix Protection Domain Alerts and Events

#region script template 2

Write-Verbose "$(Get-Date): Finishing up document"
#end of document processing

###Change the two lines below for your script
$AbstractTitle = "Nutanix Documentation Report"
$SubjectTitle = "Nutanix Documentation Report"
UpdateDocumentProperties $AbstractTitle $SubjectTitle

If($MSWORD -or $PDF)
{
    SaveandCloseDocumentandShutdownWord
}
ElseIf($Text)
{
    SaveandCloseTextDocument
}
ElseIf($HTML)
{
    SaveandCloseHTMLDocument
}

Write-Verbose "$(Get-Date): Script has completed"
Write-Verbose "$(Get-Date): "

If($PDF)
{
    If(Test-Path "$($Script:FileName2)")
    {
        Write-Verbose "$(Get-Date): $($Script:FileName2) is ready for use"
    }
    Else
    {
        Write-Warning "$(Get-Date): Unable to save the output file, $($Script:FileName2)"
        Write-Error "Unable to save the output file, $($Script:FileName2)"
    }
}
Else
{
    If(Test-Path "$($Script:FileName1)")
    {
        Write-Verbose "$(Get-Date): $($Script:FileName1) is ready for use"
    }
    Else
    {
        Write-Warning "$(Get-Date): Unable to save the output file, $($Script:FileName1)"
        Write-Error "Unable to save the output file, $($Script:FileName1)"
    }
}

Write-Verbose "$(Get-Date): "

#http://poshtips.com/measuring-elapsed-time-in-powershell/
Write-Verbose "$(Get-Date): Script started: $($Script:StartTime)"
Write-Verbose "$(Get-Date): Script ended: $(Get-Date)"
$runtime = $(Get-Date) - $Script:StartTime
$Str = [string]::format("{0} days, {1} hours, {2} minutes, {3}.{4} seconds", `
    $runtime.Days, `
    $runtime.Hours, `
    $runtime.Minutes, `
    $runtime.Seconds,
    $runtime.Milliseconds)
Write-Verbose "$(Get-Date): Elapsed time: $($Str)"
$runtime = $Null
$Str = $Null
$ErrorActionPreference = $SaveEAPreference
#endregion script template 2
