//
//  User.swift
//  Neri
//
//  Created by Gabriel Bendia on 11/4/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import Foundation

class User {
    
//    var name: String!
    var birthDay: String!   // String format: MM/dd/yyyy
    var phone: String!
    var userID: String!
    
    
    
    func getUserID() -> String {
        return userID
    }
    func setUserID(id: String) {
        self.userID = id
    }
    
    // MARK: - Class Functions -
    
    func calculateAge() -> Int {
        
        /*******************************************************
         **                                                   **
         **         FUNCTION TO CALCULATE USER AGE            **
         **                                                   **
         *******************************************************/
        
        /* 
         
         * User string birthDay format: MM/dd/yyy
         * Function separates birthDay string to get day, month and year, returning user current age.
         
         */
        
        let separatedDate = birthDay.components(separatedBy: "/")
         
        // day   = separatedDate[1] (dd)
        // month = separatedDate[0] (MM)
        // year  = separatedDate[2] (yyyy)

        let dateOfBirth = Calendar.current.date(from: DateComponents(year: Int(separatedDate[2]), month: Int(separatedDate[0]), day: Int(separatedDate[1])))
        
        return Calendar.current.dateComponents([.year], from: dateOfBirth!, to: Date()).year!
        
    }
    
}
