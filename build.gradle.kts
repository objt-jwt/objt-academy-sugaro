import java.io.FileInputStream
import java.util.*
import java.util.regex.Pattern

plugins {
    id("objt-java")
}

// general build properties
val distributionName = project.property("distributionName")
val environmentName = project.property("environmentName")
val maturityLevel = project.property("maturityLevel")

allprojects {
    group = "com.objt.delivery.sugaro"

    // when running a dev build and the version has not been set, automatically read the 'Application.Version' property
    if (environmentName == "dev" && project.version == "unspecified") {
        version = readBuildVersion()
    }
    // don't proceed with the build script if the version hasn't been set/resolved
    if (version == "unspecified") throw Exception("version property not set")

    configurations.all {
        resolutionStrategy {
            // prefer modules that are part of this build (multi-project or composite build) over external modules
            preferProjectModules()
        }
    }
}

buildscript {
    repositories {
        // needed to find the com.objtstart dependency
        maven {
            setUrl("https://artifactory.new-solutions.com:443/artifactory/objt-maven-${project.properties["maturityLevel"]}")
            credentials {
                username = "objt-read"
                password = "SmR\$n9azp&Qu"
            }
        }
    }

    dependencies {
        classpath(group = "com.objt", name = "com.objt.start", version = "1.0.4")
        classpath(group = "com.objt", name = "objt.translation", version = "1.5.0.3")
    }
}

// add the translations to the resources-generated
subprojects.forEach { subProject ->
    val translationAssetDir = file("${subProject.projectDir}/src/main/assets/translation")

    if (translationAssetDir.exists()) {
        // create task to process the translation dictionaries
        subProject.tasks.register("processTranslations") {
            val dictionaryFiles = translationAssetDir.listFiles { f -> f.name.endsWith("_dic.xml") }
            val outputFolder = file("${project.projectDir}/src/main/resources-generated/translation")

            if (dictionaryFiles != null) inputs.files(dictionaryFiles)
            outputs.dir(outputFolder)

            doLast {
                // clear the output folder
                if (outputFolder.exists()) outputFolder.deleteRecursively()

                dictionaryFiles?.forEach {
                    if (it.name.endsWith("_dic.xml")) {
                        val dic = objt.translation.bo.Dictionary(it)
                        objt.translation.transaction.DictionaryTransaction.get().writeProperties(dic, outputFolder,
                                it.nameWithoutExtension + ".properties")
                    }
                }
            }
        }

        subProject.afterEvaluate {
            // register the resources-generated as a resource folder
            val mainSourceSet = subProject.sourceSets.getByName("main")
            val srcDirs = mainSourceSet.resources.srcDirs
            srcDirs.add(file("${subProject.projectDir}/src/main/resources-generated"))
            mainSourceSet.resources.setSrcDirs(srcDirs)

            // link to the processResources task
            subProject.tasks.getByName("processResources").dependsOn("processTranslations")
        }
    }
}

// add resources-development
subprojects.forEach { subProject ->
    // only need to do anything if we have at least an env folder in the main source
    if (file("${subProject.projectDir}/src/main/env").exists()) {
        val processDevelopmentResources = subProject.tasks.register<Sync>("processDevelopmentResources") {
            onlyIf { environmentName == "dev" }

            val nativeDistributionProperties = subProject.ext["nativeDistributionProperties"] as Properties
            val nativeDistributionTokens = nativeDistributionProperties.toMap() as Map<String, Any>

            // consider the distributiontokens as an input of this task so the resources are regenerated when the tokens change
            inputs.properties(nativeDistributionTokens)

            // include the 'main' distribution files
            from("${subProject.projectDir}/src/main/env/dev/resources")
            from("${subProject.projectDir}/src/main/env/default/config")
            from("${subProject.projectDir}/src/main/env/dev/config")

            // include the additional distribution files if needed
            if (distributionName != "main") {
                from("${subProject.projectDir}/src/$distributionName/env/dev/resources")
                from("${subProject.projectDir}/src/$distributionName/env/default/config")
                from("${subProject.projectDir}/src/$distributionName/env/dev/config")
            }

            exclude("**/.MySCMServerInfo")

            // use token replacements to get a 'dev' distribution
            filesMatching("**/*.properties") {
                filter(org.apache.tools.ant.filters.ReplaceTokens::class, "tokens" to nativeDistributionTokens, "beginToken" to "\${", "endToken" to "}")
            }

            into("${subProject.projectDir}/src/main/resources-development")
        }

        val cleanDevelopmentResources = subProject.tasks.register<Delete>("cleanDevelopmentResources") {
            onlyIf { environmentName != "dev" }

            delete("${subProject.projectDir}/src/main/resources-development")
        }

        subProject.afterEvaluate {
            // register the resources-development as a resource folder
            val mainSourceSet = subProject.sourceSets.getByName("main")
            val srcDirs = mainSourceSet.resources.srcDirs
            srcDirs.add(file("${subProject.projectDir}/src/main/resources-development"))
            mainSourceSet.resources.setSrcDirs(srcDirs)

            // link to the processResources task
            subProject.tasks.getByName("processResources") {
                dependsOn(processDevelopmentResources, cleanDevelopmentResources)
            }
        }
    }
}

