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

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }

}
