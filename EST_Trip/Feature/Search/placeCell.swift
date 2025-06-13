//
//  PlaceCell.swift
//  EST_Trip
//
//  Created by 권도현 on 6/11/25.
//


import UIKit

class placeCell: UITableViewCell {
    // 스토리보드에서 연결
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!

    // 선택 버튼 액션 (SearchViewController로 전달)
    var onSelectTapped: (() -> Void)?

    @IBAction func selectButtonTapped(_ sender: UIButton) {
        onSelectTapped?()
    }

    // 셀의 내용을 설정
    func configure(with place: Place) {
        placeImageView.image = UIImage(named: place.imageName)
        titleLabel.text = place.title
        subtitleLabel.text = place.subtitle

        // 버튼 초기화
        selectButton.setTitle("선택", for: .normal)
        selectButton.backgroundColor = .systemGray5
        selectButton.setTitleColor(.black, for: .normal)
        selectButton.layer.cornerRadius = selectButton.frame.height / 2
        selectButton.layer.masksToBounds = true
    }
}
