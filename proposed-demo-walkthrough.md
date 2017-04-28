# Proposed demo walkthrough

The purpose of this file is to contain the latest proposed walkthrough of the Healthlocker application to aid anyone who would like to demo it to users.

## Features to discuss
+ Non-logged in flow
+ Sign up flow
+ Login flow for users
  + Log in as Evan
  + _Note: 'Forgotten password' not working yet!_
+ **Logged in service user:** (Evan)
  + Goals
  + Coping strategies
  + Input sleep data
    (possible copy change here - input sleep data for today?)
    + Try to input sleep data again, show error
  + Review sleep data
    + Show previous 7 days
  + Care plan placeholder?
+ **Log in as different service user** (yourself) to show connecting as carer to Evan (in Account > Connect with the SLaM Care Team of someone I care for)
  + Evan's NHS number:  gLiyI9gsgoHjQc6pMcaT
  + Evan's DOB: 14/01/1975
  + Remember to show that 'Care Team' now appears in the burger menu on the top left hand corner
  + Show Care Team screen which shows you are now connected to Evan and can see who his care team is (more functionality coming soon)
+ **Log in as clinician** (Robert MacMurray)
  + Show caseload
  + In an incognito window, log in as Lisa and connect her to her SLaM account (making her an 'active Healthlocker user')
  + Back in your clinician window, refresh the page and Lisa should now move up to the Healthlocker user list
  + _Note: I think working in inactive users is a bit misleading, somone of the **might** have signed up to Healthlocker, but none of them have connected their SLaM accounts up - we'll need to rethink this_
  + Click into service user to see Contact details data (most of this data is currently pulled from fake ePJS with email being the [only field from HL](https://github.com/healthlocker/healthlocker/issues/514)) - this screen will ultimately include goals, coping strategies, messaging and tracker data
