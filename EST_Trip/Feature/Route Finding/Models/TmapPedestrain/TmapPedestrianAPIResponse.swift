//
//  TmapPedestrianAPIResponse.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/10/25.
//

import Foundation

extension TmapPedestrianRouteAPIModels {
    // MARK: - TmapPedestrianAPIResponse
    struct Response: Codable {
        let type: String // "FeatureCollection"
        let features: [Feature]
    }

    // MARK: - Feature
    struct Feature: Codable {
        let type: String
        let geometry: Geometry
        let properties: Properties
    }

    // MARK: - Geometry
    struct Geometry: Codable {
        let type: String // Point, LineString
        let coordinates: [Coordinate]
    }

    enum Coordinate: Codable {
        case double(Double)
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

    // MARK: - Properties
    struct Properties: Codable {
        let totalDistance: Int? // 경로 총 거리(m)
        let totalTime: Int? // 경로 총 소요시간(초)
        let index: Int? // 경로 순번
        let pointIndex: Int? // 아이콘 노드
        let name: String? // 안내 지점의 명칭
        let description: String? // 길 안내 정보
        let direction: String? // 방면 명칭
        let nearPoiName: String? // 안내 지점 주변 관심 장소 명칭
        let nearPoiX: String? // 안내 지점 주변 관심 장소의 좌표 (경도)
        let nearPoiY: String? // 안내 지점 주변 관심 장소의 좌표 (위도)
        let intersectionName: String? // 교차로 명칭
        let facilityType: String? // 도로 종류 지정
        let facilityName: String? // 구간 시설물 유형의 명칭
        let turnType: Int? // 회전 정보
        let pointType: String? // 안내 지점 유형
        let lineIndex: Int?
        let distance: Int?
        let time: Int?
        let roadType: Int? //도로 유형 정보
        let categoryRoadType: Int? // 특화 거리 정보
    }
}
