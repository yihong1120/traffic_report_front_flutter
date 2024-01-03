import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // 設置 Google Maps API 密鑰
    if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
      let keys = NSDictionary(contentsOfFile: path),
      let apiKey = keys["GOOGLE_MAPS_API_KEY"] as? String {
        GMSServices.provideAPIKey(apiKey)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
