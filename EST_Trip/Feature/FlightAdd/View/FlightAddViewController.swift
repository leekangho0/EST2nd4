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
        print("도착일 선택 체크")
        presentArrivalDataSheet()
    }

    @IBOutlet weak var arrivalTime: UIButton!
    @IBAction func arrivalTimeButtonTapped(_ sender: Any) {
        presentArrivalTimePicker()
    }

    @IBOutlet weak var arrivalAirport: UIButton!
    @IBAction func arrivalAirportButtonTapped(_ sender: Any) {
        presentArrivalAirportPicker()
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
        viewModel.updateFlightName(name: flightName.text ?? "")
        print(viewModel.flight.flightName)
    }

    private func setButtonTitle(title: String, for button: UIButton, active: Bool = true) {
        let color: UIColor = active ? .label : .systemGray3
        button.setAttributedTitle(
            NSAttributedString(string: title,
                               attributes: [.font: UIFont.systemFont(ofSize: 13),
                                            .foregroundColor: color]),
            for: .normal)
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

                let title = viewModel.updateDepartureDate(date: selectedDate)
                setButtonTitle(title: title, for: departureDate)

                viewModel.updateTripDirection(isFirst: isFirst)

                refreshAirportButtonsUI()
            }
            present(vc, animated: true)
        }
    }

    private func refreshAirportButtonsUI() {
        let dep = viewModel.flight.departureAirport ?? ""
        let arr = viewModel.flight.arrivalAirport ?? ""

        setButtonTitle(title: dep.isEmpty ? "공항을 선택해주세요." : dep,
                       for: departureAirport,
                       active: !dep.isEmpty)

        setButtonTitle(title: arr.isEmpty ? "공항을 선택해주세요." : arr,
                       for: arrivalAirport,
                       active: !arr.isEmpty)
    }

    private func presentDatePicker() {
        let storyboard = UIStoryboard(name: "FlightAdd", bundle: nil)

        if let vc =
            storyboard.instantiateViewController(withIdentifier: "TimePickerViewController") as? TimePickerViewController {

            vc.modalPresentationStyle = .overFullScreen

            vc.onTimeSelected = { [weak self] selectedDate in
                guard let self else { return }

                let title = viewModel.updateDepartureTime(date: selectedDate)
                setButtonTitle(title: title, for: departureTime)
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
                let title = viewModel.updateDepartureAirport(airport: selectedAirport)
                setButtonTitle(title: title, for: departureAirport)
            }
            present(vc, animated: true)
        }
    }

    private func presentArrivalDataSheet() {
        let departureDate = viewModel.flight.departureDate
        let storyboard = UIStoryboard(name: "FlightAdd", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "FlightDateSelectionViewController") as? FlightDateSelectionViewController {
            vc.modalPresentationStyle = .pageSheet
            vc.isArrivalSelection = true
            vc.baseDepartureDate = departureDate

            vc.onSelectArrivalDate = { [weak self] date in
                guard let self else { return }
                let title = viewModel.updateArrivalDate(date: date)
                setButtonTitle(title: title, for: arrivalDate)
                print("도착일 체크 \(String(describing: viewModel.flight.arrivalDate))")
            }
            present(vc, animated: true)
        }
    }

    private func presentArrivalTimePicker() {
        let storyboard = UIStoryboard(name: "FlightAdd", bundle: nil)

        if let vc = storyboard.instantiateViewController(withIdentifier: "TimePickerViewController") as? TimePickerViewController {

            vc.modalPresentationStyle = .overFullScreen

            vc.onTimeSelected = { [weak self] selectDate in
                guard let self else { return }
                let title = viewModel.updateArrivalTime(date: selectDate)
                setButtonTitle(title: title, for: arrivalTime)
            }
            present(vc, animated: true)
        }
    }

    private func presentArrivalAirportPicker() {
        let storyboard = UIStoryboard(name: "FlightAdd", bundle: nil)

        if let vc = storyboard.instantiateViewController(withIdentifier: "AirportPickerViewController") as? AirportPickerViewController {

            vc.modalPresentationStyle = .overFullScreen

            vc.onAirportSelected = { [weak self] selectAirport in
                guard let self else { return }
                let title = viewModel.updateArrivalAirport(airport: selectAirport)
                setButtonTitle(title: title, for: arrivalAirport)
                print("모델 전체 상태 체크",viewModel.flight)
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
