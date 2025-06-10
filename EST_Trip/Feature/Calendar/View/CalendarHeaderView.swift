//
//  CalendarHeaderView.swift
//  EST_Trip
//
//  Created by hyunMac on 6/9/25.
//

import UIKit

final class CalendarHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!

    func configure(title: String) {
        titleLabel.text = title
    }
}
