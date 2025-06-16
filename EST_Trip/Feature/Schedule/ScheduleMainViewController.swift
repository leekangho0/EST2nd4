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

    var schedulePlaces: [[PlaceModel]] = [[], [], []]

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

        tableView.isScrollEnabled = true

        tableView.showsVerticalScrollIndicator = false

        tableView.contentInsetAdjustmentBehavior = .never

        toggleButtons.forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
            button.layer.backgroundColor = UIColor(hex: "#D9D9D9", alpha: 0.6).cgColor
            button.setTitleColor(UIColor(hex: "#7E7E7E", alpha: 1.0), for: .normal)
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150

    }

    @objc func mapButtonTapped() {
        
    }

    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

            // scrollView contentSize 조정
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentView.frame.height)
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
            placePicker(for: section)
        }

}

extension ScheduleMainViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return schedulePlaces.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedulePlaces[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleListCell", for: indexPath) as? ScheduleListCell else {
            return UITableViewCell()
        }

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

        return headerView
    }

        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 80
        }

        func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
}


extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
