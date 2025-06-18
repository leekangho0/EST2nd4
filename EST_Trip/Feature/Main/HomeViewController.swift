//
//  HomeViewController.swift
//  EST_Trip
//
//  Created by 정소이 on 6/11/25.
//

import UIKit

class MainViewController: UIViewController {
//    var trips: [TravelEntity] = []
    // 📌 dday를 기준으로 dday >=0 이면 futureTripTitle, dday < 0 이면 pastTripTitle에 넣어주기

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var futureTripButton: UIButton!
    @IBOutlet weak var pastTripButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MainViewModel!

    // - MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        bind()
        
        viewModel.notifyAll()
        viewModel.setSection(.upcoming)
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)

        // 코어데이터에서 데이터 로드
        
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
            viewModel.setSection(.upcoming)
            futureTripButton.tintColor = .label
            pastTripButton.tintColor = .dolHareubangGray
        } else {
            viewModel.setSection(.prior)
            futureTripButton.tintColor = .dolHareubangGray
            pastTripButton.tintColor = .label
        }
    }
    
    private func layout() {
        header.backgroundColor = UIColor.dolHareubangLightGray.withAlphaComponent(0.2)

        if let savedName = UserDefaults.standard.string(forKey: "username") {
            userName.text = savedName
        }
    }
    
    private func bind() {
        tableView.dataSource = self
        tableView.delegate = self
        
        // reload closure 전달
        viewModel.bind { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.bind(travel: viewModel.item(for: indexPath))
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let travel = viewModel.item(for: indexPath)

        let vc = FeatureFactory.makePlanner(travel: travel)

        navigationController?.pushViewController(vc, animated: true)
    }
}

