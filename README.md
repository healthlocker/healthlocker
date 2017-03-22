# Healthlocker

## Getting started

#### Install the following:
* [Elixir](https://github.com/dwyl/learn-elixir#how)
* [Postgresql](https://github.com/dwyl/learn-postgresql) (and ensure you create a user)
* [Node.js](https://nodejs.org/en/)

#### Once everything is installed:
* Enter `brew link autoconf automake` into your terminal
* Open Postgresql (if you can see the elephant symbol in your menu bar you know that it's running)
* Get dependencies (including if they are out of date) with `mix deps.get`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`
* If prompted by the following message, enter `y`:

` Could not find "rebar3", which is needed to build dependency :fs
I can install a local copy which is just used by Mix
Shall I install rebar3? (if running non-interactively, use: "mix local.rebar --force") [Yn] `
* Install Node.js dependencies with `npm install`
* Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check the deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


# What?

### Current features

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
