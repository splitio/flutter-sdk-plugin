# Please include these rules in your project
# in order to make Split code work properly when
# using proguard
-keep class io.split.android.client.dtos.* { *; }
-keep class io.split.android.client.storage.db.** { *; }
-keep public class io.split.android.client.service.sseclient.SseJwtToken.** { *; }
-keep public class io.split.android.client.service.sseclient.SseAuthToken.** { *; }
-keep public class io.split.android.client.service.sseclient.SseAuthenticationResponse.** { *; }
-keep class io.split.android.client.service.sseclient.notifications.** { *; }
-keepattributes Signature
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keepclassmembers,allowobfuscation class * {
 @com.google.gson.annotations.SerializedName <fields>;
}
