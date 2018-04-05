/*
 * basic class to handle the responses returned by our API requests
 * this isn't strictly required but does setup the app for a reasonably usable structure later
 *
*/

namespace NutanixAPIDemo
{
    class RequestResponse
    {

        public int Code { get; set; }
        public string Message { get; set; }

    }
}
