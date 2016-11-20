//
//  MainCareTakerViewController.swift
//  Neri
//
//  Created by Pedro de Sá on 20/11/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import UIKit

class MainCareTakerViewController: UIViewController {
    
    @IBOutlet weak var elderName: UILabel!
    @IBOutlet weak var elderAge: UILabel!
    
    var nome = ""
    var idade = ""
    var tel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("nome do idoso é: \(nome)\n")
        print("idade do idoso é: \(idade)\n")
        
        self.elderName.text = nome
        self.elderAge.text = idade
    }
    
    
}
