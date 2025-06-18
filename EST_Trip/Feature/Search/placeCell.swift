//
//  PlaceCell.swift
//  EST_Trip
//
//  Created by 권도현 on 6/11/25.
//


import UIKit
import GooglePlaces
import GooglePlacesSwift

class placeCell: UITableViewCell {
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!

    var onSelectTapped: (() -> Void)?

    @IBAction func selectButtonTapped(_ sender: UIButton) {
        onSelectTapped?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        placeImageView.layer.cornerRadius = 8
        placeImageView.clipsToBounds = true
    }

    func configure(with model: GooglePlaceDTO) {
        let place = model.place
        titleLabel.text = place.displayName
        subtitleLabel.text = place.formattedAddress

        placeImageView.image = model.image ?? UIImage(systemName: "photo")

        selectButton.setTitle("선택", for: .normal)
        selectButton.backgroundColor = .systemGray5
        selectButton.setTitleColor(.label, for: .normal)
        selectButton.layer.cornerRadius = selectButton.frame.height / 2
        selectButton.layer.masksToBounds = true
    }
}
