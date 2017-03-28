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

## How?

#### Updating select input options (e.g. security questions)
Security questions can be updated by editing the
[`security_questions.txt` file](web/static/assets/security_questions.txt).

Click on the pencil in the top right corner of the file.
![edit-file](https://cloud.githubusercontent.com/assets/1287388/24212494/74f767d0-0f27-11e7-95b8-2b3bff21cbc5.png)

Make any changes you wish to the file. Delete questions, change the wording,
or add new ones. The only thing to keep in mind for this is to put each question
in the file on it's own line. Do not use commas or anything besides a new line
to separate questions.

```
Question 1?
Question 2?
Question 3?
```

After you are done making changes, you can find a box underneath the file that
says `Commit changes`.

![commit-changes](https://cloud.githubusercontent.com/assets/1287388/24213604/fb238f2a-0f2a-11e7-8a60-251e40e3251c.png)

In here, you can write a short message in the box that says `Update` describing
the change e.g. Add new security question, Reword security question, etc.

Ensure the bottom option ("*Create a new branch for this commit and start a
pull request.*") is ticked as in the image above.

Click on `Propose file change`.

You will be taken to a new page where you can create a pull request. You can
leave the default text as the title, and reference any related issues in the
comment box.

Click `Create pull request` in the bottom right.

![create-pr](https://cloud.githubusercontent.com/assets/1287388/24213909/e2c6164a-0f2b-11e7-8ccf-d3f206108488.png)

If you are happy with the changes, change the label to `awaiting-review`:

![awaiting-review](https://cloud.githubusercontent.com/assets/1287388/24214001/21fe0ac0-0f2c-11e7-96a5-8f58110637c5.png)

Then add a `Reviewer` and `Assignee` of your choice.

The options for `hours_slept` and `wake_count` can be updated in the same way.
Go to the files for [hours_slept](web/static/assets/hours_slept.txt) or
[wake_count](web/static/assets/wake_count.txt), and follow through the
instructions above.

## What?  

#### Current features

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
