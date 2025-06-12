//
//  TransportationCollectionViewCell.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/11/25.
//

import UIKit

class TransportationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = contentView.frame.height / 2
        contentView.layer.masksToBounds = true
    }
    
    func configure(imageName: String, isSelected: Bool) {
        imageView.image = UIImage(systemName: imageName)
        imageView.tintColor = isSelected ? .white : .init(red: 29, green: 29, blue: 29)
        contentView.backgroundColor = isSelected ? .jejuOrange : .clear
    }
}
