# Healthlocker [![Build Status](https://travis-ci.org/healthlocker/healthlocker.svg?branch=master)](https://travis-ci.org/healthlocker/healthlocker) [![Deps Status](https://beta.hexfaktor.org/badge/all/github/healthlocker/healthlocker.svg)](https://beta.hexfaktor.org/github/healthlocker/healthlocker)

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

* Tips can be added in, and can be viewed either in full or filtered by tag
* Story content can be input by users, and are displayed in cards with a
story preview
* Stories can be expanded to view the full individual story
* Support page is available in full
* Three-step sign up process
* Login
* Users can only post content when logged in
* Users can create, view, update and delete coping strategies they have made
* Users can create, view, update, and delete goals they have made
* Goals can be marked as important and are displayed at the top of the goals page
* Users can visit their account page where they can update their name, email,
or phone number
* Users can update their consent for sharing data with researchers in their account
* Users can update their password and security Q&A in their account
* Terms of service can be accessed from the footer and is linked in sign up
* Privacy statement can be accessed from the footer and is linked in sign up
* Feedback can be sent about the site from a form. This is done
[using Bamboo and Amazon SES](https://github.com/dwyl/learn-phoenix-framework/blob/master/sending-emails.md)
* Logged in users can track their sleep over time using the sleep tracker in toolkit
* Users who have tracked sleep can view:
  * hours slept each night over the past week
  * average number of hours slept over the past week
  * times they woke up each night for the past week
  * notes they made about their sleep from the past week
* Users can view the previous 7 days sleep data, or go forward once they've gone back.
* [Styleguide](https://www.healthlocker.uk/components)
