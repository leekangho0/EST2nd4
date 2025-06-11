//
//  ScheduleMainViewController.swift
//  JejuTripAppTutorial
//
//  Created by 고재현 on 6/8/25.
//

import UIKit

class ScheduleMainViewController: UIViewController {

    @IBOutlet var toggleButtons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()

        toggleButtons.forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
//            button.layer.backgroundColor = UIColor(hex: "#D9D9D9", alpha: 0.6).cgColor
//            button.setTitleColor(UIColor(hex: "#7E7E7E", alpha: 1.0), for: .normal)
        }

    }

    @IBAction func toggleButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()

        if sender.isSelected {
            sender.backgroundColor = UIColor(hex: "#FFA24D", alpha: 1.0)
            sender.setTitleColor(UIColor(hex: "#FFFFFF", alpha: 1.0), for: .normal)
        } else {
            sender.backgroundColor = UIColor(hex: "#D9D9D9", alpha: 0.6)
            sender.setTitleColor(UIColor(hex: "#7E7E7E", alpha: 1.0), for: .normal)
        }
    }

}


extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
