//
//  AddTimeViewController.swift
//  EST_Trip
//
//  Created by 정소이 on 6/16/25.
//

import UIKit

class AddTimeViewController: UIViewController {

    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var backgroundView: UIView!

    var onTimeSelected: ((Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    @IBAction private func confirmButtonTapped(_ sender: UIButton) {
        onTimeSelected?(datePicker.date)

        dismiss(animated: true)
    }

    private func setupUI() {
        view.backgroundColor = .dolHareubangGray.withAlphaComponent(0.7)

        backgroundView.layer.cornerRadius = 16
        backgroundView.layer.masksToBounds = true
    }
}
