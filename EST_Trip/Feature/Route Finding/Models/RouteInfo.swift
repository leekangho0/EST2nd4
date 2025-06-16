//
//  RouteInfo.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/15/25.
//

import UIKit
import CoreLocation

struct RouteInfo {
    let duration: Int // 총 걸린시간
    let distance: Int // 총 거리
    var locations: [CLLocationCoordinate2D]? = nil // 경로 좌표
    var taxiFare: Int? = nil // 택시요금
    var fare: Int? = nil // 요금
    var walkDuration: Int? = nil // 총 도보시간
    var routes: [Route]? = nil // 대중교통 상세경로 최상위 노드
    
    struct Route {
        let mode: Mode // 타입 (ex. 걷기, 승차, 하차, 출발, 도착)
        var duration: String? // 걸린 시간 (ex. 도보 20분 이동)
        var address: String? // 승/하차 일때 주소 정보 및 하차시 정류장 정보 (ex. 출발 - 제주도 제주시, 하차 - 제주공항 )
        var stop: Stop? // 승차시 정류장 및 버스 정보
        var location: CLLocationCoordinate2D? // 출/도착 좌표
        var polyline: String?
    }
    
    struct Stop {
        let departureName: String // 승차 정류장 이름
//        let intermediateStops: [String]  // 중간 정류장 목록
        let stopCount: Int
        let busInfo: BusInfo? // 버스 정보
    }
    
    struct BusInfo {
        let name: String // 버스 번호
        let color: String // 버스 노선 색상
    }
    
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
}

extension RouteInfo {
    func durationText() -> String {
        let seconds = self.duration
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)시간 \(minutes)분"
        } else {
            return "\(minutes)분"
        }
    }
    
    func distanceText() -> String {
        let meters = self.distance
        
        if meters < 1000 {
            return "\(meters)m"
        } else {
            let kilometers = Double(meters) / 1000.0
            return String(format: "%.1fkm", kilometers)
        }
    }
    
    func taxiFareText() -> String {
        if let taxiFare {
            return "택시 요금 약 \(taxiFare)원"
        } else {
            return ""
        }
    }
    
    func fareText() -> String {
        if let fare {
            return "운행 요금 약 \(fare)원"
        } else {
            return ""
        }
    }
    
    func walkDurationText() -> String {
        if let walkDuration {
            return "도보이동 \(walkDuration)분"
        } else {
            return ""
        }
    }
}
