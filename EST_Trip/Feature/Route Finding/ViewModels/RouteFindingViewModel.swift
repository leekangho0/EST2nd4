//
//  RouteFindingViewModel.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/10/25.
//

import Foundation
import CoreLocation

final class RouteFindingViewModel {
    
    // [논현역 좌표, 서울숲역 좌표]
    private let testLocation1 = [CLLocationCoordinate2D(latitude: 37.510745, longitude: 127.021890), CLLocationCoordinate2D(latitude: 37.544172, longitude: 126.486440)]
    // [제주 공항 좌표, 제주 롯데시티 호텔 좌표]
    private let testLocation2 = [CLLocationCoordinate2D(latitude: 33.504663, longitude: 126.496481), CLLocationCoordinate2D(latitude: 33.490635, longitude: 126.486440)]
    
    /// 자동차 경로를 가져옵니다
    func fetchRoute() {
        Task {
            do {
                let features = try await RouteFindingNetworkManager.shared.fetchTmapRoutes(
                    from: testLocation2[0],
                    to: testLocation2[1]
                )
                
                let _ = parseFeatures(features: features)
            } catch {
                print("🚨 오류 발생: \(error.localizedDescription)")
            }
        }
    }
    
    /// 보행자 경로를 가져옵니다
    func fetchPedestrianRoute() {
        Task {
            do {
                let features = try await RouteFindingNetworkManager.shared.fetchTmapPedestrianRoute(
                    from: testLocation2[0],
                    to: testLocation2[1]
                )
                
                let _ = parseFeatures(features: features)
            } catch {
                print("🚨 오류 발생: \(error.localizedDescription)")
            }
        }
    }
    
    /// 대중교통 경로를 가져옵니다
    func fetchTransitRoute() {
        Task {
            do {
                let routes = try await RouteFindingNetworkManager.shared.fetchRoute(
                    from: testLocation1[0],
                    to: testLocation1[1]
                )
                
                let _ = parseRoutes(routes: routes)
            } catch {
                print("🚨 오류 발생: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Tmap API 보행자 경로 데이터 가공
extension RouteFindingViewModel {
    private func parseFeatures(features: [TmapRoutesAPIModels.Feature]) -> TmapRoute {
        var locations = [CLLocationCoordinate2D]()
        var totalTime = 0
        var totalDistance = 0
        
        for feature in features {
            let geometry = feature.geometry
            let coordinates = geometry.coordinates
            
            if geometry.type == .point {
                // Point면 [Double] 타입 (ex.[127.xxx, 35.xxx])
                var location: [Double] = []
                
                coordinates.forEach {
                    if case let .double(value) = $0 {
                        location.append(value)
                    }
                }
                
                if location.count == 2 {
                    locations
                        .append(
                            CLLocationCoordinate2D(
                                latitude: location[1],
                                longitude: location[0]
                            )
                        )
                }
            } else {
                // LineString이면 [[Double]] 타입 (ex. [[127.xx, 34.xx], [127.xx, 34.xx] ... ])
                coordinates.forEach {
                    if case let .doubleArray(value) = $0 {
                        if value.count == 2 {
                            locations
                                .append(
                                    CLLocationCoordinate2D(
                                        latitude: value[1],
                                        longitude: value[0]
                                    )
                                )
                        }
                    }
                }
            }
            
            let properties = feature.properties
            
            // 출발지(S)인 경우에만 totalTime과 totalDistance 정보를 포함합니다
            if properties.pointType == "S",
               let time = properties.totalTime,
                let distance = properties.totalDistance {
                totalTime = time
                totalDistance = distance
            }
        }
        
        return TmapRoute(
            distance: totalDistance,
            time: totalTime,
            locations: locations
        )
    }
}

// MARK: - Tmap API 보행자 경로 데이터 가공
extension RouteFindingViewModel {
    private func parseFeatures(features: [TmapPedestrianRouteAPIModels.Feature]) -> TmapPedestrianRoute {
        var locations = [CLLocationCoordinate2D]()
        var totalTime = 0
        var totalDistance = 0
        
        for feature in features {
            let geometry = feature.geometry
            let coordinates = geometry.coordinates
            
            if geometry.type == "Point" {
                // Point면 [Double] 타입 (ex.[127.xxx, 35.xxx])
                var location: [Double] = []
                
                coordinates.forEach {
                    if case let .double(value) = $0 {
                        location.append(value)
                    }
                }
                
                if location.count == 2 {
                    locations
                        .append(
                            CLLocationCoordinate2D(
                                latitude: location[1],
                                longitude: location[0]
                            )
                        )
                }
            } else {
                // LineString이면 [[Double]] 타입 (ex. [[127.xx, 34.xx], [127.xx, 34.xx] ... ])
                coordinates.forEach {
                    if case let .doubleArray(value) = $0 {
                        if value.count == 2 {
                            locations
                                .append(
                                    CLLocationCoordinate2D(
                                        latitude: value[1],
                                        longitude: value[0]
                                    )
                                )
                        }
                    }
                }
            }
            
            let properties = feature.properties
            
            if properties.pointType == "SP",
               let time = properties.totalTime,
                let distance = properties.totalDistance {
                totalTime = time
                totalDistance = distance
            }
        }
        
        return TmapPedestrianRoute(
            distance: totalDistance,
            time: totalTime,
            locations: locations
        )
    }
}

// MARK: - Google Route API로 받은 데이터 가공
extension RouteFindingViewModel {
    private func parseRoutes(routes: [GoogleRouteAPIModels.Route]) {
        for (index, route) in routes.enumerated() {
            print("🚀 \(index + 1)번째 경로")
            
            for (_, leg) in route.legs.enumerated() {
                for (index, step) in leg.steps.enumerated() {
                    let indexStep = "✅ Step \(index + 1) "
                    
                    if step.travelMode == "WALK" {
                        print("\(indexStep) 🚶🏼‍♂️ 걷기")
                    } else {
                        // 제주도는 버스만 이용 가능하므로, 교통수단을 버스로 제한
                        print("\(indexStep) 🚌 버스")
                        if let transitDetails = step.transitDetails,
                            let stopDetails = transitDetails.stopDetails {
                            
                            print("출발 정류장 : \(stopDetails.arrivalStop!.name!)")
                            print("\(transitDetails.stopCount!) 정류장 이동")
                            print("도착 정류장 : \(stopDetails.departureStop!.name!)")
                        }
                    }
                    
                    print("시간 : \(step.localizedValues!.staticDuration.text), 거리 : \(step.localizedValues!.distance.text)")
                }
            }
            
            print("🕒 총 시간 : \(route.duration!), 📍 총 거리 : \(route.distanceMeters!)")
            print("---------------------------------")
        }
    }
}

