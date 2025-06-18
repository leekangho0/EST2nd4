//
//  RouteFindingViewController.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/11/25.
//

import UIKit
import GoogleMaps

class RouteFindingViewController: UIViewController {
    
    struct Place {
        var name: String
        var location: CLLocationCoordinate2D
    }
    
    @IBOutlet weak var routeInfoHeaderView: UIView!
    @IBOutlet var mapContainerView: UIView!
    @IBOutlet weak var mapContainerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var transportationCollectionView: UICollectionView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var startLocationField: UITextField!
    @IBOutlet weak var endLocationField: UITextField!
    
    @IBOutlet weak var iconImgeView: UIImageView!
    @IBOutlet weak var routeDetailContainerView: UIView!
    @IBOutlet weak var routeDetailContainerViewHeightConstraint: NSLayoutConstraint!
    
    private var mapView: GMSMapView!
    private var startMarker: GMSMarker?
    private var endMarker: GMSMarker?
    private var polylines = [GMSPolyline]()
    
    private var isMapBottomInit = false
    
    private let locationManager = CLLocationManager()
    private var hasUpdatedRoute = false
    
    private let routeFindingVM = RouteFindingViewModel()
    
    private var selectedTransport: Transport = .car
    
    let jejuAirportLocation = CLLocationCoordinate2D(latitude:33.507251, longitude: 126.493223)
    
    private lazy var detailVC: RouteDetailViewController? = {
        let storyboard = UIStoryboard(name: "RouteFinding", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: RouteDetailViewController.self)) as? RouteDetailViewController
        vc?.dragDelegate = self
        vc?.delegate = self
        
        return vc
    }()
    
    var place: PlaceEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupMapView()
        embedRouteDetailVC()
        checkAuthorization()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupCurrentLocationButton()
        setupLayout()
    }
    
    @IBAction func moveToCurrentLocation(_ sender: Any) {
        if let currentLocation = locationManager.location?.coordinate {
            let camera = GMSCameraPosition.camera(
                withLatitude: jejuAirportLocation.latitude,
                longitude: jejuAirportLocation.longitude,
                zoom: 15
            )
            mapView.animate(to: camera)
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func swapLocations(_ sender: Any) {
        routeFindingVM.swapLocations()
        
        let startLocationName = startLocationField.text
        let endLocationName = endLocationField.text
        
        startLocationField.text = endLocationName
        endLocationField.text = startLocationName
        
        startLocationField.textColor = textColor(text: startLocationField.text)
        endLocationField.textColor = textColor(text: endLocationField.text)
        
        fetchRoutes()
    }
    
    private func updateSelectedTransport(transport: Transport) {
        selectedTransport = transport
        detailVC?.selectedTransport = selectedTransport
    }
        
    private func updateRouteInfos() {
        self.detailVC?.routeInfos = self.routeFindingVM.routeInfos
        
        DispatchQueue.main.async {
            self.setupRouteDetailContainerViewHeight()
        }
    }
    
    private func updateWarningRouteInfo(_ localizedDescription: String) {
        self.detailVC?.warningMessage = localizedDescription
        self.detailVC?.routeInfos = [RouteInfo(duration: 0, distance: 0)]
        
        DispatchQueue.main.async {
            self.setupRouteDetailContainerViewHeight()
        }
    }
}

// MARK: - UI Setting
extension RouteFindingViewController {
    private func configure() {
        currentLocationButton.layer.shadowColor = UIColor.label.cgColor
        currentLocationButton.layer.shadowOpacity = 0.3
        currentLocationButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        currentLocationButton.layer.shadowRadius = 4
        
        startLocationField.text = "현위치"
        startLocationField.textColor = textColor(text: startLocationField.text)
        
        endLocationField.text = place?.name ?? "-"
        
        transportationCollectionView.isScrollEnabled = false
        
        iconImgeView.transform = CGAffineTransform(rotationAngle: .pi / 2)
        
        locationManager.delegate = self
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
    }
    
    private func textColor(text: String?) -> UIColor {
        if text == "현위치" {
            return .init(red: 217, green: 217, blue: 217)
        } else {
            return .label
        }
    }
    
    private func setupMapView() {
        let options = GMSMapViewOptions()
        options.frame = mapContainerView.bounds
        
        mapView = GMSMapView(options: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mapView.isMyLocationEnabled = true
        
        mapContainerView.addSubview(mapView)
    }
    
    private func setupCurrentLocationButton() {
        currentLocationButton.layer.cornerRadius = currentLocationButton.frame.size.height / 2
    }
    
    private func setupLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let transportCount = CGFloat(Transport.allCases.count)
        let cellSpacing: CGFloat = 10
        // collectionView 전체 너비에서 아이템 사이 간격(cellSpacing)을 제외한 후,
        // 표시할 셀 개수(transportCount)로 나누어 셀 너비를 계산
        let cellWidth: CGFloat = (transportationCollectionView.frame.size.width - (cellSpacing * (transportCount - 1))) / transportCount
        layout.itemSize = CGSize(
            width: cellWidth,
            height: transportationCollectionView.frame.size.height
        )
        layout.minimumLineSpacing = cellSpacing
        
        transportationCollectionView.collectionViewLayout = layout
    }
    
    private func embedRouteDetailVC() {
        guard let detailVC else { return }
        
        let navController = UINavigationController(rootViewController: detailVC)
        
        addChild(navController)
        
        navController.view.translatesAutoresizingMaskIntoConstraints = false
        routeDetailContainerView.addSubview(navController.view)
        
        NSLayoutConstraint.activate([
            navController.view.topAnchor.constraint(equalTo: routeDetailContainerView.topAnchor),
            navController.view.bottomAnchor.constraint(equalTo: routeDetailContainerView.bottomAnchor),
            navController.view.leadingAnchor.constraint(equalTo: routeDetailContainerView.leadingAnchor),
            navController.view.trailingAnchor.constraint(equalTo: routeDetailContainerView.trailingAnchor)
        ])
        
        navController.didMove(toParent: self)
        
        detailVC.didMove(toParent: self)
    }
    
    private func setupRouteDetailContainerViewHeight() {
        guard let detailVC else { return }
        
        routeDetailContainerViewHeightConstraint.constant = detailVC.viewHeight()
        if !isMapBottomInit {
            mapContainerViewBottomConstraint.constant = routeDetailContainerViewHeightConstraint.constant
            isMapBottomInit = true
        }
    }
    
    private func routeDetailContainerViewMinHeight() -> CGFloat {
        guard let detailVC else { return 0 }
        
        return detailVC.viewHeight()
    }
}

// MARK: - Fetch Datas
extension RouteFindingViewController {
    private func fetchRoutes() {
        switch selectedTransport {
        case .car:
            routeFindingVM.fetchDrivingRoute { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success:
                    self.updateRouteInfos()
                    self.drawRouteFromCoordinates(
                        routeCoordinates: self.routeFindingVM.locations
                    )
                case .failure(let error):
                    self.updateWarningRouteInfo(error.message)
                }
            }
        case .transit:
            routeFindingVM.fetchTransitRoute { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success:
                    self.updateRouteInfos()
                    self.drawRouteFromPolylines(
                        routes: self.routeFindingVM.routes(index: 0)
                    )
                case .failure(let error):
                    self.updateWarningRouteInfo(error.message)
                }
            }
        case .walk:
            routeFindingVM.fetchPedestrianRoute { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success:
                    self.updateRouteInfos()
                    self.drawRouteFromCoordinates(
                        routeCoordinates: self.routeFindingVM.locations
                    )
                case .failure(let error):
                    self.updateWarningRouteInfo(error.message)
                }
            }
        }
    }
}

