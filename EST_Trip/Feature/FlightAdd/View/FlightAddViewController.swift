//
//  FlightAddViewController.swift
//  EST_Trip
//
//  Created by hyunMac on 6/10/25.
//

import UIKit

class FlightAddViewController: UIViewController {
    let viewModel = FlightAddViewModel()

    @IBOutlet weak var departureDate: UIButton!

    @IBAction func departureDateButtonTapped(_ sender: Any) {
        presentDataSelectionSheet()
    }

    @IBOutlet weak var departureAirport: UIButton!
    @IBOutlet weak var arrivalAirport: UIButton!
    

    private var hasPresentedDateSheet = false

    override func viewDidLoad() {
        super.viewDidLoad()
		setupNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !hasPresentedDateSheet {
            presentDataSelectionSheet()
            hasPresentedDateSheet = true
        }
    }

    private func setupNavigationBar() {
        let leftButton = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let chevronImage = UIImage(systemName: "chevron.left", withConfiguration: config)
        leftButton.setImage(chevronImage, for: .normal)
        leftButton.tintColor = .label
        let customLeftBarButton = UIBarButtonItem(customView: leftButton)
        navigationItem.leftBarButtonItem = customLeftBarButton

        let titleView = FlightAddNavigationTitleView()
        titleView.titleLabel.text = "항공편 추가"
        titleView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
        navigationItem.titleView = titleView

        let rightButton = UIButton(type: .system)
        rightButton.setTitle("완료", for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        let customRightBarButton = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = customRightBarButton
    }

    private func presentDataSelectionSheet() {
        let storyboard = UIStoryboard(name: "FlightAdd", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "FlightDateSelectionViewController") as? FlightDateSelectionViewController {

            vc.viewModel = viewModel
            vc.modalPresentationStyle = .pageSheet

            vc.onSelectDepartureDate = { [weak self] selectedDate in
                guard let self else { return }

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.M.d"
                let title = formatter.string(from: selectedDate)

                departureDate.setTitle(title, for: .normal)
                departureDate.setTitleColor(.label, for: .normal)

                if !viewModel.flight.departureAirport.isEmpty {
                    departureAirport.setTitle(viewModel.flight.departureAirport, for: .normal)
                    departureAirport.setTitleColor(.label, for: .normal)
                }
                if !viewModel.flight.arrivalAirport.isEmpty {
                    arrivalAirport.setTitle(viewModel.flight.arrivalAirport, for: .normal)
                    arrivalAirport.setTitleColor(.label, for: .normal)
                }
            }
            present(vc, animated: true)
        }
    }
}
