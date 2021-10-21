plugins {
    id("objt-java")
}

dependencies {
    implementation(platform(project(":objt-platform")))
    implementation(group = "com.objt", name = "objt.swingclient-core")
    implementation(project(":objt.custom")) { isTransitive = false }
    implementation(project(":objt.applicationserver")) {
        isTransitive = false
    }
}
