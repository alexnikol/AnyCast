// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import HTTPClient
import URLSessionHTTPClient

protocol EphemeralClient {
    func ephemeralClient(file: StaticString, line: UInt) -> HTTPClient
    func fetchResult<MapperResult>(
        from url: URL,
        withMapper mapper: @escaping (Data, HTTPURLResponse) throws -> MapperResult,
        file: StaticString,
        line: UInt
    ) -> Swift.Result<MapperResult, Error>?
}

extension EphemeralClient where Self: XCTestCase {
    func ephemeralClient(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }
    
    func fetchResult<MapperResult>(
        from url: URL,
        withMapper mapper: @escaping (Data, HTTPURLResponse) throws -> MapperResult,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Swift.Result<MapperResult, Error>? {
        var receivedResult: Swift.Result<MapperResult, Error>?
        let exp = expectation(description: "Wait for load completion")
        
        ephemeralClient().get(from: url) { result in
            receivedResult = result.flatMap { (data, response) in
                do {
                    return .success(try mapper(data, response))
                } catch {
                    return .failure(error)
                }
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        return receivedResult
    }
}
