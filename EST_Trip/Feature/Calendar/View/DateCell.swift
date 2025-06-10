//
//  DateCell.swift
//  EST_Trip
//
//  Created by hyunMac on 6/9/25.
//

import UIKit

class DateCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var circleBackgroundView: UIView!

    override func layoutSubviews() {
        super.awakeFromNib()
        // 백그라운드 UIView 기초 세팅
        circleBackgroundView.layer.cornerRadius = circleBackgroundView.frame.height / 2
        circleBackgroundView.clipsToBounds = true
    }

    func configure(dateText: String, subtitleText: String?, isToday: Bool, isWeekend: Bool, isSelected: Bool, isInRange: Bool) {
		dateLabel.text = dateText
        subLabel.text = subtitleText

        // 서브 텍스트가 존재했을때 적용
        if let subtitle = subtitleText {
            subLabel.text = subtitle
            subLabel.isHidden = false
        } else {
            subLabel.text = nil
            subLabel.isHidden = true
        }

        // 날짜가 오늘이냐 주말이냐에 따라서 다른 색상 적용
        if isToday {
            dateLabel.textColor = UIColor.jejuOrange
            subLabel.textColor = UIColor.jejuOrange
        } else if isWeekend {
            dateLabel.textColor = .red
            subLabel.textColor = .red
        } else {
            dateLabel.textColor = .label
        }

        // 날짜 선택에 따른 백그라운드 색상 변경
        if isSelected {
            circleBackgroundView.isHidden = false
            circleBackgroundView.backgroundColor = UIColor.jejuOrange
            dateLabel.textColor = UIColor.white
        } else if isInRange {
            circleBackgroundView.isHidden = false
            circleBackgroundView.backgroundColor = UIColor.canolaSand
        } else {
            circleBackgroundView.isHidden = true
        }
    }
}
