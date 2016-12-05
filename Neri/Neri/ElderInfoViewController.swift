//
//  ElderInfoViewController.swift
//  Neri
//
//  Created by Pedro de Sá on 20/11/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import UIKit
import CloudKit

class ElderInfoViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var adress: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    
    @IBOutlet weak var telephone: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var view2: UIView!
    
    var privateDatabase: CKDatabase?
    var currentRecord: CKRecord?
    var recordZone: CKRecordZone?
    
    var activeTextField: UITextField?
    
    var imagePicked: UIImage?
    
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
        
        self.name.delegate = self
        self.age.delegate = self
        self.adress.delegate = self
        self.city.delegate = self
        self.state.delegate = self
        self.telephone.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(ElderInfoViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ElderInfoViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @IBAction func `continue`(_ sender: Any) {
        
        if name.text != nil && age.text != nil && adress.text != nil && city.text != nil && state.text != nil && telephone.text != nil {
            
            Elder.singleton.setUserName(name: name.text!)
            Elder.singleton.setUserBirthDay(birthDay: age.text!)
            Elder.singleton.setElderStreet(street: adress.text!)
            Elder.singleton.setElderCity(city: city.text!)
            Elder.singleton.setElderState(state: state.text!)
            Elder.singleton.setUserPhone(phone: telephone.text!)
            
            
            CloudKitDAO().loadElderUser(phone: Elder.singleton.getUserPhone()) { (success) in
                
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
    
    func keyboardWillShow(notification:NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let _: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue  else { return }
        guard let endKeyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  else { return }
        guard let activeTextField = self.activeTextField else { return }
        guard let activeTextFieldFrame = activeTextField.superview?.convert(activeTextField.frame, to: nil)else { return }
        
        if activeTextFieldFrame.maxY > endKeyboardFrame.origin.y {
            self.bottomConstraint.constant = (activeTextFieldFrame.maxY - endKeyboardFrame.origin.y) + 8
        }
    }
    
    func keyboardWillHide(notification:NSNotification) {
        self.bottomConstraint.constant = 0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imagePicked = image
        self.dismiss(animated: true, completion: nil);
    }

    @IBAction func openCameraButton(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
}
