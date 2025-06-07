//
//  APIKey.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/8/25.
//

import Foundation

enum APIKey: String {
    case googleMaps = "GoogleAPIKey"
    
    var value: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: self.rawValue) as? String, !key.isEmpty else {
            fatalError("\(self.rawValue) is missing! Please check your Info.plist or xcconfig setup.")
        }
        return key
    }
}
