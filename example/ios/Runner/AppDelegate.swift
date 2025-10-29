import UIKit
import Flutter
import flutter_local_notifications
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
//        GeneratedPluginRegistrant.register(with: registry)
//    }
    GeneratedPluginRegistrant.register(with: self)
    configureAudioSession()
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  func configureAudioSession() {
    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.playAndRecord, mode: .voiceChat, options: [])
      print("AVAudioSession configured successfully.")
    } catch {
      print("Failed to configure AVAudioSession: \(error.localizedDescription)")
    }
  }
}
