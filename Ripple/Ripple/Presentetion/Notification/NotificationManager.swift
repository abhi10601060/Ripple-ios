//
//  NotificationManager.swift
//  Ripple
//
//  Created by Abhishek Velekar on 28/12/25.
//

import Foundation
import UserNotifications
import Combine

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    // Request permission to send notifications
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
        
        // Set the delegate to handle foreground notifications
        UNUserNotificationCenter.current().delegate = self
    }
    
    // Schedule a local notification
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval = 5) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func scheduleNotificationWithActions(title: String, body: String, timeInterval: TimeInterval = 5) {
            // Define actions
            let acceptAction = UNNotificationAction(
                identifier: "ACCEPT_ACTION",
                title: "Accept",
                options: []
            )
            let cancelAction = UNNotificationAction(
                identifier: "REJECT_ACTION",
                title: "Reject",
                options: [.destructive]
            )
            
            // Define category
            let category = UNNotificationCategory(
                identifier: "ACTION_CATEGORY",
                actions: [acceptAction, cancelAction],
                intentIdentifiers: [],
                options: []
            )
            
            // Register category
            UNUserNotificationCenter.current().setNotificationCategories([category])
            
            // Create notification content
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            content.categoryIdentifier = "ACTION_CATEGORY"
            
            // Create trigger and request
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }
        }
    
    // to take action on actions click
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
           let actionIdentifier = response.actionIdentifier

           switch actionIdentifier {
           case "ACCEPT_ACTION":
               print("Accept action tapped")
               scheduleNotification(title: "Action Accepted", body: "Action Accepted", timeInterval: 2)
               // Perform your accept logic here
           case "REJECT_ACTION":
               print("Cancel action tapped")
               scheduleNotification(title: "Action Rejected", body: "Action Rejected", timeInterval: 2)
               // Perform your cancel logic here
           default:
               print("Notification tapped")
               // Handle default tap
           }

           completionHandler()
       }
    
    // Show notification even if app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .sound, .badge])
        } else {
            // Fallback on earlier versions where `.alert` is still valid
            completionHandler([.alert, .sound, .badge])
        }
    }
}
