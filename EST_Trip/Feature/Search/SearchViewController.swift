//
//  SearchViewController.swift
//  EST_Trip
//
//  Created by 권도현 on 6/9/25.
//

import UIKit
import GooglePlaces

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tourButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var cafeButton: UIButton!
    @IBOutlet weak var searchBar: UITextField!

    var allPlaces: [Place] = [
        Place(imageName: "beach", title: "협재 해수욕장", subtitle: "관광 · 제주 제주시 협재리", category: .관광),
        Place(imageName: "mountain", title: "한라산", subtitle: "관광 · 제주 제주시", category: .관광),
        Place(imageName: "restaurant", title: "흑돼지 맛집", subtitle: "맛집 · 제주 제주시", category: .맛집),
        Place(imageName: "cafe", title: "예쁜카페", subtitle: "카페 · 제주 제주시", category: .카페)
    ]

    var filteredPlaces: [Place] = []
    var selectedCategory: Category?

    private lazy var autocompleteDataSource: GMSAutocompleteTableDataSource = {
        let source = GMSAutocompleteTableDataSource()
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

        tableView.dataSource = self
        tableView.delegate = self

        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)

        filteredPlaces = allPlaces
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

        // 자동완성 결과 테이블 뷰 설정
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

    private func setupSelectButtonAppearance() {
        // 버튼 공통 외형 설정
    }

    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        switch sender {
        case tourButton:
            toggleCategory(.관광, sender)
        case foodButton:
            toggleCategory(.맛집, sender)
        case cafeButton:
            toggleCategory(.카페, sender)
        default:
            break
        }
        filterPlaces(allPlaces)
    }

    private func toggleCategory(_ category: Category, _ button: UIButton) {
        if selectedCategory == category {
            selectedCategory = nil
            resetCategoryButtons()
        } else {
            selectedCategory = category
            resetCategoryButtons()

            var config = button.configuration
            config?.baseBackgroundColor = UIColor(named: "JejuOrange")
            config?.baseForegroundColor = .white
            button.configuration = config
        }
    }

    private func resetCategoryButtons() {
        let buttons = [tourButton, foodButton, cafeButton]
        buttons.forEach { btn in
            var config = btn?.configuration
            config?.baseBackgroundColor = .systemGray5
            config?.baseForegroundColor = .black
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

    private func filterPlaces(_ place: [Place]) {
        let searchText = searchBar.text?.lowercased() ?? ""

        filteredPlaces = allPlaces.filter { place in
            let matchesCategory = selectedCategory == nil || place.category == selectedCategory
            let matchesSearch = searchText.isEmpty || place.title.lowercased().contains(searchText)
            return matchesCategory && matchesSearch
        }

        emptyView.isHidden = !filteredPlaces.isEmpty
        tableView.isHidden = filteredPlaces.isEmpty
        tableView.reloadData()
    }
}


extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlaces.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as? placeCell else {
            return UITableViewCell()
        }

        let place = filteredPlaces[indexPath.row]
        cell.configure(with: place)

        cell.onSelectTapped = {
            print("선택된 장소: \(place.title)")
        }

        return cell
    }
}


extension SearchViewController: UITableViewDelegate {}


extension SearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        hideAutocompleteResults()
        return true
    }
}


extension SearchViewController: GMSAutocompleteTableDataSourceDelegate {
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        print("✅ 선택된 장소: \(place.name ?? "이름 없음")")
        hideAutocompleteResults()
        searchBar.resignFirstResponder()
        searchBar.text = place.name

        // 선택된 장소 저장 또는 화면 갱신
        LocalPlaceService.shared.addPlace(place: place)
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
