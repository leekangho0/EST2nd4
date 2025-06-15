//
//  RoundedView.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/12/25.
//

import UIKit

@IBDesignable
class RoundedView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }
    
    private func configure() {
        self.layer.cornerRadius = cornerRadius
    }
}
