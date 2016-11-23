//
//  MainElderViewController.swift
//  Neri
//
//  Created by Pedro de Sá on 22/11/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import UIKit
import CloudKit

class MainElderViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    
    var fetchedRecord:CKRecord?
    var recordid: CKRecordID?
    var ctUsers = [CKRecord]()
    var timer: Timer!
    var id: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        
        container.fetchUserRecordID { (userRecordID, error) in
            if error != nil {
                print("DEU MERDA PEGANDO O RECORD ID DO USUARIO!\n")
                print(error?.localizedDescription as Any)
            }
            print("O ID DO USUARIO É:\(userRecordID?.recordName)\n")
            self.fetchUserID(id: String(describing: userRecordID?.recordName))
        }
        
        fetchRecordZone()
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(MainElderViewController.fetchRecordZone), userInfo: nil, repeats: true)
        
        
    }
    
    func fetchHeartRate() {
        DispatchQueue.main.async() {
            print("\nMUDANDO A LABEL DO BATIMENTO CARDÍACO!!\n")
            self.heartRateLabel.text = self.fetchedRecord?.value(forKey: "HeartRate") as! String?
        }
    }
    
    func fetchRecordZone() {
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
                        self.fetchInfo(id: item.zoneID)
                    }
                }
            }
        }
    }
    
    func fetchInfo(id: CKRecordZoneID) {
        
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
                
                
                for item in results!{
                    
                    let cloudID = item.object(forKey: "cloudID")!
                    print("*************\n*************\n\(cloudID.description)\n*************\n*************")
                    
                    if cloudID.description == self.id {
                        self.fetchRecord(recordid: (results?.first?.recordID)!, completionHandler: { (success) in
                            if success {
                                
                                print("NOME:\n\(self.fetchedRecord?.value(forKey: "name"))\n")
                                print("IDADE:\n\(self.fetchedRecord?.value(forKey: "age"))\n")
                                
                                DispatchQueue.main.async() {
                                    self.nameLabel.text = self.fetchedRecord?.object(forKey: "name") as? String
                                    self.ageLabel.text = self.fetchedRecord?.object(forKey: "age") as? String
                                    self.heartRateLabel.text = self.fetchedRecord?.object(forKey: "HeartRate") as? String
                                }
                            }
                        })
                    }
                }
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
                print("PRINTANDO O RECORD DA MAIN ELDER:\n\(record)\n")
                self.fetchedRecord = record
                completionHandler(true)
            }
        })
    }
    
    func fetchUserID(id: String) {
        ctUsers = [CKRecord]()
        
        let privateData = CKContainer.default().privateCloudDatabase
        let predicate = NSPredicate(format: "cloudID == %@", id)
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        privateData.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Cloud Query Error - Fetch Establishments: \(error)")
                }
                return
            }
            if let users = results {
                self.ctUsers = users
                self.id = results?.first?.object(forKey: "cloudID") as! String!
            }
        }
    }
}
