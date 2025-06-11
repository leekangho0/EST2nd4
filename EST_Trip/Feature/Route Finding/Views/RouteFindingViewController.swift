//
//  RouteFindingViewController.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/11/25.
//

import UIKit
import GoogleMaps

class RouteFindingViewController: UIViewController {
    
    enum Transport: Int, CaseIterable {
        case car, transit, walk
        
        var image: String {
            switch self {
            case .car:
                return "car.fill"
            case .transit:
                return "bus.fill"
            case .walk:
                return "figure.walk"
            }
        }
    }
    
    @IBOutlet var mapContainerView: UIView!
    @IBOutlet weak var transportationCollectionView: UICollectionView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var startLocationField: UITextField!
    @IBOutlet weak var endLocationField: UITextField!
    
    @IBOutlet weak var iconImgeView: UIImageView!
    
    private var mapView: GMSMapView!
    
    private var isLayoutSetupDone = false
    private var selectedTransport: Transport = .car
    
    private let locationManager = CLLocationManager()
    
    var place: PlaceEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupMapView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupCurrentLocationButton()
        setupLayout()
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
        selectedTransport = Transport.allCases[indexPath.item]
        
        transportationCollectionView.reloadData()
    }
}
