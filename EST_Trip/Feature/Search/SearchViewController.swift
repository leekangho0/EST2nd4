//
//  SearchViewController.swift
//  EST_Trip
//
//  Created by 권도현 on 6/9/25.
//

import UIKit

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
        searchBar.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)

        filteredPlaces = allPlaces
        setupSelectButtonAppearance()

        // 버튼 스타일
        [tourButton, foodButton, cafeButton].forEach { button in
            button.backgroundColor = .systemGray5
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = button.frame.height / 2
            button.layer.masksToBounds = true
        }

        // emptyView 추가
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupSelectButtonAppearance() {
        // 버튼 외형 공통 설정용
    }

    // 카테고리 버튼 토글
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
        filterPlaces()
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

    // 검색어 입력 처리
    @objc private func searchTextChanged(_ textField: UITextField) {
        filterPlaces()
    }

    // 카테고리 + 검색어 필터링 + emptyView 처리
    private func filterPlaces() {
        let searchText = searchBar.text?.lowercased() ?? ""

        filteredPlaces = allPlaces.filter { place in
            let matchesCategory = selectedCategory == nil || place.category == selectedCategory
            let matchesSearch = searchText.isEmpty || place.title.lowercased().contains(searchText)
            return matchesCategory && matchesSearch
        }

        if filteredPlaces.isEmpty {
            emptyView.isHidden = false
            tableView.isHidden = true
        } else {
            emptyView.isHidden = true
            tableView.isHidden = false
        }

        tableView.reloadData()
    }
}

// MARK: - 데이터소스
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
            // TODO: 선택 후 일정 화면으로 이동 구현
        }

        return cell
    }
}

// MARK: - 델리게이트
extension SearchViewController: UITableViewDelegate {
    // 필요시 구현
}
