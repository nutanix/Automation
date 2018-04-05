# Nutanix Graphical API Demos v2 (Laravel)

Demo app aimed at showing how to consume the Nutanix API using PHP.

# Requirements

- PHP >=5.5.9
- MySQL server as per standard Laravel app requirements (local or remote - doesn't matter as long as the web server can access)
- Knowledge of how to deploy a Laravel app from Github

# Requirements - Full VM Deployment

- A copy of web-server.yaml from this repo
- The web-server.yaml file will need to be uploaded to the container you choose during the wizard
- To make parameter entry easy, you can click 'Need cluster details? Click here!' then 'Get Details'.  Click the container name you want to use, the network UUID you want to use and the disk UUID you want to use.

# Execution

- Change to app directory and run the following command:

    php artisan serve
    
- Browse to web server's IP address/name, depending on how you're running the demo
- Enter cluster details as per Step 1 on the form
- Select the required demo from Step 2
- Click 'Run Demo'
- Check out the results in Step 3 

# Note
moved to /nutanix/automation from https://github.com/digitalformula/nutanix-graphical-api-demo-2 (JonKohler 2018.04.06)