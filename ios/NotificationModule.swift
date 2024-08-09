import Foundation
import React
import UserNotifications

@objc(MyNativeModules)
class MyNativeModules: NSObject, RCTBridgeModule, UNUserNotificationCenterDelegate {
  
  var Notification_Title = "App Termination"
  var Notification_Body = "Hey, the app is killed now. None of the JS will work."
  
  static func moduleName() -> String! {
    return "MyNativeModules"
  }
  
  @objc
  func onNotification() {
    self.sendNotification()
  }
  
  func sendNotification() {
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    center.requestAuthorization(options: options) { (granted, error) in
      if !granted {
        print("error permission notification")
      }
    }
    
    let content = UNMutableNotificationContent()
    content.title = Notification_Title
    content.body = Notification_Body
    content.sound = UNNotificationSound.default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: "LocalNotification", content: content, trigger: trigger)
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner, .badge, .sound])
  }
  
  @objc
  func requestNotificationPermission() {
    let center = UNUserNotificationCenter.current()
    
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        print("Error requesting notification permission: \(error)")
        return
      }
      
      if !granted {
        DispatchQueue.main.async {
          self.showSettingsAlert(from: self.getRootViewController()!)
        }
      }
    }
  }
  
  func openAppSettings() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
  
  func getRootViewController() -> UIViewController? {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let rootViewController = windowScene.windows.first?.rootViewController {
      return rootViewController
    }
    return nil
  }
  
  func showSettingsAlert(from viewController: UIViewController) {
    let alert = UIAlertController(title: "Permissison Alert",
                                  message: "Notification permission is not granted, Please enable permission from mobile settings",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
      self.openAppSettings()
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    viewController.present(alert, animated: true, completion: nil)
  }
  
}
