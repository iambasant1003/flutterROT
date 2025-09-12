plugins {
    // ✅ Keep only AGP here, since Flutter brings Kotlin already
    id("com.android.application") version "8.7.3" apply false
}

// Legacy buildscript for Google Services + Crashlytics
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Google Services plugin (latest stable)
        classpath("com.google.gms:google-services:4.4.2")

        // Firebase Crashlytics Gradle plugin (latest stable)
        classpath("com.google.firebase:firebase-crashlytics-gradle:3.0.2")
    }
}

// 🔥 Unified build output folder
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)

    project.evaluationDependsOn(":app")
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
