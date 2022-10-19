// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import HTTPClient

class RemoteImageDataLoader {
    typealias Result = Swift.Result<Data, Swift.Error>
    
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) {
        client.get(from: url, completion: { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                if response.statusCode == 200 && !data.isEmpty {
                    completion(.success(data))
                } else {
                    completion(.failure(Error.invalidData))
                }
                
            case let .failure(error):
                completion(.failure(error))
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
    
    func test_loadImageDataFromURL_requestsDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteImageDataLoader(client: client)
        let requestURL = anyURL()
        
        sut.loadImageData(from: requestURL) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [requestURL])
    }
    
    func test_loadImageDataFromURLTwice_requestsDataFromURLTwice() {
        let client = HTTPClientSpy()
        let sut = RemoteImageDataLoader(client: client)
        let requestURL = anyURL()
        
        sut.loadImageData(from: requestURL) { _ in }
        sut.loadImageData(from: requestURL) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [requestURL, requestURL])
    }
    
    func test_loadImageDataFromURL_deliversErrorOnClientError() {
        let client = HTTPClientSpy()
        let sut = RemoteImageDataLoader(client: client)
        
        expect(sut, expectedResult: .failure(anyNSError()), when: {
            client.complete(with: anyNSError())
        })
    }
    
    func test_loadImageDataFromURL_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, expectedResult: .failure(RemoteImageDataLoader.Error.invalidData), when: {
                client.complete(withStatusCode: code, data: anyData(), at: index)
            })
        }
    }
    
    func test_loadImageDataFromURL_deliversInvalidDataErrorOn200HTTPResponseWithEmptyData() {
        let (sut, client) = makeSUT()
        
        expect(sut, expectedResult: .failure(RemoteImageDataLoader.Error.invalidData), when: {
            let emptyData = Data()
            client.complete(withStatusCode: 200, data: emptyData)
        })
    }
    
    func test_loadImageDataFromURL_deliversReceivedNonEmptyDataOn200HTTPResponse() {
        let (sut, client) = makeSUT()
        let nonEmptyData = Data("non-empty data".utf8)
        
        expect(sut, expectedResult: .success(nonEmptyData), when: {
            client.complete(withStatusCode: 200, data: nonEmptyData)
        })
    }
    
    func test_loadImageDataFromURL_doesNotDeliverResultAfterInstanceHasBeedDeallocated() {
        let client = HTTPClientSpy()
        var sut: RemoteImageDataLoader? = RemoteImageDataLoader(client: client)
        
        var receivedResult: [RemoteImageDataLoader.Result] = []
        sut?.loadImageData(from: anyURL()) { receivedResult.append($0) }
        
        sut = nil
        
        client.complete(with: anyNSError())
        
        XCTAssertTrue(receivedResult.isEmpty)
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
                
            case let (.failure(receivedError as RemoteImageDataLoader.Error), .failure(expectedError as RemoteImageDataLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
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
    
    private func anyData() -> Data {
        Data("any data".utf8)
    }
    
    private final class HTTPClientSpy: HTTPClient {
        private class Task: HTTPClientTask {
            private let cancelCallback: () -> Void
            
            init(cancelCallback: @escaping () -> Void) {
                self.cancelCallback = cancelCallback
            }
            
            func cancel() {
                cancelCallback()
            }
        }
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) -> HTTPClientTask {
            messages.append((url, completion))
            return Task {
                
            }
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
