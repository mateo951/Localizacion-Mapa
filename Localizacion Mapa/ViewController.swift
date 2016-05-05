//
//  ViewController.swift
//  Localizacion Mapa
//
//  Created by Mateo Villagomez on 1/30/16.
//  Copyright © 2016 Mateo Villgomez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    // Variables for getting location and covered distance
    var loc = CLLocation()
    var dist = 0.0
    // CLLocationManager
    let manejador = CLLocationManager()
    
    //Map Types Selection
    @IBAction func segmentedControlAction(sender: UISegmentedControl!) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            self.mapa.mapType = .Standard
        case 1:
            self.mapa.mapType = .Hybrid
        default:
            self.mapa.mapType = .Satellite
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Definiendo el manejador
        self.manejador.delegate = self
        self.manejador.desiredAccuracy = kCLLocationAccuracyBest
        self.manejador.distanceFilter = 50
        manejador.startUpdatingLocation()
        // Blue dot userLocaiton
        self.mapa.showsUserLocation = true
        
        // Dispositivo movil descontianuado
        if #available(iOS 8.0, *) {
            self.manejador.requestWhenInUseAuthorization()
        } else {
            // Fallback on earlier versions
        }
    }
    
    // Autorizacion del usuario - iOS 8 or newr
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // Dispositivo movil descontianuado
        if #available(iOS 8.0, *) {
            if status == .AuthorizedWhenInUse {
                manejador.startUpdatingLocation()
                mapa.showsUserLocation = true
            } else {
                manejador.stopUpdatingLocation()
                mapa.showsUserLocation = false
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("ERROR")
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        print(manager.location!)
        // Centrando el mapa en el usuario
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: center, span: span)
        mapa.setRegion(region, animated: true)
        
        if loc.coordinate.latitude == 0 {
            loc = manager.location!
        }else if loc.distanceFromLocation(manager.location!) > 50 {
            dist = dist + 50.0
            updatePositions(manager)
        }
    }
    
    func updatePositions(manager: CLLocationManager) {
        // Añadiendo pines
        loc = manager.location!
        let annottation = MKPointAnnotation()
        annottation.coordinate = loc.coordinate
        annottation.title = "Long: \(manager.location!.coordinate.longitude) - Lat: \(manager.location!.coordinate.latitude)"
        annottation.subtitle = "Distancia: \(round(dist))"
        mapa.addAnnotation(annottation)
    }
    
    @IBAction func resetButton(sender: AnyObject) {
        dist = 0.0
        mapa.removeAnnotations(mapa.annotations)
    }
    
}

