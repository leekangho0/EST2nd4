//
//  RouteInfoTableViewCell.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/12/25.
//

import UIKit

protocol RouteInfoTableViewCellDelegate {
    func didTapSelectButton()
}

class RouteInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var taxiFareLabel: UILabel!
    @IBOutlet weak var fareLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!

    @IBOutlet weak var findRouteButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    var delegate: RouteInfoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func presentTransitDetailVC(_ sender: Any) {
        delegate?.didTapSelectButton()
    }
}
