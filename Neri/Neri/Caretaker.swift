//
//  Caretaker.swift
//  Neri
//
//  Created by Gabriel Bendia on 11/4/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import Foundation
import UIKit

class Caretaker: User {
    
    static let singleton = Caretaker()
    
    // MARK: - Class Methods -
    
    func updateData() -> ErrorType {
       
       /*******************************************************
        **                                                   **
        **               UPDATE DATA FUNCTION                **
        **                                                   **
        *******************************************************/
        
        /*
         
         *
         
         */
        
       /*******************************************************
        **                                                   **
        **       AQUI PRECISA PEGAR DADOS DO CLOUD KIT       **
        **                                                   **
        *******************************************************/
        
        return ErrorType.OK
        
    }
    
    func callCaretaker(elderPhone: String) -> ErrorType {
        
        /*******************************************************
         **                                                   **
         **            CALLING CARETAKER FUNCTION             **
         **                                                   **
         *******************************************************/
        
        /*
         
         * Elder phone must exist
         * If the phone is for another region (country or state), it has to be complete
         * In case the call can't be completed the app shows an alert
         
         */
        
        if let url = NSURL(string: "tel://\(elderPhone)") {
            UIApplication.shared.open(url as URL)
            return ErrorType.OK
        } else {
            return ErrorType.CallFailed
        }
        
    }
    
}
