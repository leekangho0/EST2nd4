//
//  OvalBorderView.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/11/25.
//

import UIKit

@IBDesignable
class OvalBorderView: UIView {

    @IBInspectable var borderColor: UIColor = .systemGray5
    @IBInspectable var cornerRadius: CGFloat = 8

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
    }
}

