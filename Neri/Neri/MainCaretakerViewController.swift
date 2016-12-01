//
//  MainCaretakerViewController.swift
//  Neri
//
//  Created by Pedro de Sá on 20/11/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import UIKit
import CloudKit

class MainCaretakerViewController: UIViewController {
    
    @IBOutlet weak var elderName: UILabel!
    @IBOutlet weak var elderAge: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    
    var nome = ""
    var idade = ""
    var tel = ""
    
    var recordid: CKRecordID?
    var ctUsers = [CKRecord]()
    var timer: Timer!
    
    let progressHUD = ProgressHUD(text: "Loading")
    
    var lat:String!
    var long:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Activity indicator
        self.view.addSubview(progressHUD)
        progressHUD.show()
        // Activicty indicator iniciado.

        
        print("\nnome do idoso é: \(nome)\n")
        print("idade do idoso é: \(idade)\n")
        print("o id do record é: \(recordid)\n")
        
        self.elderName.text = nome
        self.elderAge.text = idade
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(MainCaretakerViewController.fetchHeartRate), userInfo: nil, repeats: true)
        
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
                    self.lat = record?.object(forKey: "lat") as? String
                    self.long = record?.object(forKey: "long") as? String
                    
                    // Encerrando o Activity indicator:
                    self.progressHUD.hide()
                }
            }
        })
    }
    
}
