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
        locationManeger.requestWhenInUseAuthorization()
        locationManeger.startUpdatingLocation()
        
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

