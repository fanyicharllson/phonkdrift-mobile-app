# Firebase Cloud Messaging — push payload parsing relies on these at runtime.
-keep class com.google.firebase.messaging.** { *; }
-keep class com.google.firebase.** { *; }

# Play Core split-install classes — Flutter's deferred-components support
# references these even when unused; R8 needs them kept or explicitly ignored
# to avoid "Missing classes" build failures on AGP 8+.
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# just_audio / audio_service / just_audio_background — media session and
# background playback callbacks are invoked reflectively by the platform.
-keep class com.ryanheise.** { *; }

# Parcelable CREATOR fields are looked up reflectively by the platform.
-keepclassmembers class * implements android.os.Parcelable {
    public static final ** CREATOR;
}
