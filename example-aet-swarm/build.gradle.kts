plugins {
    id("com.cognifide.environment") version("1.1.8")
}

defaultTasks("up", "await")

environment {
    docker {
        containers {
            "mongo" {
                resolve {
                    ensureDir("data")
                }
            }

            // optional, even will be not needed after: https://github.com/Cognifide/gradle-environment-plugin/issues/12
            define("hub", "chrome", "activemq", "browsermob", "karaf", "report")
        }
    }
    healthChecks {
        http("Karaf", "http://karaf:karaf@localhost:8181/health-check", "HEALTHY")
    }
}