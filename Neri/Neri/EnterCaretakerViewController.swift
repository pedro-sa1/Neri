//
//  EnterCaretakerViewController.swift
//  Neri
//
//  Created by Pedro de Sá on 20/11/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import UIKit
import CloudKit

class EnterCaretakerViewController: UIViewController {

    @IBOutlet weak var tel: UITextField!
    
    var currentRecord: CKRecord?
    var nomeIdoso = String()
    var idadeIdoso = String()
    var recordID: CKRecordID?
    
    var nextVC = MainCareTakerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func fetchShare(_ metadata: CKShareMetadata) {
        let operation = CKFetchRecordsOperation(recordIDs: [metadata.rootRecordID])
        operation.perRecordCompletionBlock = { record, _, error in
            
            print("PRINTANDO DA FETCH SHARE")
            print(record)
            
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            if record != nil {

                print("PRINTANDO O RECORD DA ENTER CARETAKER:\n")
                print(record as Any)
                self.currentRecord = record
                self.nomeIdoso = (record?.object(forKey: "name") as? String)!
                self.idadeIdoso = (record?.object(forKey: "age") as? String)!
                self.recordID = record?.recordID
                print("PRINTANDO O RECORD ID DA ENTER CARETAKER: \(self.recordID)\n")
                
                print("OS DADOS DO IDOSO SÃO:\n")
                print(self.nomeIdoso)
                print(self.idadeIdoso)

            }
        }
        operation.fetchRecordsCompletionBlock = { _, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
        }
        CKContainer.default().sharedCloudDatabase.add(operation)
    }
    
    
    @IBAction func continue2Main(_ sender: Any) {
        print("\nBUTTON CLICKED")
        print("\n\n\(self.nomeIdoso)\n\n")
        if tel.text != nil {
            performSegue(withIdentifier: "go2MainCT", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go2MainCT" {
            
            print("PRINTNADO O TELEFONE DA PREPARE FOR SEGUE:\n\(self.tel.text)")
            
            let vc = segue.destination as! MainCareTakerViewController
            vc.nome = nomeIdoso
            vc.idade = idadeIdoso
            vc.tel = tel.text!
            vc.recordid = self.recordID
        }
    }
}
