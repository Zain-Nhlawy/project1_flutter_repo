# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.**

# Jitsi Meet SDK
-keep class org.jitsi.** { *; }
-keep class org.jitsi.meet.sdk.** { *; }
-keep class org.jitsi.meet.sdk.JitsiMeetActivity { *; }
-keep class org.jitsi.meet.sdk.JitsiMeetOngoingConferenceService { *; }
-keep class org.jitsi.jitsi_meet_flutter_sdk.** { *; }
-keep interface org.jitsi.meet.sdk.** { *; }
-dontwarn org.jitsi.**

# WebRTC
-keep class org.webrtc.** { *; }
-dontwarn org.webrtc.**

# React Native & Hermes (used by Jitsi Meet)
-keep class com.facebook.react.** { *; }
-keep class com.facebook.react.bridge.** { *; }
-keep class com.facebook.react.uimanager.** { *; }
-keep class com.facebook.jni.** { *; }
-keep class com.facebook.hermes.** { *; }
-keep class com.facebook.hermes.unicode.** { *; }
-keep class com.facebook.soloader.** { *; }
-keep class com.facebook.imagepipeline.** { *; }
-keep class com.facebook.drawee.** { *; }
-keep class com.facebook.common.** { *; }
-keep class com.facebook.yoga.** { *; }

-keepclassmembers class * {
    @com.facebook.react.uimanager.annotations.ReactProp <methods>;
    @com.facebook.react.uimanager.annotations.ReactPropGroup <methods>;
}

-keep,allowobfuscation @interface com.facebook.proguard.annotations.DoNotStrip
-keep,allowobfuscation @interface com.facebook.proguard.annotations.KeepGettersAndSetters
-keep @com.facebook.proguard.annotations.DoNotStrip class *
-keepclassmembers class * {
    @com.facebook.proguard.annotations.DoNotStrip *;
}
-keepclassmembers class * {
    native <methods>;
}

-dontwarn com.facebook.react.**
-dontwarn com.facebook.jni.**
-dontwarn com.facebook.hermes.**
-dontwarn com.facebook.soloader.**
-dontwarn com.facebook.yoga.**

# Network & Utilities
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-dontwarn org.bouncycastle.**
