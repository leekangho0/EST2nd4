//
//  TimePickerViewController.swift
//  EST_Trip
//
//  Created by hyunMac on 6/12/25.
//

import UIKit

class TimePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var containerView: UIView!
    
    var onTimeSelected: ((Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
    }

    @IBAction func confimButtonTapped(_ sender: Any) {
        onTimeSelected?(datePicker.date)
        dismiss(animated: true)
    }
}
