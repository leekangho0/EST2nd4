//
//  RouteFindingError.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/16/25.
//

import Foundation

enum RouteFindingError: Error {
    case distanceTooShort
    case networkError(Error)
    
    var localizedDescription: String {
        switch self {
        case .distanceTooShort:
            return "700m 이내 경로"
        case .networkError(let error):
            return error.localizedDescription
        }
    }
    
    var message: String {
        switch self {
        case .distanceTooShort:
            return "700m 이내는 경로 검색이 지원되지 않습니다."
        case .networkError(let error):
            return "경로 검색 결과가 없습니다."
        }
    }
}
