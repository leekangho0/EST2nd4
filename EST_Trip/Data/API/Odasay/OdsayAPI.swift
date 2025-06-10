//
//  OdsayAPI.swift
//  EST_Trip
//
//  Created by kangho lee on 6/10/25.
//

import Foundation
import Moya

enum OdsayAPI {
    case transport(dto: RouteTransportDTO)
}

extension OdsayAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://api.odsay.com/v1/api")!
    }
    
    var path: String {
        return "searchPubTransPathT"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .transport(let dto):
            let parameter: [String: Any] = [
                "SX": dto.startX, "SY": dto.startY,
                "EX": dto.endX, "EY": dto.endY
            ].merging([
                "apiKey": APIKey.odsayKey.value
            ]) { $1 }
            
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
