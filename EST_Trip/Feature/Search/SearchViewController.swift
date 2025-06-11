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

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)

        filteredPlaces = allPlaces
        setupSelectButtonAppearance()
            
            // 카테고리 버튼 기본 색상 지정
        [tourButton, foodButton, cafeButton].forEach { button in
            button.backgroundColor = .systemGray5
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = button.frame.height / 2
            button.layer.masksToBounds = true
        }
    }

    private func setupSelectButtonAppearance() {
        // "선택" 버튼 색상은 셀에서 처리되지만,
        // 예시로 여기에 공통 스타일 설정 로직 두면 좋아!
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
            config?.baseForegroundColor = .white // 버튼 텍스트 색 흰색
            button.configuration = config
        }
    }

    private func resetCategoryButtons() {
        let buttons = [tourButton, foodButton, cafeButton]
        buttons.forEach { btn in
            var config = btn?.configuration
            config?.baseBackgroundColor = .systemGray5
            config?.baseForegroundColor = .black // 버튼 텍스트 색 검정
            btn?.configuration = config
        }
    }


    // 검색어 입력 처리
    @objc private func searchTextChanged(_ textField: UITextField) {
        filterPlaces()
    }

    // 카테고리 + 검색어 필터링 로직
    private func filterPlaces() {
        let searchText = searchBar.text?.lowercased() ?? ""

        filteredPlaces = allPlaces.filter { place in
            let matchesCategory = selectedCategory == nil || place.category == selectedCategory
            let matchesSearch = searchText.isEmpty || place.title.lowercased().contains(searchText)
            return matchesCategory && matchesSearch
        }
        tableView.reloadData()
    }
}

// 데이터소스
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
            //TODO: 선택버튼 눌렀을때, 일정리스트 메인화면으로 넘어가기 구현하기
        }
        return cell
    }
}

// 델리게이트
extension SearchViewController: UITableViewDelegate {
    // 필요시 구현해놓기
}
