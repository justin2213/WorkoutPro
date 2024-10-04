//
//  NotificatonManager.swift
//  WorkoutPro
//
//  Created by Justin Gmys on 7/12/24.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager() // Singleton
    
    static private var endTimerNotificationIdentifier = UUID().uuidString
    static private var inactivityNotificationIdentifier = UUID().uuidString
    static private var savedWorkoutNotificationIdentifier = UUID().uuidString
    
    func requestAuthorization() {
        
        let options: UNAuthorizationOptions = [.alert,.sound, .badge]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ErrorL \(error)")
            } else {
                print("Success")
            }
        }
    }
    
    func scheduleSavedWorkoutNotifcation() {
        let content = UNMutableNotificationContent()
        content.title = "Workout"
        content.body = "You have been gone a while. We saved your workout for you."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: NotificationManager.savedWorkoutNotificationIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling inactivity notification: \(error.localizedDescription)")
            } else {
                print("Inactivy Notification scheduled successfully")
            }
        }
    }
    
    
    func scheduleEndTimerNotification() {
            
            
            let content = UNMutableNotificationContent()
            content.title = "Workout Timer"
            content.body = "Your timer has finished!"
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: NotificationManager.endTimerNotificationIdentifier, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully")
                }
            }
        }
    
    func scheduleInactivityNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Active Workout"
        content.body = "You have been inactive for 15 minutes. Are you still working out?"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: NotificationManager.inactivityNotificationIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling inactivity notification: \(error.localizedDescription)")
            } else {
                print("Inactivy Notification scheduled successfully")
            }
        }
    }
    
    
    func cancelAllNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func cancelInactivityNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NotificationManager.inactivityNotificationIdentifier])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [NotificationManager.inactivityNotificationIdentifier])
    }
    
    func cancelEndTimerNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NotificationManager.endTimerNotificationIdentifier])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [NotificationManager.endTimerNotificationIdentifier])
    }
    
    func cancelSavedWorkoutNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [NotificationManager.savedWorkoutNotificationIdentifier])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [NotificationManager.savedWorkoutNotificationIdentifier])
    }
}