// let the run tasks of the several applications depend on the global processResources task
afterEvaluate {
    val processResources = tasks.getByName("processResources")
    subprojects.forEach { subProject ->
        subProject.tasks.findByName("run")?.dependsOn(processResources)
    }
}

/** ENVIRONMENT TOKENS **/

/* method to load properties from a file into a given Properties object, overwriting any previously set value */
fun loadPropertyFile(pProperties : Properties, pFileName : String) {
    val propertiesFile = File(pFileName)
    if (propertiesFile.exists()) {
        val inputStream = FileInputStream(propertiesFile)
        inputStream.use { inputStream ->
            pProperties.load(inputStream)
        }

        logger.info("loadPropertyFile: loaded property file <$pFileName>")
    }
    else {
        logger.debug("loadPropertyFile: property file <$pFileName> not found")
    }
}

/* method to load the distribution/environment specicifc environment properties of a specified project */
fun loadDistributionProperties(pProperties : Properties, pDir : String, pFileName : String) {
    loadPropertyFile(pProperties, "$pDir/main/env/default/$pFileName")
    loadPropertyFile(pProperties, "$pDir/main/env/$environmentName/$pFileName")
    loadPropertyFile(pProperties, "$pDir/$distributionName/env/default/$pFileName")
    loadPropertyFile(pProperties, "$pDir/$distributionName/env/$environmentName/$pFileName")
}

/* load the environment tokens */
subprojects.forEach { subProject ->
    // load the general and application-specific distribution properties
    val distributionProperties = Properties()
    distributionProperties["build.version"] = project.version
    distributionProperties["build.distribution.name"] = distributionName
    distributionProperties["build.environment.name"] = environmentName
    loadDistributionProperties(distributionProperties, "$rootDir/distribution", "distribution.properties")
    loadDistributionProperties(distributionProperties, "${subProject.projectDir}/src", "distribution.properties")

    // load any 'native' distribution properties
    val nativeDistributionProperties = Properties()
    nativeDistributionProperties.putAll(distributionProperties)
    loadDistributionProperties(nativeDistributionProperties, "$rootDir/distribution", "distribution-native.properties")
    loadDistributionProperties(nativeDistributionProperties, "${subProject.projectDir}/src", "distribution-native.properties")
    // make these properties accessible on the project
    subProject.ext["nativeDistributionProperties"] = nativeDistributionProperties

    if (file("${subProject.projectDir}/src/main/docker").exists()) {
        val dockerDistributionProperties = Properties()
        dockerDistributionProperties.putAll(distributionProperties)
        loadDistributionProperties(dockerDistributionProperties, "$rootDir/distribution", "distribution-docker.properties")
        loadDistributionProperties(dockerDistributionProperties, "${subProject.projectDir}/src", "distribution-docker.properties")

        // make these properties accessible on the project
        subProject.ext["dockerDistributionProperties"] = dockerDistributionProperties
    }
}

/** END ENVIRONMENT TOKENS **/

