/*
 * basic class to cover very high-level Nutanix cluster details
 * this isn't strictly required but does setup the app for a reasonably usable structure later
*/
namespace NutanixAPIDemo
{
    class NutanixCluster
    {

        public string Name { get; set; }
        public string Version { get; set; }

    }
}