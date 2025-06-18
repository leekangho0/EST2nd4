//
//  GMSMarker.swift
//  EST_Trip
//
//  Created by kangho lee on 6/17/25.
//

import Foundation
import GoogleMaps

extension GMSMarker {
    static func createNumberedPinImage(number: Int, size: CGSize = CGSize(width: 44, height: 44)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            // Draw base pin
            let pinPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.width))
            UIColor.sunsetCoral.setFill()
            pinPath.fill()
            
            let smallPinPath = UIBezierPath(ovalIn: CGRect(x: 5, y: 5, width: size.width - 10, height: size.width - 10))
            UIColor.canolaSand.setFill()
            smallPinPath.fill()
            
            // Draw number text
            let numberText = "\(number)" as NSString
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 15),
                .foregroundColor: UIColor.sunsetCoral
            ]
            let textSize = numberText.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.width - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            numberText.draw(in: textRect, withAttributes: attributes)
        }
    }
    static func createNumberedMarkerImage(number: Int, size: CGSize = CGSize(width: 30, height: 20)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            //            let ctx = context.cgContext
            
            // 1. 마커 모양 (물방울)
            let pinPath = UIBezierPath()
            let width = size.width
            let height = size.height
            let radius = width / 2
            
            // 원 + 꼬리 만들기
            pinPath.addArc(withCenter: CGPoint(x: width/2, y: radius), radius: radius, startAngle: 0, endAngle: .pi, clockwise: true)
            pinPath.addArc(withCenter: CGPoint(x: width/2, y: radius), radius: radius, startAngle: .pi, endAngle: .pi * 2, clockwise: true)
            
            pinPath.addLine(to: CGPoint(x: width/2 + 10, y: height - 10))
            pinPath.addLine(to: CGPoint(x: width/2, y: height)) // 꼬리
            pinPath.addLine(to: CGPoint(x: width/2 - 10, y: height - 10))
            pinPath.close()
            
            UIColor.systemRed.setFill()
            pinPath.fill()
            
            // 2. 텍스트 (번호)
            let numberText = "\(number)" as NSString
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 12),
                .foregroundColor: UIColor.white
            ]
            let textSize = numberText.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (width - textSize.width) / 2,
                y: (radius - textSize.height / 2),
                width: textSize.width,
                height: textSize.height
            )
            numberText.draw(in: textRect, withAttributes: attributes)
        }
    }
}
