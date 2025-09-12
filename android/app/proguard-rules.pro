# --- Razorpay (reflection based) ---
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# --- Firebase ---
-keep class com.google.firebase.** { *; }
-keepattributes *Annotation*

# --- Flutter Local Notifications ---
-keep class com.dexterous.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.**

# --- Flutter generated plugins (to avoid stripping) ---
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.plugins.**

# --- General Flutter / Dart reflection ---
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**
