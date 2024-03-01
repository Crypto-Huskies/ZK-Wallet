//
//  ZK_WalletApp.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 11/24/23.
//

import Firebase
import SwiftUI
import UIKit
import UserNotifications

@main
struct ZK_WalletApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()

        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()

//        sendDeviceTokenToServer()

        return true
    }

    private func sendDeviceTokenToServer() {
        guard let fcmToken = Messaging.messaging().fcmToken else {
            print("FCM token is not available yet.")
            return
        }

        let url = URL(string: "https://339a-63-149-110-127.ngrok-free.app/token")! //8000
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let emailAddress = "sai@test.com"
        let walletAddress = "0x03fcDbb718cDDb25ab4c07D77e1511c5bbF5D126"

        let body: [String: Any] = [
            "emailAddress": emailAddress,
            "token": fcmToken,
            "walletAddress": walletAddress,
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error sending token to server: \(error)")
                return
            }
        }

        task.resume()
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
        -> UIBackgroundFetchResult {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        return UIBackgroundFetchResult.newData
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
//      NotificationCenter.default.post(
//        name: Notification.Name("FCMToken"),
//        object: nil,
//        userInfo: dataDict
//      )
        
        sendDeviceTokenToServer()
        print(dataDict)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        if let dataPayload = userInfo["body"] as? String {
            handleDataPayload(dataPayload)
        }

        Messaging.messaging().appDidReceiveMessage(userInfo)

        // Change this to your preferred presentation option
        completionHandler([[.banner, .badge, .sound]])
    }

    private func handleDataPayload(_ dataPayload: String) {
        print("Parsing JSON from data payload")
        if let data = dataPayload.data(using: .utf8),
           let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            print(jsonData)
            if let from = jsonData["from"] as? String,
               let message = jsonData["message"] as? String,
               let txType = jsonData["txType"] as? String,
               let txId = jsonData["txId"] as? String {
                let transaction = Transaction(txId: txId, from: from, message: message, timestamp: nil, txType: txType)
                // Insert the transaction into the database
                let dbManager = DatabaseManager()
                dbManager.insertTransaction(transaction: transaction)
            } else {
                print("Error: Missing keys in data payload")
            }
        } else {
            print("Error: Unable to parse JSON from data payload")
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        Messaging.messaging().appDidReceiveMessage(userInfo)

        completionHandler()
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }
}
