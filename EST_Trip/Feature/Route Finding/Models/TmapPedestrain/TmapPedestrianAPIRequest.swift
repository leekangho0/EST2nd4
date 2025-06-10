//
//  TmapPedestrianAPIRequest.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/10/25.
//

import Foundation

struct TmapPedestrianRouteAPIModels {
    // MARK: - TmapTransitAPIRequest
    struct Request: Codable {
        let startX: String // 출발지 좌표(경도)
        let startY: String // 출발지 좌표(위도)
        let endX: String // 목적지 좌표(경도)
        let endY: String // 목적지 좌표(위도)
        // 출발지 명칭, 필수값이라 빈 문자열대신 기본값 설정
        var startName: String = "%"
        // 목적지 명칭, 필수값이라 빈 문자열대신 기본값 설정
        var endName: String = "%"
    }
}
