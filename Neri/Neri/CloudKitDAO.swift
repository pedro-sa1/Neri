//
//  CloudKitDAO.swift
//  Neri
//
//  Created by Pedro de Sá on 20/11/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import Foundation
import CloudKit

public class CloudKitDAO {
    
    var ctUsers = [CKRecord]()
    var recordZone: CKRecordZone?
    var currentRecord: CKRecord?
    var privateDatabase: CKDatabase?
    
    typealias CompletionHandler2 = (_ success:Bool) -> Void
    func sendElder(usuario: Elder, zoneID: CKRecordZoneID, completionHandler: @escaping CompletionHandler2) -> CKRecord {
        
        let container = CKContainer.default
        privateDatabase = container().privateCloudDatabase
        
        print("CHEGOU NA SEND ELDER")
        
        let user = CKRecord(recordType: "Elder", zoneID: zoneID)
        
        user["name"] = usuario.getUserName() as CKRecordValue
        user["age"] = usuario.getUserBirthDay() as CKRecordValue
        user["adress"] = usuario.getElderStreet() as CKRecordValue
        user["city"] = usuario.getElderCity() as CKRecordValue
        user["state"] = usuario.getElderState() as CKRecordValue
        user["telephone"] = usuario.getUserPhone()
            as CKRecordValue
        user["cloudID"] = usuario.getUserID() as CKRecordValue?
        
        let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [user], recordIDsToDelete: nil)
        
        modifyRecordsOperation.timeoutIntervalForRequest = 10
        modifyRecordsOperation.timeoutIntervalForResource = 10
        
        modifyRecordsOperation.modifyRecordsCompletionBlock = { records, recordIDs, error in
                if error != nil {
                    print("Save Error")
                    print(error?.localizedDescription as Any)
                } else {
                    DispatchQueue.main.async {
                        print("Elder saved successfully")
                        completionHandler(true)
                    }
                    self.currentRecord = user
                }
        }
        privateDatabase?.add(modifyRecordsOperation)
        return user
    }
    
    typealias CompletionHandler = (_ success:Bool) -> Void
    func loadElderUser(phone: String, completionHandler: @escaping CompletionHandler) {
        
        ctUsers = [CKRecord]()
        print("\nO TELEFONE É:\(phone)")
        
        let privateData = CKContainer.default().privateCloudDatabase
        let predicate = NSPredicate(format: "telephone == %@", phone)
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
                    completionHandler(false)
                }
                else {
                    completionHandler(true)
                }
            }
        }
    }
}
