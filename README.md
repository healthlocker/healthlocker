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

## How?

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
* Feedback can be sent about the site from a form. This is done
[using Bamboo and Amazon SES](https://github.com/dwyl/learn-phoenix-framework/blob/master/sending-emails.md)
* [Track sleep, a custom problem, or input daily diary entries](tracking-feature.md)
* [Reset forgotten password](https://www.healthlocker.uk/password/new). Uses a
custom made [forgotten password controller](https://github.com/dwyl/learn-phoenix-framework/blob/master/forgot-password.md)
* [Styleguide](https://www.healthlocker.uk/components)
