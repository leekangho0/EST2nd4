//
//  OdsayTests.swift
//  EST_TripTests
//
//  Created by kangho lee on 6/10/25.
//

import XCTest
@testable import EST_Trip

final class OdsayTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTransportAPI() throws {
        let provider = OdsayProvider()
        
        // 제주 공항 -> 오설록 티뮤지엄
        let dto = makeJejuAiportToOserlock()
        let exp = expectation(description: "exp")
        provider.transport(type: Odsay.Transport.self, route: dto) { result in
            switch result {
            case .success(let success):
                XCTAssertEqual(1, 1)
            case .failure(let failure):
                XCTFail(failure.localizedDescription)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    private func makeJejuAiportToOserlock() -> RouteTransportDTO {
        RouteTransportDTO(
            startX: 126.49306, startY: 33.51139,
            endX: 126.2901309, endY: 33.30601
        )
    }

}
