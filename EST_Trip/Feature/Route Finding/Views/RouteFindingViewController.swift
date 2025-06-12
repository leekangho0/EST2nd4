//
//  RouteFindingViewController.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/11/25.
//

import UIKit
import GoogleMaps

class RouteFindingViewController: UIViewController {
    
    @IBOutlet var mapContainerView: UIView!
    @IBOutlet weak var transportationCollectionView: UICollectionView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var startLocationField: UITextField!
    @IBOutlet weak var endLocationField: UITextField!
    
    @IBOutlet weak var iconImgeView: UIImageView!
    @IBOutlet weak var routeDetailContainerView: UIView!
    @IBOutlet weak var routeDetailContainerViewHeightConstraint: NSLayoutConstraint!
    
    private var mapView: GMSMapView!
    
    private var isLayoutSetupDone = false
    private var selectedTransport: Transport = .car
    
    private let locationManager = CLLocationManager()
    
    private lazy var detailVC: RouteDetailViewController? = {
        let storyboard = UIStoryboard(name: "RouteFinding", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: RouteDetailViewController.self)) as? RouteDetailViewController
        return vc
    }()
    
    var place: PlaceEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
//        setupMapView()
        embedRouteDetailVC()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupCurrentLocationButton()
        setupLayout()
        setupRouteDetailContainerViewHeight()
    }
    
    @IBAction func moveToCurrentLocation(_ sender: Any) {
        if let currentLocation = locationManager.location?.coordinate {
            let camera = GMSCameraPosition.camera(
                withLatitude: currentLocation.latitude,
                longitude: currentLocation.longitude,
                zoom: 15
            )
            mapView.animate(to: camera)
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func updateSelectedTransport(transport: Transport) {
        selectedTransport = transport
        detailVC?.selectedTransport = selectedTransport
    }
}

// MARK: - UI Setting
extension RouteFindingViewController {
    private func configure() {
        currentLocationButton.layer.shadowColor = UIColor.black.cgColor
        currentLocationButton.layer.shadowOpacity = 0.3
        currentLocationButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        currentLocationButton.layer.shadowRadius = 4
        
        startLocationField.textColor = .init(red: 217, green: 217, blue: 217)
        startLocationField.text = "현위치"
        
        endLocationField.text = place?.name ?? "우진해장국"
        
        transportationCollectionView.isScrollEnabled = false
        
        iconImgeView.transform = CGAffineTransform(rotationAngle: .pi / 2)
            
        locationManager.delegate = self
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
    }
    
    private func setupMapView() {
//        let camera = GMSCameraPosition.camera(withLatitude: 37.5665, longitude: 126.9780, zoom: 14.0)
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
        
        addChild(detailVC)
        routeDetailContainerView.addSubview(detailVC.view)

        detailVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailVC.view.topAnchor.constraint(equalTo: routeDetailContainerView.topAnchor),
            detailVC.view.leadingAnchor.constraint(equalTo: routeDetailContainerView.leadingAnchor),
            detailVC.view.trailingAnchor.constraint(equalTo: routeDetailContainerView.trailingAnchor),
            detailVC.view.bottomAnchor.constraint(equalTo: routeDetailContainerView.bottomAnchor),
        ])
        
        detailVC.didMove(toParent: self)
    }
    
    private func setupRouteDetailContainerViewHeight() {
        guard let detailVC else { return }
        
        routeDetailContainerViewHeightConstraint.constant = detailVC.viewHeight(forRouteInfoCount: 2)
    }
}

// MARK: - CLLocationManagerDelegate
extension RouteFindingViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedWhenInUse {
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
        
        transportationCollectionView.reloadData()
    }
}
