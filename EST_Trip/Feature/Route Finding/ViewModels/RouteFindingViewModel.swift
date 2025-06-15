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
    
    var routeInfos = [RouteInfo]()
    
    /// 자동차 경로를 가져옵니다
    func fetchDrivingRoute(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let features = try await RouteFindingNetworkManager.shared.fetchTmapRoutes(
                    from: testLocation2[0],
                    to: testLocation2[1]
                )
                
                let routeInfo = parseFeatures(features: features)
                routeInfos = [routeInfo]
                
                completion(.success(()))
            } catch {
                print("🚨 오류 발생: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    /// 보행자 경로를 가져옵니다
    func fetchPedestrianRoute(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                let features = try await RouteFindingNetworkManager.shared.fetchTmapPedestrianRoute(
                    from: testLocation2[0],
                    to: testLocation2[1]
                )
                
                let routeInfo = parseFeatures(features: features)
                routeInfos = [routeInfo]
                
                completion(.success(()))
            } catch {
                print("🚨 오류 발생: \(error.localizedDescription)")
                completion(.failure(error))
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
    private func parseFeatures(features: [TmapRoutesAPIModels.Feature]) -> RouteInfo {
        var locations = [CLLocationCoordinate2D]()
        var totalDuration = 0
        var totalDistance = 0
        var totalFare = 0
        var taxiFare = 0
        
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
            if properties.pointType == "S" {
                if let time = properties.totalTime,
                   let distance = properties.totalDistance {
                    totalDuration = time
                    totalDistance = distance
                }
                
                if let fare = properties.totalFare {
                    totalFare = fare
                }
                
                if let taxi = properties.taxiFare {
                    taxiFare = taxi
                }
            }
        }
        
        return RouteInfo(
            duration: totalDuration,
            distance: totalDistance,
            locations: locations,
            taxiFare: taxiFare,
            fare: totalFare
        )
    }
}

// MARK: - Tmap API 보행자 경로 데이터 가공
extension RouteFindingViewModel {
    private func parseFeatures(features: [TmapPedestrianRouteAPIModels.Feature]) -> RouteInfo {
        var locations = [CLLocationCoordinate2D]()
        var totalDuration = 0
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
            
            // 출발지(SP)인 경우에만 전체 보행 시간과 거리 정보를 제공함
            if properties.pointType == "SP",
               let time = properties.totalTime,
               let distance = properties.totalDistance {
                totalDuration = time
                totalDistance = distance
            }
        }
        
        return RouteInfo(
            duration: totalDuration,
            distance: totalDistance,
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

