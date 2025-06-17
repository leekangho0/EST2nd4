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

    // 더미 데이터
    //    let trips = [
    //        Trip(title: "6월", startDate: Date(year: 2025, month: 6, day: 13), endDate: Date(year: 2025, month: 6, day: 15)),
    //        Trip(title: "7월 여름휴가입니다아아아", startDate: Date(year: 2025, month: 7, day: 10), endDate: Date(year: 2025, month: 7, day: 12)),
    //        Trip(title: "4월 제주", startDate: Date(year: 2024, month: 4, day: 15), endDate: Date(year: 2024, month: 4, day: 20)),
    //        Trip(title: "8월 제주", startDate: Date(year: 2025, month: 8, day: 15), endDate: Date(year: 2025, month: 8, day: 23)),
    //        Trip(title: "9월 한달살기", startDate: Date(year: 2025, month: 9, day: 3), endDate: Date(year: 2025, month: 10, day: 2)),
    //        Trip(title: "겨울 제주", startDate: Date(year: 2024, month: 12, day: 15), endDate: Date(year: 2024, month: 12, day: 19))
    //    ]
    var trips: [Trip] = []


    // 📌 dday를 기준으로 dday >=0 이면 futureTripTitle, dday < 0 이면 pastTripTitle에 넣어주기
    var futureTrip: [Trip] = []
    var pastTrip: [Trip] = []
    var currentTrip: [Trip] = []

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var futureTripButton: UIButton!
    @IBOutlet weak var pastTripButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self

        // 코어데이터에서 데이터 로드
		fetchTrips()
        // futureTrip/ pastTrip 나누는 메서드로 보입니다, 명칭 수정하면 더 좋을 것 같아요!
        loadTrips()
        currentTrip = futureTrip

        header.backgroundColor = UIColor.dolHareubangLightGray.withAlphaComponent(0.2)

        if let savedName = UserDefaults.standard.string(forKey: "username") {
            userName.text = savedName
        }
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
		//임시코드!, 플러스버튼 선택시 CoreData에 임시데이터 저장
        let randomNumber = Int.random(in: -10...10) // 시작날짜 현재 날짜 기준 -10~+10
        let startDate = Calendar.current.date(byAdding: .day, value: randomNumber, to: Date())!
        let tripLength = Int.random(in: 1...3) // 시작날짜와 끝나는 날짜 설정 +1~+3
        let endDate = Calendar.current.date(byAdding: .day, value: tripLength, to: startDate)!
        let randomNumber2 = Int.random(in: 1...100) // title뒤에 붙을 이름 랜덤 1~100

        CoreDataManager.shared.insert(TravelEntity.self) { travel in
            travel.id = UUID()
            travel.title = "제주여행\(randomNumber2)"
            travel.startDate = startDate
            travel.endDate = endDate
        }
        // 여기까지 임시코드입니다. 추후 삭제필요!

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

extension MainViewController {
    func fetchTrips() {
        let travelData = CoreDataManager.shared.fetch(TravelEntity.self)
        self.trips = travelData.compactMap { travel in
            guard let title = travel.title,
                  let startDate = travel.startDate,
                  let endDate = travel.endDate else { return nil }
            return Trip(title: title, startDate: startDate, endDate: endDate)
        }
        tableView.reloadData()
    }
}

