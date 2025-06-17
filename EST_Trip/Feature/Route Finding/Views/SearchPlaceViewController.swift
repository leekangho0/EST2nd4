//
//  SearchPlaceViewController.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/16/25.
//

import UIKit
import GooglePlaces

class SearchPlaceViewController: UIViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    
    private lazy var autocompleteDataSource: GMSAutocompleteTableDataSource = {
        let source = GMSAutocompleteTableDataSource()
        source.delegate = self
        let filter = GMSAutocompleteFilter()
    
        filter.countries = ["KR"] // 국가 코드 지정
        filter.regionCode = "KR" // 검색 지역 한정
        
        source.autocompleteFilter = filter
        
        return source
    }()
    
    var onPlaceSelected: ((_ name: String, _ location: CLLocationCoordinate2D) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !searchController.isActive {
            searchController.isActive = true
            DispatchQueue.main.async {
                self.searchController.searchBar.becomeFirstResponder()
            }
        }
    }
    
    private func setupView() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "장소를 검색하세요"
        searchController.searchBar.tintColor = .label
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
        definesPresentationContext = true
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = autocompleteDataSource
        tableView.dataSource = autocompleteDataSource
    }
}

// MARK: - UISearchResultsUpdating
extension SearchPlaceViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else { return }
        autocompleteDataSource.sourceTextHasChanged(text)
    }
}

// MARK: - GMSAutocompleteTableDataSourceDelegate
extension SearchPlaceViewController: GMSAutocompleteTableDataSourceDelegate {
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        onPlaceSelected?(place.name ?? "-", place.coordinate)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        print("❌ 자동완성 실패: \(error.localizedDescription)")
    }
    
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        tableView.reloadData()
    }
    
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        tableView.reloadData()
    }
}
