//
//  FlightAddViewController.swift
//  EST_Trip
//
//  Created by hyunMac on 6/10/25.
//

import UIKit

class FlightAddViewController: UIViewController, UITextFieldDelegate {
    let viewModel = FlightAddViewModel()
    private var hasPresentedDateSheet = false

    @IBOutlet weak var departureDate: UIButton!
    @IBAction func departureDateButtonTapped(_ sender: Any) {
        presentDataSelectionSheet()
    }

    @IBOutlet weak var departureTime: UIButton!
    @IBAction func departureTimeButtonTapped(_ sender: Any) {
		presentDatePicker()
    }

    @IBOutlet weak var flightName: UITextField!

    @IBOutlet weak var departureAirport: UIButton!
    @IBAction func dapartureAirportButtonTapped(_ sender: Any) {
        presentDepartureAirportPicker()
    }

    @IBOutlet weak var arrivalDate: UIButton!
    @IBAction func arrivalDateButtonTapped(_ sender: Any) {
    }

    @IBOutlet weak var arrivalTime: UIButton!
    @IBAction func arrivalTimeButtonTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var arrivalAirport: UIButton!
    @IBAction func arrivalAirportButtonTapped(_ sender: Any) {
    }

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

        flightName.delegate = self
        flightName.addTarget(self, action: #selector(flightNameChanged), for: .editingChanged)
    }

    @objc private func flightNameChanged() {
        viewModel.flight.flightName = flightName.text
        print(viewModel.flight.flightName ?? "")
    }

    private func setupNavigationBar() {
        let leftButton = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let chevronImage = UIImage(systemName: "chevron.left", withConfiguration: config)
        leftButton.setImage(chevronImage, for: .normal)
        leftButton.tintColor = .label

        leftButton.addTarget(self, action: #selector(onBack), for: .touchUpInside)
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

        rightButton.addTarget(self, action: #selector(completeTap), for: .touchUpInside)
    }

    private func presentDataSelectionSheet() {
        let storyboard = UIStoryboard(name: "FlightAdd", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "FlightDateSelectionViewController") as? FlightDateSelectionViewController {

            vc.modalPresentationStyle = .pageSheet

            vc.onSelectDepartureDate = { [weak self] selectedDate, isFirst in
                guard let self else { return }

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.M.d"
				let title = formatter.string(from: selectedDate)

                departureDate.setAttributedTitle(NSAttributedString(
                    string: title,
                    attributes: [.font: UIFont.systemFont(ofSize: 13),
                                 .foregroundColor: UIColor.label]), for: .normal)

                viewModel.flight.departureDate = selectedDate

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

            departureAirport.setAttributedTitle(NSAttributedString(
                string: departure,
                attributes: [.font: UIFont.systemFont(ofSize: 13),
                             .foregroundColor: UIColor.label]), for: .normal)
        } else {
            departureAirport.setAttributedTitle(NSAttributedString(
                string: "공항을 선택해주세요.",
                attributes: [.font: UIFont.systemFont(ofSize: 13),
                             .foregroundColor: UIColor.systemGray3]), for: .normal)
        }

        if let arrival = viewModel.flight.arrivalAirport, !arrival.isEmpty {
            arrivalAirport.setAttributedTitle(nil, for: .normal)

            arrivalAirport.setAttributedTitle(NSAttributedString(
                string: arrival,
                attributes: [.font: UIFont.systemFont(ofSize: 13),
                             .foregroundColor: UIColor.label]), for: .normal)


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

            vc.modalPresentationStyle = .overFullScreen

            vc.onTimeSelected = { [weak self] selectedDate in
                guard let self else { return }

                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let title = formatter.string(from: selectedDate)

                departureTime.setAttributedTitle(NSAttributedString(
                    string: title,
                    attributes: [.font: UIFont.systemFont(ofSize: 13),
                                 .foregroundColor: UIColor.label]), for: .normal)

                viewModel.flight.departureTime = selectedDate
            }
            present(vc, animated: true)
        }
    }

    private func presentDepartureAirportPicker() {
        let storyboard = UIStoryboard(name: "FlightAdd", bundle: nil)

        if let vc = storyboard.instantiateViewController(withIdentifier: "AirportPickerViewController") as? AirportPickerViewController {

            vc.modalPresentationStyle = .overFullScreen

            vc.onAirportSelected = { [weak self] selectedAirport in
                guard let self else { return }

				print("선택된 공항 \(selectedAirport)")
                print("뷰모델 상태:", viewModel.flight.departureAirport ?? "없음")
                departureAirport.setAttributedTitle(nil, for: .normal)

                departureAirport.setAttributedTitle(NSAttributedString(
                    string: selectedAirport,
                    attributes: [.font: UIFont.systemFont(ofSize: 13),
                                 .foregroundColor: UIColor.label]), for: .normal)

                viewModel.flight.departureAirport = selectedAirport
            }
            present(vc, animated: true)
        }
    }
}

extension FlightAddViewController {
    @objc func completeTap(_ sender: Any) {
        let vc = FeatureFactory.makePlanner()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
