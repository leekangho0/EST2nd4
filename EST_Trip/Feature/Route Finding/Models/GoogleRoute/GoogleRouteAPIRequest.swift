//
//  GoogleRouteAPIRequest.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/10/25.
//

import Foundation
import CoreLocation

struct GoogleRouteAPIModels {
    // MARK: - RouteAPIRequest
    struct Request: Codable {
        // 출발 좌표
        let origin: Waypoint
        // 도착 좌표
        let destination: Waypoint
        // 이동수단
        let travelMode: String
        // 최적 경로 외에 여러 대체 경로 요청
        let computeAlternativeRoutes: Bool
        // 응답 메세지 언어 코드
        let languageCode: String
    }
    
    // MARK: - Waypoint (위치 정보)
    struct Waypoint: Codable {
        let location: Location
    }
    
    // MARK: - Location
    struct Location: Codable {
        let latLng: LatLng // 위도/경도 좌표
    }
    
    // MARK: - LatLng (위도, 경도)
    struct LatLng: Codable {
        let latitude: Double
        let longitude: Double
    }
}

