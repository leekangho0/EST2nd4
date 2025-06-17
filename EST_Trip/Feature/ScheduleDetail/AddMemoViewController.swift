//
//  AddMemoViewController.swift
//  EST_Trip
//
//  Created by 정소이 on 6/17/25.
//

import UIKit

class AddMemoViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet private weak var memoTextView: UITextView!
    @IBOutlet private weak var confirmButton: UIButton!

    var currentMemo: String?
    var memoEnteredHandler: ((String) -> Void)?

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "50자 이내로 여행 정보들을 기록해보세요."
        label.numberOfLines = 0
        label.textColor = .dolHareubangLightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupPlaceholder()

        memoTextView.text = currentMemo
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        memoTextView.becomeFirstResponder()
    }

    private func setupUI() {
        memoTextView.delegate = self
        memoTextView.text = currentMemo
        memoTextView.textContainer.lineFragmentPadding = 0
        confirmButton.isEnabled = false

        view.backgroundColor = .dolHareubangGray.withAlphaComponent(0.7)

        backgroundView.layer.cornerRadius = 8
        backgroundView.layer.masksToBounds = true
    }

    private func setupPlaceholder() {
        memoTextView.addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: memoTextView.topAnchor, constant: memoTextView.textContainerInset.top),
            placeholderLabel.leadingAnchor.constraint(equalTo: memoTextView.leadingAnchor, constant: memoTextView.textContainerInset.left)
        ])

        updatePlaceholderVisibility()
    }

    private func updatePlaceholderVisibility() {
        let isEmpty = memoTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        placeholderLabel.isHidden = !isEmpty
        confirmButton.isEnabled = !isEmpty
    }

    @IBAction private func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction private func confirmButtonTapped(_ sender: Any) {
        guard let text = memoTextView.text, !text.isEmpty else { return }
        memoEnteredHandler?(text)
        dismiss(animated: true)
    }
}

extension AddMemoViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }

    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText string: String) -> Bool {
        guard let currentText = textView.text,
              let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count < 50
    }
}
