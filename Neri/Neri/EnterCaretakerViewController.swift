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
    var ctUsers = [CKRecord]()
    var userID: String!
    
    
    
    //var nextVC = EldersViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        print("AAAAAAAAAAAAA")
        container.fetchUserRecordID { (userRecordID, error) in
            if error != nil {
                print("DEU MERDA PEGANDO O RECORD ID DO USUARIO!\n")
                print(error?.localizedDescription as Any)
            }
            print("OOOOOOO ID DO USUARIO É:\(userRecordID?.recordName.description)\n")
            self.userID = userRecordID?.recordName.description
//            self.fetchID(id: self.userID)
        }
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
                
                
                print("\n\((record?.object(forKey: "cloudID")))\n")
                self.fetchID(id: (record?.object(forKey: "cloudID"))! as! String)
            }
        }
        operation.fetchRecordsCompletionBlock = { _, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            }
        }
        CKContainer.default().sharedCloudDatabase.add(operation)
    }
    
    
    
    
    func fetchID(id: String) {  // ID DO USUARIO
        ctUsers = [CKRecord]()
        
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        let privateData = container.privateCloudDatabase
        let predicate = NSPredicate(format: "cloudID == %@", id)
        let query = CKQuery(recordType: "Caretaker", predicate: predicate)
        
        privateData.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Cloud Query Error - Fetch Establishments: \(error)")
                }
                return
            }
            if let users = results {
                self.ctUsers = users
                print("\nENTER CARETAKER - How many users in cloud: \(self.ctUsers.count)\n")
                
                if self.ctUsers.count != 0 {
                    print("VOCÊ JÁ ESTÁ CADASTRADO NO APP!\n")
                    DispatchQueue.main.async() {
                        self.performSegue(withIdentifier: "go2MainCT", sender: self)
                    }
                }
                else {
                    print("USUARIO NOVO!\n")
                    
                    let container = CKContainer(identifier: "iCloud.pedro.Neri")
                    let privateData = container.privateCloudDatabase
                    let ctRecord = CKRecord(recordType: "Caretaker")
                    privateData.save(ctRecord, completionHandler: { (record, error) in
                        if error != nil {
                            print("ERRO AO SALVAR CARETAKER NA NUVEM!\n\(error?.localizedDescription)")
                        } else {
                            print("CARETAKER SALVO COM SUCESSO!\n")
                        }
                    })
                }
            }
        }
    }
    
    
    
    
    
    @IBAction func continue2Main(_ sender: Any) {
        
        var alreadyExists = false
        
        print("\nBUTTON CLICKED")
        print("\n\n\(self.nomeIdoso)\n\n")
        print("NOME: \(nomeIdoso)")
        print("IDADE: \(idadeIdoso)")
        print("ID DO RECORD: \(recordID)")
        
        if tel.text != nil {
            
            print("NOME222: \(nomeIdoso)")
            print("IDADE222: \(idadeIdoso)")
            print("ID DO RECORD222: \(recordID)")
            
            Caretaker.singleton.setUserID(id: userID)
            Caretaker.singleton.setUserPhone(phone: tel.text!)
            
            let container = CKContainer(identifier: "iCloud.pedro.Neri")
            let sharedData = container.sharedCloudDatabase
            
            for item in (self.currentRecord?.object(forKey: "CaretakerTelephone")) as! [String] {
                print("Entrei no for")
                print("O NUMERO DE ITENS É: \(item)")
                if item == self.tel.text {
                    // ja ta pareado
                    // faz a segue
                    alreadyExists = true
                    DispatchQueue.main.async() {
                        self.performSegue(withIdentifier: "go2Elders", sender: self)
                    }
                }
            }
            
            print("sai do for")
            
            if alreadyExists == false {
                // não ta pareado
                // adiciona
                
                var ar = self.currentRecord?.object(forKey: "CaretakerTelephone") as! [String]
                ar.append(self.tel.text!)
                
                print(ar)
                
                self.currentRecord?.setObject(ar as CKRecordValue?, forKey: "CaretakerTelephone")
                
                sharedData.save(self.currentRecord!, completionHandler: { (record, error) in
                    if error != nil {
                        print("ERRO AO ATUALIZAR MEDICAL RECORD COM TELEFONE DO CUIDADOR!!: \(error?.localizedDescription)")
                    } else {
                        print("MEDICAL RECORD ATUALIZADA COM O TELEFONE DO CUIDADOR COM SUCESSO!!\n")
                    }
                })
            }
            
            performSegue(withIdentifier: "go2Elders", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go2Elders" {
            
            print("PRINTNADO O TELEFONE DA PREPARE FOR SEGUE:\n\(self.tel.text)")
            print("NOME: \(nomeIdoso)")
            print("IDADE: \(idadeIdoso)")
            print("ID DO RECORD: \(recordID)")
            
            
            let vc = segue.destination as! EldersViewController
            vc.nome = nomeIdoso
            vc.idade = idadeIdoso
            vc.tel = tel.text!
            vc.recordid = self.recordID
        }
    }
}
