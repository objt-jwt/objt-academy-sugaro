plugins {
    id("java-platform")
}

javaPlatform {
    allowDependencies()
}

dependencies {
    api(platform("com.objt:objt.core-platform:7.0.4.0"))
}

dependencies {
    constraints {
        // collect specific project dependencies in here
    }
}