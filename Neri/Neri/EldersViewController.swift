//
//  EldersViewController.swift
//  Neri
//
//  Created by Ana Carolina Nascimento on 01/12/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//


import Foundation
import UIKit
import CloudKit

class EldersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var nome = ""
    var idade = ""
    var tel = ""
    var recordid: CKRecordID?
    
    var nameArray = ["Pedro"]
    
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "elderCell", for: indexPath) as! ElderCollectionViewCell
        
        
        
        cell.elderNameLabel.text = nameArray[indexPath.row]
        cell.elderImageView.image = UIImage(named: "nophoto")
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showElder", sender: self)
    }
    
    //func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showElder" {
            
            print("PRINTNADO O TELEFONE DA PREPARE FOR SEGUE:\n\(self.tel)")
            
            let vc = segue.destination as! MainCaretakerViewController
            vc.nome = nome
            vc.idade = idade
            vc.tel = tel
            vc.recordid = recordid
        }
    }
    
}

