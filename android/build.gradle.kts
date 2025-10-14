import com.android.build.gradle.LibraryExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.layout.buildDirectory.set(file("../build"))

subprojects {
    project.layout.buildDirectory.set(file("${rootProject.layout.buildDirectory.get().asFile}/${project.name}"))
}

// https://github.com/flutter/flutter/issues/169215
subprojects {
    afterEvaluate {
        // Check if this is an Android library project (not the app)
        if (project.name != "app" && project.extensions.findByType(LibraryExtension::class.java) != null) {
            project.extensions.configure<LibraryExtension> {
                buildTypes.configureEach {
                    // Disable applicationIdSuffix for libraries
                    @Suppress("DEPRECATION")
                    applicationIdSuffix = null
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
