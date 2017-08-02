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

> If _anyone_ is ever in any doubt as to "which version is on which environment",
simply visit: https://staging.healthlocker.uk/_version


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

### Encrypted SSH Key for Deployment

#### Download the Private Key File

On your `localhost`, download the `private` key you created in the previous step.

```
scp root@51.140.86.5:/root/.ssh/id_rsa ./deploy_key
echo "deploy_key" >> .gitignore
```

![download-ssh-key](https://user-images.githubusercontent.com/194400/28846821-c8570300-7704-11e7-993c-478010457fbd.png)

_Ensure_ you don't accidentally commit the _private_ key
to GitHub by your `.gitignore` file.

#### Encrypt the Private Key

Again, on your localhost, encrypt the `private` key using Travis' CLI:

```
gem install travis
touch .travis.yml && travis encrypt-file ~/.ssh/deploy_key --add
```

You should have a `deploy_key.enc` file in your working directory.
This should be added/commited to GitHub so that Travis can use it.

#### How the Private RSA Key is Used by Travis-CI to Deploy using Edeliver

The key decrypted by Travis in the `before_install:` script.
We check that the decrypted key is valid by testing the `ssh` access in `after_success:`
If that works, we attempt to run the `mix edeliver build upgrade` task.

### Version Route

visiting the `/_version` route will give you the _current_ version of the app
running in that environment e.g: https://staging.healthlocker.uk/_version

![image](https://user-images.githubusercontent.com/194400/28873365-430727f8-7785-11e7-96f0-67ef0a056a3e.png)

### Version Script

When the app is being deployed on Travis-CI,
Travis needs to know _exactly_ which version to deploy
e.g: `/home/hladmin/healthlocker/releases/1.0.3+3a4f948/healthlocker_1.0.3+3a4f948.tar.gz`

the `.deliver/version.sh` bash script handles returning the latest version to be deployed.
