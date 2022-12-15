// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import MapperLibrary

class GenericAPIMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPURLResponse() throws {
        let validJSON = Data("{ \"string\": \"result\" }".utf8)
        
        try [199, 201, 400, 500].forEach { code in
            XCTAssertThrowsError(
                try SUT.map(validJSON, from: HTTPURLResponse(statusCode: code), domainMapper: DomainModel.init)
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try SUT.map(invalidJSON, from: HTTPURLResponse(statusCode: 200), domainMapper: DomainModel.init)
        )
    }
    
    // MARK: - Helpers
    
    private typealias SUT = GenericAPIMapper<RemoteModel, DomainModel>
    
    private struct RemoteModel: Decodable {
        let string: String
    }
    
    private struct DomainModel {
        let string: String
        
        init(remoteModel: RemoteModel) {
            self.string = remoteModel.string
        }
    }
}

private extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        let anyURL = URL(string: "https://a-url.com")!
        self.init(url: anyURL, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
