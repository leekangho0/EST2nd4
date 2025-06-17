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
    
    var firstPlace: PlaceDTO? {
        schedules.first?.places.first
    }
    
    // MARK: - Properties
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 메소드 분리
        // ViewDIdload life cycle
        
        if let firstPlace {
            let camera = GMSCameraPosition.camera(withLatitude: firstPlace.latitude, longitude: firstPlace.longitude, zoom: 14)
            mapView.camera = camera
        }
        
        let places = travel.schedules.flatMap { $0.places }
        
        
        let markers = places.map(GMSMarker.make(from:))
        
        markers.forEach { marker in
            marker.map = mapView
        }
        
        // 경로 그리기
        let path = GMSMutablePath()
        for place in places {
            path.add(CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
        }

        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .systemBlue
        polyline.strokeWidth = 3.0
        polyline.map = mapView
    }
}
