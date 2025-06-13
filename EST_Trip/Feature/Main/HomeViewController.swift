//
//  HomeViewController.swift
//  EST_Trip
//
//  Created by 정소이 on 6/11/25.
//

import UIKit

struct Trip {
    let title: String
    let startDate: Date
    let endDate: Date
}

class MainViewController: UIViewController {

    @IBOutlet weak var header: UIView!

    @IBOutlet weak var futureTripButton: UIButton!
    @IBOutlet weak var pastTripButton: UIButton!

    @IBOutlet weak var tableView: UITableView!

    let trips = [
        Trip(title: "6월", startDate: Date(year: 2025, month: 6, day: 13), endDate: Date(year: 2025, month: 6, day: 15)),
        Trip(title: "7월 여름휴가입니다아아아", startDate: Date(year: 2025, month: 7, day: 10), endDate: Date(year: 2025, month: 7, day: 12)),
        Trip(title: "4월 제주", startDate: Date(year: 2024, month: 4, day: 15), endDate: Date(year: 2024, month: 4, day: 20)),
        Trip(title: "8월 제주", startDate: Date(year: 2025, month: 8, day: 15), endDate: Date(year: 2025, month: 8, day: 23)),
        Trip(title: "9월 한달살기", startDate: Date(year: 2025, month: 9, day: 3), endDate: Date(year: 2025, month: 10, day: 2)),
        Trip(title: "겨울 제주", startDate: Date(year: 2024, month: 12, day: 15), endDate: Date(year: 2024, month: 12, day: 19))
    ]

    // 📌 dday를 기준으로 dday >=0 이면 futureTripTitle, dday < 0 이면 pastTripTitle에 넣어주기
    var futureTrip: [Trip] = []
    var pastTrip: [Trip] = []
    var currentTrip: [Trip] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTrips()

        tableView.dataSource = self

        currentTrip = futureTrip

        header.backgroundColor = UIColor.dolHareubangLightGray.withAlphaComponent(0.2)
    }

    @IBAction func plusButtonTapped(_ sender: Any) {
        let vc = FeatureFactory.makeCalendar()

        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func menuButtonTapped(_ sender: UIButton) {
        if sender == futureTripButton {
            currentTrip = futureTrip
            futureTripButton.tintColor = .label
            pastTripButton.tintColor = .dolHareubangGray
        } else {
            currentTrip = pastTrip
            futureTripButton.tintColor = .dolHareubangGray
            pastTripButton.tintColor = .label
        }

        tableView.reloadData()
    }

    func loadTrips() {
        for trip in trips {
            let dayDiff = trip.startDate.days(from: Date.today)

            if dayDiff >= 0 {
                futureTrip.append(trip)
            } else {
                pastTrip.append(trip)
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTrip.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }

        let trip = currentTrip[indexPath.row]

        func showDday() {
            let targetDate = trip.startDate // 📌 Schedule 메인에서 날짜 가져와 넣어주기
            let today = Date.today

            let dayDiff = targetDate.days(from: today)

            if dayDiff == 0 {
                cell.dDay.text = "D-Day"
            } else if dayDiff > 0 {
                cell.dDay.text = "D-\(dayDiff)"
            } else {
                cell.dDay.text = "D+\(abs(dayDiff))"
            }
        }

        showDday()

        cell.tripTitle.text = trip.title // 📌 Schedule 메인에서 일정 제목 가져와 넣어주기
        cell.tripDate.text = "\(trip.startDate.toString()) ~ \(trip.endDate.toString(format: "MM.dd"))" // 📌 Schedule 메인에서 날짜 가져와 넣어주기
        cell.tripImage.image = UIImage(systemName: "airplane")

        return cell
    }
}
