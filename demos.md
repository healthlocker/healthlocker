# Demos

## Tuesday 7-Feb-2017 demo agenda
+ Currently optimised for mobile devices
+ Show homepage, currently includes 1 story and 1 tip (of the day)
  + Events will be added but we want to prove the concept with these two content types first
+ Can either
  + Click on 'Read this story' to show the full story
  + Click back to homepage
    + _NB. We definitely still need a home breadcrumb or icon here for easy access to homepage_
  + Now click on 'See more stories' to see all the stories (we don't have many in the database yet!)
  + Click back to homepage
+ Similarly for tips we can:
  + 'See more tips' OR
  + Select to see more tips from a **pre-determined (for now) list of tags**, denoted by the hashtags
+ If we head to the menu, we can see that we are logged out (we're given the option to log in)
  + If we try to go to the place to create posts, we get an error showing we must be logged in (and have the right permissions) to do so
+ Now we log in (we only have one user set up at the moment)
  + This takes us straight to the new post page
  + Currently there are two types of post we can create:
    + Let's create a story: this supports markdown for styling and is denoted by a `#story#` hashtag
    + Let's also create a tip: this doesn't have any styling, but must have the `#tip` hashtag. It can also support the pre-determined hashtags (currently `#connect`, `#keeplearning`, `#givetoothers`, `#beactive` and `#takenotice`)
+ If we now head to our homepage, we can check out the more stories link and the more tips link to see our new tip and stories
  + These are currently in chronological order but can be reversed so that the newest is always at the top
+ Lastly, we have also put in placeholders for the 'About' (still in progress) and 'Get support' (highlighted button) pages


## Tuesday 24-Jan-2017 demo agenda
+ Context: Majority of this sprint has been spent on setup, start made on
functionality for the not-logged-in content creation
+ Mini demo:
  + Setup
  + Phoenix app
  + Front end
+ Normally we would have a sprint retrospective but we will only be working together
in the coming sprint so we will do this in following demo slots
+ Review existing issues with HL team, talk through process and what a good user
 story looks like (including acceptance criteria)
+ Answer questions on ways of working together
  + HL team will need to make sure they know markdown
  + HL team HTML and tachyons workshop
+ Sprint planning for sprint 2
