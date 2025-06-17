//
//  EditMenuViewController.swift
//  EST_Trip
//
//  Created by 고재현 on 6/16/25.
//

import UIKit

class EditMenuViewController: UIViewController {

    @IBOutlet weak var titleEditButton: UIButton!
    @IBOutlet weak var dateEditButton: UIButton!
    @IBOutlet weak var tripDeleteButton: UIButton!

    var currentTitleText: String?
    var onTitleUpdate: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let sheet = self.sheetPresentationController {
            sheet.detents = [
                .custom { context in
                    return 280
                }
            ]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 20
        }
    }

    @IBAction func titleEditButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Schedule", bundle: nil)
        guard let editTitleVC = storyboard.instantiateViewController(withIdentifier: "EditTripTitleViewController") as? EditTripTitleViewController else { return }

        editTitleVC.currentTitle = currentTitleText

        editTitleVC.onTitleConfirmed = { [weak self] newTitle in
            self?.onTitleUpdate?(newTitle)
            self?.dismiss(animated: true)
        }
        editTitleVC.modalPresentationStyle = .overFullScreen
        editTitleVC.modalTransitionStyle = .crossDissolve
        present(editTitleVC, animated: true)
    }

    @IBAction func dateEditButtonTapped(_ sender: UIButton) {
        // TODO: 날짜 수정 로직
    }

    @IBAction func tripDeleteButtonTapped(_ sender: UIButton) {
        // TODO: 삭제 로직
    }
}
