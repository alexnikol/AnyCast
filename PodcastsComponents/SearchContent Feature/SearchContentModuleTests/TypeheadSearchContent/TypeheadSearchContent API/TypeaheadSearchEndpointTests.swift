// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SearchContentModule

final class TypeaheadSearchEndpointTests: XCTestCase {
    
    func test_generalSearch_endpointURL() {
        let baseURL = URL(string: "https://listen-api-test.listennotes.com")!
        let searchTerm = "any term"
        let received = SearchEndpoint.getTypeaheadSearch(term: searchTerm).url(baseURL: baseURL)
        let exptected = URL(string: "https://listen-api-test.listennotes.com/api/v2/typeahead?q=any%20term")

        XCTAssertEqual(received, exptected)
    }
}
