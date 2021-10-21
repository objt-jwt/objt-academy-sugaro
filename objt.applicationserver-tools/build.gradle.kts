import java.io.FileInputStream
import java.util.*

plugins {
    id("objt-java")
}

// general build properties
val distributionName = project.property("distributionName")
val environmentName = project.property("environmentName")

dependencies {
    implementation(platform(project(":objt-platform")))
    implementation(group = "com.objt", name = "dce")
    implementation(group = "com.objt", name = "objt")

    implementation(group = "org.apache.ant", name = "ant")
    implementation(group = "com.objt", name = "objt.meta")
    implementation(group = "com.objt", name = "objt.meta.tools")

    // meta model information
    runtimeOnly(project(":objt.meta.model"))

    // database drivers (for the db sync script generation task)
    runtimeOnly(group = "com.microsoft.sqlserver", name = "mssql-jdbc")
    runtimeOnly(group = "oracle", name = "ojdbc7")
}

/* method to load properties from a file into a given Properties object, overwriting any previously set value */
fun loadPropertyFile(pProperties : Properties, pFileName : String) {
    val propertiesFile = File(pFileName)
    if (propertiesFile.exists()) {
        pProperties.load(FileInputStream(propertiesFile))
        logger.info("loadPropertyFile: loaded property file <$pFileName>")
    }
    else {
        logger.debug("loadPropertyFile: property file <$pFileName> not found")
    }
}

/* method to load the distribution/environment specicifc environment properties of a specified project */
fun loadDistributionProperties(pProperties : Properties, pProjectDir : String) {
    loadPropertyFile(pProperties, "${pProjectDir}/main/env/default/distribution.properties")
    loadPropertyFile(pProperties, "${pProjectDir}/main/env/$environmentName/distribution.properties")
    loadPropertyFile(pProperties, "${pProjectDir}/$distributionName/env/default/distribution.properties")
    loadPropertyFile(pProperties, "${pProjectDir}/$distributionName/env/$environmentName/distribution.properties")
}

// load the general and application-specific environment properties
var distributionProperties = Properties()
loadDistributionProperties(distributionProperties, "$rootDir/distribution")
loadDistributionProperties(distributionProperties, "$projectDir/src")

tasks.register<Copy>("generate_reporting_views") {
    dependsOn("assemble", ":objt.settings:processResources")
    group = "application"

    // don't do an up-to-date check for this task
    outputs.upToDateWhen { false }
    // setup some general properties
    val applicationServerDir = project(":objt.applicationserver").projectDir
    val templateScriptsDir = "$applicationServerDir/db/template_scripts"
    val tempScriptsDir = "$buildDir/tmp/scripts"
    val scriptsDir = "$applicationServerDir/db/scripts"
    // copy the template .sqlt files and rename them to .sql on-the-go
    from(templateScriptsDir)
    into(tempScriptsDir)
    rename(".sqlt", ".sql")
    // use some ant-base scripting to replace the CLASSOID/CLASSNAME macro's in the template views with the correct values.
    doLast {

        val settingsDir = "${project(":objt.settings").projectDir}/src/main/resources"

        // read the project.properties file
        val projectProperties = Properties()
        projectProperties.load(FileInputStream("$settingsDir/project.properties"))

        val antClassPath = sourceSets["main"].runtimeClasspath.asPath
        val classModelFile = projectProperties.getProperty("FACTORY.CLASSMODELFILE")
        val tokenPropertiesFile = "$tempScriptsDir/replacement_tokens.properties"
        ant.withGroovyBuilder {
            // define the ant task to generate the tokens with
            "taskdef"("name" to "generate_class_tokens", "classname" to "objt.applicationserver.tools.database.GenerateSqlTokenReplacementFile") {
                "classpath" {
                    "pathelement"("path" to antClassPath)
                }
            }
            // generate the token file using the current meta file
            "generate_class_tokens"("classmodelfile" to classModelFile, "outputfile" to tokenPropertiesFile)
            // replace the tokens in this view
            "replace"("dir" to tempScriptsDir, "includes" to "**/*.sql", "replacefilterfile" to tokenPropertiesFile)
            // copy the de-tokenized views to their final destination
            "move"("todir" to scriptsDir) {
                "fileset"("dir" to tempScriptsDir){
                    "include"("name" to "**/*.sql")
                }
            }
            // delete the temp dir
            "delete"("dir" to tempScriptsDir)
        }

        logger.quiet("Generated reporting views to: $scriptsDir")
    }
}

