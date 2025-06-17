//
//  ScheduleDetailViewController.swift
//  EST_Trip
//
//  Created by 정소이 on 6/16/25.
//

import UIKit

protocol ScheduleDetailViewControllerDelegate {
    func didTapRouteFindingButton()
}

struct ScheduleDetail {
    var time: Date?
    var memo: String?
}

class ScheduleDetailViewController: UIViewController {

    @IBOutlet weak var addTimeButton: UIButton!
    @IBOutlet weak var addMemoButton: UIButton!
    @IBOutlet private weak var routeFindingButton: UIButton!
    
    var delegate: ScheduleDetailViewControllerDelegate?
    private var detail = ScheduleDetail()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSavedData()
    }

    @IBAction private func addTimeButtonTapped(_ sender: UIButton) {
        presentTimePicker()
    }

    @IBAction func addMemoButtonTapped(_ sender: Any) {
//        presentMemoView()
    }

    private func setupUI() {
        let grayColor = UIColor.dolHareubangGray.withAlphaComponent(0.6)
        setupButtons(with: grayColor)
        setupRouteFindingButton(borderColor: grayColor.cgColor)
        configureSheetPresentation()
    }

    private func setupButtons(with color: UIColor) {
        [addTimeButton, addMemoButton].forEach { button in
            button?.tintColor = color
            button?.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            button?.contentHorizontalAlignment = .left
        }

        addMemoButton.titleLabel?.lineBreakMode = .byTruncatingTail
        addMemoButton.titleLabel?.numberOfLines = 1
        addMemoButton.titleLabel?.adjustsFontSizeToFitWidth = false

        addTimeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
        addTimeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)

        addMemoButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: -3)
        addMemoButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 3)
    }

    private func setupRouteFindingButton(borderColor: CGColor) {
        routeFindingButton.layer.borderWidth = 0.8
        routeFindingButton.layer.borderColor = borderColor
        routeFindingButton.layer.cornerRadius = 8
        routeFindingButton.clipsToBounds = true
    }

    private func configureSheetPresentation() {
        guard let sheet = sheetPresentationController else { return }
        sheet.detents = [.custom(resolver: { _ in 270 })]
        sheet.preferredCornerRadius = 16
    }
    
    @IBAction func findRoute(_ sender: Any) {
        self.dismiss(animated: false) { [weak self] in
            // 여기서 protocol 수정 후 데이터 넘겨주세요
            self?.delegate?.didTapRouteFindingButton()
        }
    }

    private func loadSavedData() {
        if let timeInterval = UserDefaults.standard.object(forKey: "savedTime") as? TimeInterval {
            let savedDate = Date(timeIntervalSince1970: timeInterval)
            detail.time = savedDate
            addTimeButton.setTitle(formatTime(savedDate), for: .normal)
        }

        if let savedMemo = UserDefaults.standard.string(forKey: "savedMemo") {
            detail.memo = savedMemo
            addMemoButton.setTitle(savedMemo, for: .normal)
        }
    }

    private func presentTimePicker() {
        guard let timeVC = storyboard?.instantiateViewController(withIdentifier: "AddTimeViewController") as? AddTimeViewController else { return }

        timeVC.onTimeSelected = { [weak self] selectedDate in
            guard let self = self else { return }
            self.detail.time = selectedDate
            UserDefaults.standard.set(selectedDate.timeIntervalSince1970, forKey: "savedTime")
            self.addTimeButton.setTitle(self.formatTime(selectedDate), for: .normal)
        }

        timeVC.modalPresentationStyle = .overFullScreen
        timeVC.modalTransitionStyle = .crossDissolve
        present(timeVC, animated: true)
    }

//    private func presentMemoView() {
//        guard let memoVC = storyboard?.instantiateViewController(withIdentifier: "AddMemoViewController") as? AddMemoViewController else { return }
//
//        memoVC.memoEnteredHandler = { [weak self] memo in
//            guard let self = self else { return }
//            self.detail.memo = memo
//            UserDefaults.standard.set(memo, forKey: "savedMemo")
//            self.addMemoButton.setTitle(memo, for: .normal)
//        }
//
//        memoVC.currentMemo = (addMemoButton.titleLabel?.text == "메모 추가") ? "" : addMemoButton.titleLabel?.text
//
//        memoVC.modalPresentationStyle = .overFullScreen
//        memoVC.modalTransitionStyle = .crossDissolve
//        present(memoVC, animated: true)
//    }

    private func formatTime(_ date: Date) -> String {
        return timeFormatter.string(from: date)
    }
}
