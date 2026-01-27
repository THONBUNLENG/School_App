plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.beltel_is"
    compileSdk = 36  // Updated for plugin compatibility

    defaultConfig {
        applicationId = "com.example.beltel_is"
        minSdk = flutter.minSdkVersion // Flutter minimum recommended
        targetSdk = 36 // Match compileSdk
        versionCode = 1
        versionName = "1.0.0"

        // Enable multidex if needed
        multiDexEnabled = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Updated desugaring library for Java 17 + plugin requirements
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
