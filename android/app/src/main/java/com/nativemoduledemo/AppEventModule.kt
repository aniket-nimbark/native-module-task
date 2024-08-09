package com.nativemoduledemo

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

class AppEventModule(private val context: ReactApplicationContext) :
    ReactContextBaseJavaModule(context) {
    override fun getName(): String {
        return "MyNativeModules"
    }
    init {
        createNotificationChannel()
    }
    companion object {
        private const val TAG = "MyNativeModules"
        private const val CHANNEL_ID = "MyNotificationChannel"
    }
    @ReactMethod
    fun onNotification(){
        Log.d(TAG, "onNotification:")
        sendNotification()
    }

    private fun sendNotification() {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        val notificationBuilder = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_notification_overlay)  // Use your own icon here
            .setContentTitle("App Termination")
            .setContentText("Hey, the app is killed now. None of the JS will work.")
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)

        notificationManager.notify(1, notificationBuilder.build())
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Notification Channel"
            val descriptionText = "Channel for app notifications"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
}