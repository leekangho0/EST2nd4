//
//  HomeViewController.swift
//  EST_Trip
//
//  Created by 정소이 on 6/11/25.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var header: UIView!

    @IBOutlet weak var futureTripButton: UIButton!
    @IBOutlet weak var pastTripButton: UIButton!

    @IBOutlet weak var tableView: UITableView!

    // 📌 앱을 들어가는 시간 기준으로 예정된 여행이거나 당일 여행이면 futureTripTitle, 과거 여행이면 pastTripTitle에 넣어주기?
    var futureTripTitle = ["7월 제주", "2025 8월 제주", "2025 9월 제주", "2025 10~11월 제주", "2025 겨울 내 생일 제주", "2025 겨울 2주살기 제주", "2025 겨울 한달살기 제주"]
    var pastTripTitle = ["2024 여름 제주", "2024 가을 제주", "2023 겨울 제주"]
    var currentTitle: [String] = []

    private let viewModel = CalendarViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        currentTitle = futureTripTitle
        tableView.dataSource = self

        header.backgroundColor = UIColor.dolHareubangLightGray.withAlphaComponent(0.2)
    }

    @IBAction func menuButtonTapped(_ sender: UIButton) {
        if sender == futureTripButton {
            currentTitle = futureTripTitle
            futureTripButton.tintColor = .label
            pastTripButton.tintColor = .dolHareubangGray
        } else {
            currentTitle = pastTripTitle
            futureTripButton.tintColor = .dolHareubangGray
            pastTripButton.tintColor = .label
        }

        tableView.reloadData()
    }
}

class CustomCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTitle.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }

        /// 캘린더에서 시작, 종료일 가져와 label에 띄어주기
//        func dateLabel() {
//            let travelDate = viewModel.travelDate
//            let formatter = DateFormatter()
//            formatter.dateFormat = "MM월.dd일"
//
//            if let start = travelDate.startDate, let end = travelDate.endDate {
//                let startText = formatter.string(from: start)
//                let endText = formatter.string(from: end)
//                let fullText = "\(startText) - \(endText)"
//
//                cell.dateLabel.text = "\(fullText)"
//            }
//        }

        cell.titleLabel.text = currentTitle[indexPath.row]
        cell.dateLabel.text = "07월 15일 - 07월 18일"
        cell.iconImageView.image = UIImage(systemName: "airplane")

        return cell
    }
}