// task to create the distribution of the applicationserver and the client applications
tasks.register("buildApplicationServerDist") {
    group = "deployment"

    dependsOn(":objt.applicationserver:installDist", ":objt.configurator:installDist", ":objt.supervisor:installDist",
        ":objt.mes.operatorclient:installDist", ":objt.wms.operatorclient:installDist", ":objt.tagexplorer:installDist")

    val httpBinDir = file("${buildDir}/install/objt.applicationserver/http/bin")

    doLast {
        /* server */
        sync {
            from("${project(":objt.applicationserver").buildDir}/install/objt.applicationserver")
            into("${buildDir}/install/objt.applicationserver")
        }

        /* clients */
        // sync the .objt launch files to the http/bin directory
        sync {
            from("${project(":objt.configurator").buildDir}/install/objt.configurator/bin",
                "${project(":objt.supervisor").buildDir}/install/objt.supervisor/bin",
                "${project(":objt.mes.operatorclient").buildDir}/install/objt.mes.operatorclient/bin",
                "${project(":objt.wms.operatorclient").buildDir}/install/objt.wms.operatorclient/bin",
                "${project(":objt.tagexplorer").buildDir}/install/objt.tagexplorer/bin")
            into("${buildDir}/install/objt.applicationserver/http/bin")
        }
        // sync all required client libs to the applicationserver's http/lib directory
        sync {
            from("${project(":objt.configurator").buildDir}/install/objt.configurator/lib",
                "${project(":objt.supervisor").buildDir}/install/objt.supervisor/lib",
                "${project(":objt.mes.operatorclient").buildDir}/install/objt.mes.operatorclient/lib",
                "${project(":objt.wms.operatorclient").buildDir}/install/objt.wms.operatorclient/lib",
                "${project(":objt.tagexplorer").buildDir}/install/objt.tagexplorer/lib")
            into("${buildDir}/install/objt.applicationserver/http/lib")
        }
        // copy client JRE
        copy {
            from("C:/javalib/java") {
                include("jre-8u192-windows-i586.jar")
            }
            into("${buildDir}/install/objt.applicationserver/http/jre")
        }
        // copy OBJTSTART installer
        copy {
            from("C:/javalib/objtstart/1.x-latest/install") {
                include("ObjtStart-win-i586-jre8.exe")
            }
            into("${buildDir}/install/objt.applicationserver/http/custom")
        }

        // copy manual (documentation) files
        copy {
            // get the tokens of the current version
            val versionTokens = getVersionTokens()
            val major = versionTokens[0]
            val minor = versionTokens[1]
            val release = versionTokens[2]
            // build the path towards the correct manual file
            val manualPath = "\\\\Sourcerer/Projects/OBJT.Objective/02.Development/$major.$minor/04.Documentation/Manuals/webhelp"
            val manualFile = "Objective_WebHelp_EN_$major.$minor.$release.zip"
            logger.info("Copying manual file '$manualPath/$manualFile'")
            from(manualPath) {
                include(manualFile)
            }
            into("${buildDir}/install/objt.applicationserver/http/docs/en")
            rename(manualFile, "manual.zip")
        }

        // generate digest files for the client objt files
        httpBinDir.listFiles()?.filter { file -> file.name.endsWith(".objt") }?.forEach { objtfile ->
            run {
                val digester = com.objt.start.tools.Digester(objtfile)
                digester.createDigest()
            }
        }
    }
}

tasks.register("buildDeviceServerDist") {
    group = "deployment"

    dependsOn(":objt.deviceserver:installDist")

    doLast {
        /* server */
        sync {
            from("${project(":objt.deviceserver").buildDir}/install/objt.deviceserver")
            into("${buildDir}/install/objt.deviceserver")
        }
    }
}

tasks.register("buildPrintServerDist") {
    group = "deployment"

    dependsOn(":objt.printserver:installDist")

    doLast {
        /* server */
        sync {
            from("${project(":objt.printserver").buildDir}/install/objt.printserver")
            into("${buildDir}/install/objt.printserver")
        }
    }
}

