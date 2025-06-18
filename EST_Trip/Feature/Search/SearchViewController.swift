//
//  SearchViewController.swift
//  EST_Trip
//
//  Created by 권도현 on 6/9/25.
//


import UIKit
import GooglePlaces
import GooglePlacesSwift



class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tourButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var cafeButton: UIButton!
    @IBOutlet weak var searchBar: UITextField!

    weak var delegate: SearchViewControllerDelegate?
    
    var viewModel: SearchViewModel!

    private lazy var autocompleteDataSource: GMSAutocompleteTableDataSource = {
        let source = GMSAutocompleteTableDataSource()
        let filter = GMSAutocompleteFilter()
        filter.countries = ["KR"]
        filter.regionCode = "KR"
        filter.locationRestriction = GMSPlaceCircularLocationOption(Jeju.northEast.coordinate2d, 600)
        source.autocompleteFilter = filter
        source.delegate = self
        return source
    }()

    private lazy var resultsController: UITableViewController = {
        let controller = UITableViewController(style: .plain)
        controller.tableView.delegate = autocompleteDataSource
        controller.tableView.dataSource = autocompleteDataSource
        controller.view.alpha = 0
        return controller
    }()

    private let emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "검색 결과가 없어요."
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let subtitleLabel = UILabel()
        subtitleLabel.text = "정확하게 다시 입력해주세요."
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),

            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),

            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
        ])

        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toggleCategory(.travel, tourButton)
    }
    
    private func bind() {
        tableView.dataSource = self
        tableView.delegate = self

        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        
        viewModel.onReload = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "에러", message: error.localizedDescription, preferredStyle: .alert)
                self?.present(alert, animated: true) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        alert.dismiss(animated: true)
                    }
                }
            }
        }
        
        viewModel.onPlace = { [weak self] item in
            guard let self else { return }
            self.deliverPlace(item)
        }
    }
    
    private func deliverPlace(_ item: GooglePlaceDTO) {
        DispatchQueue.main.async { [self] in
            self.delegate?.searchViewController(self, place: item, for: self.viewModel.section)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func layout() {
        setupSelectButtonAppearance()

        [tourButton, foodButton, cafeButton].forEach { button in
            button.backgroundColor = .systemGray5
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = button.frame.height / 2
            button.layer.masksToBounds = true
        }

        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        embed()
    }
    
    private func embed() {
        // 자동완성 결과 테이블 추가
        addChild(resultsController)
        view.addSubview(resultsController.view)
        resultsController.didMove(toParent: self)

        resultsController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultsController.view.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            resultsController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultsController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultsController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideAutocompleteResults()
        autocompleteDataSource.delegate = nil
        searchBar.delegate = nil
    }

    // MARK: Trait
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print("화면 방향 또는 사이즈 클래스가 변경됨")

        // iPad split view나 orientation 대응을 위한 UI 업데이트 필요 시 여기에 작성
        updateLayoutForCurrentTrait()
    }

    private func updateLayoutForCurrentTrait() {
        if traitCollection.horizontalSizeClass == .regular {
            // iPad 모드 대응: 예를 들어 버튼 폰트 크기 늘리기 등
            [tourButton, foodButton, cafeButton].forEach { $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold) }
        } else {
            [tourButton, foodButton, cafeButton].forEach { $0.titleLabel?.font = .systemFont(ofSize: 14) }
        }
    }

    private func setupSelectButtonAppearance() {
        // 버튼 외형 공통 설정
    }

    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        switch sender {
        case tourButton:
            toggleCategory(.travel, sender)
        case foodButton:
            toggleCategory(.restaurant, sender)
        case cafeButton:
            toggleCategory(.cafe, sender)
        default:
            break
        }
    }

    private func toggleCategory(_ category: CategoryType, _ button: UIButton) {
        resetCategoryButtons()
        if viewModel.selectedCategory == category {
            viewModel.selectedCategory = nil
        } else {
            viewModel.selectedCategory = category
            selectButton(button: button)
            
            // category가 선택되면, 주변 검색으로 검색
            viewModel.loadByCategory()
        }
    }
    
    private func selectButton(button: UIButton) {
        var config = button.configuration ?? UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(named: "JejuOrange")
        config.baseForegroundColor = .white
        button.configuration = config
    }

    private func resetCategoryButtons() {
        let buttons = [tourButton, foodButton, cafeButton]
        buttons.forEach { btn in
            var config = btn?.configuration ?? UIButton.Configuration.filled()
            config.baseBackgroundColor = .systemGray5
            config.baseForegroundColor = .black
            btn?.configuration = config
        }
    }

    @objc private func searchTextChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        if text.trimmingCharacters(in: .whitespaces).isEmpty {
            hideAutocompleteResults()
        } else {
            autocompleteDataSource.sourceTextHasChanged(text)
            UIView.animate(withDuration: 0.3) {
                self.resultsController.view.alpha = 1
            }
        }
    }

    private func hideAutocompleteResults() {
        UIView.animate(withDuration: 0.3) {
            self.resultsController.view.alpha = 0
        }
        autocompleteDataSource.clearResults()
    }
}


extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! placeCell

        cell.configure(with: viewModel.item(for: indexPath))

        cell.onSelectTapped = { [weak self] in
            guard let self else { return }
            self.deliverPlace(viewModel.item(for: indexPath))
        }

        return cell
    }
}


extension SearchViewController: UITableViewDelegate {}

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.resultsController.view.alpha = 1
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        hideAutocompleteResults()
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        hideAutocompleteResults()
        return true
    }

    // 장소 검색
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        hideAutocompleteResults()
        
        if let text = textField.text, !text.isEmpty {
            viewModel.loadFromText(text: text.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        return true
    }
}

extension SearchViewController: GMSAutocompleteTableDataSourceDelegate {
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        print("✅ 선택된 장소: \(place.name ?? "이름 없음")")
        
        hideAutocompleteResults()
        searchBar.resignFirstResponder()

        var address = place.formattedAddress
        
        if let components = place.addressComponents {
            var city: String?
            var local: String?
            var dong: String?
            
            for component in components {
                if component.types.contains("administrative_area_level_1") {
                    city = component.shortName // 예: 서울특별시
                } else if component.types.contains("sublocality_level_2") {
                    dong = component.shortName // 예: 상봉동
                } else if component.types.contains("locality") {
                    local = component.shortName
                }
            }
            
            if let city = city, let dong = dong {
                address = "\(city) \(dong)"
            } else if let city = city, let local = local {
                address = "\(city) \(local)"
            }
        }
        
        let categoryType = CategoryType.from(placeTypes: place.types ?? [] )
        
        //TODO: 장소 선택시 Place 데이터 저장
        
        let placeDTO = PlaceDTO(
            id: UUID(),
            name: place.name,
            latitude: place.coordinate.latitude,
            longitude: place.coordinate.longitude,
            address: address,
            category: CategoryDTO(type: categoryType, name: categoryType.name)
        )
        
        /*
        if let id = place.id {
            viewModel.load(by: id)
        }*/
        
        DispatchQueue.main.async { [self] in
            self.delegate?.searchViewController(self, place: placeDTO, for: viewModel.section)
            self.navigationController?.popViewController(animated: true)
        }
    }

    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        print("❌ 자동완성 실패: \(error.localizedDescription)")
    }

    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        resultsController.tableView.reloadData()
    }

    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        resultsController.tableView.reloadData()
    }
}
