package voip24h.sdk.mobile.voip24h_sdk_mobile

import android.util.Log
import androidx.annotation.NonNull
import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject
import voip24h.sdk.mobile.voip24h_sdk_mobile.model.SipConfiguration
import voip24h.sdk.mobile.voip24h_sdk_mobile.sip_manager.SipManager

/** FlutterVoip24hSdkMobilePlugin */
class Voip24hSdkMobilePlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var methodChannel: MethodChannel
  private var eventChannel: EventChannel? = null
  private lateinit var sipManager: SipManager

  companion object {
    var eventSink: EventChannel.EventSink? = null
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_voip24h_sdk_mobile_method_channel")
    methodChannel.setMethodCallHandler(this)

    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "flutter_voip24h_sdk_mobile_event_channel")
    eventChannel?.setStreamHandler(this)

    sipManager = SipManager.getInstance(flutterPluginBinding.applicationContext)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    Log.d(this.javaClass.name, "onMethodCall")
    when (call.method) {
      "initSipModule" -> {
        call.argument<Map<*, *>>("sipConfiguration")?.let {
          val sipConfiguration = Gson().fromJson(JSONObject(it).toString(), SipConfiguration::class.java)
          sipManager.initSipModule(sipConfiguration)
          result.success("Init sip module successful")
        } ?: kotlin.run {
          result.error("500", "Sip configuration is not valid", null)
        }
      }
      "call" -> {
        val phoneNumber = call.argument<String>("recipient")
        if (phoneNumber.isNullOrEmpty()) {
          return result.error("500", "Phone number is null or empty", null)
        }
        sipManager.call(phoneNumber, result)
      }
      "answer" -> {
        sipManager.answer(result)
      }
      "hangup" -> {
        sipManager.hangup(result)
      }
      "reject" -> {
        sipManager.reject(result)
      }
      "transfer" -> {
        val extension = call.argument<String>("extension")
        if (extension.isNullOrEmpty()) {
          return result.error("500", "Extension is null or empty", null)
        }
        sipManager.transfer(extension, result)
      }
      "pause" -> {
        sipManager.pause(result)
      }
      "resume" -> {
        sipManager.resume(result)
      }
      "sendDTMF" -> {
        val dtmf = call.argument<String>("recipient")
        if (dtmf.isNullOrEmpty()) {
          return result.error("500", "DTMF is null or empty", null)
        }
        sipManager.sendDTMF(dtmf, result)
      }
      "toggleSpeaker" -> {
        sipManager.toggleSpeaker(result)
      }
      "toggleMic" -> {
        sipManager.toggleMic(result)
      }
      "refreshSipAccount" -> {
        sipManager.refreshSipAccount(result)
      }
      "unregisterSipAccount" -> {
        sipManager.unregisterSipAccount(result)
      }
      "getCallId" -> {
        sipManager.getCallId(result)
      }
      "getMissedCalls" -> {
        sipManager.getMissedCalls(result)
      }
      "getSipRegistrationState" -> {
        sipManager.getSipRegistrationState(result)
      }
      "isMicEnabled" -> {
        sipManager.isMicEnabled(result)
      }

      "isSpeakerEnabled" -> {
        sipManager.isSpeakerEnabled(result)
      }
      // "removeListener" -> {
      // sipManager.removeListener()
      // }
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }

      "setCodecs" -> {
        val codecs = call.argument<String>("codecs")
        val isEnable = call.argument<Boolean>("isEnable")
        if (codecs.isNullOrEmpty() || isEnable == null) {
          return result.error("500", "Codecs or enable is null or empty", null)
        }
        sipManager.setCodecs(codecs, isEnable, result)
      }

      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventSink = null
    eventChannel = null
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
    this.eventChannel = null
  }
}