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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("nome do idoso é: \(nome)\n")
        print("idade do idoso é: \(idade)\n")
        
        self.elderName.text = nome
        self.elderAge.text = idade
        
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        var sharedData = container.sharedCloudDatabase
        
        sharedData = CKContainer.default().sharedCloudDatabase
        sharedData.fetchAllRecordZones { (recordZone, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            if let recordZones = recordZone {
                
            }
        }
    }
    
    
    
    func fetchHeartRate() {
        ctUsers = [CKRecord]()
        
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        let sharedData = container.sharedCloudDatabase
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        //sharedData.fetch(withRecordID: <#T##CKRecordID#>, completionHandler: <#T##(CKRecord?, Error?) -> Void#>)
        
    }
    
}
