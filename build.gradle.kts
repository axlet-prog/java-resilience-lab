import org.springframework.boot.gradle.plugin.SpringBootPlugin

plugins {
    id("org.springframework.boot") version "4.2.0" apply false
}

allprojects {
    group = "dev.axlet.resilience"
    version = "0.0.1-SNAPSHOT"
}

subprojects {
    plugins.withId("java") {
        extensions.configure<JavaPluginExtension> {
            toolchain {
                languageVersion.set(JavaLanguageVersion.of(25))
            }
        }

        tasks.withType<Test>().configureEach {
            useJUnitPlatform()
        }
    }
}