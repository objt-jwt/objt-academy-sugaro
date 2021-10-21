plugins {
    id("objt-java")
}

dependencies {
    implementation(platform(project(":objt-platform")))

    runtimeOnly(group = "com.objt", name = "objt.meta") {
        exclude(group = "com.objt", module = "dce")
    }
}