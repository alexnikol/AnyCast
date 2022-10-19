// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import HTTPClient

class RemoteImageDataLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageData(from url: URL, completion: @escaping (Error?) -> Void) {
        client.get(from: url, completion: { result in
            switch result {
            case let .failure(error):
                completion(error)
                
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
        let requestURL = anyURL()
        let exp = expectation(description: "Wait on loading completion")
        
        var receivedError: Error?
        sut.loadImageData(from: requestURL) { error in
            receivedError = error
        
            exp.fulfill()
        }
        client.complete(with: anyNSError())
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertNotNil(receivedError)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RemoteImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteImageDataLoader(client: client)
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        return (sut, client)
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
