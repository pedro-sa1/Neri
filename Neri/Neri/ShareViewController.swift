//
//  ShareViewController.swift
//  Neri
//
//  Created by Pedro de Sá on 20/11/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import UIKit
import CloudKit

class ShareViewController: UIViewController, UICloudSharingControllerDelegate {

    var currentRecord: CKRecord?
    var privateDatabase: CKDatabase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = CKContainer.default
        privateDatabase = container().privateCloudDatabase
        
        print("CURRENT RECORD É:\n")
        print(currentRecord)
    }
    
    
    @IBAction func share(_ sender: Any) {
        
        // CRIANDO A SHARE
        
        let controller = UICloudSharingController { controller, preparationCompletionHandler in
            let share = CKShare(rootRecord: self.currentRecord!)
            
            share[CKShareTitleKey] = "My medical record" as CKRecordValue
            share.publicPermission = .readWrite
            
            let modifyRecordsOperation = CKModifyRecordsOperation(
                recordsToSave: [self.currentRecord!, share],
                recordIDsToDelete: nil)
            
            modifyRecordsOperation.timeoutIntervalForRequest = 10
            modifyRecordsOperation.timeoutIntervalForResource = 10
            
            modifyRecordsOperation.modifyRecordsCompletionBlock = {
                records, recordIDs, error in
                if error != nil {
                    print(error?.localizedDescription)
                }
                preparationCompletionHandler(share, CKContainer.default(), error)
            }
            self.privateDatabase?.add(modifyRecordsOperation)
        }
        controller.availablePermissions = [.allowPrivate, .allowReadWrite]
        controller.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        controller.delegate = self
        
        self.present(controller, animated: true)
        
       // performSegue(withIdentifier: "go2MainElder", sender: self)
    }
    
    // UICloudSharingController Delegate
    
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        print("ERROR SAVING SHARE")
        print(error.localizedDescription)
    }
    
    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        print("SHARE SAVED")
    }
    
    func itemTitle(for csc: UICloudSharingController) -> String? {
        return "My medical record"
    }
}
