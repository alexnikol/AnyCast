// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SearchContentModule

final class GeneralSearchEndpointTests: XCTestCase {
    
    func test_generalSearch_endpointURL() {
        let baseURL = URL(string: "https://listen-api-test.listennotes.com")!
        let searchTerm = "any term"
        let received = SearchEndpoint.getGeneralSearch(term: searchTerm).url(baseURL: baseURL)
        let exptected = URL(string: "https://listen-api-test.listennotes.com/api/v2/search?q=any%20term")
        
        XCTAssertEqual(received, exptected)
    }
}
