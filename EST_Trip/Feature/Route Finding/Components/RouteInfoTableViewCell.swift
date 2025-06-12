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

    @IBOutlet weak var findRouteButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
