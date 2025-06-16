//
//  ScheduleListHeaderView.swift
//  EST_Trip
//
//  Created by 고재현 on 6/12/25.
//

import UIKit

class ScheduleListHeaderView: UIView {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addPlaceButton: UIButton!
    @IBOutlet weak var addMemoButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("ScheduleListHeaderView", owner: self, options: nil)
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addButtonStyles()
    }

    private func addButtonStyles() {
        let borderColor = UIColor.black.cgColor
        [addPlaceButton, addMemoButton].forEach { button in
            button?.layer.borderWidth = 1
            button?.layer.borderColor = borderColor
            button?.layer.cornerRadius = 8
            button?.clipsToBounds = true
        }
    }
}