// todo: script should be migrated to the 'objt.model' subproject when available
// toenhance AL: the properties that are database related should be centralized (modelversion now in project properties)
tasks.register("generate_database_creation_script") {
    dependsOn(":objt.meta.model:assemble", ":objt.settings:processResources")
    group = "application"

    // don't do an up-to-date check for this task
    outputs.upToDateWhen { false }

    doLast {

        val settingsDir = "${project(":objt.settings").projectDir}/src/main/resources"

        // read the project.properties file
        val projectProperties = Properties()
        projectProperties.load(FileInputStream("$settingsDir/project.properties"))

        val vendor = distributionProperties.getProperty("DATABASE.VENDOR")
        var databaseName = distributionProperties.getProperty("DATABASE.DATABASENAME")
        if (vendor == "SQLSERVER") databaseName = "\"" + databaseName + "\""

        val outputDir = "${project(":objt.applicationserver").projectDir}/db/generated_scripts/$vendor"
        val outputFile = "$outputDir/user.create_tables.sql"
        val antClassPath = sourceSets["main"].runtimeClasspath.asPath

        ant.withGroovyBuilder {
            "mkdir"("dir" to outputDir)
            // define the ant task to generate the tokens with
            "taskdef"("name" to "generate_db_script", "classname" to "objt.meta.tools.ant.GenerateDatabaseAntTask") {
                "classpath" {
                    "pathelement"("path" to antClassPath)
                }
            }
            // generate
            "generate_db_script"("metafile" to projectProperties.getProperty("FACTORY.CLASSMODELFILE"),
                    "dbversion" to projectProperties.getProperty("FACTORY.CLASSMODELVERSION"),
                    "vendor" to distributionProperties.getProperty("DATABASE.VENDOR"),
                    "databasename" to databaseName,
                    "datatablespace" to distributionProperties.getProperty("DATABASE.DATATABLESPACE"),
                    "indextablespace" to distributionProperties.getProperty("DATABASE.INDEXTABLESPACE"),
                    "droptables" to "NO",
                    "nruploadfields" to projectProperties.getProperty("DATABASE.NRUPLOADFIELDS"),
                    "uploadfieldlength" to projectProperties.getProperty("DATABASE.UPLOADFIELDLENGTH"),
                    "uploaddescriptionlength" to projectProperties.getProperty("DATABASE.UPLOADDESCRIPTIONLENGTH"),
                    "outputfile" to outputFile)

        }

        // provide some feedback to the user
        logger.quiet("Generated table creation script: $outputFile")
    }
}

// todo: script should be migrated to the 'objt.model' subproject when available
// toenhance AL: the properties that are database related should be centralized (modelversion now in project properties)
tasks.register("generate_database_synchronization_script") {
    dependsOn(":objt.meta.model:assemble", ":objt.settings:processResources")
    group = "application"

    // don't do an up-to-date check for this task
    outputs.upToDateWhen { false }

    doLast {

        val settingsDir = "${project(":objt.settings").projectDir}/src/main/resources"

        // read the project.properties file
        val projectProperties = Properties()
        projectProperties.load(FileInputStream("$settingsDir/project.properties"))

        val vendor = distributionProperties.getProperty("DATABASE.VENDOR")
        var databaseName = distributionProperties.getProperty("DATABASE.DATABASENAME")
        if (vendor == "SQLSERVER") databaseName = "\"" + databaseName + "\""

        val outputDir = "${project(":objt.applicationserver").projectDir}/db/generated_scripts/$vendor"
        val outputFile = "$outputDir/user.synchronize_tables.sql"
        val antClassPath = sourceSets["main"].runtimeClasspath.asPath

        ant.withGroovyBuilder {
            "mkdir"("dir" to outputDir)
            // define the ant task to generate the tokens with
            "taskdef"("name" to "generate_synchronization_script", "classname" to "objt.meta.tools.ant.SyncDatabaseAntTask") {
                "classpath" {
                    "pathelement"("path" to antClassPath)
                }
            }
            // generate
            "generate_synchronization_script"("metafile" to projectProperties.getProperty("FACTORY.CLASSMODELFILE"),
                    "vendor" to distributionProperties.getProperty("DATABASE.VENDOR"),
                    "driver" to distributionProperties.getProperty("DATABASE.DRIVER"),
                    "url" to distributionProperties.getProperty("DATABASE.URL"),
                    "userid" to distributionProperties.getProperty("DATABASE.USER"),
                    "password" to distributionProperties.getProperty("DATABASE.PASSWORD"),
                    "nruploadfields" to projectProperties.getProperty("DATABASE.NRUPLOADFIELDS"),
                    "uploadfieldlength" to projectProperties.getProperty("DATABASE.UPLOADFIELDLENGTH"),
                    "uploaddescriptionlength" to projectProperties.getProperty("DATABASE.UPLOADDESCRIPTIONLENGTH"),
                    "databasename" to databaseName,
                    "datatablespace" to distributionProperties.getProperty("DATABASE.DATATABLESPACE"),
                    "indextablespace" to distributionProperties.getProperty("DATABASE.INDEXTABLESPACE"),
                    "outputfile" to outputFile)

        }

        // provide some feedback to the user
        logger.quiet("Generated table synchronization script: $outputFile")
    }
}

tasks.register("generate_license") {
    
    group = "application"
    outputs.upToDateWhen { false }

    doLast {

        val configFile = "${project(":objt.applicationserver").projectDir}/src/${distributionName}/env/${environmentName}/assets/license/objective.xml"
        val licenseFile = "${project(":objt.applicationserver").projectDir}/src/${distributionName}/env/${environmentName}/config/objective.lic"
        val antClassPath = sourceSets["main"].runtimeClasspath.asPath

        logger.info("antclasspath: $antClassPath")

        ant.withGroovyBuilder {
            // define the ant task to generate the license file
            "taskdef"("name" to "licensegen", "classname" to "dce.util.lic.LicenseGenAntTask") {
                "classpath" {
                    "pathelement"("path" to antClassPath)
                }
            }
            // automatically clear the read-only flag of the license file -->
            "attrib"("file" to licenseFile, "readonly" to "false")
            // generate the new license file
            "licensegen"("configfile" to configFile, "licensefile" to licenseFile)
        }
    }
}

