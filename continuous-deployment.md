# Continuous Deployment using Travis-CI & Edeliver

## Context

We already have a Virtual Machine (VM) configured on Microsoft Azure
according to: https://github.com/dwyl/learn-microsoft-azure

Edeliver is setup according to:
[production-deployment.md](https://github.com/dwyl/learn-phoenix-framework/blob/master/production-deployment.md)

The purpose of this guide is to show _exactly_ how we have enabled
"Continuous Deployment" each time a Pull Request passes all it's
"Integration Tests" on Travis-CI.

The guide is _necessarily_ technical, but with enough screenshots,
we expect that any reasonably experienced person will be able
to follow, understand, replicate and exend it (_where necessary_).

> Note: if you are `new` to Travis-CI, please see:
[github.com/dwyl/**learn-travis**](https://github.com/dwyl/learn-travis)

## Why?

Continuous Deployment _completely_ automates the process of
deploying the latest version of the project/application to a given environment.
This saves a _considerable_ amount of time for the team as
there are no _manual_ steps to perform each time a new feature or bug-fix
needs to be deployed, and avoids confusion around which version is
on the given instance.


## What?

Each time a commit passes the Tests on Travis-CI it is _automatically_
deployed to https://staging.healthlocker.uk so it can be tested
(_by humans_) and the feature in a given commit (Pull Request)
can be "_signed off_" as meeting the "_acceptance criteria_".

## How?

> Our aim is to make this guide _complete_ so it can be "_owned_" by
the NHS Technical team without any _dependence_ on the _original_ development
team. However if you (_the reader_) have _any_ questions,
please do not hesitate to contact us (_the authors_) by opening an issue on GitHub!
