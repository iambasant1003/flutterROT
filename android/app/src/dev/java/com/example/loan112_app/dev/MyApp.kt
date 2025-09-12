package com.example.loan112_app.dev

import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.google.firebase.crashlytics.FirebaseCrashlytics
import com.google.firebase.FirebaseApp

class MyApp : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()

        // ✅ Initialize Firebase
        FirebaseApp.initializeApp(this)

        // ✅ Enable Crashlytics crash reporting
        FirebaseCrashlytics.getInstance().setCrashlyticsCollectionEnabled(true)
    }
}
