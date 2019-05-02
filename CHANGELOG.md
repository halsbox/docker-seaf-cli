## [1.2.0] - 2019/05/02
- Replace _supervisord_ with _cron_ for running the front job that keeps the container up. It uses less resources.
- Improve the __infinite-seaf-cli-start.sh__ into __seafile-healthcheck.sh__. The Seafile daemon will not be restarted if it's state are either _downloading_ or _committing_, which otherwise is problematic.
### [1.1.2] - 2019/04/18
- Slim down the Docker image, from 102MB to 67MB, gaining 35MB, reducing size by 34%.
### [1.1.1] - 2019/04/18
- Because of the infinite-seaf-cli-start loop, within the container was running many seaf-daemons. Now, the infinite loop stop the current seaf-daemon before starting it again. (see #3)
## [1.1.0] - 2019/04/09
- The container now actually use the UID/GID provided to it:  
The container entrypoint is run with root, then another entrypoint is run by the container's user, seafuser, to run the Seafile client.

### [1.0.6] - 2019/03/25
- More minor fixes from v1.0.4
### [1.0.5] - 2019/03/25
- Minor fixes from v1.0.4
### [1.0.4] - 2019/03/25
- Fix the build target detection (@a52559ddb38a64d7fceaa8bf9b8afd7356ccc439)
- Login to the Docker Hub from within the script, not the gitlab-ci.yml, using (@72bab017c1167b8ab35cef3cc709ff83686eaca4, @f69483354a4cf8afdbea89ef2bb1d9a9b7b2ac10)
- Require Bash on all Gitlab CI stages (@72bab017c1167b8ab35cef3cc709ff83686eaca4)
- Add a script to push the README.md into the Docker Hub repository's full_description (@8cb49cbc8253368701d718c2e38017790c78ceca, @ca6128fb96602da71f3b7a560e834d1b7587abac)
### [1.0.3] - 2019/03/19
- Restrict staging pipelines to pushed pipelines
- Restrict production pipelines to pushed and triggered pipelines
- Require a build target on triggered production pipelines
### [1.0.2] - 2019/03/18
- Fix a minor issue when testing for requested production build.
### [1.0.1] - 2019/03/18
- Add failsafe when importing Seafile's APT-key
- Restrict production build to latest, majors, minors and revisions version, on-demand.
# [1.0.0] - 2019/03/15
- Release to Docker Hub

# [0.9.2] - 2019/03/15
- Test release on GitLab, before Docker Hub
