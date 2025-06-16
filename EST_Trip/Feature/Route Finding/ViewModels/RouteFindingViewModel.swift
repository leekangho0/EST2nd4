//
//  RouteFindingViewModel.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/10/25.
//

import UIKit
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
    func fetchTransitRoute(completion: @escaping (Result<Void, RouteFindingError>) -> Void) {
        Task {
            do {
                let routes = try await RouteFindingNetworkManager.shared.fetchRoute(
                    from: testLocation2[0],
                    to: testLocation2[1]
                )
                
                if let routeInfos = parseRoutes(routes: routes) {
                    self.routeInfos = routeInfos
                    completion(.success(()))
                } else {
                    completion(.failure(.distanceTooShort))
                }
            } catch {
                print("🚨 오류 발생: \(error.localizedDescription)")
                completion(.failure(.networkError(error)))
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
    private func parseRoutes(routes: [GoogleRouteAPIModels.Route]) -> [RouteInfo]? {
        var routeInfos = [RouteInfo]()
        
        for route in routes {
            
            // 700m 이내면 경로 탐색 불가 처리
            if route.distanceMeters ?? 0 <= 700 {
                return nil
            }
            
            var routes = [RouteInfo.Route]()
            
            for leg in route.legs {
                // 출발 정보
                if let startLocation = leg.startLocation?.latLng {
                    routes.append(
                        .init(
                            mode: .start,
                            location: CLLocationCoordinate2D(
                                latitude: startLocation.latitude,
                                longitude: startLocation.longitude
                            )
                        )
                    )
                }
                
                for step in leg.steps {
                    if step.travelMode == "WALK" {
                        routes.append(
                            .init(
                                mode: .walk,
                                duration: step.localizedValues?.staticDuration.text,
                                polyline: step.polyline?.encodedPolyline
                            )
                        )
                    } else if step.travelMode == "TRANSIT" {
                        if let transitDetails = step.transitDetails,
                            let stopDetails = transitDetails.stopDetails {
                            
                            // 승차 정보
                            routes.append(
                                .init(
                                    mode: .boarding,
                                    stop: .init(
                                        departureName: stopDetails.arrivalStop?.name ?? "-",
                                        stopCount: (transitDetails.stopCount ?? 1) - 1 , // 출발 정류장 제외
                                        busInfo: (transitDetails.transitLine.map {
                                            RouteInfo.BusInfo(name: $0.nameShort ?? "", color: $0.color ?? "")
                                        })
                                    ),
                                    polyline: step.polyline?.encodedPolyline
                                )
                            )
                            
                            // 하차 정보
                            routes.append(
                                .init(
                                    mode: .alighting,
                                    address: stopDetails.departureStop?.name ?? "-"
                                )
                            )
                        }
                    }
                }
                
                // 도착 정보
                if let endLocation = leg.endLocation?.latLng {
                    routes.append(
                        .init(
                            mode: .end,
                            location: CLLocationCoordinate2D(
                                latitude: endLocation.latitude,
                                longitude: endLocation.longitude
                            )
                        )
                    )
                }
            }
            
            let durationString = route.duration?.filter { $0.isNumber } ?? ""
            
            dump(routes)
            
            routeInfos.append(
                RouteInfo(
                    duration: Int(durationString) ?? 0,
                    distance: route.distanceMeters ?? 0,
                    routes: routes
                )
            )
        }
        
        return routeInfos
    }
}

