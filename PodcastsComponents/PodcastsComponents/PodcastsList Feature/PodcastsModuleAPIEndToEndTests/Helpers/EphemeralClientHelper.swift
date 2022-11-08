// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import HTTPClient
import URLSessionHTTPClient

protocol EphemeralClientHelpers {
    func ephemeralClient(file: StaticString, line: UInt) -> HTTPClient
}

extension EphemeralClientHelpers where Self: XCTestCase {
    func ephemeralClient(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }
}
