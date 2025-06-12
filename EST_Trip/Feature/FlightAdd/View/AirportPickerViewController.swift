//
//  AirportPickerViewController.swift
//  EST_Trip
//
//  Created by hyunMac on 6/12/25.
//

import UIKit

class AirportPickerViewController: UIViewController {

    let airportList = [
        "광주공항",
        "군산공항",
        "김포국제공항",
        "김해국제공항",
        "대구국제공항",
        "사천공항",
        "여수공항",
        "울산공항",
        "원주공항",
        "청주국제공항",
        "포항경주공항"
    ]

    @IBOutlet weak var pickerView: UIPickerView!

    @IBOutlet weak var containerView: UIView!

    var onAirportSelected: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .clear

        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true

        pickerView.delegate = self
        pickerView.dataSource = self

    }
    @IBAction func confirmButtonTapped(_ sender: Any) {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let selectedAirport = airportList[selectedRow]
        onAirportSelected?(selectedAirport)
        dismiss(animated: true)
    }
}

extension AirportPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return airportList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return airportList[row]
    }
}