tasks.register("buildAccessServerDist") {
    group = "deployment"

    dependsOn(":objt.accessserver:installDist")

    doLast {
        /* server */
        sync {
            from("${project(":objt.accessserver").buildDir}/install/objt.accessserver")
            into("${buildDir}/install/objt.accessserver")
        }
    }
}

tasks.register("buildSchedulingServerDist") {
    group = "deployment"

    dependsOn(":objt.schedulingserver:installDist")

    doLast {
        /* server */
        sync {
            from("${project(":objt.schedulingserver").buildDir}/install/objt.schedulingserver")
            into("${buildDir}/install/objt.schedulingserver")
        }
    }
}

tasks.register("buildDatawarehouseServerDist") {
    group = "deployment"

    dependsOn(":objt.datawarehouseserver:installDist")

    doLast {
        /* server */
        copy {
            from("${project(":objt.datawarehouseserver").buildDir}/install/objt.datawarehouseserver")
            into("${buildDir}/install/objt.datawarehouseserver")
        }
    }
}

tasks.register("buildUpdaterDist") {
    group = "deployment"

    dependsOn(":objt.updater:installDist")

    doLast {
        /* server */
        copy {
            from("${project(":objt.updater").buildDir}/install/objt.updater")
            into("${buildDir}/install/objt.updater")
        }
    }
}

tasks.register("buildDbBackupRestoreDist") {
    group = "deployment"

    dependsOn(":objt.dbbackuprestore:installDist")

    doLast {
        /* server */
        sync {
            from("${project(":objt.dbbackuprestore").buildDir}/install/objt.dbbackuprestore")
            into("${buildDir}/install/objt.dbbackuprestore")
        }
    }
}

tasks.register("buildThinClientDist"){
    group = "deployment"

    dependsOn(":objt.thinclient:installDist")

    doLast {
        /* server */
        sync {
            from("${project(":objt.thinclient").buildDir}/install/objt.thinclient")
            into("${buildDir}/install/objt.thinclient")
        }
    }
}

tasks.register("buildProjectDist"){
    group = "deployment"

    dependsOn(":buildApplicationServerDist",
        ":buildDeviceServerDist",
        ":buildPrintServerDist",
        ":buildAccessServerDist",
        ":buildSchedulingServerDist",
        ":buildDatawarehouseServerDist",
        ":buildUpdaterDist",
        ":buildDbBackupRestoreDist",
        ":buildThinClientDist")

    doLast {
        // unpack the 32-bit jdk
        sync {
            from(zipTree(file("c:/javalib/java/jdk-8u192-windows-i586.zip")))
            into("$buildDir/install/java/windows-i586")
        }

        // unpack the 64-bit jdk
        sync {
            from(zipTree(file("c:/javalib/java/jdk-8u192-windows-x64.zip")))
            into("$buildDir/install/java/windows-x64")
        }
    }
}

tasks.register<Zip>("packageProjectDist") {
    group = "deployment"

    dependsOn("buildProjectDist")

    archiveFileName.set("objt-$distributionName-${project.version}.zip")
    destinationDirectory.set(file("$buildDir/${project.version}"))

    from("$buildDir/install")

    exclude("**/.dockerignore")
}

tasks.register("buildProjectDeployment") {
    group = "deployment"

    dependsOn("packageProjectDist")
}

fun readBuildVersion() : String {
    // check if we can resolve the application version from the environment settings
    val distributionDir = "$rootDir/distribution"
    var file = File("$distributionDir/main/env/$environmentName/distribution.properties")
    if (!file.exists()) file = File("$distributionDir/main/env/default/distribution.properties")
    if (!file.exists()) return "unspecified"

    val fis = FileInputStream(file)
    val prop = Properties()
    prop.load(fis)
    return prop.getProperty("Application.Version")
}

/**
 * This function return the individual major/minor/release/revision tokens of the current build version
 */
fun getVersionTokens() : List<String> {
    val versionTokens = version.toString().split(Pattern.compile("[.-]"), 4)
    if (versionTokens.size < 4) throw Exception("unable to resolve major/minor/release/revision for version '$version'")
    return versionTokens;
}
