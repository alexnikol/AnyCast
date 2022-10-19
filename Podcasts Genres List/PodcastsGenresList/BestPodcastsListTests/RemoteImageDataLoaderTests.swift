// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import HTTPClient

class RemoteImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) {
        client.get(from: url, completion: { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            default: break
            }
        })
    }
}

class RemoteImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformAnyRequestOnCreation() {
        let client = HTTPClientSpy()
        _ = RemoteImageDataLoader(client: client)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadImageData_requestsDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteImageDataLoader(client: client)
        let requestURL = anyURL()
        
        sut.loadImageData(from: requestURL) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [requestURL])
    }
    
    func test_loadImageDataTwice_requestsDataFromURLTwice() {
        let client = HTTPClientSpy()
        let sut = RemoteImageDataLoader(client: client)
        let requestURL = anyURL()
        
        sut.loadImageData(from: requestURL) { _ in }
        sut.loadImageData(from: requestURL) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [requestURL, requestURL])
    }
    
    func test_loadImageData_deliversErrorOnClientError() {
        let client = HTTPClientSpy()
        let sut = RemoteImageDataLoader(client: client)
        
        expect(sut, expectedResult: .failure(anyNSError()), when: {
            client.complete(with: anyNSError())
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteImageDataLoader(client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(
        _ sut: RemoteImageDataLoader,
        expectedResult: RemoteImageDataLoader.Result,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let requestURL = anyURL()
        let exp = expectation(description: "Wait on loading completion")
        
        sut.loadImageData(from: requestURL) { receivedResult in
            
            switch (receivedResult, expectedResult) {
            case (let .success(receivedData), let .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
                
            case (.failure, .failure):
                break
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://a-url.com")!
    }
    
    func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
    
    private final class HTTPClientSpy: HTTPClient {
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: messages[index].url,
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success((data, response)))
        }
    }
}
