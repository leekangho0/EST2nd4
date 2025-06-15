//
//  BusNumberCollectionViewCell.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/12/25.
//

import UIKit

class BusNumberCollectionViewCell: UICollectionViewCell {
    
    lazy var numberLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = self.frame.height / 2
    }
    
    private func setupView() {
        contentView.layer.masksToBounds = true
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.textColor = .white
        numberLabel.textAlignment = .center
        numberLabel.font = .systemFont(ofSize: 12, weight: .semibold)

        contentView.addSubview(numberLabel)

        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            numberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
    
    func configure(busInfo: RouteInfo.BusInfo) {
        numberLabel.text = busInfo.name
        contentView.backgroundColor = busInfo.color
    }
}
