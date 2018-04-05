/*
 * basic class to handle the actual API request
 *
*/

using System;
using System.IO;
using System.Net;
using System.Text;

namespace NutanixAPIDemo
{

    class RESTClient
    {

        public string EndPoint { get; set; }
        public string HttpMethod { get; set; }
        public string RequestBody { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public bool IgnoreSslErrors { get; set; }

        public RESTClient()
        {
            
        }

        public RequestResponse SendRequest()
        {

            /*
             * check to see if the user has specified to ignore SSL warnings
             * this is BAD in production - just don't do it
             * 
             * for the purposes of this demo, many Nutanix clusters will still use self-signed certificates
             * if SSL errors are not ignored, connections will be refused since we aren't automatically accepting self-signed certs in this app
            */
            if ( IgnoreSslErrors == true )
            {
                System.Net.ServicePointManager.ServerCertificateValidationCallback = ((sender, certificate, chain, sslPolicyErrors) => true);
            }

            RequestResponse Response = new RequestResponse();
            HttpWebResponse HttpResponse = null;

            try
            {

                var request = (HttpWebRequest)WebRequest.Create(EndPoint);
                request.Method = HttpMethod;

                /*
                 * this section only applies if the user as selected to send a POST request
                 * if the POST method is selected, we also need to process and send the POST body
                */
                if (HttpMethod != "GET")
                {
                    var requestBody = Encoding.ASCII.GetBytes(RequestBody);
                    var newStream = request.GetRequestStream();
                    newStream.Write(requestBody, 0, requestBody.Length);
                    newStream.Close();
                }

                /*
                 * setup the request headers
                 * 
                 * for this app, we are only worried about the authentication type (Basic)
                 * and the valid encoding (application/json for Nutanix clusters)
                */
                String authHeader = System.Convert.ToBase64String(System.Text.ASCIIEncoding.ASCII.GetBytes(Username + ":" + Password));
                request.Headers.Add("Authorization", "Basic " + authHeader);
                request.Headers.Add("Accept-Encoding", "application/json");

                /*
                 * make sure the request doesn't sit there forever ...
                 * set this to a more appropriate value if accessing API URIs over slow/high-latency connections (e.g. VPN)
                */
                request.Timeout = 5000;

                HttpResponse = (HttpWebResponse)request.GetResponse();
                using (Stream HttpResponseStream = HttpResponse.GetResponseStream())
                {
                    if (HttpResponseStream != null)
                    {
                        using (StreamReader reader = new StreamReader(HttpResponseStream))
                        {
                            Response.Code = 1;
                            Response.Message = reader.ReadToEnd();
                        }
                    }
                }
            }
            catch( Exception ex )
            {
                Response.Code = 99;
                Response.Message = "{\"errors\":[\"" + ex.Message.ToString() + "\"]}";
            }
            finally
            {
                if(HttpResponse != null)
                {
                    ((IDisposable)HttpResponse).Dispose();
                }
            }

            return Response;
        }

    }
}