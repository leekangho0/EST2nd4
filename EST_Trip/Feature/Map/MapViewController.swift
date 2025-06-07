//
//  MapViewController.swift
//  EST_Trip
//
//  Created by kangho lee on 6/5/25.
//

import UIKit
import MapKit
import CoreLocation

class PathDrawingViewController: UIViewController {
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private var routeCoordinates: [CLLocationCoordinate2D] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupLocationManager()
    }
    
    private func setupMapView() {
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        displayPOIs()
    }
    
    private func displayPOIs() {
        // 예시 POI 좌표 (서울 시청, 종로, 경복궁)
        let pois: [(name: String, coordinate: CLLocationCoordinate2D)] = [
            ("서울시청", CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)),
            ("종로", CLLocationCoordinate2D(latitude: 37.5700, longitude: 126.9920)),
            ("경복궁", CLLocationCoordinate2D(latitude: 37.5760, longitude: 126.9850))
        ]
        
        var coordinates: [CLLocationCoordinate2D] = []
        
        for poi in pois {
            let annotation = MKPointAnnotation()
            annotation.title = poi.name
            annotation.coordinate = poi.coordinate
            mapView.addAnnotation(annotation)
            coordinates.append(poi.coordinate)
        }
        
        // POI 간 선 연결
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        
        // 지도 확대해서 모두 보기
        mapView.showAnnotations(mapView.annotations, animated: true)
        
        let region = MKCoordinateRegion(center: coordinates[0], latitudinalMeters: 3000, longitudinalMeters: 3000)
        mapView.setRegion(region, animated: true)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
    }
    
    private var currentPolyline: MKPolyline?
    
    private func updateRoute(with newLocation: CLLocation) {
        let coordinate = newLocation.coordinate
        routeCoordinates.append(coordinate)
        
        // 최소 두 좌표 이상 있어야 선 생성 가능
        guard routeCoordinates.count >= 2 else { return }
        
        // 기존 오버레이 제거
        if let currentPolyline = currentPolyline {
            mapView.removeOverlay(currentPolyline)
        }
        
        // 새 polyline 추가
        let newPolyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
        currentPolyline = newPolyline
        mapView.addOverlay(newPolyline)
        
        // 중심 좌표 업데이트
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
    }
    
}

extension PathDrawingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        updateRoute(with: latestLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

extension PathDrawingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer()
    }
}
