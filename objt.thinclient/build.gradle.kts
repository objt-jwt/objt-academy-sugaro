import org.apache.tools.ant.filters.ReplaceTokens

plugins {
    id("distribution")
}

// general build properties
val distributionName = project.property("distributionName")
val environmentName = project.property("environmentName")
val nativeDistributionProperties = project.ext["nativeDistributionProperties"] as java.util.Properties
val nativeDistributionTokens = nativeDistributionProperties.toMap() as Map<String, Any>

val distBin = copySpec {
    from("C:/javalib/thinclient/2.0.0")
    
    include("ThinClient.exe")
    include("dialogmgr.xml")
    include("dce.dll")
}

// include the default and environment-specific distributables
val distFiles = copySpec {

    from("$projectDir/src/main/env/default/dist")
    from("$projectDir/src/main/env/$environmentName/dist")

    if (distributionName != "main") {
        from("$projectDir/src/$distributionName/dist")
        from("$projectDir/src/$distributionName/env/default/dist")
        from("$projectDir/src/$distributionName/env/$environmentName/dist")
    }

    filesMatching("**/*.xml") {
        filter(ReplaceTokens::class, "tokens" to nativeDistributionTokens, "beginToken" to "\${", "endToken" to "}")
    }
}

distributions {
    main {
        contents {
            with (distBin, distFiles)
        }
    }
}

tasks.register<Exec>("run_thinclient_[test1]") {
    dependsOn("installDist")

    group = "application"

    workingDir = file("$buildDir/install/${project.name}")
    commandLine(listOf("cmd", "/c", "thinclient_test1.cmd"))
}

tasks.register<Exec>("run_thinclient_[test2]") {
    dependsOn("installDist")

    group = "application"

    workingDir = file("$buildDir/install/${project.name}")
    commandLine(listOf("cmd", "/c", "thinclient_test2.cmd"))
}

tasks.register<Exec>("run_thinclient-android_[CK75]") {
    group = "application"

    commandLine(listOf("cmd", "/c", "C:/Android/OAE_CK75.cmd"))
}

tasks.register<Exec>("run_thinclient-android_[VM1A]") {
    group = "application"

    commandLine(listOf("cmd", "/c", "C:/Android/OAE_VM1A.cmd"))
}
