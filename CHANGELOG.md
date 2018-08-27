# Unreleased
- Karaf base image with resolved bundles from features file
- Karaf container `HEALTHCHECK`

# 0.2.0
- latest AET from `master` (with Chrome support and new OSGi configurations)
- added Karaf image `ENV` variable `MONGODB_URI` that enables to set `mongoURI` at the cluster manager level (e.g. to external MongoDB instance)
- optionally running Karaf in Debug mode

# 0.1.0
- expose port range in BrowserMob container
- updated AET app (from the latest [`milestone/chrome-support`](https://github.com/Cognifide/aet/tree/milestone/chrome-support))
- selenium grid updated to `3.14.0-arsenic`
- added Karaf image `ENV` variable `REPORT_DOMAIN` that enables to set `ReportConfigurationManager.reportDomain` at the cluster manager level