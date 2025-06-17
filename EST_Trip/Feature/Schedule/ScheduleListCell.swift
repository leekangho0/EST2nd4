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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        numberBadgeLabel.layer.cornerRadius = numberBadgeLabel.frame.height / 2
    }
    
    
    func configure(indexPath: IndexPath, place: PlaceEntity) {
        numberBadgeLabel.text = "\(indexPath.row + 1)"
        titleLabel.text = place.name
        categoryLabel.text = place.categoryType.name
        addressLabel.text = place.address
        distanceLabel.text = "3.7 km"
    }
    
}

