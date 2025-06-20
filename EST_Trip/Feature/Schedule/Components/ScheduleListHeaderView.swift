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
    
    @IBOutlet weak var editConfirmButton: UIButton!
    
    var endEdit: (() -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //commonInit()
    }
    
    private func commonInit() {
        if let view = Bundle.main.loadNibNamed("ScheduleListHeaderView", owner: self, options: nil)?.first as? UIView {
            addSubview(view)
            view.frame = bounds
        }
        
/*
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.setTitle(nil, for: .normal)
        
        addPlaceButton.setTitle("장소 추가", for: .normal)
        addMemoButton.setTitle("메모 추가", for: .normal)
        
        addButtonStyles()
 */
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    @IBAction func endEdit(_ sender: Any) {
        addPlaceButton.isHidden = false
        editConfirmButton.isHidden = true
        
        endEdit?()
    }
}
