//
//  TimePickerViewController.swift
//  EST_Trip
//
//  Created by hyunMac on 6/12/25.
//

import UIKit

class TimePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!

    var onTimeSelected: ((Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func confimButtonTapped(_ sender: Any) {
        onTimeSelected?(datePicker.date)
        dismiss(animated: true)
    }
}
