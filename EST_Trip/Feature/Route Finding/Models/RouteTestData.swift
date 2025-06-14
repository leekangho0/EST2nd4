//
//  RouteTestData.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/13/25.
//

import UIKit

enum RouteTestData {
    
    enum Mode {
        case start, end
        case walk, boarding, alighting
        
        var title: String {
            switch self {
            case .start:
                return "출발"
            case .end:
                return "도착"
            case .walk:
                return "걷기"
            case .boarding:
                return "승차"
            case .alighting:
                return "하차"
            }
        }
    }
    
    struct Route {
        let mode: Mode
        var duration: Int? = nil
        var address: String? = nil
        var stop: Stop? = nil
        
        struct Stop {
            let departureName: String      // 출발지 이름
            let destinationName: String    // 도착지 이름
            let intermediateStops: [String]  // 중간 정류장 목록
            let busInfos: [BusInfo]       // 버스 번호 배열
        }
    }
    
    struct BusInfo {
        let name: String
        let color: UIColor
    }
}
