//
//  Elder.swift
//  Neri
//
//  Created by Gabriel Bendia on 11/4/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import HealthKit
import CoreLocation

class Elder: User {
    
    var street: String!
    var houseNumber: Int!
    var city: String!
    var state: String!
    var weight: String!
    var height: String!
    var currentHeartRate: String?       // Heartbeat -> String = 87
    var location: [String]?             // Location  -> [String, String] = [latitude, longitude]
    
    /* Units:
     
     * Weight    : kilograms
     * Height    : meters
     * HeartBeat : BPM (Beats per Minute)
     
     */
    
    init (name: String, birthDay: String, phone: String, street: String, houseNumber: Int, city: String, state: String, weight: String, height: String) {
        
        super.init(name: name, birthDay: birthDay, phone: phone)
        
        self.street = street
        self.houseNumber = houseNumber
        self.city = city
        self.state = state
        self.weight = weight
        self.height = height
        
    }
    
    func callCaretaker(caretakerPhone: String) -> ErrorType {
        
        return ErrorType.OK
        
    }
    
    func verifyFall(accelerometerData: CMAccelerometerData) -> ErrorType {
        
        return ErrorType.OK
        
    }
    
    func verifyHeartBeat(heartBeat: Double) -> ErrorType {
        
        return ErrorType.OK
        
    }
    
    func sendLowHeartBeatNotification() -> ErrorType {
        
        return ErrorType.OK
        
    }
    
    func sendHighHeartBeatNotification() -> ErrorType {
        
        return ErrorType.OK
        
    }
    
    func sendFallNotification() -> ErrorType {
        
        return ErrorType.OK
        
    }
    
    func sendLocation() -> ErrorType {
        
        return ErrorType.OK
        
    }
    
    func calculateBMI() -> Double {
        
        /*******************************************************
         **                                                   **
         **         FUNCTION TO CALCULATE ELDER BMI           **
         **                                                   **
         *******************************************************/
        
        /* Function assertions
         
         * Weight is stored in kilograms
         * Height is stored in meters
         * Using Metric Method: weight/heightˆ2
         
         */

        return (Double(self.weight))!/(Double(self.height)!*Double(self.height)!)
        
    }
    
}
