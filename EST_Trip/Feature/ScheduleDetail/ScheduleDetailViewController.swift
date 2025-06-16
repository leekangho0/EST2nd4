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

class ScheduleDetailViewController: UIViewController {

    @IBOutlet weak var addTimeButtonLabel: UIButton!
    @IBOutlet weak var addMemoButtonLabel: UIButton!

    @IBOutlet weak var routeFindingButtonLabel: UIButton!
    
    var delegate: ScheduleDetailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        let dolHareubangGray = UIColor.dolHareubangGray.withAlphaComponent(0.6)

        setupButton(color: dolHareubangGray)
        setuprouteFindingButton(borderColor: dolHareubangGray.cgColor)
        configureSheetPresentation()
    }

    private func setupButton(color: UIColor) {
        addTimeButtonLabel.tintColor = color
        addMemoButtonLabel.tintColor = color
    }

    private func setuprouteFindingButton(borderColor: CGColor) {
        routeFindingButtonLabel.layer.borderWidth = 0.8
        routeFindingButtonLabel.layer.borderColor = borderColor
        routeFindingButtonLabel.layer.cornerRadius = 8
        routeFindingButtonLabel.clipsToBounds = true
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
}
