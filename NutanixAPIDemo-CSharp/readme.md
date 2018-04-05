# Nutanix API Demo - C#

Basic demo of consuming the Nutanix API using Microsoft C#.

# Installation

You'll need Visual Studio Community Edition or above to open this solution.

Once you have that, you'll also need to install Newtonsoft's JSON Converter extension:

- Tools > NuGet Package Manager > Package Manager Console
- Enter the following command:

```Install-Package Newtonsoft.Json```

When the installation has completed, the solution build will succeed.

# Usage

Run the application from within Visual Studio and enter the path to your API endpoint.

You can use this demo to consume any API, although there are a couple of checks in the code to do different things if the Nutanix API is detected.  For example, cluster details will be displayed if the API endpoint is the 'cluster' object exposed by the Nutanix API.

# Help

You can email crasmussen@nutanix.com if you have any questions.

Please note that this demo my own and is not supported, endorsed or approved by Nutanix in any way.

