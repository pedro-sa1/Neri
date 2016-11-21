//
//  ErrorType.swift
//  Neri
//
//  Created by Gabriel Bendia on 11/4/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import Foundation
import UIKit

enum ErrorType {
    
    case OK
    case UpdateFailed
    case CallFailed
    case VerificationFailed
    case HeartBeatNotificationFailed
    case FallNotificationFailed
    case CloudKitConnectionFailed
    case PairingFailed
    case RetrieveHeartbeatError
    case RetrieveLocationFailed
    
}

// MARK: - Class Functions -

func getErrorMessage(errorType: ErrorType) -> UIAlertController {
    
    /*******************************************************
     **                                                   **
     **                 GET ERROR MESSAGE                 **
     **                                                   **
     *******************************************************/
    
    /*
     
     * Creates an alert using error given
        * Possible errors: enum ErrorType
     * Sets a title and a message for the user
     * The alerts have only an OK Button
     * Returns the alert to the current View Controller
     * The View Controller is responsable to present the alert to the user
     
     */
    
    let alertController = UIAlertController()
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    alertController.addAction(okAction)
        
    switch errorType {
        
    case .UpdateFailed:
        alertController.title = "Update Failed"
        alertController.message = "There was an error trying to update the data. Please try again."
        
    case .CallFailed:
        alertController.title = "Call Failed"
        alertController.message = "There was an error trying to call this person. Please verify the phone number registered."
        
    case .VerificationFailed:
        alertController.title = "Verification Failed"
        alertController.message = "There was an error trying to verify the data. Please check your AppleWatch and connection to the internet."
        
    case .HeartBeatNotificationFailed:
        alertController.title = "Heartbeat Notification Failed"
        alertController.message = "There was an error trying to send heartbeat notification. Please check your connection to the internet. If it's an emergency call someone to help you."
        
    case .FallNotificationFailed:
        alertController.title = "Fall Notification Failed"
        alertController.message = "There was an error trying to send fall notification. Please check your connection to the internet. If it's an emergency call someone to help you."
        
    case .CloudKitConnectionFailed:
        alertController.title = "iCloud Connection Failed"
        alertController.message = "There was an error trying to connect to iCloud. Please check your internet connection and try again."
        
    case .PairingFailed:
        alertController.title = "Pairing Data Failed"
        alertController.message = "There was an error trying to pair the phones. Please try again or contact us if the error continues."
        
    case .RetrieveHeartbeatError:
        alertController.title = "Unable to get Heartbeat"
        alertController.message = "There was an error trying to get heartbeat info with the Apple Watch. Please try again. If the error persists, contact us."
        
    case .RetrieveLocationFailed:
        alertController.title = "Unable to get Location"
        alertController.message = "There was an error trying to get the location. Please check your internet connection and try again. If the error persists, contact us."
        
    default:
        print("\nNothing ocurred. Error OK\n")
        
    }
    
    return alertController
    
}
