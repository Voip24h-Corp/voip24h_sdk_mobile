import Flutter
import UIKit

public class SwiftVoip24hSdkMobilePlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    
    private var sipManager: SipManager = SipManager.instance
    static var eventSink: FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftVoip24hSdkMobilePlugin()
        
        let methodChannel = FlutterMethodChannel(name: "flutter_voip24h_sdk_mobile_method_channel", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        
        let eventChannel = FlutterEventChannel(name: "flutter_voip24h_sdk_mobile_event_channel", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
        case "initSipModule":
            let jsonString = toJson(from: (call.arguments as? [String:Any])?["sipConfiguration"])
            if(jsonString == nil) {
                return NSLog("Sip configuration is not valid")
            }
            let sipConfiguration = SipConfiguaration.toObject(JSONString: jsonString!)
            if(sipConfiguration == nil) {
                return NSLog("Sip configuration is not valid")
            }
            sipManager.initSipModule(sipConfiguration: sipConfiguration!)
            break
        case "call":
            let phoneNumber = (call.arguments as? [String:Any])?["recipient"] as? String
            if(phoneNumber == nil) {
                // NSLog("Recipient is not valid")
                return result(FlutterError(code: "404", message: "Recipient is not valid", details: nil))
            }
            sipManager.call(recipient: phoneNumber!, result: result)
            break
        case "hangup":
            sipManager.hangup(result: result)
            break
        case "answer":
            sipManager.answer(result: result)
            break
        case "reject":
            sipManager.reject(result: result)
            break
        case "transfer":
            let ext = (call.arguments as? [String:Any])?["extension"] as? String
            if(ext == nil) {
                // NSLog("Extension is not valid")
                return result(FlutterError(code: "404", message: "Extension is not valid", details: nil))
            }
            sipManager.transfer(recipient: ext!, result: result)
            break
        case "pause":
            sipManager.pause(result: result)
            break
        case "resume":
            sipManager.resume(result: result)
            break
        case "sendDTMF":
            let dtmf = (call.arguments as? [String:Any])?["recipient"] as? String
            if(dtmf == nil) {
                return result(FlutterError(code: "404", message: "DTMF is not valid", details: nil))
            }
            sipManager.sendDTMF(dtmf: dtmf!, result: result)
            break
        case "toggleSpeaker":
            sipManager.toggleSpeaker(result: result)
            break
        case "toggleMic":
            sipManager.toggleMic(result: result)
            break
        case "refreshSipAccount":
            sipManager.refreshSipAccount(result: result)
            break
        case "unregisterSipAccount":
            sipManager.unregisterSipAccount(result: result)
            break
        case "getCallId":
            sipManager.getCallId(result: result)
            break
        case "getMissedCalls":
            sipManager.getMissCalls(result: result)
            break
        case "getSipRegistrationState":
            sipManager.getSipReistrationState(result: result)
            break
        case "isMicEnabled":
            sipManager.isMicEnabled(result: result)
            break
        case "isSpeakerEnabled":
            sipManager.isSpeakerEnabled(result: result)
            break
            // case "removeListener":
            // sipManager.removeListener()
            // break
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        SwiftVoip24hSdkMobilePlugin.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        SwiftVoip24hSdkMobilePlugin.eventSink = nil
        return nil
    }
}
