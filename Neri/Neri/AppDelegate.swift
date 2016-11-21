//
//  AppDelegate.swift
//  Neri
//
//  Created by Pedro de Sá on 04/11/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import UIKit
import WatchConnectivity
import HealthKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let healthStore = HKHealthStore()
    
    var vc = EnterCaretakerViewController()
    
    
    // Sharing:
    func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShareMetadata) {
        
        let acceptSharesOperation = CKAcceptSharesOperation(shareMetadatas: [cloudKitShareMetadata])
        acceptSharesOperation.perShareCompletionBlock = {
            metadata, share, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                
                
//                let vc: EnterCaretakerViewController = self.window?.rootViewController as! EnterCaretakerViewController
                self.vc.fetchShare(cloudKitShareMetadata)
                
                
                
                
                let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Entrada") as UIViewController
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
        CKContainer(identifier: cloudKitShareMetadata.containerIdentifier).add(acceptSharesOperation)
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        
        self.healthStore.handleAuthorizationForExtension { success, error in
            
            
            
        }
        
    }


}

