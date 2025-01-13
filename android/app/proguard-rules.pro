# Manter classes usadas pelo Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Manter classes usadas pela biblioteca Kotlin
-keepclassmembers class kotlin.** { *; }
-dontwarn kotlin.**

# Manter classes usadas por APIs externas
-keepattributes Signature, InnerClasses, Annotation
