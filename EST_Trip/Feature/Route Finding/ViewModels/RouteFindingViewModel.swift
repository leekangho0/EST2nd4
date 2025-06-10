//
//  RouteFindingViewModel.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/10/25.
//

import Foundation
import CoreLocation

final class RouteFindingViewModel {
    
}

// MARK: - Google Route API로 받은 데이터 가공
extension RouteFindingViewModel {
    func parseRoutes(routes: [GoogleRouteAPIModels.Route]) {
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

