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

    // MARK: - Properties
    @IBOutlet weak var mapView: GMSMapView!
    private var bottomSheetVC: PlanSheetViewController!
    
    var viewModel: TravelPlanMapViewModel!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embed()
        setCamera(Jeju.northEast.coordinate2d)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        bottomSheetVC.days = viewModel.schedules
    }
  
    private func embed() {
        self.bottomSheetVC = FeatureFactory.makePlanMap()
        
        addChild(self.bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        
        // Sheet 높이 지정
        let height: CGFloat = 250
        let yPosition = view.bounds.height - height
        bottomSheetVC.view.frame = CGRect(x: 0, y: yPosition, width: view.bounds.width, height: height)
        
        self.bottomSheetVC.didMove(toParent: self)
        
        self.bottomSheetVC.delegate = self
    }
    
    private func drawPolyLine() {
        // 경로 그리기
        let (polyline, path) = viewModel.drawPolyLine()
        
        polyline.map = mapView
        
        // Camera Update Zoom out
        let mapBounds = GMSCoordinateBounds(path: path)
        let cameraUpdate = GMSCameraUpdate.fit(mapBounds)
        mapView.moveCamera(cameraUpdate)
    }
    
    private func setCamera(_ position: CLLocationCoordinate2D, zoom: Float = 10) {
        let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: zoom)
        mapView.animate(to: camera)
    }
}

extension TravelPlanMapViewController: PlanSheetDelegate {
    func sheet(_ view: PlanSheetViewController, didSelectDayAt item: ScheduleEntity) {
        print("day selected")
        
        drawMarker(item.orderedPlaces)
    }
    
    func sheet(_ view: PlanSheetViewController, didSelectPlaceAt item: PlaceEntity) {
        
        if let marker = viewModel.selectMarker(item) {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.25)
            setCamera(marker.position)
            mapView.selectedMarker = marker
            CATransaction.commit()
        }
    }
    
    private func drawMarker(_ item: [PlaceEntity]) {
        self.mapView.clear()
        
        viewModel.drawMarkers(item)
        
        viewModel.currentMarker.enumerated().forEach { index, marker in
            marker.map = self.mapView
            marker.icon = GMSMarker.createNumberedMarkerImage(number: index)
        }
        
        if let first = viewModel.currentMarker.first {
            setCamera(first.position)
        }
        
        drawPolyLine()
    }
}

extension TravelPlanMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
}
