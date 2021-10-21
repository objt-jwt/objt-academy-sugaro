import org.apache.tools.ant.filters.ReplaceTokens

plugins {
    id("objt-java")
    id("application")
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

// native library configuration (use for declaring native dependencies)
val nativeLibsConfiguration = configurations.create("nativeLibs")

dependencies {
    "nativeLibs"(platform(project(":objt-platform")))

    implementation(platform(project(":objt-platform")))
    implementation(group = "com.objt", name = "objt.printserver-core")
    implementation(project(":objt.custom")) { isTransitive = false }

    runtimeOnly(project(":objt.settings"))

    // servicewrapper
    runtimeOnly(group = "com.objt", name = "objt.servicewrapper")
    runtimeOnly(group = "org.tanukisoftware", name = "wrapper")
    "nativeLibs"(group = "org.tanukisoftware", name = "wrapper-windows-x86-32")

    // (optional) teamdev ComfyJ for objt.servicewrapper.ComServiceWrapper
    runtimeOnly(group = "com.jniwrapper", name = "comfyj")
    "nativeLibs"(group = "com.jniwrapper", name = "comfyj-windows")

    // (optional) jacozoom for objt.servicewrapper.JacoZoomComServiceWrapper
//    runtimeOnly(group = "com.inzoom", name = "izmcomjni")
//    "nativeLibs"(group = "com.inzoom", name = "izmcomjni-win32")

    // objt.driver.print
    implementation(group = "com.objt", name = "objt.driver.print")
    // optional dependencies based on used print engine
    runtimeOnly(group = "com.objt", name = "objt.driver.print-nicelabel")
    runtimeOnly(group = "com.objt", name = "objt.driver.print-bartender")
    runtimeOnly(group = "com.objt", name = "objt.driver.print-codesoft")
    runtimeOnly(group = "com.objt", name = "objt.driver.print-colos")

    // slf4j
    runtimeOnly(group = "org.slf4j", name = "slf4j-simple")

    // serialio
    runtimeOnly(group = "com.serialio", name = "serialio")
    "nativeLibs"(group = "com.serialio", name = "serialio-windows")
}

/** BUILD **/

// task to extract the native libraries from the jar resource to the build output dir
val extractNativeLibs = task<Sync>("extractNativeLibs") {
    nativeLibsConfiguration.resolve().forEach { file -> from(zipTree(file.path)) }
    into(file("${buildDir}/native"))
}

// copy the environment properties to the resources folder before they are processed to the output folder
tasks.processResources {
    dependsOn(extractNativeLibs)
}

/** EXECUTION **/

application{
    mainClass.set("dce.util.net.service.ComServiceWrapper")
//    applicationDefaultJvmArgs = listOf("-server", "-Xms128M", "-Xmx512M", "-XX:+UseG1GC")
}

// set the startup arguments for the application
val runTask = tasks.getByPath("run") as JavaExec
runTask.setExecutable("C:/java/jdk1.8.0/bin/java.exe")
runTask.args = listOf("dce.pd.server.ApplicationServer", "printserver.properties", "objt/app/printserver/printserver.xml")
runTask.systemProperty("java.library.path", "${buildDir}/native")

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

    filesMatching(listOf("**/*.properties", "**/*.ini")) {
        filter(ReplaceTokens::class, "tokens" to nativeDistributionTokens, "beginToken" to "\${", "endToken" to "}")
    }
}

// include the x64 wrapper files for the deployment
val serviceWrapperFiles = copySpec {
    from("C:/javalib/javaServiceWrapper/3.5.37/windows-x86-32") {
        include("*.exe")
    }
    into("bin")
}

// include the native libraries
val nativeLibs = copySpec {
    from("${buildDir}/native")
    into("lib/native")
}

// include the data
val data = copySpec {
    from("${projectDir}/data/labels")
    into("data")
}

// include the environment specific config files
val environmentConfigFiles = copySpec {

    // include the main distribution's config
    from("$projectDir/src/main/env/default/config")
    from("$projectDir/src/main/env/$environmentName/config")

    if (distributionName != "main") {
        // include this distribution's default config
        from("$projectDir/src/$distributionName/env/default/config")
        // include this distribution's environment-specific config
        from("$projectDir/src/$distributionName/env/$environmentName/config")
    }

    into("config")
}

// include the config.default files
val defaultConfigFiles = copySpec()

// configure the copyspec after project evaluation to postpone the resolve
afterEvaluate {
    // add the core's default config
    configurations.runtimeClasspath.get().resolve().forEach { file ->
        if (file.name.startsWith("${project.name}-core")) {
            defaultConfigFiles.from(zipTree(file)) {
                include("modules/")
            }
        }
    }

    // include the main distribution's defaults
    defaultConfigFiles.from("$projectDir/src/main/env/default/config")

    if (distributionName != "main") {
        // include this distribution's defaults
        defaultConfigFiles.from("$projectDir/src/$distributionName/env/default/config")
    }

    defaultConfigFiles.into("config.default")
}

distributions {
    main {
        contents {
            with(distFiles, environmentConfigFiles, defaultConfigFiles, serviceWrapperFiles, nativeLibs, data)
            exclude("**/.MySCMServerInfo")
        }
    }
}

tasks.startScripts {
    enabled = false // don't use the default generated scripts because we're using wrapper to launch the application
}


