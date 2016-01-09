//
//  ViewController.swift
//  GenderViolence
//
//  Created by Mauricio Oliveira on 12/28/15.
//  Copyright (c) 2015 Mauricio Oliveira. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        centerMapOnLocation()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation() {
        
        let currentLocation = CLLocation(latitude: -8.055474, longitude: -34.951216)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        let currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
    }
    
    @IBAction func onRefreshClick(sender: AnyObject) {
        
        centerMapOnLocation()
        
    }


}

