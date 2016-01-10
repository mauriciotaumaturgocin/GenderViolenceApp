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
    
    var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as String
        databasePath = (docsDir as NSString).stringByAppendingPathComponent("reports.sqlite")
        
        let currentLocation = CLLocation(latitude: -8.055474, longitude: -34.951216)
        centerMapOnLocation(currentLocation)
        
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
    
    func centerMapOnLocation(location : CLLocation) {

        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        let currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
    }
    
    func plotPin(address : String)
    {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error ---->", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.centerMapOnLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude))
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
            }
        })

    }
    
    override func viewWillAppear(animated: Bool) {
        //Get all reports and insert pins.
        getAllReports()
    }
    
    @IBAction func onRefreshClick(sender: AnyObject) {
        
        let currentLocation = CLLocation(latitude: -8.055474, longitude: -34.951216)
        centerMapOnLocation(currentLocation)
        
    }
    
    //Returns zipcode, state, city and street from all reports
    func getAllReports()-> [ReportViolence]{
        
        var reports = [ReportViolence]()
        
        var status = ""
        let reportsDB = FMDatabase(path: databasePath as String)
        
        if reportsDB.open() {
            let querySQL = "SELECT ZIPCODE, STATE, CITY, STREET FROM REPORTS WHERE ZIPCODE != ''"
            
            let results:FMResultSet? = reportsDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            
            while results?.next() == true {
                var report = ReportViolence()
                report.zipCode = results!.stringForColumn("ZIPCODE")
                report.state = results!.stringForColumn("STATE")
                report.city = results!.stringForColumn("CITY")
                report.street = results!.stringForColumn("STREET")
                print(report.zipCode + "|" + report.state + "|" + report.city + "|" + report.street)
                status = "Record Found"
                reports.append(report)
                plotPin(report.street + ", " + report.state + ", " + "BRA")
            }

            print(status)
            reportsDB.close()
        } else {
            print("Error: \(reportsDB.lastErrorMessage())")
        }

        return reports;
        
    }


}

