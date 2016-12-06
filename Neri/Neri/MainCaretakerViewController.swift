//
//  MainCaretakerViewController.swift
//  Neri
//
//  Created by Pedro de Sá on 20/11/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import UIKit
import CloudKit
import MapKit

class MainCaretakerViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var elderName: UILabel!
    @IBOutlet weak var elderAge: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    var nome = ""
    var idade = ""
    var tel = ""
    
    var recordid: CKRecordID?
    var ctUsers = [CKRecord]()
    var timer: Timer!
    
    let progressHUD = ProgressHUD(text: "Loading")
    
    var lat:String!
    var long:String!
    
    var adress = Adress()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        map.showsUserLocation = false
        
        // Activity indicator
        self.view.addSubview(progressHUD)
        progressHUD.show()
        // Activicty indicator iniciado.

        
        print("\nnome do idoso é: \(nome)\n")
        print("idade do idoso é: \(idade)\n")
        print("o id do record é: \(recordid)\n")
        
        self.elderName.text = nome
        self.elderAge.text = idade
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(MainCaretakerViewController.fetchHeartRate), userInfo: nil, repeats: true)
        
        //fetchHeartRate()
//        let container = CKContainer(identifier: "iCloud.pedro.Neri")
//        var sharedData = container.sharedCloudDatabase
//        
//        sharedData = CKContainer.default().sharedCloudDatabase
//        sharedData.fetchAllRecordZones { (recordZone, error) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//            }
//            if recordZone != nil {
//                
//            }
//        }
    }
    
    
    
    func fetchHeartRate() {
        ctUsers = [CKRecord]()
        print("CHEGOU NA FETCHHEARTRATE\n")
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        let sharedData = container.sharedCloudDatabase
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        sharedData.fetch(withRecordID: recordid!, completionHandler: { (record, error) in
            
            if error != nil {
                print("ERRO NA MAIN TENTANDO DAR FETCH NO RECORD")
            } else {
                print("PRINTANDO O RECORD:\n")
                print(record)
                
                DispatchQueue.main.async() {
                    self.heartRateLabel.text = record?.object(forKey: "HeartRate") as? String
                    self.lat = record?.object(forKey: "lat") as? String
                    self.long = record?.object(forKey: "long") as? String
                    
                    self.centerMap()
                    // Encerrando o Activity indicator:
                    self.progressHUD.hide()
                }
            }
        })
    }
    
    func centerMap() {
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.lat)!, longitude: CLLocationDegrees( self.long)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.026, longitudeDelta: 0.026))
        self.map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        
       
        
        CLGeocoder().reverseGeocodeLocation( CLLocation(latitude: CLLocationDegrees(self.lat)!, longitude: CLLocationDegrees(self.long)!), completionHandler: {(placemarks, error)-> Void in
            if (error != nil)
            {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if placemarks!.count > 0
            {
                let pm = (placemarks?[0])! as CLPlacemark
                print("\n\n\n************ADRESS******************\n\n\n")
                
                self.adress.coordinate = pm.location?.coordinate
                self.adress.thoroughfare = pm.thoroughfare ?? ""
                self.adress.subThoroughfare = pm.subThoroughfare ?? ("" as String)
                self.adress.subLocality = pm.subLocality ?? ""
                self.adress.locality = pm.locality ?? ""
                self.adress.administrativeArea = pm.administrativeArea ?? ""
                self.adress.country = pm.country ?? ""
            
                print(self.adress)
                
                if self.adress.thoroughfare != nil && self.adress.subThoroughfare != nil && self.adress.administrativeArea != nil && self.adress.locality != nil && self.adress.country != nil
                {
                    annotation.title = ((self.adress.thoroughfare!) + ", " + (self.adress.subThoroughfare!))
                    annotation.subtitle = ((self.adress.locality!) + ", " + (self.adress.administrativeArea!) + " - " + (self.adress.country)!)
                    
                    annotation.title = annotation.title?.replacingOccurrences(of: "Optional", with: "")
                    annotation.title = annotation.title?.replacingOccurrences(of: "(\"", with: "")
                    annotation.title = annotation.title?.replacingOccurrences(of: "\")", with: "")
                    
                    annotation.subtitle = annotation.subtitle?.replacingOccurrences(of: "Optional", with: "")
                    annotation.subtitle = annotation.subtitle?.replacingOccurrences(of: "(\"", with: "")
                    annotation.subtitle = annotation.subtitle?.replacingOccurrences(of: "\")", with: "")
                }
                
            }
            else
            {
                print("Problem with the data received from geocoder")
            }
        })
        
        self.map.removeAnnotations(self.map.annotations)
        self.map.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let userIdentifier = "UserLocation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: userIdentifier)
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: userIdentifier)
            annotationView!.canShowCallout = true
            annotationView!.image = UIImage(named: "location")
        }
        else
        {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
}
