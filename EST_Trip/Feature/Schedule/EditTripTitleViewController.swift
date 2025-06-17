//
//  EditTripTitleViewController.swift
//  EST_Trip
//
//  Created by 고재현 on 6/17/25.
//


import UIKit

class EditTripTitleViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var modal: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!

    var currentTitle: String?
    var onTitleConfirmed: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.delegate = self
        titleTextField.text = currentTitle
        confirmButton.isEnabled = !(currentTitle?.isEmpty ?? true)

        background.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        modal.layer.cornerRadius = 12

        titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.becomeFirstResponder()
    }

    @objc func textFieldDidChange() {
        let trimmed = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        confirmButton.isEnabled = !trimmed.isEmpty
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func confirmButtonTapped(_ sender: Any) {
        let trimmed = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !trimmed.isEmpty else { return }
        onTitleConfirmed?(trimmed)
        dismiss(animated: true)
    }

    // 텍스트 제한 (선택사항)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let current = textField.text ?? ""
        guard let stringRange = Range(range, in: current) else { return false }
        let updated = current.replacingCharacters(in: stringRange, with: string)
        return updated.count <= 20
    }
}
