# Healthlocker [![Build Status](https://travis-ci.org/healthlocker/healthlocker.svg?branch=master)](https://travis-ci.org/healthlocker/healthlocker) [![Deps Status](https://beta.hexfaktor.org/badge/all/github/healthlocker/healthlocker.svg)](https://beta.hexfaktor.org/github/healthlocker/healthlocker)

Healthlocker is an application which connects service users (*SU*), their clinicians
(*care team*), and other relevant people(e.g. parent or spouse of SU,
known as *carers*) together. It allows for open and frequent communication
between a SU and their care team, or between a carer and the SU's
care team. SUs and carers can message the care team for instant
communication. Clinicians can also stay updated on goals and coping strategies
created by their SUs in Healthlocker, which keeps them up-to-date with what is
important to their SU. A full list of features can be found
[here](https://github.com/healthlocker/healthlocker#current-features).


## Getting started

### Install the following:
* [Elixir](https://github.com/dwyl/learn-elixir#how)
* [Postgresql](https://github.com/dwyl/learn-postgresql) (and ensure you create a `postgres` user)
* [Node.js](https://nodejs.org/en/)

### Once everything is installed:
* Enter `brew link autoconf automake` into your terminal
* Start Postgresql server
* Get dependencies (including if they are out of date) with `mix deps.get`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`
* If prompted by the following message, enter `y`:

```
Could not find "rebar3", which is needed to build dependency :fs
I can install a local copy which is just used by Mix
Shall I install rebar3? (if running non-interactively, use: "mix local.rebar --force") [Yn]
```
* Insert seed data for ePJS patients & clinicians by running the following
commands
  * `mix run priv/read_only_repo/seeds.exs`
  * `mix run priv/read_only_repo/address_seed.exs`
  * `mix run priv/read_only_repo/under_12s_seeds.exs`
* Insert healthlocker demo data by running  `mix run priv/repo/seeds.exs`
* There are other optional seeds which are not necessary for using all the
project features, but can be helpful for demoing a patient having more than one
clinician and for demoing sleep tracking data
  * `mix run priv/read_only_repo/clinician_seeds.exs`
  * `mix run priv/read_only_repo/sleep_data_seeds.exs`
* Install Node.js dependencies with `npm install`
* Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser
and checkout the [styleguide](http://localhost:4000/components).

Ready to run in production? Please [check the deployment guides](http://www.phoenixframework.org/docs/deployment).

### Testing

We use [`ExUnit`](http://elixir-lang.org/docs/stable/ex_unit/) and
[`wallaby`](https://github.com/keathley/wallaby) for testing. Wallaby has a
dependency on phantomjs. You can follow their
[instructions](https://github.com/keathley/wallaby#phantomjs) to install it.

After that you should be able to run `mix test` and see lots of green!

### Routes

You can view all of the routes by running `mix phoenix.routes` in your terminal.

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Phoenix Docs: https://hexdocs.pm/phoenix
  * Ecto Docs: https://hexdocs.pm/ecto/Ecto.html


### Updating select input options

The dropdown options for security questions, hours slept and wake count from
the sleep tracker, and symptom scale from the symptom tracker can be updated
by following the instructions in [this document](editing-select-options.md).

### Writing tips & stories

The stories and tips can be written using markdown. This will allow you to
style the text as you write it.

You can find a
[guide to common things you may want to do with markdown](markdown-syntax.md)
in this repository.

In addition to formatting the text with markdown, be sure to include `#story`
or `#tip` (with an additional *category* tag) so the story or tip displays on
the correct page.

### Current features

![style-guide](https://cloud.githubusercontent.com/assets/25007700/24720714/f1c77f70-1a35-11e7-808c-b1f1596ea0ae.png)

* Tips can be added in by admin users, and
[can be viewed either in full or filtered by tag](https://www.healthlocker.uk/tips)
* Story content can be input by admin users, and are displayed in
[cards with a story preview](https://www.healthlocker.uk/posts)
* Stories can be expanded to view the full individual story
* [Three-step sign up process](https://www.healthlocker.uk/users/new)
* [Login](https://www.healthlocker.uk/login)
* [Coping strategies](https://www.healthlocker.uk/coping-strategy)
  * view full list they have made
  * view individual coping strategies
  * edit and delete coping strategies
* [Goals](https://www.healthlocker.uk/goal)
  * view full list they have made
  * view individual goals
  * edit and delete goals
  * mark as important to display at the top of the goals page
  * mark as achieved once a goal is completed
* Static info pages:
  * [Support page](https://www.healthlocker.uk/support)
  * [Terms of service](https://www.healthlocker.uk/pages/terms) (also linked in sign up)
  * [Privacy statement](https://www.healthlocker.uk/pages/privacy) (also linked in sign up)
  * [About](https://www.healthlocker.uk/pages/about)
* [Account](https://www.healthlocker.uk/account)
  * update their name (only if not a carer or service user), and phone number
  * [update consent](https://www.healthlocker.uk/account/consent) for sharing
  data with researchers, and consent to be contacted
  * [update password and security Q&A](https://www.healthlocker.uk/pages/security)
  * [connect to their NHS health record](https://www.healthlocker.uk/account/slam)
  * [connect as a carer for a service user](https://www.healthlocker.uk/slam/new)
  * [disconnect from their NHS health record](https://www.healthlocker.uk/pages/disconnect)
* Feedback can be sent about the site from a form. This is done
[using Bamboo and Amazon SES](https://github.com/dwyl/learn-phoenix-framework/blob/master/sending-emails.md)
* [Track sleep, a custom problem, or input daily diary entries](tracking-feature.md)
* [Reset forgotten password](https://www.healthlocker.uk/password/new). Uses a
custom made [forgotten password controller](https://github.com/dwyl/learn-phoenix-framework/blob/master/forgot-password.md)
* [Clinician caseload](https://www.healthlocker.uk/caseload)
  * Clinicians can click on Healthlocker connected users to view
  goals and coping strategies, tracking data, contact details, and messaging
  * Clinicians can click on carers to message or get contact details
* [Styleguide](https://www.healthlocker.uk/components)


## DevOps

### Application Architecture

The Healthlocker App is deployed to "Production" in the following configuration:

![healthlocker-architecture-diagram-2](https://cloud.githubusercontent.com/assets/194400/26106766/e62c9316-3a3e-11e7-830e-96df89c4f5d7.jpg)
> To edit this diagram, open:<br />
https://docs.google.com/drawings/d/1VwpBVKzqSX0q81KsKSKAOS7wtYcqZqARKAFTKJUaowg

The cluster of Web Servers is two or more Linux VMs behind a load balancer.

#### Infrastructure Details

There are 4 pieces to the puzzle

+ Azure **Load Balancer**:
https://azure.microsoft.com/en-gb/services/load-balancer -
All web traffic is handled through the load balancer which performs
_continous_ health checks on the application server(s) and routes
requests in a "round-robin" to balance load.
+ **Linux Virtual Machines** (VMs):
https://azure.microsoft.com/en-gb/services/virtual-machines - these run our
Phoenix Web Application. The Application is _compiled_ as an _executable_
which runs on "BEAM" (_the Erlang Virtual Machine_).
The VMs are _actively_ monitored and can be scaled up dynamically
dependent on request volume.
+ Azure **PostgreSQL Database-as-a-Service**:
https://azure.microsoft.com/en-us/services/postgresql - all application data
is stored in an Azure Database instance which is encrypted at rest,
scales dynamically/transparently ("_built-in high availability_")
and backed up transparently. Data is _Only_ accessible from the Production VMs
+ Azure **SQL Server** (_Database-as-a-Service_):
https://azure.microsoft.com/en-gb/services/sql-database - Stores a _read-only_
_snapshot_ of the "Care Notes" (ePJS) Database. This contains the patients
personal health information and is controlled by the "SLaM" IT team.
Access is restricted to the Production Healthlocker VMs and patient (_personal_)
data is only viewable by the patient and authorized healthcare professionals.

### Continuous Integration/Testing and Deployment Pipeline




### Deployment Guide

In the interest of _reproducibility_ we have produced a
***step-by-step guide*** to deploying a Phoenix Web Application to
Microsoft Azure: <br />
https://github.com/dwyl/learn-microsoft-azure

### Capacity Building Through Documentation & Learning Resources

Unlike _most_ application development Agencies, that attempt to "Lock-in"
clients, the team building Healthlocker are _focussed_ on
building capacity within the NHS to support and extend Healthlocker.

The following learning resources are community-maintained and 100% free/open:

+ Continuous Integration / Deployment: https://github.com/dwyl/learn-travis
+ Elixir Programming Language: https://github.com/dwyl/learn-elixir
+ Phoenix Web Applciation Framework: https://github.com/dwyl/learn-phoenix-framework
+ Mobile-first User Interface Library: https://github.com/dwyl/learn-tachyons
