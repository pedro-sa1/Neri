//
//  MainElderViewController.swift
//  Neri
//
//  Created by Pedro de Sá on 22/11/16.
//  Copyright © 2016 Pedro de Sá. All rights reserved.
//

import UIKit
import CloudKit
import MapKit

struct Adress
{
    var coordinate : CLLocationCoordinate2D?
    var thoroughfare : String?
    var subThoroughfare : String?
    var subLocality : String?
    var locality : String?
    var administrativeArea : String?
    var country : String?
}

class MainElderViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var photo: UIImageView!
    
    var fetchedRecord:CKRecord?
    var fetchedRecord2:CKRecord?
    var recordid: CKRecordID?
    var ctUsers = [CKRecord]()
    var timer: Timer!
    var id: String!
    var elderFoto: UIImage?
    
    var adress = Adress()
    
    var firstTime = true
    
    
    let progressHUD = ProgressHUD(text: "Loading")
    
    var latitude:String?
    var longitude:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        userLocation()
        
        map.delegate = self
        map.showsUserLocation = true
        
        photo.layer.masksToBounds = false
        photo.contentMode = .scaleAspectFit
        photo.layer.cornerRadius = photo.frame.width/2;
        photo.clipsToBounds = true

        // Activity indicator
        self.view.addSubview(progressHUD)
        progressHUD.show()
        // Activicty indicator iniciado.
        
        
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        
        container.fetchUserRecordID { (userRecordID, error) in
            if error != nil {
                print("DEU MERDA PEGANDO O RECORD ID DO USUARIO!\n")
                print(error?.localizedDescription as Any)
            }
            print("O ID DO USUARIO É:\(userRecordID?.recordName)\n")
            self.fetchUserID(id: String(describing: userRecordID?.recordName))
        }
        
        fetchRecordZone()
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(MainElderViewController.fetchRecordZone), userInfo: nil, repeats: true)
        
        
    }
    
    
    
    func fetchHeartRate() {
        DispatchQueue.main.async() {
            print("\nMUDANDO A LABEL DO BATIMENTO CARDÍACO!!\n")
            self.heartRateLabel.text = self.fetchedRecord?.value(forKey: "HeartRate") as! String?
            
            // Encerrando o Activity indicator:
            //self.progressHUD.hide()
        }
    }
    
    func fetchRecordZone() {
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        let privateData = container.privateCloudDatabase
        privateData.fetchAllRecordZones { (recordZones, error) in
            if error != nil {
                print("DEU MERDA NA FETCH RECORDZONE\n")
                print(error?.localizedDescription)
            }
            if recordZones != nil {
                print(recordZones)
                let count = recordZones?.count
                for item in recordZones!{
                    
                    let zoneName = (item.value(forKey: "_zoneID") as! CKRecordZoneID).value(forKey: "_zoneName") as! String
                    print("zone name iS: \(zoneName)")
                    if(zoneName == "MedicalRecord"){
                        self.fetchInfo(id: item.zoneID)
                        
                        //print("VAI MANDAR A LOCALIZAÇÃO!!!\n")
                        //self.sendLatLong(id: item.zoneID, lat: self.latitude!, long: self.longitude!)
                    }
                }
            }
        }
    }
    
    
    
    // Mandando localização pra nuvem:
    //
    //_______________________________
    
    func sendLatLong(id: CKRecordZoneID, lat: String, long: String) { // send location
        ctUsers = [CKRecord]()
        
        print("SHARED ZONE VERDADEIRA: \(id)")
        print("CHEGOU NA SEND LAT LONG\n")
        
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        let privateData = container.privateCloudDatabase
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        privateData.perform(query, inZoneWith: id) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Cloud Query Error - Fetch Establishments: \(error)")
                }
                return
            }
            if results != nil {
                print("PRINTANDO OS RESULTS\n")
                print(results as Any)
                print("\nO ID DO RECORD É:\n")
                print(results?.first?.recordID as Any)
                
                self.fetchRecord2(recordid: (results?.first?.recordID)!, completionHandler2: { (success) in
                    if success {
                        
                        print("ATUALIZANDO A LATITUDE E A LONGITUDE NA NUVEM!\n")
                        
                        self.fetchedRecord2?.setObject(lat as CKRecordValue?, forKey: "lat")
                        self.fetchedRecord2?.setObject(long as CKRecordValue?, forKey: "long")
                        
                        privateData.save(self.fetchedRecord2!, completionHandler: { (record, error) in
                            if error != nil {
                                print("DEU MERDA TENTANDO SALVAR O RECORD PUXADO\n")
                                print(error?.localizedDescription)
                            } else {
                                print("LOCALIAÇÃO ATUALIZADA!!!!!!!!!\n")
                            }
                        })
                    }
                })
            }
        }
    }
    
    typealias CompletionHandler2 = (_ success:Bool) -> Void
    func fetchRecord2(recordid: CKRecordID, completionHandler2: @escaping CompletionHandler) {
        
        print("\nCHEGOU NA FETCH RECORD 2\n")
        
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        let privateData = container.privateCloudDatabase
        
        privateData.fetch(withRecordID: recordid, completionHandler: { (record, error) in
            if error != nil {
                print("DEU MERDA PROCURANDO O RECORD COM RECORDID\n")
                print(error?.localizedDescription as Any)
                completionHandler2(false)
            } else {
                print("CHEGOU PRA SALVAR NO FETCHED RECORD!!\n")
                self.fetchedRecord2 = record
                completionHandler2(true)
            }
        })
    }
    
    // Terminando de mandar pra nuvem
    //
    //_______________________________
    
    
    func fetchInfo(id: CKRecordZoneID) {
        
        ctUsers = [CKRecord]()
        
        print("SHARED ZONE VERDADEIRA: \(id)")
        
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        let privateData = container.privateCloudDatabase
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        
        privateData.perform(query, inZoneWith: id) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("aaaaaCloud Query Error - Fetch Establishments: \(error)")
                }
                return
            }
            if results != nil {
                print("PRINTANDO OS RESULTS\n")
                print(results as Any)
                print("\nO ID DO RECORD É:\n")
                print(results?.first?.recordID as Any)
                
                
                for item in results!{
                    
                    let cloudID = item.object(forKey: "cloudID")!
                    print("*************\n*************\n\(cloudID.description)\n*************\n*************")
                    
                    if cloudID.description == self.id {
                        self.fetchRecord(recordid: (results?.first?.recordID)!, completionHandler: { (success) in
                            if success {
                                
                                print("NOME:\n\(self.fetchedRecord?.value(forKey: "name"))\n")
                                print("IDADE:\n\(self.fetchedRecord?.value(forKey: "age"))\n")
                                
                                DispatchQueue.main.async() {
                                    self.nameLabel.text = self.fetchedRecord?.object(forKey: "name") as? String
                                    self.ageLabel.text = self.fetchedRecord?.object(forKey: "age") as? String
                                    self.heartRateLabel.text = self.fetchedRecord?.object(forKey: "HeartRate") as? String
                                    
                                    // Encerrando o Activity indicator:
                                    self.progressHUD.hide()
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    typealias CompletionHandler = (_ success:Bool) -> Void
    func fetchRecord(recordid: CKRecordID, completionHandler: @escaping CompletionHandler) {
        
        let container = CKContainer(identifier: "iCloud.pedro.Neri")
        let privateData = container.privateCloudDatabase
        
        privateData.fetch(withRecordID: recordid, completionHandler: { (record, error) in
            if error != nil {
                print("DEU MERDA PROCURANDO O RECORD COM RECORDID\n")
                print(error?.localizedDescription as Any)
                completionHandler(false)
            } else {
                print("PRINTANDO O RECORD DA MAIN ELDER:\n\(record)\n")
                self.fetchedRecord = record
                completionHandler(true)
            }
        })
    }
    
    func fetchUserID(id: String) {
        ctUsers = [CKRecord]()
        
        let privateData = CKContainer.default().privateCloudDatabase
        let predicate = NSPredicate(format: "cloudID == %@", id)
        let query = CKQuery(recordType: "Elder", predicate: predicate)
        
        privateData.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Cloud Query Error - Fetch Establishments: \(error)")
                }
                return
            }
            if let users = results {
                self.ctUsers = users
                self.id = results?.first?.object(forKey: "cloudID") as! String!
            }
        }
    }
    
    func userLocation()
    {
        print("USER LOCATIONNNNNNN")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        let center = CLLocationCoordinate2D(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.026, longitudeDelta: 0.026))
        self.map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        
        
        CLGeocoder().reverseGeocodeLocation(locationManager.location!, completionHandler: {(placemarks, error)-> Void in
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        print("\n\nENTROU NO LOCATION MANAGER\n\n")
        if firstTime == true {
            
            self.latitude = String(describing: locations.last?.coordinate.latitude)
            self.longitude = String(describing: locations.last?.coordinate.longitude)
            
            latitude = latitude?.replacingOccurrences(of: "Optional", with: "")
            latitude = latitude?.replacingOccurrences(of: "(\"", with: "")
            latitude = latitude?.replacingOccurrences(of: "\")", with: "")
            latitude = latitude?.replacingOccurrences(of: "(", with: "")
            latitude = latitude?.replacingOccurrences(of: ")", with: "")
            
            longitude = longitude?.replacingOccurrences(of: "Optional", with: "")
            longitude = longitude?.replacingOccurrences(of: "(\"", with: "")
            longitude = longitude?.replacingOccurrences(of: "\")", with: "")
            longitude = longitude?.replacingOccurrences(of: "(", with: "")
            longitude = longitude?.replacingOccurrences(of: ")", with: "")
            
            print("COORDENADAS: \(self.latitude) \(self.longitude)\n")
            
            let container = CKContainer(identifier: "iCloud.pedro.Neri")
            let privateData = container.privateCloudDatabase
            privateData.fetchAllRecordZones { (recordZones, error) in
                if error != nil {
                    print("DEU MERDA NA FETCH RECORDZONE\n")
                    print(error?.localizedDescription)
                }
                if recordZones != nil {
                    print(recordZones)
                    let count = recordZones?.count
                    for item in recordZones!{
                        
                        let zoneName = (item.value(forKey: "_zoneID") as! CKRecordZoneID).value(forKey: "_zoneName") as! String
                        print("zone name iS: \(zoneName)")
                        if(zoneName == "MedicalRecord"){
                            
                            print("VAI MANDAR A LOCALIZAÇÃO!!!\n")
                            self.sendLatLong(id: item.zoneID, lat: self.latitude!, long: self.longitude!)
                        }
                    }
                }
            }
            
            firstTime = false
            
        } else {
            if locations.last != locations[locations.endIndex-1] {
                
                self.latitude = String(describing: locations.last?.coordinate.latitude)
                self.longitude = String(describing: locations.last?.coordinate.longitude)
                
                print("COORDENADAS PIRU:\n\(self.latitude)\n\(self.longitude)\n")
                
                let container = CKContainer(identifier: "iCloud.pedro.Neri")
                let privateData = container.privateCloudDatabase
                privateData.fetchAllRecordZones { (recordZones, error) in
                    if error != nil {
                        print("DEU MERDA NA FETCH RECORDZONE\n")
                        print(error?.localizedDescription)
                    }
                    if recordZones != nil {
                        print(recordZones)
                        let count = recordZones?.count
                        for item in recordZones!{
                            
                            let zoneName = (item.value(forKey: "_zoneID") as! CKRecordZoneID).value(forKey: "_zoneName") as! String
                            print("zone name iS: \(zoneName)")
                            if(zoneName == "MedicalRecord"){
                                
                                print("VAI MANDAR A LOCALIZAÇÃO!!!\n")
                                self.sendLatLong(id: item.zoneID, lat: self.latitude!, long: self.longitude!)
                            }
                        }
                    }
                }
            }
            else {
                //NÃO mandar pro cloud
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error while updating location " + error.localizedDescription)
    }

    @IBAction func callButtonAction(_ sender: Any) {
        
        print("Call button clicked")
        
        // PEGAR TELEFONE DO CARETAKER E MANDAR PARA A FUNÇÃO
        // POR ENQUANTO TA COM UM TELEFONE FIXO PARA DEMONSTRAÇÃO
        
        let returnedCondition = Elder.singleton.callCaretaker(caretakerPhone: "+552988191552")
        
        print(returnedCondition)
        
    }

}
