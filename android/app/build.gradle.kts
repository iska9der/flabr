import com.android.build.gradle.internal.api.ApkVariantOutputImpl
import java.util.Properties
import java.util.Base64

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Keystore properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

// Dart env variables
val dartEnvironmentVariables: Map<String, String> = if (project.hasProperty("dart-defines")) {
    project.property("dart-defines")
        .toString()
        .split(",")
        .associate { entry ->
            val pair = String(Base64.getDecoder().decode(entry)).split("=")
            pair.first() to pair.last()
        }
} else {
    emptyMap()
}

val appName = dartEnvironmentVariables["APP_NAME"] ?: "Flabr"
val isDev = dartEnvironmentVariables["ENV"]?.equals("dev", ignoreCase = true) == true
val appIdSuffix = if (isDev) ".dev" else ""

val abiCodes = mapOf(
    "x86_64" to 1,
    "armeabi-v7a" to 2,
    "arm64-v8a" to 3
)

android {
    namespace = "ru.iska9der.flabr"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }

    // F-droid
    dependenciesInfo {
        // Disables dependency metadata when building APKs.
        includeInApk = false
        // Disables dependency metadata when building Android App Bundles.
        includeInBundle = false
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
    }

    defaultConfig {
        applicationId = "ru.iska9der.flabr"
        applicationIdSuffix = appIdSuffix
        minSdk = flutter.minSdkVersion.coerceAtLeast(21)
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        resValue("string", "app_name", appName)
    }

    splits {
        abi {
            // Enables building multiple APKs per ABI.
            isEnable = true

            // Resets the list of ABIs for Gradle to create APKs for to none.
            // By default all ABIs are included, so use 'reset()' and 'include' to specify that
            // you only want to create APKs for a subset of ABIs, for example 'armeabi-v7a' and 'arm64-v8a'.
            reset()
            
            // Specifies a list of ABIs for Gradle to create APKs for.
            include("armeabi-v7a", "arm64-v8a", "x86_64") // "x86"
            
            // Specifies that you want to also generate a universal APK that includes all ABIs.
            isUniversalApk = true
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it.toString()) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = false

            // Clear the automatically set filters.
            ndk.abiFilters.clear()

            // Set your custom filters.
            ndk.abiFilters.addAll(abiCodes.keys.toList())
        }

        debug {
            applicationIdSuffix = ".debug"
            isMinifyEnabled = false
        }

        // Profile build type is created by Flutter Gradle plugin
        named("profile") {
            applicationIdSuffix = ".debug"
            isMinifyEnabled = false
        }
    }
}

flutter {
    source = "../.."
}

// F-droid splits APKs by ABI, and requires different versionCode for each ABI.
// For flutter version X.Y.Z, version code is X0Y0ZA, where A is the ABI code.
// See:
// * https://developer.android.com/build/gradle-tips
// * https://developer.android.com/studio/build/configure-apk-splits
android.applicationVariants.configureEach {
    val variant = this
    variant.outputs.forEach { output ->
        val name = output.filters.find { it.filterType == "ABI" }?.identifier
        val abiVersionCode = abiCodes[name] ?: 0
        (output as ApkVariantOutputImpl).versionCodeOverride = variant.versionCode * 10 + abiVersionCode
    }
}