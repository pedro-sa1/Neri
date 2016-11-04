//
//  Elder.swift
//  Neri
//
//  Created by Gabriel Bendia on 11/4/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import Foundation
import UIKit

/*******************************************************
 **                                                   **
 **  VERIFICAR PESO, ALTURA, BATIMENTO E LOCALIZAÇÃO  **
 **                                                   **
 *******************************************************/

class Elder: User {
    
    var street: String!
    var houseNumber: Int!
    var city: String!
    var state: String!
    var weight: String!
    var height: String!
    var currentHeartRate: String?
    var location: String?
    
    init (name: String, birthDay: String, phone: String, street: String, houseNumber: Int, city: String, state: String, weight: String, height: String) {
        
        super.init(name: name, birthDay: birthDay, phone: phone)
        
        self.street = street
        self.houseNumber = houseNumber
        self.city = city
        self.state = state
        self.weight = weight
        self.height = height
        
    }
    
}