// MARK: - 경로 그리기
extension RouteFindingViewController {
    private func drawRouteFromCoordinates(routeCoordinates: [CLLocationCoordinate2D]) {
        DispatchQueue.main.async {
            self.resetMapView()
            
            let path = GMSMutablePath()
            for coordinate in routeCoordinates {
                path.add(coordinate)
            }
            
            let polyline = GMSPolyline(path: path)
            
            polyline.strokeWidth = 5.0 // 선의 두께 (포인트 단위)
            polyline.strokeColor = .jejuOrange // 선의 색상
            polyline.geodesic = true // 지오데식 선 (지구의 곡률을 따라 가장 짧은 경로)
            
            // 폴리라인을 지도에 추가
            polyline.map = self.mapView
            
            self.polylines.append(polyline)
            
            // 경로의 시작점과 끝점에 마커 추가
            if let startCoordinate = routeCoordinates.first {
                self.startMarker = GMSMarker(position: startCoordinate)
                self.startMarker?.title = "출발지"
                self.startMarker?.icon = GMSMarker.markerImage(with: .hallasanGreen)
                self.startMarker?.map = self.mapView
            }
            
            if let endCoordinate = routeCoordinates.last {
                self.endMarker = GMSMarker(position: endCoordinate)
                self.endMarker?.title = "도착지"
                self.endMarker?.icon = GMSMarker.markerImage(with: .red)
                self.endMarker?.map = self.mapView
            }
            
            // 경로 전체가 보이도록 카메라 이동
            // 모든 경로 좌표를 포함하는 GMSCoordinateBounds 생성
            let bounds = GMSCoordinateBounds(path: path)
            let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 50.0) // 패딩 추가
            
            self.mapView?.animate(with: cameraUpdate)
        }
    }
    
    private func drawRouteFromPolylines(routes: [RouteInfo.Route]) {
        DispatchQueue.main.async {
            self.resetMapView()
            
            var bounds: GMSCoordinateBounds?
            
            for route in routes {
                if let encodedPolyline = route.polyline,
                   let path = GMSPath(fromEncodedPath: encodedPolyline) {
                    
                    let polyline = GMSPolyline(path: path)
                    polyline.geodesic = true
                    
                    if route.mode == .walk {
                        polyline.strokeWidth = 4.0
                        
                        let dashedLineStyles = [
                            GMSStrokeStyle.solidColor(UIColor.dolHareubangGray), // 실제 선의 색상
                            GMSStrokeStyle.solidColor(UIColor.clear) // 빈 공간 (투명)
                        ]
                        
                        let lengths: [NSNumber] = [15, 10] // 10포인트 선, 5포인트 공백 반복
                        
                        polyline.spans = GMSStyleSpans(polyline.path!, dashedLineStyles, lengths, .geodesic)
                    } else {
                        polyline.strokeWidth = 5.0
                        polyline.strokeColor = .jejuOrange
                    }
                    
                    polyline.map = self.mapView
                    self.polylines.append(polyline)
                    
                    let pathBounds = GMSCoordinateBounds(path: path)
                    if let currentBounds = bounds {
                        bounds = currentBounds.includingBounds(pathBounds)
                    } else {
                        bounds = pathBounds
                    }
                }
            }
            
            if let startCoordinate = routes.first?.location {
                self.startMarker = GMSMarker(position: startCoordinate)
                self.startMarker?.title = "출발지"
                self.startMarker?.icon = GMSMarker.markerImage(with: .hallasanGreen)
                self.startMarker?.map = self.mapView
            }
            
            if let endCoordinate = routes.last?.location {
                self.endMarker = GMSMarker(position: endCoordinate)
                self.endMarker?.title = "도착지"
                self.endMarker?.icon = GMSMarker.markerImage(with: .red)
                self.endMarker?.map = self.mapView
            }
            
            if let bounds = bounds {
                let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
                self.mapView.animate(with: cameraUpdate)
            }
        }
    }
    
    private func resetMapView() {
        startMarker?.map = nil
        endMarker?.map = nil
        polylines.forEach {
            $0.map = nil
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension RouteFindingViewController: CLLocationManagerDelegate {
    func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        let error = error as NSError
        guard error.code != CLError.Code.locationUnknown.rawValue else { return }
        print("❌ \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !hasUpdatedRoute,
              let currentLocation = locations.last?.coordinate,
              let place = place else { return }
        
        routeFindingVM.updateLocation(jejuAirportLocation, for: .start)
        routeFindingVM.updateLocation(
                CLLocationCoordinate2D(
                    latitude: place.latitude,
                    longitude: place.longitude
                ),
                for: .end
            )
        fetchRoutes()
        
        hasUpdatedRoute = true
    }
}

// MARK: - UICollectionViewDataSource
extension RouteFindingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Transport.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TransportationCollectionViewCell.self), for: indexPath) as? TransportationCollectionViewCell else { return UICollectionViewCell() }
        
        let transport = Transport.allCases[indexPath.item]
        
        cell.configure(
            imageName: transport.image,
            isSelected: selectedTransport == transport
        )
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RouteFindingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateSelectedTransport(transport: Transport.allCases[indexPath.item])
        fetchRoutes()
        transportationCollectionView.reloadData()
        
        NotificationCenter.default.post(name: .didUpdateTransport, object: nil)
    }
}

