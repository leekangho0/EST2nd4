//
//  EditMenuViewController.swift
//  EST_Trip
//
//  Created by 고재현 on 6/16/25.
//

import UIKit

protocol EditMenuViewControllerDelegate {
    func didUpdateTitle(_ newTitle: String)
    func didUpdateDate()
    func didDeleteTravel()
}

class EditMenuViewController: UIViewController {

    @IBOutlet weak var titleEditButton: UIButton!
    @IBOutlet weak var dateEditButton: UIButton!
    @IBOutlet weak var tripDeleteButton: UIButton!

    var currentTitleText: String?
    var onTitleUpdate: ((String) -> Void)?
    var delegate: EditMenuViewControllerDelegate?

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

        [titleEditButton, dateEditButton, tripDeleteButton].forEach {
                $0?.tintColor = .label
                $0?.setTitleColor(.label, for: .normal)
            }
    }

    @IBAction func titleEditButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Schedule", bundle: nil)
        guard let editTitleVC = storyboard.instantiateViewController(withIdentifier: "EditTripTitleViewController") as? EditTripTitleViewController else { return }

        editTitleVC.currentTitle = currentTitleText

        editTitleVC.onTitleConfirmed = { [weak self] newTitle in
            self?.dismiss(animated: true) {
                self?.delegate?.didUpdateTitle(newTitle)
            }
        }
        editTitleVC.modalPresentationStyle = .overFullScreen
        editTitleVC.modalTransitionStyle = .crossDissolve
        present(editTitleVC, animated: true)
    }

    @IBAction func dateEditButtonTapped(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didUpdateDate()
        }
    }

    @IBAction func tripDeleteButtonTapped(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didDeleteTravel()
        }
    }
}
