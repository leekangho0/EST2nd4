//
//  FlightAddViewController.swift
//  EST_Trip
//
//  Created by hyunMac on 6/10/25.
//

import UIKit

class FlightAddViewController: UIViewController, UITextFieldDelegate {
    let viewModel = FlightAddViewModel()

    @IBOutlet weak var departureDate: UIButton!

    @IBAction func departureDateButtonTapped(_ sender: Any) {
        presentDataSelectionSheet()
    }

    @IBOutlet weak var departureTime: UIButton!
    
    @IBAction func departureTimeButtonTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var departureAirport: UIButton!
    @IBOutlet weak var arrivalAirport: UIButton!
    @IBOutlet weak var flightName: UITextField!
    
    private var hasPresentedDateSheet = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()

        flightName.delegate = self
        flightName.addTarget(self, action: #selector(flightNameChanged), for: .editingChanged)
    }

    @objc private func flightNameChanged() {
        viewModel.flight.flightName = flightName.text
        print(viewModel.flight.flightName ?? "")
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

            vc.onSelectDepartureDate = { [weak self] selectedDate, isFirst in
                guard let self else { return }

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.M.d"
				let title = formatter.string(from: selectedDate)

                departureDate.setTitle(title, for: .normal)
                departureDate.setTitleColor(.label, for: .normal)

                if isFirst {
                    viewModel.flight.arrivalAirport = "제주국제공항"
                    viewModel.flight.departureAirport = nil
                } else {
                    viewModel.flight.departureAirport = "제주국제공항"
                    viewModel.flight.arrivalAirport = nil
                }

                refreshAirportButtonsUI()
            }
            present(vc, animated: true)
        }
    }

    private func refreshAirportButtonsUI() {
        if let departure = viewModel.flight.departureAirport, !departure.isEmpty {
            departureAirport.setAttributedTitle(nil, for: .normal)
            departureAirport.setTitle(departure, for: .normal)
            departureAirport.setTitleColor(.label, for: .normal)
        } else {
            departureAirport.setAttributedTitle(NSAttributedString(
                string: "공항을 선택해주세요.",
                attributes: [.font: UIFont.systemFont(ofSize: 13),
                             .foregroundColor: UIColor.systemGray3]), for: .normal)
        }

        if let arrival = viewModel.flight.arrivalAirport, !arrival.isEmpty {
            arrivalAirport.setAttributedTitle(nil, for: .normal)
            arrivalAirport.setTitle(arrival, for: .normal)
            arrivalAirport.setTitleColor(.label, for: .normal)
        } else {
            arrivalAirport.setAttributedTitle(NSAttributedString(
                string: "공항을 선택해주세요.",
                attributes: [.font: UIFont.systemFont(ofSize: 13),
                             .foregroundColor: UIColor.systemGray3]), for: .normal)
        }
    }

    private func presentDatePicker() {
        let storyboard = UIStoryboard(name: "FlightAdd", bundle: nil)

        if let vc =
            storyboard.instantiateViewController(withIdentifier: "TimePickerViewController") as? TimePickerViewController {
            vc.modalPresentationStyle = .overCurrentContext
            vc.onTimeSelected = { [weak self] selectedDate in
                self?.viewModel.flight.departureTime = selectedDate
            }
            present(vc, animated: true)
        }
    }
}
