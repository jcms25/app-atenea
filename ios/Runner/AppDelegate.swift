// import UIKit
// import Flutter
// import Firebase
//
// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     FirebaseApp.configure()
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }

import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Configure Firebase
    FirebaseApp.configure()

    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    // Set up the MethodChannel for native sorting
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let sortingChannel = FlutterMethodChannel(name: "native_sorting", binaryMessenger: controller.binaryMessenger)

    sortingChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
        if call.method == "sortSpanish" {
            guard let args = call.arguments as? [String: Any],
                  let items = args["items"] as? [[String: Any]],
                  let key = args["key"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Items or key is missing", details: nil))
                return
            }
            let sortedItems = self.sortObjectsByKey(items: items, key: key)
            result(sortedItems)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Native sorting function using `localizedStandardCompare`
  private func sortObjectsByKey(items: [[String: Any]], key: String) -> [[String: Any]] {
      return items.sorted {
          let value1 = ($0[key] as? String) ?? ""
          let value2 = ($1[key] as? String) ?? ""
          return value1.localizedStandardCompare(value2) == .orderedAscending
      }
  }
}
