rootProject.name = "java-resilience-lab"

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)

    repositories {
        mavenCentral()
    }
}

include(
//    ":services:order-service"
    ":services:payment-service",
//    ":services:notification-service",
//    ":libraries:resilience-core",
//    ":libraries:observability-spring-boot-starter",
//    ":tools:load-generator",
)