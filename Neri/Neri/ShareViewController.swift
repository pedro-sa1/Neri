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
    
    var flag = 0
    var timer: Timer!
    var foto:UIImage?
    
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("A FOTO É:\n")
        print(foto)
        print("----------------")
        
        let container = CKContainer.default
        privateDatabase = container().privateCloudDatabase
        
        print("CURRENT RECORD É:\n")
        print(currentRecord as Any)
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(ShareViewController.check), userInfo: nil, repeats: true)
    }
    
    func check() {
        if self.flag == 1 {
            performSegue(withIdentifier: "go2MainElder", sender: self)
        }
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
                    print(error?.localizedDescription as Any)
                }
                preparationCompletionHandler(share, CKContainer.default(), error)
//                self.flag = 1
            }
            self.privateDatabase?.add(modifyRecordsOperation)
        }
        controller.availablePermissions = [.allowPrivate, .allowReadWrite]
        controller.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        controller.delegate = self
        
        
        
        self.present(controller, animated: true)
        self.flag = 1
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go2MainElder"{
            let vc = segue.destination as! MainElderViewController
            vc.elderFoto = self.foto
        }
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
