import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // Bật 2 plugin dưới sau khi thêm google-services.json cho từng flavor
    // (android/app/src/staging/google-services.json, android/app/src/product/google-services.json)
    // và khai báo version trong android/settings.gradle.kts.
    // id("com.google.gms.google-services")
    // id("com.google.firebase.crashlytics")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Khoá ký bản release: android/keystore.properties (không commit).
// keyAlias=... / keyPassword=... / storeFile=... / storePassword=...
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("keystore.properties")
val hasReleaseKeystore = keystorePropertiesFile.exists()
if (hasReleaseKeystore) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "vn.babyfamily.baby_family"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    buildFeatures {
        buildConfig = true
        resValues = true
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "vn.babyfamily.app"
        // Android 8.0+ (tài liệu kỹ thuật mục 2).
        minSdk = maxOf(flutter.minSdkVersion, 26)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (hasReleaseKeystore) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    flavorDimensions += "default"

    productFlavors {
        create("staging") {
            dimension = "default"
            applicationIdSuffix = ".staging"
            resValue("string", "app_name", "SBaby Family")
        }
        create("product") {
            dimension = "default"
            resValue("string", "app_name", "Baby Family")
        }
    }

    buildTypes {
        getByName("release") {
            // Chưa có keystore thì ký bằng debug key để `flutter run --release` vẫn chạy.
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
