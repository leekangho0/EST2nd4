//
//  TestMapViewController.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/7/25.
//

import UIKit
import GoogleMaps

class TestMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition(latitude: 1.285, longitude: 103.848, zoom: 12)
        options.frame = self.view.bounds;

        let mapView = GMSMapView(options:options)
        self.view = mapView
    }
}
