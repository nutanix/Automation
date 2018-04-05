# kees@nutanix.com
# @kbaggerman on Twitter
# http://blog.myvirtualvision.com
# Created on Januari 20, 2015


#region script template

Param(     
    # vCenter IP Address
    [Parameter(Mandatory = $true)]
    [Alias('PRISM Cluster IP')] [string] $ntnxIP,
    # vCenter FQDN
    [Parameter(Mandatory = $true)]
    [Alias('PRISM Cluster Name')] [string] $ntnxHostName
)

#endregion script template

#region script functions
function Get-WebsiteCertificate {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$false)] [System.Uri]
      $Uri,
    [Parameter()] [System.IO.FileInfo]
      $OutputFile,
    [Parameter()] [Switch]
      $UseSystemProxy,  
    [Parameter()] [Switch]
      $UseDefaultCredentials,
    [Parameter()] [Switch]
      $TrustAllCertificates
  )
  try {
    $request = [System.Net.WebRequest]::Create($Uri)
    if ($UseSystemProxy) {
      $request.Proxy = [System.Net.WebRequest]::DefaultWebProxy
    }

    if ($UseSystemProxy -and $UseDefaultCredentials) {
      $request.Proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
    }

    if ($TrustAllCertificates) {
      # Create a compilation environment
      $Provider=New-Object Microsoft.CSharp.CSharpCodeProvider
      $Compiler=$Provider.CreateCompiler()
      $Params=New-Object System.CodeDom.Compiler.CompilerParameters
      $Params.GenerateExecutable=$False
      $Params.GenerateInMemory=$True
      $Params.IncludeDebugInformation=$False
      $Params.ReferencedAssemblies.Add("System.DLL") > $null
      $TASource=@'
        namespace Local.ToolkitExtensions.Net.CertificatePolicy {
          public class TrustAll : System.Net.ICertificatePolicy {
            public TrustAll() { 
            }
            public bool CheckValidationResult(System.Net.ServicePoint sp,
              System.Security.Cryptography.X509Certificates.X509Certificate cert, 
              System.Net.WebRequest req, int problem) {
              return true;
            }
          }
        }
'@ 
      $TAResults=$Provider.CompileAssemblyFromSource($Params,$TASource)
      $TAAssembly=$TAResults.CompiledAssembly

      ## We now create an instance of the TrustAll and attach it to the ServicePointManager
      $TrustAll=$TAAssembly.CreateInstance("Local.ToolkitExtensions.Net.CertificatePolicy.TrustAll")
      [System.Net.ServicePointManager]::CertificatePolicy=$TrustAll
    }

    $response = $request.GetResponse()
    $servicePoint = $request.ServicePoint
    $certificate = $servicePoint.Certificate

    if ($OutputFile) {
      $certBytes = $certificate.Export(
          [System.Security.Cryptography.X509Certificates.X509ContentType]::Cert
        )
      [System.IO.File]::WriteAllBytes( $OutputFile, $certBytes )
      $OutputFile.Refresh()
      return $OutputFile
    } else {
      return $certificate
    }
  } catch {
    Write-Error "Failed to get website certificate. The error was '$_'."
    return $null
  }

  <#
    .SYNOPSIS
      Retrieves the certificate used by a website.

    .DESCRIPTION
      Retrieves the certificate used by a website. Returns either an object or file.

    .PARAMETER  Uri
      The URL of the website. This should start with https.

    .PARAMETER  OutputFile
      Specifies what file to save the certificate as.

    .PARAMETER  UseSystemProxy
      Whether or not to use the system proxy settings.

    .PARAMETER  UseDefaultCredentials
      Whether or not to use the system logon credentials for the proxy.

    .PARAMETER  TrustAllCertificates
      Ignore certificate errors for certificates that are expired, have a mismatched common name or are self signed.

    .EXAMPLE
      PS C:\> Get-WebsiteCertificate "https://www.gmail.com" -UseSystemProxy -UseDefaultCredentials -TrustAllCertificates -OutputFile C:\gmail.cer

    .INPUTS
      Does not accept pipeline input.

    .OUTPUTS
      System.Security.Cryptography.X509Certificates.X509Certificate, System.IO.FileInfo
  #>
}

