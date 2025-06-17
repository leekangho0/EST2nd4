//
//  HomeViewController.swift
//  EST_Trip
//
//  Created by 정소이 on 6/11/25.
//

import UIKit

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
    
    struct Trip {
        let id: UUID
        let title: String
        let startDate: Date
        let endDate: Date
    }
    
    var trips: [Trip] = []
    // 📌 dday를 기준으로 dday >=0 이면 futureTripTitle, dday < 0 이면 pastTripTitle에 넣어주기
    var futureTrip: [Trip] = []
    var pastTrip: [Trip] = []
    
    private var travels = [Travel]()

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var futureTripButton: UIButton!
    @IBOutlet weak var pastTripButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        header.backgroundColor = UIColor.dolHareubangLightGray.withAlphaComponent(0.2)

        if let savedName = UserDefaults.standard.string(forKey: "username") {
            userName.text = savedName
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTrips()
        menuButtonTapped(futureTripButton)
    }
    
    private func updateTrips() {
        fetchTrips()
        loadTrips()
        
        trips = futureTrip
        
        tableView.reloadData()
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
        
        self.travels = []
        self.trips = []
        
        travelData.forEach { travel in
            let id = travel.id
            
            if let title = travel.title,
               let startDate = travel.startDate,
               let endDate = travel.endDate {
                trips.append(Trip(id: id, title: title, startDate: startDate, endDate: endDate))
            }
            
            travels.append(Travel(entity: travel))
        }
        
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = FeatureFactory.makePlanner()
        if let index = travels.firstIndex(where: { $0.id == trips[indexPath.row].id }){
            vc.travel = travels[index]
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

