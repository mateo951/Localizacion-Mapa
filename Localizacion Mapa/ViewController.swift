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
    
    let manejador = CLLocationManager()
    
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
            } else {
                manejador.stopUpdatingLocation()
            }
        } else {
            // Fallback on earlier versions
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        // Localizacion Usuario
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: center, span: span)
        mapa.setRegion(region, animated: true)
        
        // Añadiendo pines
        let coordinate = locations[0].coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(coordinate.latitude) \(coordinate.longitude)"
        let distanciaPrincipal = CLLocation(latitude: (locations.first?.coordinate.latitude)!, longitude: (locations.last?.coordinate.longitude)!)
        let distanciaActual = CLLocation(latitude: (locations.last?.coordinate.latitude)!, longitude: (locations.last?.coordinate.longitude)!)
        //let distancia = CLLocation(latitude: (locations.last?.coordinate.latitude)!, longitude:(locations.last?.coordinate.longitude)!)
        //let distanciaReccorida = distancia.distanceFromLocation(locations.first!)
        annotation.subtitle = "\(distanciaPrincipal.distanceFromLocation(distanciaActual))"
        mapa.addAnnotation(annotation)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("ERROR")
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

