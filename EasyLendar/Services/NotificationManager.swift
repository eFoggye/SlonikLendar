import Foundation
import UserNotifications
import UIKit

protocol NotificationManagerProtocol {
    func addNotification(event: Event)
    func removeNotification(event: Event)
    func checkAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void)
}

final class NotificationManager: NSObject, NotificationManagerProtocol {
    
    static let shared = NotificationManager()
    
    private override init() {}
    
    private lazy var notificationManager = UNUserNotificationCenter.current()
    //MARK: - Notification Manage Functions
    func addNotification(event: Event) {
        notificationManager.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case    .authorized:
                self.dispatchNotification(event: event)
                
            case        .denied:
                return
                
            case .notDetermined:
                self.notificationManager.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.dispatchNotification(event: event)
                    }
                }
                
            default: return
            }
        }
    }
    
    func removeNotification(event: Event) {
        self.notificationManager.removePendingNotificationRequests(withIdentifiers: [event.id.uuidString])
    }
    
    private func dispatchNotification(event: Event) {
        let calendar = Calendar.current
        let startDate = event.startDate
        guard startDate > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "SlonikLendar"
        content.body = "\(event.name) event start!"
        content.sound = .default
        
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.year = calendar.component(.year, from: startDate)
        dateComponents.month = calendar.component(.month, from: startDate)
        dateComponents.day = calendar.component(.day, from: startDate)
        dateComponents.hour = calendar.component(.hour, from: startDate)
        dateComponents.minute = calendar.component(.minute, from: startDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: event.id.uuidString, content: content, trigger: trigger)
        self.notificationManager.add(request)
    }
    //MARK: - Other Help Functions
    func checkAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        notificationManager.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
}
//MARK: - Notification Center Delegate
extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
