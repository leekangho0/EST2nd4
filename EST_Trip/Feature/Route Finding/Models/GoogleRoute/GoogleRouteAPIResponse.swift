//
//  GoogleRouteAPIResponse.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/10/25.
//

import Foundation

extension GoogleRouteAPIModels {
    // MARK: - RouteAPIResponse
    struct Response: Codable {
        let routes: [Route]?
    }

    // MARK: - Route
    struct Route: Codable {
        let legs: [RouteLeg]
        let distanceMeters: Int? // 총 거리 (미터)
        let duration: String? // 총 소요 시간 (초 단위 문자열, 예: "1200s")
        let polyline: Polyline? // 경로를 그리기 위한 폴리라인 인코딩 데이터
        let staticDuration: String? // 대중교통 경로의 경우, 정적 소요 시간 (실시간 반영 전)
    }

    // MARK: - RouteLeg (경로의 각 구간)
    struct RouteLeg: Codable {
        let steps: [RouteStep]
        let distanceMeters: Int?
        let duration: String?
        let staticDuration: String?
        let startLocation: Location?
        let endLocation: Location?
    }

    // MARK: - RouteStep (경로의 각 단계, 예: 걷기, 버스 타기)
    struct RouteStep: Codable {
        let distanceMeters: Int?
        let staticDuration: String?
        let polyline: Polyline?
        let startLocation: Location?
        let endLocation: Location?
        let navigationInstruction: NavigationInstruction?
        let localizedValues: LocalizedValues?
        let transitDetails: TransitDetails? // 대중교통 경로일 경우에만 존재
        let travelMode: String? // "TRANSIT", "WALK" 등
    }

    // MARK: - Polyline (경로)
    struct Polyline: Codable {
        let encodedPolyline: String? // 폴리라인 인코딩 문자열
    }

    // MARK: - NavigationInstruction
    struct NavigationInstruction: Codable {
        let instructions: String? // 예: 버스 신사동행
    }

    // MARK: - LocalizedValues (로컬라이징 된 텍스트, 예: 47 m, 1분)
    struct LocalizedValues: Codable {
        let distance: LocalizedText
        let staticDuration: LocalizedText
    }

    // MARK: - LocalizedText (LocalizedValues 세부 정보)
    struct LocalizedText: Codable {
        let text: String
    }

    // MARK: - TransitDetails (대중교통 세부 정보)
    struct TransitDetails: Codable {
        let stopDetails: StopDetails? // 출발/도착 정류장 or 역 정보
        let localizedValues: LocalizedValues?
        let headsign: String? // 종착역/방향 (예: "제주공항 방면")
        let transitLine: TransitLine? // 노선 정보
        let stopCount: Int?    // 해당 노선에서 지나가는 정류장 수
        
        struct LocalizedValues: Codable {
            let arrivalTime: LocalizedTimeValues
            let departureTime: LocalizedTimeValues
        }
        
        struct LocalizedTimeValues: Codable {
            let time: LocalizedText
            let timeZone: String?
        }
    }

    // MARK: - StopDetails (출발/도착 정류장 정보)
    struct StopDetails: Codable {
        let arrivalStop: Stop?
        let arrivalTime: String?
        let departureStop: Stop?
        let departureTime: String?
    }

    // MARK: - Stop (정류장 정보)
    struct Stop: Codable {
        let name: String? // 정류장 이름
        let location: Location? // 정류장 위치
    }

    // MARK: - TransitLine (대중교통 노선 정보)
    struct TransitLine: Codable {
        let agencies: [TransitAgency]? // 운영 기관 정보
        let name: String? // 노선 이름 (예: 제주 간선버스)
        let color: String? // 노선 색상
        let nameShort: String? // 노선 번호 (예: 360(부영아파트)
        let textColor: String?
        let vehicle: TransitVehicle? // 차량 정보 (버스, 지하철 등)
    }

    // MARK: - TransitAgency (대중교통 운영 기관)
    struct TransitAgency: Codable {
        let name: String? // 기관 이름 (예: "제주특별자치도 버스")
        let uri: String? // 기관 웹사이트 URL (선택 사항)
    }

    // MARK: - TransitVehicle (대중교통 차량 정보)
    struct TransitVehicle: Codable {
        let name: LocalizedText? // 차량 종류 이름 (예: "버스", "지하철")
        let type: String? // 차량 종류 타입 (예: "BUS", "SUBWAY", "TRAIN", "TRAM" 등)
        let iconUri: String?
    }

}
