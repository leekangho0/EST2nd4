//
//  FlightAddViewController.swift
//  EST_Trip
//
//  Created by hyunMac on 6/10/25.
//

import UIKit

class FlightAddViewController: UIViewController, UITextFieldDelegate {
    var viewModel: FlightAddViewModel!
    
    private var hasPresentedDateSheet = false
//    var travel: Travel?
    enum DateType {
        case start, end, all
    }
    
    enum Mode {
        case edit, append, none
    }
    
//    var travel: Travel?
    var mode: Mode = .none
    var dateType: DateType = .all
    var onUpdate: ((DateType, FlightDTO) -> Void)? = nil
    var onDelete: (() -> Void)? = nil
    var existingFlight: FlightDTO?

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
        
        if mode == .edit {
            configureView()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !hasPresentedDateSheet, mode != .edit {
            presentDataSelectionSheet()
            hasPresentedDateSheet = true
        }

        flightName.delegate = self
        flightName.addTarget(self, action: #selector(flightNameChanged), for: .editingChanged)
    }

    @objc private func flightNameChanged() {
        viewModel.updateFlightName(name: flightName.text ?? "")
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
        
        let font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        let rightButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeTap))
        rightButton.setTitleTextAttributes([.font: font], for: .normal)
        rightButton.setTitleTextAttributes([.font: font], for: .highlighted)
        rightButton.tintColor = .label
        
        if mode == .append {
            navigationItem.rightBarButtonItems = [rightButton]
        } else if mode == .edit {
            let deleteButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteFlight))
            deleteButton.setTitleTextAttributes([.font: font], for: .normal)
            deleteButton.setTitleTextAttributes([.font: font], for: .highlighted)
            deleteButton.tintColor = .red
            
            navigationItem.rightBarButtonItems = [deleteButton, rightButton]
            
        } else {
            let skipButton = UIBarButtonItem(title: "스킵", style: .plain, target: self, action: #selector(skipTap))
            skipButton.setTitleTextAttributes([.font: font], for: .normal)
            skipButton.setTitleTextAttributes([.font: font], for: .highlighted)
            skipButton.tintColor = .label
            
            navigationItem.rightBarButtonItems = [skipButton, rightButton]
        }
    }
    
    private func configureView() {
        guard let flight = existingFlight else { return }
        
        viewModel.flight = flight
        
        flightName.text = flight.flightName
        
        setButtonTitle(
            title: viewModel.dayFormatter.string(from: flight.departureDate ?? .now),
            for: departureDate
        )
        setButtonTitle(
            title: viewModel.timeFormatter.string(from: flight.departureTime ?? .now),
            for: departureTime
        )
        setButtonTitle(
            title: flight.departureAirport ?? "",
            for: departureAirport
        )
        
        setButtonTitle(
            title: viewModel.dayFormatter.string(from: flight.arrivalDate ?? .now),
            for: arrivalDate
        )
        setButtonTitle(
            title: viewModel.timeFormatter.string(from: flight.arrivalTime ?? .now),
            for: arrivalTime
        )
        setButtonTitle(
            title: flight.arrivalAirport ?? "",
            for: arrivalAirport
        )
    }

    private func presentDataSelectionSheet() {
        let storyboard = UIStoryboard(name: "FlightAdd", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "FlightDateSelectionViewController") as? FlightDateSelectionViewController {

            vc.modalPresentationStyle = .pageSheet
            vc.dateType = dateType

            vc.onSelectDepartureDate = { [weak self] selectedDate, isFirst in
                guard let self else { return }

                let title = viewModel.updateDepartureDate(date: selectedDate)
                setButtonTitle(title: title, for: departureDate)

                viewModel.updateTripDirection(isFirst: isFirst)
                
                self.dateType = isFirst ? .start : .end

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
            }
            present(vc, animated: true)
        }
    }
}

extension FlightAddViewController {
    @objc func completeTap(_ sender: Any) {
        if !viewModel.isFlightVaild() {
            let alert = UIAlertController(title: "비어있는 항목이 있습니다", message: "모든 항목을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        if mode != .none {
            onUpdate?(dateType, viewModel.flight)
            navigationController?.popViewController(animated: true)
        } else {
            let vc = FeatureFactory.makePlanner(travel: viewModel.travel, startFlight: viewModel.flight)
            viewModel.addFlight()
            viewModel.saveToCoreData()
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func skipTap(_ sender: Any) {
        let vc = FeatureFactory.makePlanner(travel: viewModel.travel)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteFlight(_ sender: Any) {
        onDelete?()
        navigationController?.popViewController(animated: true)
    }
}

extension FlightAddViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

