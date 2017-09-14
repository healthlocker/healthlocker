# Deploying Healthlocker to an Azure instance

Most of the instruction will be found in the
[Oxleas deployment documentation](https://github.com/healthlocker/oxleas-adhd/blob/master/deployment_and_ssl_doc.md#create-an-ssl-certificate).

This document will go through changes in the deployment process that need to
happen in order to deploy Healthlocker.

### [Installing Erlang](https://github.com/healthlocker/oxleas-adhd/blob/master/deployment_and_ssl_doc.md#install-erlang)

Erlang needs to be installed with ODBC to access the MSSQL database.
`apt-get install erlang-odbc`

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