// MARK: - DraggableHeaderViewDelegate
extension RouteFindingViewController: DraggableHeaderViewDelegate {
    func draggableHeaderView(_ headerView: UIView, gesture: UIPanGestureRecognizer) {
        let translationY = gesture.translation(in: headerView).y
        let threshold: CGFloat = 50
        let topSpacing: CGFloat = 10
        
        let headerBottomY = routeInfoHeaderView.frame.maxY
        let containerTopY = routeDetailContainerView.frame.minY
        let containerBottomY = routeDetailContainerView.frame.maxY
        
        let maxHeight = containerBottomY - headerBottomY - topSpacing
        let minHeight = routeDetailContainerViewMinHeight()
        
        switch gesture.state {
        case .changed:
            let newHeight = routeDetailContainerViewHeightConstraint.constant - translationY
            if newHeight <= maxHeight && newHeight >= minHeight {
                routeDetailContainerViewHeightConstraint.constant = newHeight
            }
        case .ended:
            if translationY < -threshold {
                let heightDifference = containerTopY - headerBottomY - topSpacing
                routeDetailContainerViewHeightConstraint.constant += heightDifference
            } else {
                setupRouteDetailContainerViewHeight()
            }
        default:
            break
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextFieldDelegate
extension RouteFindingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let searchPlaceVC = SearchPlaceViewController()
        searchPlaceVC.onPlaceSelected = { [weak self] name, location in
            guard let self else { return }
            
            DispatchQueue.main.async {
                textField.text = name
                textField.textColor = .label
            }
            
            switch textField {
            case self.startLocationField:
                self.routeFindingVM.updateLocation(location, for: .start)
            case self.endLocationField:
                self.routeFindingVM.updateLocation(location, for: .end)
            default:
                break
            }
            
            fetchRoutes()
        }
        
        self.navigationController?.pushViewController(searchPlaceVC, animated: true)
    }
}

// MARK: - RouteDetailViewControllerDelegate
extension RouteFindingViewController: RouteDetailViewControllerDelegate {
    func routeDetailViewController(didSelectCellAt index: Int) {
        drawRouteFromPolylines(
            routes: routeFindingVM.routes(index: index)
        )
    }
}
