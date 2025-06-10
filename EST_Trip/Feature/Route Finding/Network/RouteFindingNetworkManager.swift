//
//  RouteFindingNetworkManager.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/10/25.
//

import Foundation
import CoreLocation

final class RouteFindingNetworkManager {
    
    enum GoogleAPI {
        static let baseURL = "https://routes.googleapis.com"
        
        enum Directions {
            static let computeRoutes = "\(GoogleAPI.baseURL)/directions/v2:computeRoutes"
        }
    }
    
    static let shared = RouteFindingNetworkManager()
    private init() {}
}

// MARK: - Google Route API
extension RouteFindingNetworkManager {
    func fetchRoute(
        from origin: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D
    ) async throws -> [GoogleRouteAPIModels.Route] {
        let body = GoogleRouteAPIModels.Request(
            origin: .init(
                location: .init(
                    latLng: .init(
                        latitude: origin.latitude,
                        longitude: origin.longitude
                    )
                )
            ),
            destination: .init(
                location: .init(
                    latLng: .init(
                        latitude: destination.latitude,
                        longitude: destination.longitude
                    )
                )
            ),
            travelMode: "TRANSIT",
            computeAlternativeRoutes: true,
            languageCode: "ko-KR"
        )
        
        guard let jsonData = try? JSONEncoder().encode(body) else {
            throw EncodingError.invalidValue(body, .init(codingPath: [], debugDescription: "Failed to encode body"))
        }
        
        guard var components = URLComponents(string: GoogleAPI.Directions.computeRoutes) else {
            throw URLError(.badURL)
        }
        components.queryItems = [
            URLQueryItem(name: "key", value: APIKey.googleMaps.value)
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(APIKey.googleMaps.value, forHTTPHeaderField: "X-Goog-Api-Key")
        // 서버 응답에서 받을 필드를 지정
        request.setValue(
            "routes.duration," +
            "routes.distanceMeters," +
            "routes.polyline.encodedPolyline," +
            "routes.legs.steps," +
            "routes.legs.steps.transitDetails"
            ,forHTTPHeaderField: "X-Goog-FieldMask"
        )
        request.setValue(Bundle.main.bundleIdentifier, forHTTPHeaderField: "X-Ios-Bundle-Identifier")

        let (data, _) = try await URLSession.shared.data(for: request)
        
//        print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "none")")
        
        let response = try JSONDecoder().decode(GoogleRouteAPIModels.Response.self, from: data)
        
        return response.routes ?? []
    }
}



