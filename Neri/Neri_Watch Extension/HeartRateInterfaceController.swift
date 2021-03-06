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
import CoreMotion

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
    
    // State of the app - is the workout activated
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
    
    /*******************************************************
     **                                                   **
     **                CLOUDKIT VARIABLES                 **
     **                                                   **
     *******************************************************/
    
    // MARK: - CloudKit Variables -
    
    var ctUsers = [CKRecord]()
    var fetchedRecord:CKRecord?
    
    /*******************************************************
     **                                                   **
     **              END: CLOUDKIT VARIABLES              **
     **                                                   **
     *******************************************************/
    
    /*******************************************************
     **                                                   **
     **              ACCELEROMETER VARIABLES              **
     **                                                   **
     *******************************************************/
    
    // MARK: - Accelerometer Variables -
    
    var accelerometerValue = 3.0
    
    // Motion Manager -> Handle Accelerometer and Gyroscope Data
    let motionManager = CMMotionManager()
    
    // Activity Manager -> Handle Activity Data: Running and walking
    let activityManager = CMMotionActivityManager()
    
    /*******************************************************
     **                                                   **
     **            END: ACELLEROMETER VARIABLES           **
     **                                                   **
     *******************************************************/
    
    // MARK: - End: Variables -
    
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
        
        // MARK: - HealthKit: Start Getting Heart Rate -
        
        guard HKHealthStore.isHealthDataAvailable() == true else {
            
            /* APAGAR ESSE COMENTARIO
             
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
    
    override func didAppear() {
        
        /*******************************************************
         **                                                   **
         **             GET ACCELEROMETER DATA                **
         **                                                   **
         *******************************************************/
        
        // MARK: - Get Accelerometer Data -
        
        //        if !motionManager.isAccelerometerActive {
        //
        //            motionManager.accelerometerUpdateInterval = 0.2
        //
        //            let accelerometerHandler = { (accelerometerData: CMAccelerometerData?, error: NSError?) in
        //
        //
        //
        //
        //
        //                // AQUI TEM QUE FAZER A VERIFICAÇÃO DA QUEDA COM O CÓDICO CERTO PARA PASSAR PRA CLOUD. POR ENQUANTO TA NO ANTIGO
        //
        //
        //
        //
        //                if fabs(accelerometerData!.acceleration.x) >= 3.0 || fabs(accelerometerData!.acceleration.y) >= 3.0 || fabs(accelerometerData!.acceleration.z) >= 3.0 {
        //
        //                    print("\n\nFall detected!!\n\n")
        //                    print("x: \(accelerometerData?.acceleration.x)\ny: \(accelerometerData?.acceleration.y)\nz: \(accelerometerData?.acceleration.z)\n")
        //
        //                    /************************************************
        //
        //                     * AQUI TEM QUE PASSAR PRO CLOUD QUE CAIU PRA MUDAR NO IPHONE E MANDAR A NOTIFICAÇÃO
        //
        //                     ************************************************/
        //
        //                    self.motionManager.stopAccelerometerUpdates()
        //
        //                    // Go to emergency button screen on the Apple Watch
        //                    self.presentController(withName: "CountdownInterfaceController", context: self)
        //
        //                } else {
        //                    print("Nothing detected")
        //                }
        //
        //                } as! CMAccelerometerHandler
        //
        //            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: accelerometerHandler)
        //
        //        }
        
//        motionManager.startAccelerometerUpdates()
//        
//        let timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(HeartRateInterfaceController.verifyFall), userInfo: nil, repeats: true)
//        
//        timer.fire()
//        
//        print("consegui!")
        
        /*******************************************************
         **                                                   **
         **           END: GET ACCELEROMETER DATA             **
         **                                                   **
         *******************************************************/
        
    }
    
    
    
    
    
    
    
    func verifyFall() -> Void {
        
        // FALL IS STILL IN DEVELOPMENT
        
        /*******************************************************
         **                                                   **
         **             ALGORITHM TO VERIFY FALL              **
         **                                                   **
         *******************************************************/
        
        /*
         
         * Uses an algorithm to analise the accelerometer data
         * Neural Network used to learn from the user
         * User has 30 seconds to confirm that he's OK
         * If the time passes or the user asks for help, send notification to emergency contact
         
         */
        
        // Vai jogando os dados recebidos em vetores de tamanho 10
        // Caso já esteja cheio, retira a primeira infromação e anda com o resto para frente
        // Joga a informação nova na ultima casa
        // Analisa os dados do acelerometro pela equação gerada pelos dados
        // Futuramente, usará rede neural pra analisar
        // Caso aconteça algum problema, mandar notificação
        
        
        
        // NEURAL NETWORK (IN DEVELOPMENT)
        
//        print("Entrei na função de verificação de queda")
        
        
        if evaluateAccelerometerData(motionManager.accelerometerData) {
            
            // MANDA AQUI PRO CLOUD KIT
            
//            print("Mandando que caiu pro cláudio")
            
            
            let container = CKContainer(identifier: "iCloud.pedro.Neri")
            let privateData = container.privateCloudDatabase
            privateData.fetchAllRecordZones { (recordZones, error) in
                if error != nil {
                    print("DEU MERDA NA FETCH RECORDZONE\n")
                    print(error?.localizedDescription)
                }
                if recordZones != nil {
                    print(recordZones)
                    let count = recordZones?.count
                    for item in recordZones!{
                        
                        let zoneName = (item.value(forKey: "_zoneID") as! CKRecordZoneID).value(forKey: "_zoneName") as! String
                        print("zone name iS: \(zoneName)")
                        if(zoneName == "MedicalRecord"){
                            self.sendFall(id: item.zoneID, fall: true)
                        }
                    }
                }
            }
        }
        
        
//        print("Saí da função de verificação de queda")
        
    }
    
    func evaluateAccelerometerData(_ accelerometerData: CMAccelerometerData?) -> Bool {
        
        if accelerometerData?.acceleration.x != nil && accelerometerData?.acceleration.y != nil && accelerometerData?.acceleration.z != nil {
            
            if fabs((accelerometerData?.acceleration.x)!) >= 2.5 || fabs((accelerometerData?.acceleration.y)!) >= 2.5 || fabs((accelerometerData?.acceleration.z)!) >= 2.5 {
                
//                print(fabs((motionManager.accelerometerData?.acceleration.x)!))
//                print(fabs((motionManager.accelerometerData?.acceleration.y)!))
//                print(fabs((motionManager.accelerometerData?.acceleration.z)!))
                
                return true
            }
            
        }
        
        return false
        
    }
    
    func sendFall(id: CKRecordZoneID, fall: Bool) {
        ctUsers = [CKRecord]()
        
        
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        let privateData = container.privateCloudDatabase
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        privateData.perform(query, inZoneWith: id) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Cloud Query Error - Fetch Establishments: \(error)")
                }
                return
            }
            if results != nil {
                print("PRINTANDO OS RESULTS\n")
                print(results as Any)
                print("\nO ID DO RECORD É:\n")
                print(results?.first?.recordID as Any)
                
                self.fetchRecord(recordid: (results?.first?.recordID)!, completionHandler: { (success) in
                    if success {
                        
                        self.fetchedRecord?.setObject(fall as CKRecordValue?, forKey: "Fall")
                        
                        privateData.save(self.fetchedRecord!, completionHandler: { (record, error) in
                            if error != nil {
                                print("DEU MERDA TENTANDO SALVAR O RECORD PUXADO\n")
                                print(error?.localizedDescription)
                            } else {
                                print("QUEDA ATUALIZADA!!!!!!!!!\n")
                            }
                        })
                    }
                })
            }
        }
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
        
        print("Entrei na updateHeartRate")
        
        guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
        
        print("passei do guard let")
        
        DispatchQueue.main.async {
            
            print("Entrei no dispatch")
            
            guard let sample = heartRateSamples.first else{return}
            let value = sample.quantity.doubleValue(for: self.heartRateUnit)
            
            self.heartRateLabel.setText(String(Int(value)))
            
            // MANDAR PRO CLOUD KIT ESSE DADO: String(Int(value))
            
            self.fetchRecordZone(heartRate: String(Int(value)))
            
            print(String(Int(value)))
            
        }
        
        print("Sai da updateHeartRate")
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
    
    func fetchRecordZone(heartRate: String) {
        
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        let privateData = container.privateCloudDatabase
        privateData.fetchAllRecordZones { (recordZones, error) in
            if error != nil {
                print("DEU MERDA NA FETCH RECORDZONE\n")
                print(error?.localizedDescription)
            }
            if recordZones != nil {
                print(recordZones)
                let count = recordZones?.count
                for item in recordZones!{
                    
                    let zoneName = (item.value(forKey: "_zoneID") as! CKRecordZoneID).value(forKey: "_zoneName") as! String
                    print("zone name iS: \(zoneName)")
                    if(zoneName == "MedicalRecord"){
                        self.sendHeartRate(id: item.zoneID, heartRate: heartRate)
                    }
                }
            }
        }
    }
    
    func sendHeartRate(id: CKRecordZoneID, heartRate: String) {
        ctUsers = [CKRecord]()
        
        print("SHARED ZONE VERDADEIRA: \(id)")
        
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        let privateData = container.privateCloudDatabase
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        privateData.perform(query, inZoneWith: id) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("aaaaaCloud Query Error - Fetch Establishments: \(error)")
                }
                return
            }
            if results != nil {
                print("PRINTANDO OS RESULTS\n")
                print(results as Any)
                print("\nO ID DO RECORD É:\n")
                print(results?.first?.recordID as Any)
                
                self.fetchRecord(recordid: (results?.first?.recordID)!, completionHandler: { (success) in
                    if success {
                        
                        self.fetchedRecord?.setObject(heartRate as CKRecordValue?, forKey: "HeartRate")
                        
                        privateData.save(self.fetchedRecord!, completionHandler: { (record, error) in
                            if error != nil {
                                print("DEU MERDA TENTANDO SALVAR O RECORD PUXADO\n")
                                print(error?.localizedDescription)
                            } else {
                                print("RECORD ATUALIZADO!!!!!!!!!\n")
                            }
                        })
                    }
                })
            }
        }
    }
    
    typealias CompletionHandler = (_ success:Bool) -> Void
    func fetchRecord(recordid: CKRecordID, completionHandler: @escaping CompletionHandler) {
        
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        let privateData = container.privateCloudDatabase
        
        privateData.fetch(withRecordID: recordid, completionHandler: { (record, error) in
            if error != nil {
                print("DEU MERDA PROCURANDO O RECORD COM RECORDID\n")
                print(error?.localizedDescription as Any)
                completionHandler(false)
            } else {
                print("CHEGOU PRA SALVAR NO FETCHED RECORD!!\n")
                self.fetchedRecord = record
                completionHandler(true)
            }
        })
    }
    
    /********************************************************
     **                                                    **
     **               END: CLOUD KIT FUNCTIONS             **
     **                                                    **
     ********************************************************/
    
}
