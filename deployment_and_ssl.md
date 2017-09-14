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
MPass
```
