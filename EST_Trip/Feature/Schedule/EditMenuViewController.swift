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
        let alert = UIAlertController(title: "여행 제목", message: nil, preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "제목을 입력하세요"
            textField.clearButtonMode = .whileEditing
            textField.borderStyle = .none

            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 1)
            bottomLine.backgroundColor = UIColor.systemBlue.cgColor
            textField.layer.addSublayer(bottomLine)
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                self?.onTitleUpdate?(text)
                self?.dismiss(animated: true)
            }
        })

        alert.addAction(cancelAction)
        alert.addAction(confirmAction)

        cancelAction.setValue(UIColor.gray, forKey: "titleTextColor")
        confirmAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")

        present(alert, animated: true)
    }

    @IBAction func dateEditButtonTapped(_ sender: UIButton) {
        // TODO: 날짜 수정 로직
    }

    @IBAction func tripDeleteButtonTapped(_ sender: UIButton) {
        // TODO: 삭제 로직
    }
}


