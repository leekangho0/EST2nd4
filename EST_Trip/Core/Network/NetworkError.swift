//
//  NetworkError.swift
//  EST_Trip
//
//  Created by kangho lee on 6/10/25.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case decodeError(String)
    case underlying(String)
}
