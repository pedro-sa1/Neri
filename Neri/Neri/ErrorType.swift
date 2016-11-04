//
//  ErrorType.swift
//  Neri
//
//  Created by Gabriel Bendia on 11/4/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import Foundation
import UIKit

enum ErrorType {
    
    case OK
    case UpdateFailed
    case CallFailed
    case VerificationFailed
    case HeartBeatNotificationFailed
    case FallNotificationFailed
    case CloudKitNotificationFailed
    case PairingFailed
    case RetrieveHeartbeatError
    case RetrieveLocationFailed
    
}

//func presentErrorMessage(errorType: ErrorType) {
//    
//    print("================\nPresenting error message\n================")
//    
//    switch errorType {
//    case .UpdateFailed:
//        
//    case .CallFailed:
//        
//    case .VerificationFailed:
//        
//    case .HeartBeatNotificationFailed:
//        
//    case .FallNotificationFailed:
//        
//    case .CloudKitNotificationFailed:
//        
//    case .PairingFailed:
//        
//    case .RetrieveHeartbeatError:
//        
//    case .RetrieveLocationFailed:
//        
//    default:
//        print("\nNothing ocurred. Error OK\n")
//        
//    }
//    
//}
