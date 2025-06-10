//
//  PlaceAPI.swift
//  EST_Trip
//
//  Created by kangho lee on 6/9/25.
//

import Foundation
import Moya

enum GooglePlacesAPI {
    case textSearch(query: String, location: String?, radius: Int?)
}

extension GooglePlacesAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://maps.googleapis.com/maps/api")!
    }

    var path: String {
        switch self {
        case .textSearch:
            return "place/textsearch/json"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case let .textSearch(query, location, radius):
            var params: [String: Any] = [
                "query": query,
                "key": APIKey.googleMaps.value
            ]
            if let location = location {
                params["location"] = location
            }
            if let radius = radius {
                params["radius"] = radius
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

    var sampleData: Data {
        return Data()
    }
}
