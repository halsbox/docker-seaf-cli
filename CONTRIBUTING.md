**Do you want to contribute ? Please do!**

* [How to help?](#how-to-help?)
    * [Report issues, propose features](#report-issues-propose-features)
    * [Solve problems](#solve-problems)
    * [Say thanks](#say-thanks)
* [Project workflow](#project-workflow)
    * [Environment](#environment)
    * [Development](#development)
    * [CI/CD](#ci/cd)

# How to help?
They are several ways to help and improve this project.

## Report issues, propose features
You think you found a bug ? You think something is missing out ? Check that it has not been [already reported](https://gitlab.com/flwgns-docker/seafile-client/-/issues). If it has not, [report it](https://gitlab.com/flwgns-docker/seafile-client/-/issues/new?issue).

## Solve problems
You can't wait for a problem to be solved ? Pick one from the [already reported problems](https://gitlab.com/flwgns-docker/seafile-client/-/issues) and solve it. It will be greatly appreciated!

## Say thanks
One great way to help is simply to say thanks. You can do that by [adding a star to the Docker Hub repository](https://hub.docker.com/r/flowgunso/seafile-client) or [just saying thanks in the project topic on Seafile's forum](https://forum.seafile.com/t/docker-client-to-sync-files-with-containers/8573).

# Project workflow
The ins and outs of the project, from setting up a local environment for developments to notifying users of changes.

## Environment
The following is required to develop:
* Docker engine
* Bash

## Development

A few utilities Bash scripts are available to operate the project:
* [build.sh](.utilities/build.sh): build the Docker image and save as a tarball
* [check.sh](.utilities/check.sh): validate CI pipelines
* [package_update_notifier.sh](.utilities/package_update_notifier.sh): notify, through a GitLab issue, if a new `seaf-cli` version is available
* [publish.sh](.utilities/publish.sh): tag and push the image to Docker Hub
* [test.sh](.utilities/test.sh): run the test suite
* [update-docker-hub-full-description.sh](.utilities/update-docker-hub-full-description.sh): push the README.md to the Docker Hub
* [utilities.sh](.utilities/utilities.sh): functions and assets

Following a trunk-based development strategy, all changes must come from a short lived branch and fast-forward merged into master.  
All commits must be squashed into a single commit referencing a specific issue.

## CI/CD
Tests are run only on merge requests, but they can be run on demand in a local environment.  
The [CHANGELOG.md](CHANGELOG.md) and [AUTHORS.md](AUTHORS.md) will be updated on every merge.  
Only merge resquests associated with a milestone will end up in a new release. The [README.md](README.md) will be updated then. Description pages for Docker Hub and Seafile's forum will be templated then as well and made available as artifacts for a manual update since #10 and #17 are still opened issues.
