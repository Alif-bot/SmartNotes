//
//  AppDelegate.swift
//  SmartNotes
//
//  Created by Md Alif Hossain on 18/2/25.
//

import UserNotifications
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let noteID = response.notification.request.identifier
        print("User tapped notification for note ID: \(noteID)")
        completionHandler()
    }
}
