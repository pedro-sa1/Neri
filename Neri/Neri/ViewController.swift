//
//  ViewController.swift
//  Neri
//
//  Created by Pedro de Sá on 04/11/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    
    var ctUsers = [CKRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        
        container.fetchUserRecordID { (userRecordID, error) in
            if error != nil {
                print("DEU MERDA PEGANDO O RECORD ID DO USUARIO!\n")
                print(error?.localizedDescription as Any)
            }
            print("O ID DO USUARIO É:\(userRecordID?.recordName.description)\n")
            self.fetchID(id: String(describing: userRecordID?.recordName.description))
        }
    }
    
    func fetchID(id: String) {
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
                print("\nHow many users in cloud: \(self.ctUsers.count)\n")
                if self.ctUsers.count != 0 {
                    print("VOCÊ JÁ ESTÁ CADASTRADO NO APP!\n")
                    
                }
                else {
                    print("USUARIO NOVO!\n")
                }
            }
        }
    }
}

