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
        
        /*
        let tollgateFareOption: Int // 요금 가중치 옵션
        let roadType: Int // 출발 지점의 도로 유형
        let directionOption: Int // 출발 지접의 주행 방향(우선/비우선)
        let endRpFlag: String // 길안내 요청 옵션
        let reqCoordType: String // 요청 좌표계
        let gpsTime: Int // GPS 시각
        let speed: Int // 차량 진행 속도 지정
        let uncetaintyP: Int // 위성 수를 지정
        let uncetaintyA: Int // 측위 방법을 지정
        let uncetaintyAP: Int // HDOP를 지정
        let carType: Int // 톨게이트 요금에 대한 차종을 지정
        let startName: String // 출발지 명칭
        let endName: String // 도착지 명칭
        let passList: String // 경유지 X좌표, Y좌표
        let gpsInfoList: String // GPS 궤적 정보를 지정
        let detailPosFlag: String // 고객의 상세 위치 확인 여부
        let resCoordType: String // 응답 좌표계
        let sort: String // 지리 정보 개체의 정렬 순서를 지정
        let endPoiId: String // 목적지 POI ID
        let angle: Int // GPS 각도
        let searchOption: Int // 경로 탐색 옵션
        let trafficInfo: String // 교통 정보 포함 여부
        let mainRoadInfo: String // 경로상 주요 도로 표출 여부
         let totalValue: Int // 검색 결과를 반환 방법 (1: 모든정보, 2: 요약정보)
         */
    }
}
