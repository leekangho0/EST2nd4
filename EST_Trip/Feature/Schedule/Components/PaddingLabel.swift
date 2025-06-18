//
//  PaddingLabel.swift
//  EST_Trip
//
//  Created by 고재현 on 6/13/25.
//

import UIKit

class PaddingLabel: UILabel {
    
    // 패딩 값 지정 (기본값: 위4, 좌우8, 아래4)
    var padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
    override func drawText(in rect: CGRect) {
        // 텍스트를 패딩만큼 안쪽에서 그리기
        let paddedRect = rect.inset(by: padding)
        super.drawText(in: paddedRect)
    }
    
    override var intrinsicContentSize: CGSize {
        // 패딩만큼 크기를 늘려줌
        let size = super.intrinsicContentSize
        let width = size.width + padding.left + padding.right
        let height = size.height + padding.top + padding.bottom
        return CGSize(width: width, height: height)
    }
}
