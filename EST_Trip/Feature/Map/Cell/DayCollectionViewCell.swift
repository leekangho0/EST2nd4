//
//  DayCollectionViewCell.swift
//  EST_Trip
//
//  Created by kangho lee on 6/17/25.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .jejuOrange : .canolaSand
            contentView.layer.borderColor = isSelected
            ? UIColor(.canolaSand).cgColor
            : UIColor(.jejuOrange).cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = contentView.frame.height / 2
        contentView.layer.borderWidth = 2
    }
}
