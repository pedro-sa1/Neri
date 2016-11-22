//
//  MainCareTakerViewController.swift
//  Neri
//
//  Created by Pedro de Sá on 20/11/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import UIKit
import CloudKit

class MainCareTakerViewController: UIViewController {
    
    @IBOutlet weak var elderName: UILabel!
    @IBOutlet weak var elderAge: UILabel!
    
    @IBOutlet weak var heartRateLabel: UILabel!
    
    var nome = ""
    var idade = ""
    var tel = ""
    var recordid: CKRecordID?
    
    var ctUsers = [CKRecord]()
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("\nnome do idoso é: \(nome)\n")
        print("idade do idoso é: \(idade)\n")
        print("o id do record é: \(recordid)\n")
        
        self.elderName.text = nome
        self.elderAge.text = idade
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(MainCareTakerViewController.fetchHeartRate), userInfo: nil, repeats: true)
        
        //fetchHeartRate()
//        let container = CKContainer(identifier: "iCloud.pedro.Neri")
//        var sharedData = container.sharedCloudDatabase
//        
//        sharedData = CKContainer.default().sharedCloudDatabase
//        sharedData.fetchAllRecordZones { (recordZone, error) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//            }
//            if recordZone != nil {
//                
//            }
//        }
    }
    
    
    
    func fetchHeartRate() {
        ctUsers = [CKRecord]()
        print("CHEGOU NA FETCHHEARTRATE\n")
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        let sharedData = container.sharedCloudDatabase
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        sharedData.fetch(withRecordID: recordid!, completionHandler: { (record, error) in
            
            if error != nil {
                print("ERRO NA MAIN TENTANDO DAR FETCH NO RECORD")
            } else {
                print("PRINTANDO O RECORD:\n")
                print(record)
                
                DispatchQueue.main.async() {
                    self.heartRateLabel.text = record?.object(forKey: "HeartRate") as? String
                }
            }
            
        })
        
    }
    
}
