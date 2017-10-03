# Deploying Healthlocker to an Azure instance

Most of the instruction will be found in the
[Oxleas deployment documentation](https://github.com/healthlocker/oxleas-adhd/blob/master/deployment_and_ssl_doc.md#create-an-ssl-certificate).

This document will go through changes in the deployment process that need to
happen in order to deploy Healthlocker.

### [Installing Erlang](https://github.com/healthlocker/oxleas-adhd/blob/master/deployment_and_ssl_doc.md#install-erlang)

Erlang needs to be installed with ODBC to access the MSSQL database.
`apt-get install erlang-odbc`

### Install ODBC drivers
After installing all necessary languages and dependencies, ODBC drivers also
need to be installed.
```
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
apt-get update
ACCEPT_EULA=Y apt-get install msodbcsql -y
```

```
# optional: for bcp and sqlcmd
ACCEPT_EULA=Y apt-get install mssql-tools -y
# Add tools to path
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
# optional: for unixODBC development headers
apt-get install unixodbc-dev -y
```

### [Adding Environment Variables](https://github.com/healthlocker/oxleas-adhd/blob/master/deployment_and_ssl_doc.md#add-environment-variables-to-azure)

In addition to all the environment variables listed in the Oxleas
documentation, the following variables also need to be added to the server.

```
SEGMENT_WRITE_KEY
READ_ONLY_HOSTNAME
READ_ONLY_USERNAME
READ_ONLY_DATABASE
READ_ONLY_PASSWORD
TIMEOUT_INTERVAL
MPass
```

### Setting up AppSignal

AppSignal is used for error logging of the staging and live sites. It is set up
differently on live and staging. You can run through this set up after you have
completed your first deploy of the application.

For both live and staging, you will need to ssh into the relevant server, and
add a variable to the profile called `APPSIGNAL_PUSH_API_KEY`. Set this to the
push api key you get from AppSignal by going to
[your AppSignal account](https://appsignal.com/accounts), selecting any
Healthlocker application, going to settings, and the `Push and Deploy` tab.
This will be the same for all apps, so it does not matter which application
you take this from.

#### Live set up
You need to ssh into the live server, and go to the folder containing the
application by running `cd /home/hladmin/healthlocker/builds`.

Run `mix appsignal.install <your push api key>`.

When running through the install, you will have an option to choose whether to
configure AppSignal using a `config` file, or with environment variables. For
live, choose `from a config file`.

AppSignal will start running once you have completed steps to have the app
running.

#### Staging set up
On staging, AppSignal is configured using environment variables. You will need
to set two additional environment variables for the staging site to complete
this:

`APPSIGNAL_APP_NAME="Healthlocker-staging"`
`APPSIGNAL_APP_ENV="staging"`

Once these are set, run `mix appsignal.install <your push api key>`.

For staging, choose the option to configure AppSignal using environment
variables.

AppSignal will start running once you have completed steps to have the app
running.

### Setting up roles
You first need to create the database and tables.
`ssh` into the server with `ssh root@"IP Address of server"`

```
cd /home/"server_name"/"app_name"/builds (example: cd /home/hladmin/healthlocker/builds/)
mix ecto.create
mix ecto.migrate
```

In Oxleas-adhd, [a super admin role needs to be set up](https://github.com/healthlocker/oxleas-adhd/blob/master/deployment_and_ssl_doc.md#add-super_admin-user-to-database).

Healthlocker does not use a `super-admin` role, however an `admin` role will
need to be set up. You can create an account for the email you wish to make an
admin account on the website at https://www.healthlocker.uk/users/new.

On the server, connect to the postgres database by running:
```
sudo -u postgres psql
\connect "name_of_the_database_your_app_uses" (e.g. \connect healthlocker_dev)
```

Once connected to postgres, run `select id from users where email = 'email you signed up with';`.
Use this `id` in place of `id_from_last_step` below.

`UPDATE users SET role = 'admin' WHERE id = id_from_last_step;`

When you have entered this info type `\q` then press `return`.

`exit` the server.
