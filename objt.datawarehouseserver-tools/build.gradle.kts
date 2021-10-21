plugins {
    id("objt-java")
}

dependencies {
    implementation(platform(project(":objt-platform")))
    implementation(group = "com.objt", name = "dce")
    implementation(group = "com.objt", name = "objt.datawarehouseserver-core")
    implementation(group = "com.objt", name = "objt.meta")
    implementation(group = "com.objt", name = "objt.meta.tools")

    runtimeOnly(project(":objt.datawarehouseserver"))

    // database drivers (for the db sync script generation task)
    runtimeOnly(group = "com.microsoft.sqlserver", name = "mssql-jdbc")
    runtimeOnly(group = "oracle", name = "ojdbc7")
}

tasks.register<JavaExec>("generate_datawarehouse_tables") {
    dependsOn("build")

    group = "application"
    description = "Launch the table creation scripts"
    classpath = sourceSets["main"].runtimeClasspath
    main = "objt.datawarehouseserver.tools.DataWarehouseTableGenerator"
    jvmArgs = listOf("-DDATAWAREHOUSETABLEGENERATOR.OUTPUTPATH=${project(":objt.datawarehouseserver").projectDir}/db/generated_scripts")
    args = listOf("datawarehouse.properties", "objt/app/datawarehouseserver/datawarehouse.xml")
    workingDir = file("$projectDir")
}
