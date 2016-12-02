//
//  NotificationManager.swift
//  Neri
//
//  Created by Gabriel Bendia on 11/23/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject {
    
    /*******************************************************
     **                                                   **
     **        REQUEST NOTIFICATION AUTHORIZATION         **
     **                                                   **
     *******************************************************/
    
    /// - Description:
    ///     Ask permission from the user to send him notifications. In case there's an error, it's printed on the console. If the user does not grant permission, when called again, this function will as permession again and send him to the phone's settings so it can be authorized manually.
    
    func registerForNotifications() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
            
            if granted {
                print(granted)
            } else if error != nil {
                print(error as Any)
            } else {
                
                // Mandar para a tela de configuração para autorizar manualmente
                
                print("Notification authorization not granted")
            }
            
        })

    }
    
    /*******************************************************
     **                                                   **
     **   CREATE AND SEND HIGH HEART RATE NOTIFICATION    **
     **                                                   **
     *******************************************************/
    
    /// Function to setup and activate a notification for High Heart Rate data. This function must be called after the heart rate is verified.
    ///
    /// - Parameters:
    ///   - currentHeartRate: Users current Heart Rate
    
    func setupAndGenerateLocalHighHeartRateNotification(currentHeartRate: Int) {
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Current Heart Rate Too High!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Current Heart Rate: \(currentHeartRate) BPM", arguments: nil)
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "myNotificationCategory"
        
        // Adding the image
        
//        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
//        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
//        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
//        if let dirPath          = paths.first
//        {
//            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("logo.png")
//            
//            do {
//                let attachment = try UNNotificationAttachment(identifier: "logo", url: imageURL, options: nil)
//                content.attachments = [attachment]
//                print("Attachment")
//            } catch {
//                print("The attachment was not loaded.")
//            }
//            print("Saída->Attachment")
//            
//        }
        
        if let resourcePath = Bundle.main.resourcePath {
            let imgName = "logo.png"
            let path = resourcePath + "/" + imgName
            
            print(path)
            
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
                content.attachments = [attachment]
                print("Attachment")
            } catch {
                print("The attachment was not loaded.")
            }
            print("Saída->Attachment")
            
        }
        
        
        if let path = Bundle.main.path(forResource: "logo", ofType: "png") {
            print("Entrada->Attachment")
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
                content.attachments = [attachment]
                print("Attachment")
            } catch {
                print("The attachment was not loaded.")
            }
            print("Saída->Attachment")
        }
        
        print("Fora if Attachment")
        
        // Setting the notification to be delivered imediatly
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest.init(identifier: "HighHeartRate", content: content, trigger: trigger)
        
        // Schedule the notification
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            
            if error != nil {
                print(error as Any)
            } else {
                print("Notificação deu certo. NotificationManager.swift")
            }
            
        })
        
    }
    
    /*******************************************************
     **                                                   **
     **    CREATE AND SEND LOW HEART RATE NOTIFICATION    **
     **                                                   **
     *******************************************************/
    
    func setupAndGenerateLocalLowHeartRateNotification(currentHeartRate: Int) {
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Current Heart Rate Too Low!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Current Heart Rate: \(currentHeartRate) BPM", arguments: nil)
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "myNotificationCategory"
        
        // Setting the notification to be delivered imediatly
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest.init(identifier: "LowHeartRate", content: content, trigger: trigger)
        
        // Schedule the notification
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            
            if error != nil {
                print(error as Any)
            } else {
                print("Notificação deu certo. NotificationManager.swift")
            }
            
        })
        
    }
    
    /*******************************************************
     **                                                   **
     **         CREATE AND SEND FALL NOTIFICATION         **
     **                                                   **
     *******************************************************/
    
    func setupAndGenerateLocalFallNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Warning!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "A fall was detected!", arguments: nil)
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "myNotificationCategory"
        
        // Setting the notification to be delivered imediatly
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest.init(identifier: "Fall", content: content, trigger: trigger)
        
        // Schedule the notification
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            
            if error != nil {
                print(error as Any)
            } else {
                print("Notificação deu certo. NotificationManager.swift")
            }
            
        })
        
    }
    
}
