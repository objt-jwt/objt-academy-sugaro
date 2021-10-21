plugins {
    id("objt-java")
//    id("io.freefair.aspectj.post-compile-weaving")
}

dependencies {
    implementation(platform(project(":objt-platform")))
    implementation(group = "com.objt", name = "dce")
    implementation(group = "com.objt", name = "objt")
    implementation(group = "com.objt", name = "objt.vertical")

    // post-compile time weaving
//    aspect(platform(project(":objt-platform")))
//    aspect(group = "com.objt", name = "dce")
//    aspect(group = "com.objt", name = "objt.transaction")
}
