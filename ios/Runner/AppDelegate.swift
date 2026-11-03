import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure AVAudioSession for uninterrupted background ambient playback
    do {
      try AVAudioSession.sharedInstance().setCategory(
        .playback,
        mode: .default,
        options: [.mixWithOthers, .allowAirPlay]
      )
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("Failed to configure background AVAudioSession: \(error.localizedDescription)")
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
