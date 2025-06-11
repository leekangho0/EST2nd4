//
//  OdsayResponse.swift
//  EST_Trip
//
//  Created by kangho lee on 6/10/25.
//

import Foundation

enum Odsay {

    // 전체 응답 객체의 루트 구조
    struct Transport: Codable {
        let result: Response
    }

    // MARK: - Result
    /// API 응답의 핵심 정보 포함
    struct Response: Codable {
        let searchType: Int              // 경로 탐색 타입 (0: 전체, 1:지하철, 2:버스)
        let outTrafficCheck: Int         // 외부 교통(도보/택시) 포함 여부
        let busCount: Int                // 버스 경로 개수
        let subwayCount: Int             // 지하철 경로 개수
        let subwayBusCount: Int          // 지하철+버스 환승 경로 개수
        let pointDistance: Int           // 출발지~도착지 직선 거리 (m)
        let startRadius: Int             // 출발지 반경 검색 범위
        let endRadius: Int               // 도착지 반경 검색 범위
        let path: [Path]                 // 실제 경로들 (최대 5개)
    }

    // MARK: - Path
    /// 하나의 경로 정보 (환승 포함)
    struct Path: Codable {
        let pathType: Int                // 경로 타입 (1: 지하철, 2: 버스, 3: 지하철+버스)
        let info: Info                   // 경로 요약 정보
        let subPath: [SubPath]           // 하위 경로 목록 (도보, 버스, 지하철 등으로 분할)
    }

    // MARK: - Info
    /// 경로 요약 정보 (요금, 소요시간, 거리 등)
    struct Info: Codable {
        let trafficDistance: Int         // 실제 교통 이동 거리 (m)
        let totalWalk: Int               // 전체 도보 거리 (m)
        let totalTime: Int               // 전체 소요 시간 (분)
        let payment: Int                 // 기본 요금 (원)
        let busTransitCount: Int         // 버스 환승 횟수
        let subwayTransitCount: Int      // 지하철 환승 횟수
        let mapObj: String               // 지도용 인코딩 문자열
        let firstStartStation: String    // 출발 정류소 이름
        let lastEndStation: String       // 도착 정류소 이름
        let totalStationCount: Int       // 전체 정류장 수
        let busStationCount: Int         // 버스 정류장 수
        let subwayStationCount: Int      // 지하철 정류장 수
        let totalDistance: Int           // 총 이동 거리 (도보 포함, m)
        let totalWalkTime: Int           // 전체 도보 시간 (분)
        let checkIntervalTime: Int       // 막차 체크 시간
        let checkIntervalTimeOverYn: String // 막차 시간 초과 여부 ("Y"/"N")
        let totalIntervalTime: Int       // 전체 이동 간격 시간 (분)
    }

    // MARK: - SubPath
    /// 경로 내 세부 구간 정보 (지하철, 버스, 도보 등)
    struct SubPath: Codable {
        let trafficType: Int             // 1: 지하철, 2: 버스, 3: 도보
        let distance: Int                // 구간 거리 (m)
        let sectionTime: Int             // 구간 소요 시간 (분)
        
        let stationCount: Int?           // 정차역 수 (지하철/버스일 경우)
        let lane: [Lane]?                // 노선 정보 (버스: 번호, 지하철: 호선 등)
        let intervalTime: Int?           // 배차 간격 (분)
        
        let startName: String?           // 출발 정류소/역명
        let startX, startY: Double?      // 출발 정류소 좌표
        let endName: String?             // 도착 정류소/역명
        let endX, endY: Double?          // 도착 정류소 좌표

        // 내부 시스템용 ID 및 기타 메타 정보
        let startID, startStationCityCode, startStationProviderCode: Int?
        let startLocalStationID, startArsID: String?
        let endID, endStationCityCode, endStationProviderCode: Int?
        let endLocalStationID, endArsID: String?

        let passStopList: PassStopList?  // 지나가는 정류장 목록
    }

    // MARK: - Lane
    /// 해당 SubPath에 연결된 버스 또는 지하철 노선 정보
    struct Lane: Codable {
        let busNo: String                // 버스 번호 또는 지하철 호선
        let type: Int                    // 노선 타입 (버스 종류 코드 등)
        let busID: Int                   // 내부 시스템용 버스 ID
        let busLocalBlID: String         // 지역 블록 ID
        let busCityCode: Int             // 지역 코드
        let busProviderCode: Int         // 운수사 코드
    }

    // MARK: - PassStopList
    /// 경로에서 지나가는 정류장/역 목록
    struct PassStopList: Codable {
        let stations: [Station]
    }

    // MARK: - Station
    /// 각 정류장/역에 대한 정보
    struct Station: Codable {
        let index: Int                   // 경로 내 순번
        let stationID: Int               // 정류장 ID
        let stationName: String          // 정류장/역 이름
        let stationCityCode: Int         // 지역 코드
        let stationProviderCode: Int     // 운수사 코드
        let localStationID: String       // 지역 정류장 ID
        let arsID: String                // ARS 번호
        let x, y: String                 // 위도/경도 (WGS84 기준)
        let isNonStop: IsNonStop         // 무정차 통과 여부
    }

    // MARK: - IsNonStop
    enum IsNonStop: String, Codable {
        case n = "N"                     // "N"이면 정차함 (현재는 정적 값)
    }
}

