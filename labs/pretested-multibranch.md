# Jenkins Multibranch Pipeline

TODO: Review this with the new exercises

## Description

This is a proof of concept for a Jenkins Multibranch Pipeline,
    using a multibranch scripted pipeline with pretested integration,
    and version-based branching.

In the example we use [Semantic Versioning 2.0.0](https://semver.org/),
    i.e MAJOR.MINOR.PATCH, with a V in front, e.g. `V1.0.0`.

Jenkinsfile inspired by [jenkinsfile-examples/android-build-flavor-from-branch](https://github.com/jenkinsci/pipeline-examples/tree/master/jenkinsfile-examples/android-build-flavor-from-branch).

## Prerequisites

- Generate an SSH keypair
- A repository on GitHub "or similar"
- A running Jenkins instance

## GitHub setup

1. Create new repository
1. Add deploy key with write access using `public key` of SSH

## Jenkins setup

1. Install Jenkins with the `Pipeline` and `Pretested Integration` plugins.
1. Create `Credential` to auth against GitHub using `private key` of SSH
    1. `Manage Jenkins`
    1. `Credentials`
    1. `(global) -> Add Credentials`
    1. `SSH Username with private key`

1. Create new `Multibranch Pipeline`
    1. `Add source -> Git`
    1. Use url of repository on GitHub (use the `git@..` for SSH access)
    1. Use previously created credential as `Credential`
    1. "Maybe" configure `Scan Multibranch Pipeline Triggers -> 1 minute` for debugging purposes

## Development

In this example, we have three branches:

```shell
  remotes/origin/V1.0.0
  remotes/origin/V2.0.0
  remotes/origin/V3.0.0
```

All of them are "master" branches, meaning that they are branches we are making release candidates from.

### Developing a feature on a version

`checkout` the version from `origin`

```shell
git fetch               # download references from repository
git pull origin V3.0.0  # pull version to base feature on
```

Create a feature-branch based off of the version

```shell
$ git checkout V3.0.0       # switch to V3.0.0 master-branch
$ git branch FIX-123        # create a feature-branch from current branch (V3.0.0)
$ git checkout FIX-123      # switch to newly created feature-branch

# or use

$ git checkout -b FIX-123   # create and switch branch in one go
```

> NB: (optionally) name the feature-branch `V3.0.0-FIX-123`,
> if it's only related to this version.
> This makes it easier to track with the `git branch` command.

.. do some work on branch `FIX-123` (or `V3.0.0-FIX-123`)

```shell
$ git add some-file-i-changed.md                        # stage work / changes
$ git commit -m "FIX title.. close #FIX-123"            # make a new commit
$ git push origin FIX-123:ready/V3.0.0/FIX-123          # deliver change
$ git push origin <feature>:ready/<version>/<feature>
```

### Creating a "new version"

`checkout` "the newest master version branch" from the repository

```shell
$ git fetch
$ git pull origin V2.0.0
```

Create a new version master

```shell
$ git checkout V2.0.0                       # base the new master off of the newest master
$ git checkout -b V3.0.0                    # create and switch to new version branch
$ git push origin V3.0.0:V3.0.0             # push the new version branch to origin
```

> NB: you might also want to change the "Default branch" on the repository
> So people get the latest master version when they clone the repository.

Configure the `V3.0.0`-branch to track the `origin/V3.0.0` branch,
with the following command:

```shell
$ git --set-upstream origin/V3.0.0 V3.0.0   # track origin/V3.0.0 from (local) V3.0.0
```

> NB: this will show how many commits your local branch is ahead or behind,
> when you've checked it out in your current workspace.

## FAQ

### Q: what if `V1.2.3` doesn't exist, and I do `git push origin FIX-123:ready/V1.2.3/FIX-123`

A: Jenkins complains: `stderr: error: pathspec 'origin/V1.2.3' did not match any file(s) known to git.`

Possible solution: push to a master version branch that exists.
    If you need `V1.2.3`,
    create it like a new version (based off of the same version as `FIX-123`.)

### Q: I delivered with `git push origin FIX-123:ready/V1.0.0/FIX-123` but after a while my branch disappeared

A: Check the repository or the Jenkins logs.
    After a successful integration,
    your `ready/*`-branch should be removed.
