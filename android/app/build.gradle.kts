import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.vishesh.opinioneasy2026"
    // compileSdk = flutter.compileSdkVersion
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.vishesh.opinioneasy2026"
        //minSdk = flutter.minSdkVersion
        //targetSdk = flutter.targetSdkVersion
        minSdk = 24
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true      // Removes unused code
            isShrinkResources = true   // Removes unused images/layouts
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation(platform("com.google.firebase:firebase-bom:34.7.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.android.gms:play-services-ads:25.0.0")
}

flutter {
    source = "../.."
}

tasks.register("copyOpinionEasyApk") {
    doLast {
        val flutterApkDir = file("${project.layout.buildDirectory.get()}/outputs/flutter-apk")
        val releaseApk = File(flutterApkDir, "app-release.apk")
        if (releaseApk.exists()) {
            releaseApk.copyTo(File(flutterApkDir, "Opinion easy.apk"), overwrite = true)
            println("✅ Created: ${File(flutterApkDir, "Opinion easy.apk").path}")
        }
    }
}

tasks.matching { it.name == "assembleRelease" }.configureEach {
    finalizedBy("copyOpinionEasyApk")
}
