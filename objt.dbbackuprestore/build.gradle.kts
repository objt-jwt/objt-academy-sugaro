import org.apache.tools.ant.filters.ReplaceTokens
import java.util.*

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
val nativeDistributionProperties = project.ext["nativeDistributionProperties"] as Properties
val nativeDistributionTokens = nativeDistributionProperties.toMap() as Map<String, Any>

// a lot of the dependencies have been set non-transitive to avoid the dce lib of dragging unwanted elements with it.
dependencies {
    implementation(platform(project(":objt-platform")))
    implementation(group = "com.objt", name = "objt.dbbackuprestore-core")
    implementation(project(":objt.custom")) { isTransitive = false }
    runtimeOnly(project(":objt.settings"))
    runtimeOnly(project(":objt.meta.model")) {
        isTransitive = false
    }

    runtimeOnly(group = "com.microsoft.sqlserver", name = "mssql-jdbc")
    runtimeOnly(group = "oracle", name = "ojdbc7")
}

tasks.register<JavaExec>("database_backup") {
    dependsOn("build")

    group = "application"
    description = "Launch the database backup"
    classpath = sourceSets["main"].runtimeClasspath
    main = "objt.dbbackuprestore.DatabaseBackup"
    args = listOf("dbbackuprestore.properties")
    workingDir = file("$projectDir")
    standardInput = System.`in`
}

tasks.register<JavaExec>("database_backup_empty") {
    dependsOn("build")

    group = "application"
    description = "Create a backup file of the current database without the actual data"
    classpath = sourceSets["main"].runtimeClasspath
    main = "objt.dbbackuprestore.DatabaseBackupEmpty"
    args = listOf("dbbackuprestore.properties")
    workingDir = file("$projectDir")
    standardInput = System.`in`
}

tasks.register<JavaExec>("database_restore") {
    dependsOn("build")

    group = "application"
    description = "Launch the database restore"
    classpath = sourceSets["main"].runtimeClasspath
    main = "objt.dbbackuprestore.DatabaseRestore"
    args = listOf("dbbackuprestore.properties")
    workingDir = file("$projectDir")
    standardInput = System.`in`
}

tasks.register<JavaExec>("database_restore_empty") {
    dependsOn("build")

    group = "application"
    description = "Launch the database restore without restoring the table data"
    classpath = sourceSets["main"].runtimeClasspath
    main = "objt.dbbackuprestore.DatabaseRestoreEmpty"
    args = listOf("dbbackuprestore.properties")
    workingDir = file("$projectDir")
    standardInput = System.`in`
}

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

    filesMatching(listOf("**/*.properties")) {
        filter(ReplaceTokens::class, "tokens" to nativeDistributionTokens, "beginToken" to "\${", "endToken" to "}")
    }
}

distributions {
    main {
        contents {
            with(distFiles)
        }
    }
}

tasks.startScripts {
    enabled = false // don't use the default generated scripts because we're using wrapper to launch the application
}
