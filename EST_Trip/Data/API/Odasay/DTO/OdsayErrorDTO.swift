//
//  OdsayErrorModel.swift
//  EST_Trip
//
//  Created by kangho lee on 6/10/25.
//

import Foundation

extension Odsay {
    
    
    ///{
    ///  "error": [
    ///     {
    ///      "code": "500",
    ///      "message": "[ApiKeyAuthFailed] ApiKey authentication failed."
    ///     }
    ///  ]
    ///}
    struct ErrorResponse: Decodable {
        let error: [Message]
    }
    
    /// 500    서버 내부 오류
    /// -1    실시간 엔진 내부 오류
    /// -10    노선 정보가 없는 경우
    /// -11    실시간 정보 제공 지역이 아님
    /// -12    정류장 아이디가 잘못된 경우
    struct Message: Decodable {
        let code: String
        let message: String
    }
}

extension Odsay.ErrorResponse: CustomStringConvertible {
    var description: String {
        error.map { "code: \($0.code): message: \($0.message)" }.joined(separator: "\n")
    }
}
