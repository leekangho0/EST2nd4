//
//  EditUsernameViewController.swift
//  EST_Trip
//
//  Created by 정소이 on 6/15/25.
//

import UIKit

class EditUsernameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var modal: UIView!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var confirmButtonLabel: UIButton!

    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    var currentName: String?
    var userNameEntered: ((String) -> Void)?

    @IBAction func confirmButton(_ sender: Any) {
        guard let text = usernameTextfield.text, !text.isEmpty else { return }
        userNameEntered?(text)

        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextfield.delegate = self

        confirmButtonLabel.isEnabled = false
        usernameTextfield.text = currentName
        usernameTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        background.backgroundColor = UIColor.dolHareubangGray.withAlphaComponent(0.7)
        modal.layer.cornerRadius = 8
        modal.layer.masksToBounds = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        usernameTextfield.becomeFirstResponder()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        let isTextEmpty = usernameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        confirmButtonLabel.isEnabled = !isTextEmpty
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 현재 텍스트
        let currentText = usernameTextfield.text ?? "사용자명"

        // 바뀐 후 텍스트
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count < 10
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        confirmButton(confirmButtonLabel!)
        return true
    }
}
