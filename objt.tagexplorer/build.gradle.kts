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

dependencies {
    implementation(platform(project(":objt-platform")))
    implementation(group = "com.objt", name = "objt.tagexplorer-core")
    implementation(project(":objt.custom")) { isTransitive = false }
}

/** EXECUTION **/

application{
    mainClass.set("objt.tagexplorer.TagExplorer")
    applicationDefaultJvmArgs = listOf("-server", "-Xms64M", "-Xmx256M")
}

val runTask : JavaExec = tasks.getByPath("run") as JavaExec
runTask.args = listOf("tagexplorer.properties", "objt/tagexplorer/tagexplorer.xml")

/** DISTRIBUTION **/

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

/* method to build the <jar href="..." /> references for the .objt files */
fun buildObjtFileLibs() : String {
    // get our own output file(s)
    val files = tasks.getByName(JavaPlugin.JAR_TASK_NAME).outputs.files.files
    // add our runtime jar dependencies
    files.addAll(sourceSets["main"].runtimeClasspath.files.filter { file -> file.name.endsWith(".jar") })

    var i = 1
    var libs = ""
    files.sortedBy { file -> file.name }.forEach { file ->
        if (i > 1) libs = libs.plus("\t\t")
        libs = libs.plus("<jar href=\"lib/${file.name}\" />")
        if (i < files.size) libs = libs.plus("\n")
        i++
    }

    return libs
}

distributions {
    main {
        contents {
            with(distFiles)
            exclude("**/.MySCMServerInfo")
            filesMatching("**/*.objt") {
                val libs = buildObjtFileLibs()
                filter(org.apache.tools.ant.filters.ReplaceTokens::class,"tokens" to mapOf("libs" to libs), "beginToken" to "\${", "endToken" to "}")
            }
        }
    }
}

tasks.startScripts {
    enabled = false // don't use the default generated scripts because we're using wrapper to launch the application
}




