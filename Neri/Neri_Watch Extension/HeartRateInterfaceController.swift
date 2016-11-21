//
//  HeartRateInterfaceController.swift
//  Neri
//
//  Created by Gabriel Bendia on 11/9/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit
import CloudKit

class HeartRateInterfaceController: WKInterfaceController, HKWorkoutSessionDelegate {
    
    /*******************************************************
     **                                                   **
     **                      OUTLETS                      **
     **                                                   **
     *******************************************************/
    
    // MARK: - Outlets -
    
    @IBOutlet var heartRateLabel: WKInterfaceLabel!
    @IBOutlet var heartImage: WKInterfaceGroup!
    
    /*******************************************************
     **                                                   **
     **                    END OUTLETS                    **
     **                                                   **
     *******************************************************/
    
    /*******************************************************
     **                                                   **
     **                HEALTHKIT VARIABLES                **
     **                                                   **
     *******************************************************/
    
    // MARK: - HealthKit Variables -
    
    let healthStore = HKHealthStore()
    
    //State of the app - is the workout activated
    var workoutActive = false
    
    // define the activity type and location
    var session: HKWorkoutSession?
    let heartRateUnit = HKUnit(from: "count/min")
    var anchor = HKQueryAnchor(fromValue: Int(HKAnchoredObjectQueryNoAnchor))
    var currentQuery: HKQuery?
    
    /*******************************************************
     **                                                   **
     **             END: HEALTHKIT VARIABLES              **
     **                                                   **
     *******************************************************/
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        
        super.willActivate()
        
        /*******************************************************
         **                                                   **
         **       HEALTHKIT: START GETTING HEARTRATE          **
         **                                                   **
         *******************************************************/
        
        // MARK: - HealthKit: Start Getting HeartRate -
        
        guard HKHealthStore.isHealthDataAvailable() == true else {
            
            /* APAGAR ESSE COMENTARIOS
             
             * Caso NÃO TENHA autorização do HealthKit
             * Fazer tratamento das coisas que tem que mudar
             
             */
            
            //            label.setText("not available")
            
            print("HealthKit não autorizado.")
            
            return
        }
        
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            displayNotAllowed()
            return
        }
        
        let dataTypes = Set(arrayLiteral: quantityType)
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) -> Void in
            if success == false {
                print("Não autorizou healthKit")
                self.displayNotAllowed()
            }
        }
        
        if (self.workoutActive) {
            
            // Finish the current workout
            self.workoutActive = false
            
            if let workout = self.session {
                healthStore.end(workout)
            }
        } else {
            
            // Start a new workout
            self.workoutActive = true
            // self.startStopButton.setTitle("Stop")
            startWorkout()
            
        }
        
        /*******************************************************
         **                                                   **
         **      END HEALTHKIT: START GETTING HEARTRATE       **
         **                                                   **
         *******************************************************/
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    /*******************************************************
     **                                                   **
     **    HEALTHKIT: START GETTING HEARTRATE FUNCTIONS   **
     **                                                   **
     *******************************************************/
    
    // MARK: - HealthKit: Functions -
    
    func displayNotAllowed() {
        heartRateLabel.setText("not allowed")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            workoutDidStart(date)
        case .ended:
            workoutDidEnd(date)
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        // Do nothing for now
        print("Workout error")
    }
    
    
    func workoutDidStart(_ date : Date) {
        if let query = createHeartRateStreamingQuery(date) {
            self.currentQuery = query
            healthStore.execute(query)
        }
    }
    
    func workoutDidEnd(_ date : Date) {
        healthStore.stop(self.currentQuery!)
        // label.setText("---")
        session = nil
    }
    
    func startWorkout() {
        
        // If we have already started the workout, then do nothing.
        if (session != nil) {
            return
        }
        
        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .crossTraining
        workoutConfiguration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
            session?.delegate = self
        } catch {
            fatalError("Unable to create the workout session!")
        }
        
        healthStore.start(self.session!)
        
    }
    
    func createHeartRateStreamingQuery(_ workoutStartDate: Date) -> HKQuery? {
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return nil }
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictEndDate )
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate])
        
        
        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            self.updateHeartRate(sampleObjects)
        }
        
        heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
            self.updateHeartRate(samples)
        }
        return heartRateQuery
        
    }
    
    func updateHeartRate(_ samples: [HKSample]?) {
        
        guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
        
        DispatchQueue.main.async {
            guard let sample = heartRateSamples.first else{return}
            let value = sample.quantity.doubleValue(for: self.heartRateUnit)
            
            self.heartRateLabel.setText(String(Int(value)))
            
            // MANDAR PRO CLOUD KIT ESSE DADO: String(Int(value))
            
            
            
        }
        
    }
    
    /********************************************************
     **                                                    **
     **  END: HEALTHKIT START GETTING HEARTRATE FUNCTIONS  **
     **                                                    **
     ********************************************************/
    
    /********************************************************
     **                                                    **
     **                 CLOUD KIT: FUNCTIONS               **
     **                                                    **
     ********************************************************/
    
    // MARK: - CloudKit: Functions -
    
    
    
    /********************************************************
     **                                                    **
     **               END: CLOUD KIT FUNCTIONS             **
     **                                                    **
     ********************************************************/
    
}
