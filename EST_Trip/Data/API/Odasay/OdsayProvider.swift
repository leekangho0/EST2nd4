//
//  Provider.swift
//  EST_Trip
//
//  Created by kangho lee on 6/10/25.
//

import Foundation
import Moya

class OdsayProvider {
    typealias Target = OdsayAPI
    
    private let provider: MoyaProvider<Target>
    
    init() {
        provider = MoyaProvider<Target>(plugins: [NetworkLoggerPlugin()])
    }
    
    func transport<D: Decodable>(type: D.Type, route: RouteTransportDTO, completion: @escaping ((Result<D, Error>) -> Void)) {
        provider.request(.transport(dto: route)) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode(D.self, from: response.data)
                    completion(.success(model))
                } catch {
                    guard let errorResponse = try? JSONDecoder().decode(Odsay.ErrorResponse.self, from: response.data) else {
                        if let rawString = String(data: response.data, encoding: .utf8) {
                            print(rawString)
                        }
                        completion(.failure(NetworkError.decodeError(error.localizedDescription)))
                        return
                    }
                    
                    completion(.failure(NetworkError.underlying(errorResponse.description)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
