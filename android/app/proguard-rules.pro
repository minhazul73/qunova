# Project-specific ProGuard rules.
# This file is applied only for the Android app (see build.gradle.kts).

# Keep Flutter embedding / plugin registrant pieces.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# Avoid warnings for Flutter embedding internals.
-dontwarn io.flutter.embedding.**
