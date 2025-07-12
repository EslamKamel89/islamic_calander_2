// import Flutter
// import UIKit
// import flutter_local_notifications
// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//      // This is required to make any communication available in the action isolate.
//     FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
//         GeneratedPluginRegistrant.register(with: registry)
//     }

//     if #available(iOS 10.0, *) {
//       UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
//     }
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }
import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // print("<test widget> - 🚀 AppDelegate launched")
    GeneratedPluginRegistrant.register(with: self)

    // Setup MethodChannel for lockscreen communication
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let lockscreenChannel = FlutterMethodChannel(name: "lockscreen_channel", binaryMessenger: controller.binaryMessenger)

    lockscreenChannel.setMethodCallHandler { call, result in
      if call.method == "updatePrayerData" {
        guard let args = call.arguments as? [String: Any],
              let jsonString = args["json"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Expected JSON string", details: nil))
          return
        }

        // Save JSON string to App Group UserDefaults
        let userDefaults = UserDefaults(suiteName: "group.com.gaztec.lockwidget")
        userDefaults?.setValue(jsonString, forKey: "prayer_json")
        // print("<test widget> - ✅ JSON received from Flutter:\n\(jsonString)")
        // Trigger widget reload
        WidgetCenter.shared.reloadAllTimelines()
        // print("<test widget> - 📣 WidgetCenter.reloadAllTimelines() called")
        result("Prayer data saved")
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}