//
//  ViewController.swift
//  TravelBook_MapKit
//
//  Created by ysf on 27.10.21.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var locationManeger = CLLocationManager()
    
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManeger.delegate = self
        
        // kCLLocationAccuracyBest en iyi konumu getirir ama cok pil yer,kCLLocationAccuracyKilometer secilerek sapma goze alinabilir.
        locationManeger.desiredAccuracy = kCLLocationAccuracyBest
        //uygulama ilk acilisinda alinacak izin icin
        // info.plist icerisind de buna iliskin ayar yapildi
        locationManeger.requestWhenInUseAuthorization()
        locationManeger.startUpdatingLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))

        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func chooseLocation(gestureRecognizer:UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom:self.mapView)
            choosenLatitude = touchedCoordinates.latitude
            choosenLongitude = touchedCoordinates.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = nameField.text
            annotation.subtitle = commentField.text
            self.mapView.addAnnotation(annotation)
        }
        
    }
    
    // guncel lokasyonlari bir dizi icereinde veriyor.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //locations olarak bize donen dizinin ilk itemi mevcut konumuuz o yuzden, index 0 i secerek onu  icerisindeki koordinatlara ulasiyoruz.
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
       // 0.1 degeri kuculdukce zoom orani artiyor
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }

    @IBAction func clickedSaveButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        
    
        newPlace.setValue(nameField.text, forKey: "title")
        newPlace.setValue(commentField.text, forKey: "subtitle")
        newPlace.setValue(choosenLatitude, forKey: "latitude")
        newPlace.setValue(choosenLongitude, forKey: "longitude")
        newPlace.setValue(UUID(), forKey: "id")
        
        do{
            try context.save()
            print("success")
        } catch {
            print("error")
        }
        
    }
    
}

