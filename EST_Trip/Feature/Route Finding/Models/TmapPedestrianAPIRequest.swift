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
//        var endPoiId: String = ""  목적지 POI ID
        let endX: String // 목적지 좌표(경도)
        let endY: String // 목적지 좌표(위도)
//        var passList: String = "" // 경유지의 X좌표, Y좌표
//        var reqCoordType: String = "WGS84GEO" // 요청 좌표계
        let startName: String // 출발지 명칭 (UTF-8기반의 URL 인코딩 처리)
        let endName: String // 목적지 명칭
//        var searchOption: String = "0" // 경로 탐색 옵션
//        var resCoordType: String = "WGS84GEO" // 응답 좌표계
//        var sort: String = "index"
    }
}
