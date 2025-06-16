//
//  TestViewController.swift
//  EST_Trip
//
//  Created by 정소이 on 6/16/25.
//

import UIKit

class TestViewController: UIViewController {

    @IBAction func button(_ sender: Any) {
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleDetailViewController") as? ScheduleDetailViewController else { return }

        detailVC.modalPresentationStyle = .pageSheet
        self.present(detailVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
