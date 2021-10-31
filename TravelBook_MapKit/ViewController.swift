//
//  ViewController.swift
//  TravelBook_MapKit
//
//  Created by ysf on 27.10.21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManeger = CLLocationManager()
    
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
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = "New Annotation"
            annotation.subtitle = "Travel Book"
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


}

