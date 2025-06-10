//
//  TmapRoutesAPIResponse.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/10/25.
//

import Foundation

extension TmapRoutesAPIModels {
    // MARK: - Response
    struct Response: Codable {
//        let usedFavoriteRouteVertices: String?
        let type: String
        let features: [Feature]
    }
    
    // MARK: - Feature
    struct Feature: Codable {
        let type: FeatureType
        let geometry: Geometry
        let properties: Properties
    }

    // MARK: - Geometry
    struct Geometry: Codable {
        let type: GeometryType
        let coordinates: [Coordinate]
    }

    enum Coordinate: Codable {
        // 위경도 좌표 쌍이 1개일 때: [x1좌표, y1좌표]
        case double(Double)
        // 위경도 좌표 쌍이 2개 이상일 때: [[x1좌표, y1좌표], [x2좌표, y2좌표]]
        case doubleArray([Double])

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode([Double].self) {
                self = .doubleArray(x)
                return
            }
            if let x = try? container.decode(Double.self) {
                self = .double(x)
                return
            }
            throw DecodingError.typeMismatch(Coordinate.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Coordinate"))
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .double(let x):
                try container.encode(x)
            case .doubleArray(let x):
                try container.encode(x)
            }
        }
    }

    enum GeometryType: String, Codable {
        case lineString = "LineString"
        case point = "Point"
    }

    // MARK: - Properties
    struct Properties: Codable {
        let totalDistance: Int? // 경로 총 거리
        let totalTime: Int? // 경로 총 소요시간
        let totalFare: Int? // 경로 총 요금
        let taxiFare: Int? // 택시 예상 요금
        let index: Int // 경로 순번
        let pointIndex: Int? // 아이콘 노드
        let name: String? // 안내 지점의 명칭
        let description: String? // 길 안내 정보
        let nextRoadName: String? // 다음 구간의 도로 명칭
        let turnType: Int?  // 회전 정보
        let pointType: String? // 안내 지점 유형
        let lineIndex: Int? // 안내 지점의 노드 순번
        let distance: Int?  // 구간 거리
        let time: Int? // 구간 통과 시간
        let roadType: Int? // 도로 유형 정보
        let facilityType: Int? // 구간의 시설물 유형 정보
    }

    enum FeatureType: String, Codable {
        case feature = "Feature"
    }
}
