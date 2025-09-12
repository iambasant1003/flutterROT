plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // Flutter Gradle plugin must come after Android/Kotlin plugins
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

// 🔥 Load values from local.properties
val flutterVersionCode = project.findProperty("flutter.versionCode")?.toString() ?: "1"
val flutterVersionName = project.findProperty("flutter.versionName")?.toString() ?: "1.0.0"

android {
    namespace = "com.personalloan.rupeeontime"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.personalloan.rupeeontime"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
    }

    flavorDimensions += "default"

    productFlavors {
        create("dev") {
            dimension = "default"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            manifestPlaceholders["applicationName"] = "com.personalloan.rupeeontime.dev.MyApp"
        }
        create("prod") {
            dimension = "default"
            manifestPlaceholders["applicationName"] = "com.personalloan.rupeeontime.MyApp"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("com.guardsquare:proguard-annotations:7.2.2")

    // ✅ Firebase BOM (manages versions automatically)
    implementation(platform("com.google.firebase:firebase-bom:33.3.0"))

    // ✅ Firebase SDKs you’re using
    implementation("com.google.firebase:firebase-crashlytics-ktx")
    implementation("com.google.firebase:firebase-analytics-ktx")
}
