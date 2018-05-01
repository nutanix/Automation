# Nutanix Graphical API Demos v2 (Laravel)

Demo app aimed at showing how to consume the Nutanix API using PHP.

# Changelog

- 2018.04.24 - Chris - Updated with detailed setup instructions

# Requirements

- PHP >=5.5.9
- MySQL server as per standard Laravel app requirements (local or remote - doesn't matter as long as the web server can access)

# Requirements - Full VM Deployment

- A copy of web-server.yaml from this repo
- The web-server.yaml file will need to be uploaded to the container you choose during the wizard
- To make parameter entry easy, you can click 'Need cluster details? Click here!' then 'Get Details'.  Click the container name you want to use, the network UUID you want to use and the disk UUID you want to use.
- An Acropolis-hosted CentOS image *with Cloud-Init preinstalled*

## Detailed Installation Steps (OS X & Linux)

- Ensure [PHP Composer](https://getcomposer.org) is available on the target web server
- Ensure MySQL is available, including credentials to access it _remotely_
- Clone repo from this location
- Install Composer dependencies:

```
composer install
```

- Run Composer update, to make sure packages are latest (not really required, but you never know)

```
composer update
```

- Create a file called .env in the project root.  You can use .env.example as a base for this file
- Edit the .env parameters, particularly the MySQL database connection parameters
- Generate the Laravel application key:

```
php artisan key:generate
```

- Run the database migrations and make sure no database-related errors are shown during this step:

```
php artisan migrate
```

- Seed the database and make sure no database-related errors are shown during this step:

```
php artisan db:seed
```

## Run The Demo

- If you are running the app locally or without Nginx/Apache (etc), run the app as follows:

```
php artisan serve
```

- Browse to http://localhost:8000
- Login with username 'no-reply@acme.com' and password 'password'
- Enter cluster details as per Step 1 on the form, e.g. cluster virtual IP or CVM IP address
- Select the required demo from Step 2
- Click 'Run Demo'
- Check out the results in Step 3

If you are running the Cloud-Init demo, please see the "Full VM Deployment" section above.

# Note
moved to /nutanix/automation from https://github.com/digitalformula/nutanix-graphical-api-demo-2 (JonKohler 2018.04.06)