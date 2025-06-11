//
//  TravelPlanMapViewController.swift
//  EST_Trip
//
//  Created by kangho lee on 6/11/25.
//

import UIKit
import GoogleMaps
import GooglePlaces

/// Manages the configuration options view for the demo app.
class TravelPlanMapViewController: UIViewController {
    
    let travel = Travel.makeJejuTrip()
    
    var schedules: [Schedule] {
        travel.schedules
    }
    
    var firstPlace: Place? {
        schedules.first?.places.first
    }
    
    // MARK: - Properties
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let firstPlace {
            let camera = GMSCameraPosition.camera(withLatitude: firstPlace.latitude, longitude: firstPlace.longittude, zoom: 14)
            mapView.camera = camera
        }
        
        let markers = travel.schedules.flatMap { $0.places }
            .map(GMSMarker.make(from:))
        
        markers.forEach { marker in
            marker.map = mapView
        }
    }
}
