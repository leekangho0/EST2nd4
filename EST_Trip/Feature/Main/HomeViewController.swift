//
//  HomeViewController.swift
//  EST_Trip
//
//  Created by 정소이 on 6/11/25.
//

import UIKit

struct Trip {
    let id: UUID
    let title: String
    let startDate: Date
    let endDate: Date
}

class MainViewController: UIViewController {
    var trips: [Trip] = []
    // 📌 dday를 기준으로 dday >=0 이면 futureTripTitle, dday < 0 이면 pastTripTitle에 넣어주기
    var futureTrip: [Trip] = []
    var pastTrip: [Trip] = []
    //    var currentTrip: [Trip] = []

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var futureTripButton: UIButton!
    @IBOutlet weak var pastTripButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        trips = futureTrip

        header.backgroundColor = UIColor.dolHareubangLightGray.withAlphaComponent(0.2)

        if let savedName = UserDefaults.standard.string(forKey: "username") {
            userName.text = savedName
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 코어데이터에서 데이터 로드
        fetchTrips()
        loadTrips()
    }

    @IBAction func editNameButton(_ sender: Any) {
        guard let editUsernameVC = self.storyboard?.instantiateViewController(withIdentifier: "EditUsernameViewController") as? EditUsernameViewController else { return }

        editUsernameVC.userNameEntered = { [weak self] text in
            guard let self = self else { return }
            self.userName.text = text
            UserDefaults.standard.set(text, forKey: "username")
        }

        if userName.text == "사용자명" {
            editUsernameVC.currentName = ""
        } else {
            editUsernameVC.currentName = userName.text
        }

        editUsernameVC.modalPresentationStyle = .overFullScreen
        editUsernameVC.modalTransitionStyle = .crossDissolve
        self.present(editUsernameVC, animated: true)
    }

    @IBAction func plusButtonTapped(_ sender: Any) {
        let vc = FeatureFactory.makeCalendar()
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func menuButtonTapped(_ sender: UIButton) {
        if sender == futureTripButton {
            trips = futureTrip
            futureTripButton.tintColor = .label
            pastTripButton.tintColor = .dolHareubangGray
        } else {
            trips = pastTrip
            futureTripButton.tintColor = .dolHareubangGray
            pastTripButton.tintColor = .label
        }

        tableView.reloadData()
    }

    func loadTrips() {
        futureTrip = []
        pastTrip = []

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
        return trips.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }

        let trip = trips[indexPath.row]

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

extension MainViewController {
    func fetchTrips() {
        let travelData = CoreDataManager.shared.fetch(TravelEntity.self)

        self.trips = travelData.compactMap { travel in
            let id = travel.id
            guard let title = travel.title,
                  let startDate = travel.startDate,
                  let endDate = travel.endDate else { return nil }
            return Trip(id: id, title: title, startDate: startDate, endDate: endDate)
        }
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let trip = trips[indexPath.row]
        //디버깅시 확인후 지워주세요!
        print("인덱스\(indexPath), id:",trip.id)

        let vc = FeatureFactory.makePlanner()

        //필요시 이동할 뷰컨에 travelID를 받을 변수 하나 선언해주세요
        //EX) vc.travelID = trip.id

        navigationController?.pushViewController(vc, animated: true)
    }
}
