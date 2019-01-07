# Unreleased

# 0.8.0
- AET Version upgraded to [`3.2.0`](https://github.com/Cognifide/aet/releases/tag/3.2.0) release
- AET OSGi configs managed by Docker Configs in the stack file
- `example-aet-swarm` module with example cluster setup and configs

# 0.7.1
- [PR-4](https://github.com/Skejven/aet-docker/pull/4) - fixed incorrect format of ChromeWebDriverFactory config

# 0.7.0
- AET Version upgraded to [`3.1.0`](https://github.com/Cognifide/aet/releases/tag/3.1.0) release

# 0.6.1
- Fixed problem with Karaf configuration files permission denied

# 0.6.0
- AET Version upgraded to the official [`3.0.0`](https://github.com/Cognifide/aet/releases/tag/3.0.0) release
- [Best practices for setting up AET instance with docker](https://github.com/Skejven/aet-docker#best-practices-when-setting-up-aet-instance) added.
- Added [minimum requirements](https://github.com/Skejven/aet-docker#minimum-requirements) section.

~~# 0.5.0 - please don't use this version~~
~~- AET Version upgraded to [`3.0.1`](https://github.com/Cognifide/aet/releases/tag/3.0.1)~~

# 0.4.1
- Fixed maintainer label
- More generic build and release scripts (with `version` arg)
- Fixed Runner OSGi config
- **Beta version of [AET suite generator](https://github.com/m-suchorski/suite-generator/tree/feature/suite)**

# 0.4.0
- Swarm file removed from the repository, it will be available only in the release artifact
- full AET log now is available with `docker service logs aet_karaf -f` (from Karaf internal, runner, worker and cleaner)
- AET version upgraded to [`3.0.0-rc01`](https://github.com/Cognifide/aet/releases/tag/3.0.0-rc01)

# 0.3.0
- latest AET from `master` (with Chrome support, new OSGi configurations, suite history support and advanced screenshot comparison)
- Karaf base image with resolved bundles from features file
- Karaf container `HEALTHCHECK` (in swarm config)
    - Original `HEALTHCHECK` from the Karaf's Dockerfile was moved to swarm config because of some odd behaviour (container never was `healthy` when multi-stage build was applied)
    ```
    ARG HEALTHCHECK_PHRASE="204 bundles in total - all 204 bundles active"
    HEALTHCHECK --interval=1m --timeout=10s --start-period=120s \
       CMD curl -v --silent http://karaf:karaf@localhost:8181/system/console/bundles 2>&1 | grep -Fq ${HEALTHCHECK_PHRASE} || exit 1
    ```
- version of compose-file upgraded from `3` to `3.6` (for the healthcheck `start_period` option), notice it requires Docker Engine `18.02.0+`
- upgraded way of downloading Apache Karaf distribution

# 0.2.0
- latest AET from `master` (with Chrome support and new OSGi configurations)
- added Karaf image `ENV` variable `MONGODB_URI` that enables to set `mongoURI` at the cluster manager level (e.g. to external MongoDB instance)
- optionally running Karaf in Debug mode

# 0.1.0
- expose port range in BrowserMob container
- updated AET app (from the latest [`milestone/chrome-support`](https://github.com/Cognifide/aet/tree/milestone/chrome-support))
- selenium grid updated to `3.14.0-arsenic`
- added Karaf image `ENV` variable `REPORT_DOMAIN` that enables to set `ReportConfigurationManager.reportDomain` at the cluster manager level
