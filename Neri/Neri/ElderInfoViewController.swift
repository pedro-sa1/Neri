//
//  ElderInfoViewController.swift
//  Neri
//
//  Created by Pedro de Sá on 20/11/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import UIKit
import CloudKit

class ElderInfoViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var adress: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var telephone: UITextField!
    
    var privateDatabase: CKDatabase?
    var currentRecord: CKRecord?
    var recordZone: CKRecordZone?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let container = CKContainer.default
        privateDatabase = container().privateCloudDatabase
        
        container().fetchUserRecordID { (userRecordID, error) in
            if error != nil {
                print("DEU MERDA PEGANDO O RECORD ID DO USUARIO!\n")
                print(error?.localizedDescription as Any)
            }
            print("O ID DO USUARIO É:\(userRecordID?.recordName)\n")
            Elder.singleton.setUserID(id: String(describing: userRecordID?.recordName))
        }
        
        recordZone = CKRecordZone(zoneName: "MedicalRecord")
        privateDatabase?.save(recordZone!, completionHandler: {(recordzone, error) in
            if (error != nil) {
                print("Failed to create custom record zone.\n")
            } else {
                print("Custom zone created successfuly.\n")
            }
        })
    }
    
    
    @IBAction func `continue`(_ sender: Any) {
        
        if name.text != nil && age.text != nil && adress.text != nil && city.text != nil && state.text != nil && telephone.text != nil {
            
            Elder.singleton.setElderName(name: name.text!)
            Elder.singleton.setElderAge(age: age.text!)
            Elder.singleton.setElderStreet(street: adress.text!)
            Elder.singleton.setElderCity(city: city.text!)
            Elder.singleton.setElderState(state: state.text!)
            Elder.singleton.setElderPhone(phone: telephone.text!)
            
            
            CloudKitDAO().loadElderUser(phone: Elder.singleton.getElderPhone()) { (success) in
                
                if success { // success = 0 pessoas; salva
                    
                    self.currentRecord = CloudKitDAO().sendElder(usuario: Elder.singleton, zoneID: (self.recordZone?.zoneID)!) { (success) in
                        self.performSegue(withIdentifier: "go2Share", sender: self)
                    }
                } else {
                    print("user already in cloud\n")
                }
            }
        } else {
            print("Por favor, preencha todos os campos antes de continuar.\n")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go2Share" {
            let vc = segue.destination as! ShareViewController
            vc.currentRecord = self.currentRecord
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        name.endEditing(true)
        age.endEditing(true)
        adress.endEditing(true)
        city.endEditing(true)
        state.endEditing(true)
        telephone.endEditing(true)
    }
}
