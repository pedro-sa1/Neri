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
    
    static let singleton = Elder()
    
    var name = ""
    var age = ""
    var careTakerId = ""
    var street: String!
    var houseNumber: Int!
    var city: String!
    var state: String!
    var weight: String!
    var height: String!
    var currentHeartRate: String?       // HeartRate -> String = "87"
    var location: [String]?             // Location  -> [String, String] = [latitude, longitude]
    
    /* Units:
     
     * Weight    : kilograms
     * Height    : meters
     * HeartRate : BPM (Beats per Minute)
     
     */
    
    
    private override init() {
    
    }
    
    func getElderName() -> String {
        return name
    }
    
    func setElderName(name: String) {
        self.name = name
    }
    
    func getElderAge() -> String {
        return age
    }
    
    func setElderAge(age: String) {
        self.age = age
    }
    
    func getElderPhone() -> String {
        return phone
    }
    
    func setElderPhone(phone: String) {
        self.phone = phone
    }
    
    func getElderStreet() -> String {
        return street
    }
    
    func setElderStreet(street: String) {
        self.street = street
    }
    
    func getElderCity() -> String {
        return city
    }
    
    func setElderCity(city: String) {
        self.city = city
    }
    
    func getElderState() -> String {
        return state
    }
    
    func setElderState(state: String) {
        self.state = state
    }
    
    func getEldercareTakerId() -> String {
        return careTakerId
    }
    
    func setEldercareTakerId(id: String) {
        self.careTakerId = id
    }
    
//    init (name: String, birthDay: String, phone: String, street: String, houseNumber: Int, city: String, state: String, weight: String, height: String) {
//        
//        super.init(name: name, birthDay: birthDay, phone: phone)
//        
//        self.street = street
//        self.houseNumber = houseNumber
//        self.city = city
//        self.state = state
//        self.weight = weight
//        self.height = height
//        
//    }
    
    // MARK: - Class Functions -
    
    func callCaretaker(caretakerPhone: String) -> ErrorType {
        
        /*******************************************************
         **                                                   **
         **            CALLING CARETAKER FUNCTION             **
         **                                                   **
         *******************************************************/
        
        /*
         
         * Caretaker phone must exist
         * If the phone is for another region (country or state), it has to be complete
         * In case the call can't be completed the app shows an alert with the error message
         
         */
        
        if let url = NSURL(string: "tel://\(caretakerPhone)") {
            UIApplication.shared.open(url as URL)
            return ErrorType.OK
        } else {
            return ErrorType.CallFailed
        }
        
    }
    
    func verifyFall(accelerometerData: CMAccelerometerData) -> ErrorType {
        
        /*******************************************************
         **                                                   **
         **             ALGORITHM TO VERIFY FALL              **
         **                                                   **
         *******************************************************/
        
        /*
         
         * Uses an algorithm to analise the accelerometer data
         * Neural Network used to learn from the user
         * User has 15 seconds to confirm that he's OK
         * If the time passes or the user asks for help, send notification to emergency contact
         
         */
        
        // Vai jogando os dados recebidos em vetores de tamanho 10
        // Caso já esteaj cheio, retira a primeira infromação e anda com o resto para frente
        // Joga a informação nova na ultima casa
        // Analisa os dados do acelerometro pela equação gerada pelos dados
        // Futuramente, usará rede neural pra analisar
        // Caso aconteça algum problema, mandar notificação
        
        return ErrorType.OK
        
    }
    
    func verifyHeartRate(heartRate: Double) -> ErrorType {
        
        /*******************************************************
         **                                                   **
         **     EVALUATE HEARTRATE BASED ON BMI AND AGE       **
         **                                                   **
         *******************************************************/
        
        /*
         
         * Table (Matrix) BMI x Age to get ideal heart rate
         * Verify maximum and low heart rate
         * Send notification in case something wrong happens
         
         */
        
        return ErrorType.OK
        
    }
    
    func sendLowHeartRateNotification() -> ErrorType {
        
        /*******************************************************
         **                                                   **
         **         SEND LOW HEARTRATE NOTIFICATION           **
         **                                                   **
         *******************************************************/
        
        /*
         
         * Send Low Heart Rate notification based on the emergency level
            * Low Level: Push Notification to the main caretaker
            * Medium Level: Push Notification to all caretakers and text message to the main caretaker
            * High Level: Push Notification, e-mail and text message to all caretakers
         * If is there any error, the app shows an alert with an error message
         
         */
        
        return ErrorType.OK
        
    }
    
    func sendHighHeartRateNotification() -> ErrorType {
        
        /*******************************************************
         **                                                   **
         **         SEND HIGH HEARTRATE NOTIFICATION          **
         **                                                   **
         *******************************************************/
        
        /*
         
         * Send High Heart Rate notification based on the emergency level
            * Low Level: Push Notification to the main caretaker
            * Medium Level: Push Notification to all caretakers and text message to the main caretaker
            * High Level: Push Notification, e-mail and text message to all caretakers
         * If is there any error, the app shows an alert with an error message
         
         */
        
        return ErrorType.OK
        
    }
    
    func sendFallNotification() -> ErrorType {
        
        /*******************************************************
         **                                                   **
         **              SEND FALL NOTIFICATION               **
         **                                                   **
         *******************************************************/
        
        /*
         
         *
         
         */
        
        return ErrorType.OK
        
    }
    
    func sendLocation() -> ErrorType {
        
        /*******************************************************
         **                                                   **
         **         SEND CURRENT LOCATION TO CLOUDKIT         **
         **                                                   **
         *******************************************************/
        
        /*
         
         *
         
         */
        
        return ErrorType.OK
        
    }
    
    func calculateBMI() -> Double {
        
        /*******************************************************
         **                                                   **
         **         FUNCTION TO CALCULATE ELDER BMI           **
         **                                                   **
         *******************************************************/
        
        /*
         
         * Weight is stored in kilograms
         * Height is stored in meters
         * This uses the Metric Method: BMI = weight/heightˆ2 (kg/mˆ2)
         
         */

        return (Double(self.weight))!/(Double(self.height)!*Double(self.height)!)
        
    }
    
}