function Import-Certificate {
<#
    .SYNOPSIS
        Imports certificate in specified certificate store.

    .DESCRIPTION
        Imports certificate in specified certificate store.

    .PARAMETER  CertFile
        The certificate file to be imported.

    .PARAMETER  StoreNames
        The certificate store(s) in which the certificate should be imported.

    .PARAMETER  LocalMachine
        Using the local machine certificate store to import the certificate

    .PARAMETER  CurrentUser
        Using the current user certificate store to import the certificate

    .PARAMETER  CertPassword
        The password which may be used to protect the certificate file

    .EXAMPLE
        PS C:\> Import-Certificate C:\Temp\myCert.cer

        Imports certificate file myCert.cer into the current users personal store

    .EXAMPLE
        PS C:\> Import-Certificate -CertFile C:\Temp\myCert.cer -StoreNames my

        Imports certificate file myCert.cer into the current users personal store

    .EXAMPLE
        PS C:\> Import-Certificate -Cert $certificate -StoreNames my -StoreType LocalMachine

        Imports the certificate stored in $certificate into the local machines personal store 

    .EXAMPLE
        PS C:\> Import-Certificate -Cert $certificate -SN my -ST Machine

        Imports the certificate stored in $certificate into the local machines personal store using alias names

    .EXAMPLE
        PS C:\> ls cert:\currentUser\TrustedPublisher | Import-Certificate -ST Machine -SN TrustedPublisher

        Copies the certificates found in current users TrustedPublishers store to local machines TrustedPublisher using alias  

    .INPUTS
        System.String|System.Security.Cryptography.X509Certificates.X509Certificate2, System.String, System.String

    .OUTPUTS
        NA

    .NOTES
        NAME:      Import-Certificate
        AUTHOR:    Patrick Sczepanksi (Original anti121)
        VERSION:   20110502
        #Requires -Version 2.0
    .LINK
        http://poshcode.org/2643
        http://poshcode.org/1937 (Link to original script)

#>

    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline=$true,Mandatory=$true, Position=0, ParameterSetName="CertFile")]
        [System.IO.FileInfo]
        $CertFile,

        [Parameter(ValueFromPipeline=$true,Mandatory=$true, Position=0, ParameterSetName="Cert")]
        [System.Security.Cryptography.X509Certificates.X509Certificate2]
        $Cert,

        [Parameter(Position=1)]
        [Alias("SN")]
        [string[]] $StoreNames = "My",

        [Parameter(Position=2)]
        [Alias("Type","ST")]
        [ValidateSet("LocalMachine","Machine","CurrentUser","User")]
        [string]$StoreType = "CurrentUser",

        [Parameter(Position=3)]
        [Alias("Password","PW")]
        [string] $CertPassword
    )

    begin
    {
        [void][System.Reflection.Assembly]::LoadWithPartialName("System.Security")
    }

    process 
    {
        switch ($pscmdlet.ParameterSetName) {
            "CertFile" {
                try {
                    $Cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $($CertFile.FullName),$CertPassword
                }
                catch {   
                    Write-Error ("Error reading '$CertFile': $_ .") -ErrorAction:Continue
                }
            }
            "Cert" {

            }
            default {
                Write-Error "Missing parameter:`nYou need to specify either a certificate or a certificate file name."
            }
        }

        switch -regex ($storeType) {
            "Machine$" { $StoreScope = "LocalMachine" }
            "User$"  { $StoreScope = "CurrentUser" }
        } 

        if ( $Cert ) {
            $StoreNames | ForEach-Object {
                $StoreName = $_
                Write-Verbose " [Import-Certificate] :: $($Cert.Subject) ($($Cert.Thumbprint))"
                Write-Verbose " [Import-Certificate] :: Import into cert:\$StoreScope\$StoreName"

                if (Test-Path "cert:\$StoreScope\$StoreName") {
                    try
                    {
                        $store = New-Object System.Security.Cryptography.X509Certificates.X509Store $StoreName, $StoreScope
                        $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
                        $store.Add($Cert)
                        if ( $CertFile ) {
                            Write-Verbose " [Import-Certificate] :: Successfully added '$CertFile' to 'cert:\$StoreScope\$StoreName'."
                        } else {
                            Write-Verbose " [Import-Certificate] :: Successfully added '$($Cert.Subject) ($($Cert.Thumbprint))' to 'cert:\$StoreScope\$StoreName'."
                        }
                    }
                    catch
                    {
                        Write-Error ("Error adding '$($Cert.Subject) ($($Cert.Thumbprint))' to 'cert:\$StoreScope\$StoreName': $_ .") -ErrorAction:Continue
                    }
                    if ( $store ) {
                        $store.Close()
                    }
                } 
                else {
                    Write-Warning "Certificate store '$StoreName' does not exist. Skipping..."
                }
            }
        } else {
            Write-Warning "No certificates found."
        }
    }

    end { 
        Write-Host "Finished importing certificates." 
    }
}



#endregion script functions

#region script checks
# Check DNS and skip hosts file modification if the name exists in DNS

  if(!(Test-Connection -Cn $ntnxHostNAme -BufferSize 16 -Count 1 -ea 0 -quiet))
  
  {

   Write-Host "Problem connecting to $ntnxHostNAme"

   Write-Host "Flushing DNS"

   ipconfig /flushdns | out-null

   Write-Host "Registering DNS"

   ipconfig /registerdns | out-null

   Write-Host "Re-pinging $ntnxHostNAme"

     if(!(Test-Connection -Cn $ntnxHostNAme -BufferSize 16 -Count 1 -ea 0 -quiet))

      {Write-Host "Problem still exists in connecting to $ntnxHostNAme, setting Hosts file"}

        ac -Encoding UTF8  C:\Windows\system32\drivers\etc\hosts "$ntnxIP $ntnxHostNAme"
   } 

Write-Host "$ntnxHostNAme can be reached, proceeding with script"

#endregion script checks

#region Get the certificate and import it

#Import certificate into Trusted Peolpe Computer Cert Store
$SecSettings = "https://"
$secPort = ":9440"
$SecvcHostName = $SecSettings+$ntnxHostNAme+$secPort
Get-WebsiteCertificate $SecvcHostName local.cer -trust | Out-Null
Import-Certificate -certfile local.cer -StoreNames TrustedPeople -StoreType LocalMachine  | Out-Null

Write-Host "The SSL Certificate has been installed"

#Cleaning up

Remove-Item local.cer

#endregion Get the Certificate and import it




