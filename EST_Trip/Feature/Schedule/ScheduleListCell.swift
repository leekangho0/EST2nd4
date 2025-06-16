//
//  ScheduleListCell.swift
//  EST_Trip
//
//  Created by 고재현 on 6/12/25.
//

import UIKit

class ScheduleListCell: UITableViewCell {
    
    @IBOutlet weak var numberBadgeLabel: UILabel!
    @IBOutlet weak var distanceLabel: PaddingLabel!
    @IBOutlet weak var placeCardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dotLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    private let verticalLineView = UIView()

        override func awakeFromNib() {
            super.awakeFromNib()

            placeCardView.layer.cornerRadius = 8
            placeCardView.clipsToBounds = true

            numberBadgeLabel.layer.cornerRadius = numberBadgeLabel.frame.height / 2
            numberBadgeLabel.clipsToBounds = true
            numberBadgeLabel.backgroundColor = UIColor(named: "JejuOrange") ?? .systemOrange
            numberBadgeLabel.textColor = .white
            numberBadgeLabel.textAlignment = .center
            numberBadgeLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

            distanceLabel.backgroundColor = UIColor(named: "DolHareubangGray") // 예시
            distanceLabel.textColor = .black
            distanceLabel.layer.cornerRadius = 4
            distanceLabel.layer.masksToBounds = true
            distanceLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            distanceLabel.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

            setupVerticalLine()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            numberBadgeLabel.layer.cornerRadius = numberBadgeLabel.frame.height / 2
        }

        private func setupVerticalLine() {
            verticalLineView.backgroundColor = .lightGray
            verticalLineView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(verticalLineView)
            contentView.sendSubviewToBack(verticalLineView)

            NSLayoutConstraint.activate([
                verticalLineView.widthAnchor.constraint(equalToConstant: 0.5),
                verticalLineView.centerXAnchor.constraint(equalTo: numberBadgeLabel.centerXAnchor),
                verticalLineView.topAnchor.constraint(equalTo: contentView.topAnchor),
                verticalLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }

        func configure(indexPath: IndexPath, isLastCell: Bool, place: PlaceModel) {
            numberBadgeLabel.text = "\(indexPath.row + 1)"
            titleLabel.text = place.name
            categoryLabel.text = place.category
            addressLabel.text = place.address
            distanceLabel.text = "3.7 km"

            // 셀 높이와 뱃지 기준 Y값 계산
            contentView.layoutIfNeeded()
            let badgeCenterY = numberBadgeLabel.center.y
            let totalHeight = contentView.bounds.height

            // 상하 제약 조건 업데이트 (선 표시 범위 조절)
            for constraint in verticalLineView.constraints {
                if constraint.firstAttribute == .top || constraint.firstAttribute == .bottom {
                    verticalLineView.removeConstraint(constraint)
                }
            }

            if indexPath.row == 0 {
                // 첫 셀: 뱃지 중앙부터 아래까지
                verticalLineView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: badgeCenterY).isActive = true
                verticalLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            } else if isLastCell {
                // 마지막 셀: 위부터 뱃지 중앙까지
                verticalLineView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
                verticalLineView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: badgeCenterY).isActive = true
            } else {
                // 중간 셀: 전체 선
                verticalLineView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
                verticalLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            }
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            // 선 다시 그리기 위해 constraint 정리
            verticalLineView.removeFromSuperview()
            setupVerticalLine()
        }

}

