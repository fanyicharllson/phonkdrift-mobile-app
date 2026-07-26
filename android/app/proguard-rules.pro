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

# ExoPlayer / Media3 — the actual playback engine underneath just_audio.
# Without these, R8 renames/strips classes ExoPlayer loads reflectively
# (codec extractors, MediaSession callbacks), which crashes at playback
# time in release builds even though the com.ryanheise.** rule above is
# in place — that rule only covers the plugin glue, not the engine.
-keep class androidx.media3.** { *; }
-dontwarn androidx.media3.**
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**
-keep class androidx.media.** { *; }
-keep class android.support.v4.media.** { *; }
-dontwarn com.google.android.gms.cast.framework.**

# Parcelable CREATOR fields are looked up reflectively by the platform.
-keepclassmembers class * implements android.os.Parcelable {
    public static final ** CREATOR;
}
