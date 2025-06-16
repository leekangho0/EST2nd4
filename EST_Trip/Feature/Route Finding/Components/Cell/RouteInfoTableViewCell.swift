//
//  RouteInfoTableViewCell.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/12/25.
//

import UIKit

class RouteInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var taxiFareLabel: UILabel!
    @IBOutlet weak var fareLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!

    @IBOutlet weak var selectButton: UIButton!
    
    lazy var warningLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    private func setupView() {
        self.addSubview(warningLabel)
        
        warningLabel.frame = self.contentView.frame
        warningLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        warningLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        warningLabel.textColor = .darkGray
        warningLabel.textAlignment = .center
        
        warningLabel.isHidden = true
    }
    
    func configure(_ routeInfo: RouteInfo, isLastIndex: Bool, isTransit: Bool) {
        durationLabel.text = routeInfo.durationText()
        distanceLabel.text = routeInfo.distanceText()
        taxiFareLabel.text = routeInfo.taxiFareText()
        fareLabel.text = routeInfo.fareText()
        
        seperatorView.isHidden = isLastIndex
        selectButton.isHidden = !isTransit
        
        warningLabel.isHidden = true
    }
    
    func configure(_ warningMessage: String) {
        warningLabel.text = warningMessage
        
        durationLabel.text = ""
        distanceLabel.text = ""
        taxiFareLabel.text = ""
        fareLabel.text = ""
        
        seperatorView.isHidden = true
        selectButton.isHidden = true
        
        warningLabel.isHidden = false
    }
}
