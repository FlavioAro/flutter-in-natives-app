package com.example.android_native_app

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

private const val FLUTTER_ENGINE_ID = "module_flutter_engine"
private const val CHANNEL_NAME = "example.com/channel"
private const val METHOD_GET_DATA = "data"

class MainActivity : AppCompatActivity() {

    lateinit var flutterEngine : FlutterEngine
    private lateinit var myEditText: EditText

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        myEditText = findViewById(R.id.myEditText)

        // Instantiate a FlutterEngine
        flutterEngine = FlutterEngine(this)

        // Start executing Dart code to pre-warm the FlutterEngine
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        // Cache the FlutterEngine to be used by FlutterActivity
        FlutterEngineCache
            .getInstance()
            .put(FLUTTER_ENGINE_ID, flutterEngine)

        // Set up MethodChannel to handle communication from Flutter
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    METHOD_GET_DATA -> result.success(myEditText.text.toString())
                    else -> result.notImplemented()
                }
            }

        val myButton = findViewById<Button>(R.id.myButton)
        myButton.setOnClickListener {
            // Send text to Flutter using MethodChannel
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
                .invokeMethod(METHOD_GET_DATA, myEditText.text.toString())

            startActivity(
                FlutterActivity
                    .withCachedEngine(FLUTTER_ENGINE_ID)
                    .build(this)
            )
        }
    }
}