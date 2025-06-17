//
//  ScheduleMainViewController.swift
//  JejuTripAppTutorial
//
//  Created by 고재현 on 6/8/25.
//

import UIKit

struct PlaceModel {
    let name: String
    let category: String
    let address: String
}

class ScheduleMainViewController: UIViewController {
    
    @IBOutlet var toggleButtons: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    private let sectionHeight: CGFloat = 80
    
    private var isEditMode = false
    
    @IBOutlet weak var titleLabel: UILabel!

    var schedulePlaces: [[PlaceModel]] = [[], [], []]
    var headerTitles: [String] = ["", "", ""]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapButton = UIBarButtonItem(
            image: UIImage(systemName: "map"),
            style: .plain,
            target: self,
            action: #selector(mapButtonTapped)
        )
        navigationItem.rightBarButtonItem = mapButton

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.isScrollEnabled = false
        
        tableView.showsVerticalScrollIndicator = false
        
        tableView.contentInsetAdjustmentBehavior = .never
        
        toggleButtons.forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
            button.layer.backgroundColor = UIColor(hex: "#D9D9D9", alpha: 0.6)?.cgColor
            button.setTitleColor(UIColor(hex: "#7E7E7E", alpha: 1.0), for: .normal)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc func mapButtonTapped() {
        let mapVC = FeatureFactory.makeMap()
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // scrollView contentSize 조정
//        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentView.frame.height)
        
        updateTableViewHeight()
    }
    
    @IBAction func toggleButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            //sender.backgroundColor = UIColor(hex: "#FFA24D", alpha: 1.0)
            sender.backgroundColor = UIColor(named: "JejuOrange")
            //sender.setTitleColor(.white, for: .selected)
            sender.tintColor = .white
        } else {
            sender.backgroundColor = UIColor(hex: "#D9D9D9", alpha: 0.6)
            sender.setTitleColor(UIColor(hex: "#7E7E7E", alpha: 1.0), for: .normal)
            sender.tintColor = UIColor(hex: "#7E7E7E", alpha: 1.0)
        }
    }
    
    func placePicker(for section: Int) {
        // TODO: 장소 선택 뷰 띄우기. 현재는 더미 데이터 삽입
        let newPlace = PlaceModel(name: "우진해장국", category: "맛집", address: "제주 제주시 서사로 11")
        schedulePlaces[section].append(newPlace)
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        tableView.layoutIfNeeded()
    }

    @objc func addPlaceButtonTapped(_ sender: UIButton) {
        let section = sender.tag
        let searchVC = FeatureFactory.makeSearch()
        searchVC.selectedSection = section
        searchVC.delegate = self  // 꼭 delegate 지정
        self.navigationController?.pushViewController(searchVC, animated: true)
        
        updateTableViewHeight()
    }
    
    @objc func editPlaceButtonTapped(_ sender: UIButton) {
        isEditMode.toggle()
        tableView.isEditing = isEditMode
        
//        tableView.reloadData()
    }
}

// MARK: - Set up UI
extension ScheduleMainViewController {
    private func updateTableViewHeight() {
        let defaultHeight = sectionHeight * CGFloat(schedulePlaces.count)
        
        tableViewHeightConstraint.constant = max(tableView.contentSize.height, defaultHeight)
    }

    @IBAction func editButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Schedule", bundle: nil)
            guard let editVC = storyboard.instantiateViewController(withIdentifier: "EditMenuViewController") as? EditMenuViewController else {
                return
            }

            // 새 제목이 입력되면 실행할 코드
            editVC.onTitleUpdate = { [weak self] newTitle in
                print("입력된 새 제목: \(newTitle)")
                self?.titleLabel.text = newTitle
            }

            // 모달 시트 스타일 설정
            if let sheet = editVC.sheetPresentationController {
                sheet.detents = [.custom { _ in 280 }]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.preferredCornerRadius = 20
            }

            present(editVC, animated: true)

    }
    

