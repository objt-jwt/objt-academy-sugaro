pluginManagement {
    repositories {
        gradlePluginPortal()

        maven {
            setUrl("https://artifactory.new-solutions.com:443/artifactory/objt-maven-gradle-plugins-local")
            credentials {
                username = "objt-read"
                password = "SmR\$n9azp&Qu"
            }
        }
    }

    plugins {
        id("objt-java") version "1.0.0.0"
        id("objt-java-library") version "1.0.0.0"
        id("objt-publish") version "1.0.0.0"
        id("io.freefair.aspectj.post-compile-weaving") version "5.1.0"
        id("org.jetbrains.gradle.plugin.idea-ext") version "1.0"
    }
}

// set the rootproject's name to the dir it's stored in (spaces replaced by underscore)
rootProject.name = rootDir.name.replace(' ', '_')

// platform
include("objt-platform")

// libraries
include("objt.meta.model")
include("objt.custom")

// translations
include("objt.translations")

// settings
include("objt.settings")

// server applications
include("objt.applicationserver")
include("objt.schedulingserver")
include("objt.accessserver")
include("objt.printserver")
include("objt.deviceserver")
include("objt.datawarehouseserver")

// client applications
include("objt.swingclient")
include("objt.configurator")
include("objt.supervisor")
include("objt.mes.operatorclient")
include("objt.wms.operatorclient")
include("objt.tagexplorer")

// supporting applications
include("objt.thinclient")
include("objt.updater")
include("objt.dbbackuprestore")
include("objt.applicationserver-tools")
include("objt.datawarehouseserver-tools")
