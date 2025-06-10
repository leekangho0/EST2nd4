//
//  TmapRoutesAPIRequest.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/10/25.
//

import Foundation

// https://openapi.sk.com/products/detail?svcSeq=4&menuSeq=46

struct TmapRoutesAPIModels {
    // MARK: - Request
    struct Request: Codable {
        let startX: Double // 출발지 X좌표(경도)
        let startY: Double // 출발지 Y좌표(위도)
        let endX: Double // 목적지 X좌표(경도)
        let endY: Double // 목적지 Y좌표(위도)
    }
}