//    @objc func editButtonTapped(_ sender: UIButton) {
//        let section = sender.tag
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let editVC = storyboard.instantiateViewController(identifier: "EditMenuViewController") as? EditMenuViewController else { return }
//
//        // 여행 제목 변경 콜백 설정
//        editVC.onTitleUpdate = { [weak self] newTitle in
//            print("입력된 새 제목: \(newTitle)")
//            self?.titleLabel.setTitle(newTitle, for: .normal)
//        }
//
//        editVC.modalPresentationStyle = .pageSheet
//        if let sheet = editVC.sheetPresentationController {
//            sheet.detents = [.medium()]
//        }
//        present(editVC, animated: true)
//    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ScheduleMainViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return schedulePlaces.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedulePlaces[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ScheduleListCell.self), for: indexPath) as? ScheduleListCell else { return UITableViewCell() }
        
        let place = schedulePlaces[indexPath.section][indexPath.row]
        let isLastCell = indexPath.row == schedulePlaces[indexPath.section].count - 1
        cell.configure(indexPath: indexPath, isLastCell: isLastCell, place: place)
        
        // TODO: 셀 데이터 구성은 나중에 연결
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ScheduleListHeaderView()
        
        headerView.dayLabel.text = "Day \(section + 1)"
        headerView.dateLabel.text = "06/\(27 + section)"
        
        headerView.editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        headerView.editButton.setTitle(nil, for: .normal)
        
        headerView.addPlaceButton.setTitle("장소 추가", for: .normal)
        headerView.addMemoButton.setTitle("메모 추가", for: .normal)
        
        headerView.addPlaceButton.tag = section
        headerView.addPlaceButton.addTarget(self, action: #selector(addPlaceButtonTapped(_:)), for: .touchUpInside)
        headerView.editButton.addTarget(self, action: #selector(editPlaceButtonTapped(_:)), for: .touchUpInside)
        
        return headerView
    }
    
    // 편집
    // 편집 모드에서 셀 왼쪽에 여백 방지
    func tableView(_ tableView: UITableView,
                   shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        // 여기서 편집 로직 구현해주세요
        
        /* 예시 코드 입니다
        // 1. source 섹션의 배열에서 아이템 꺼내고 제거
        var fromSectionItems = schedulePlaces[sourceIndexPath.section]
        let movedItem = fromSectionItems.remove(at: sourceIndexPath.row)
        schedulePlaces[sourceIndexPath.section] = fromSectionItems

        // 2. destination 섹션의 배열에 아이템 삽입
        var toSectionItems = schedulePlaces[destinationIndexPath.section]
        toSectionItems.insert(movedItem, at: destinationIndexPath.row)
        schedulePlaces[destinationIndexPath.section] = toSectionItems
         */
    }
    
    // 삭제
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 여기서 삭제 로직 구현해주세요
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (_, _, completionHandler) in
            
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - UITableViewDelegate
extension ScheduleMainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width * 0.25
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 여기서 선택된 테이블뷰셀 정보를 넘겨주시면 됩니다
        let detailVC = FeatureFactory.makeScheduleDetail()
        detailVC.modalPresentationStyle = .pageSheet
        detailVC.delegate = self
        
        self.present(detailVC, animated: true)
    }
}

// MARK: - ScheduleDetailViewControllerDelegate
extension ScheduleMainViewController: ScheduleDetailViewControllerDelegate {
    func didTapRouteFindingButton() {
        let routeFindingVC = FeatureFactory.makeRoute()
        self.navigationController?.pushViewController(routeFindingVC, animated: true)
    }
}

extension ScheduleMainViewController: SearchViewControllerDelegate {
    func searchViewController(_ controller: SearchViewController, didSelectPlace place: Place, forSection section: Int) {
        
        let placeModel = PlaceModel(
            name: place.title,
            category: place.category.rawValue,  
            address: place.subtitle
        )
        schedulePlaces[section].append(placeModel)
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        updateTableViewHeight()
    }
}

