//
//  NotificationViewController.swift
//  Neri_CustomNotification
//
//  Created by Gabriel Bendia on 11/23/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    
    }
    
    func didReceive(_ notification: UNNotification) {
        
        // AQUI TEM QUE BOTAR AS COISAS CERTAS CONSIDERANDO O ESTADO (NOTIFICAÇÃO ATUAL)
        // IMAGEM DO CORAÇÃO
        // TEXTO DO CORAÇÃO
        // IMAGEM DE ALERTA
        // TEXTO DO ALERTA
        // MAPA
        
        print("Recebi notificação")
        
        switch notification.request.identifier {
            
        case "Fall":
            
            print("Fall Notification")
            
        case "HighHeartRate":
            
            print("HighHeartRate Notification")
            
            // Label configuration
            heartRateLabel.text = notification.request.content.body.replacingOccurrences(of: "Current Heart Rate: ", with: "")
            heartRateLabel.text = heartRateLabel.text?.replacingOccurrences(of: " BPM", with: "")
            heartRateLabel.textAlignment = .center
            heartRateLabel.textColor = UIColor.white
            
            // Image configuration
            self.imageView.image = UIImage(named: "notification-heart")
            imageView.backgroundColor = UIColor.black
            
        case "LowHeartRate":
            
            print("LowHeartRate Notification")
            
            // Label configuration
            heartRateLabel.text = notification.request.content.body.replacingOccurrences(of: "Current Heart Rate: ", with: "")
            heartRateLabel.text = heartRateLabel.text?.replacingOccurrences(of: " BPM", with: "")
            heartRateLabel.textAlignment = .center
            heartRateLabel.textColor = UIColor.white
            
            // Image configuration
            self.imageView.image = UIImage(named: "notification-heart")

            
        default: print("Map Notification")
            
        }
        
    }
    
}
