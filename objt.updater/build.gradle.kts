import org.apache.tools.ant.filters.ReplaceTokens

plugins {
    id("objt-java")
    id("application")
    id("io.freefair.aspectj.post-compile-weaving")
    id("org.jetbrains.gradle.plugin.idea-ext")
}

idea {
    module {
        excludeDirs = setOf(file("logs"))
    }
}

// general build properties
val distributionName = project.property("distributionName")
val environmentName = project.property("environmentName")
val nativeDistributionProperties = project.ext["nativeDistributionProperties"] as java.util.Properties
val nativeDistributionTokens = nativeDistributionProperties.toMap() as Map<String, Any>

dependencies {
    implementation(platform(project(":objt-platform")))
    implementation(group = "com.objt", name = "objt.updater-core")
    implementation(project(":objt.custom")) { isTransitive = false }
    runtimeOnly(project(":objt.meta.model"))
    runtimeOnly(project(":objt.settings"))

    implementation(project(":objt.applicationserver")) {
        isTransitive = false
    }

    // database drivers
    runtimeOnly(group = "com.microsoft.sqlserver", name = "mssql-jdbc")
    runtimeOnly(group = "oracle", name = "ojdbc7")
}

/** EXECUTION **/

application{
    mainClass.set("objt.updater.core.Updater")
}

val runTask : JavaExec = tasks.getByPath("run") as JavaExec
runTask.args = listOf("updater.properties", "updater.xml")

/** DISTRIBUTION **/

// make sure the installDist task depends on the distributiontokens for its up-to-date check
tasks.getByName("installDist").inputs.properties(nativeDistributionTokens)

// include the default and environment-specific distributables
val distFiles = copySpec {

    from("$projectDir/src/main/env/default/dist")
    from("$projectDir/src/main/env/$environmentName/dist")

    if (distributionName != "main") {
        from("$projectDir/src/$distributionName/dist")
        from("$projectDir/src/$distributionName/env/default/dist")
        from("$projectDir/src/$distributionName/env/$environmentName/dist")
    }
}

val nativeDistFiles = copySpec {
    with(distFiles)

    filesMatching(listOf("**/*.properties", "**/*.ini")) {
        filter(ReplaceTokens::class, "tokens" to nativeDistributionTokens, "beginToken" to "\${", "endToken" to "}")
    }
}

// include the scripts
val scriptFiles = copySpec {
    from("${projectDir}/src/main/scripts")
    into("scripts")
}

distributions {
    main {
        contents {
            with(nativeDistFiles, scriptFiles)
            exclude("**/.MySCMServerInfo")
        }
    }
}

tasks.startScripts {
    enabled = false // don't use the default generated scripts because we're using wrapper to launch the application
}
