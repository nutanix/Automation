using System;
using System.Windows.Forms;
using Newtonsoft.Json;
using System.IO;
using System.Text.RegularExpressions;
using System.Drawing;

namespace NutanixAPIDemo
{
    public partial class Form1 : Form
    {

        public Form1()
        {
            InitializeComponent();
            // set the dropdown box so text can't be manually entered
            this.txtVerb.DropDownStyle = ComboBoxStyle.DropDownList;   
        }

        /**
         * display a response
        */
        private void DisplayResponse(string DebugText)
        {
            try
            {
                txtResponse.Text = txtResponse.Text + JsonPrettify(DebugText) + Environment.NewLine + Environment.NewLine;
                txtResponse.SelectionStart = txtResponse.TextLength;
                txtResponse.ScrollToCaret();
            }
            catch( Exception ex )
            {
                txtResponse.Text = txtResponse + ex.Message.ToString() + Environment.NewLine;
            }
        }

        /**
         * Take a JSON-formatted string and "prettify" it i.e. insert new line and tab characters where appropriate
         * from https://stackoverflow.com/questions/2661063/how-do-i-get-formatted-json-in-net-using-c
        */
        public static string JsonPrettify(string json)
        {
            using (var stringReader = new StringReader(json))
            using (var stringWriter = new StringWriter())
            {
                var jsonReader = new JsonTextReader(stringReader);
                var jsonWriter = new JsonTextWriter(stringWriter) { Formatting = Formatting.Indented };
                jsonWriter.WriteToken(jsonReader);
                return stringWriter.ToString();
            }
        }

        /*
         * begin processing an API request event i.e. button click 
        */ 
        private void CmdGo_Click(object sender, EventArgs e)
        {

            /* keep previous responses?  if not, clear any that are still showing */
            if (chkClearEach.Checked)
            {
                txtResponse.Clear();
            }

            /*
             * instantiate our RESTClient class
             * this will hold all properties relevant to the request we're sending, then processing
             * 
            */ 
            RESTClient RestClient = new RESTClient()
            {
                EndPoint = txtRequestUri.Text,
                HttpMethod = txtVerb.Text,
                RequestBody = txtRequestBody.Text != "" ? txtRequestBody.Text : "GET"
            };

            /* get the basic properties of the request */
            RestClient.Username = txtUserName.Text;
            RestClient.Password = txtPassword.Text;
            RestClient.IgnoreSslErrors = chkIgnoreSSLErrors.Checked;
            RequestResponse Response = new RequestResponse();
            DisplayResponse("{\"event\":\"Sending request ...\"}");

            /* send the actual request */
            Response = RestClient.SendRequest();

            /* process the returned response, along with any errors that may have occurred */
            DisplayResponse(Response.Message);
            DisplayResponse("{\"event\":\"Request completed\"}");

            /*
             * because this is written with Nutanix API demos in mind (as one use),
             * check to see if the API request URI is a request for Nutanix cluster details
             * this is completely ignored for any requests that aren't aimed at a Nutanix cluster
             * 
             * this is a total hack, but gets the job done for the purposes of this demo  ;)
            */ 
            if (txtRequestUri.Text.ToLower().Contains("/api/nutanix/v2.0/cluster"))
            {
                NutanixCluster cluster = JsonConvert.DeserializeObject<NutanixCluster>(Response.Message);
                DisplayResponse("{\"cluster\":{\"name\":\"" + cluster.Name.ToString() + "\",\"version\":\"" + cluster.Version.ToString() + "\"}}");
            }

        }

        private void CmdExit_Click(object sender, EventArgs e)
        {
            /* quit the application */
            Application.Exit();
        }

        private void CmdClear_Click(object sender, EventArgs e)
        {
            /* clear any responses that are still on screen */
            txtResponse.Text = "";
        }

        private void txtRequestUri_TextChanged(object sender, EventArgs e)
        {

            /*
             * perform a simple RegEx check to make sure a valid URI has been entered
            */
            string pattern = @"^(https?)\:\/\/[0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*(:(0-9)*)*(\/?)([a-zA-Z0-9\-\.\?\,\'\/\\\+&amp;%\$#_]*)?$";
            string text = txtRequestUri.Text;

            Regex r = new Regex(pattern);
            if(r.IsMatch(text))
            {
                /* URI is valid */
                txtRequestUri.ForeColor = Color.Black;
                ButtonSendRequest.Enabled = true;
                LabelUriStatus.Text = "";
            }
            else
            {
                /* URI is invalid */
                txtRequestUri.ForeColor = Color.Red;
                ButtonSendRequest.Enabled = false;
                LabelUriStatus.Text = "!";
            }
            
        }
    }
}
