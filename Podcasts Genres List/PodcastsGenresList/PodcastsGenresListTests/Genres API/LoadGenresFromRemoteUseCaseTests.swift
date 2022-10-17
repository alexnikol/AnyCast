// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import HTTPClient
import PodcastsGenresList

class LoadGenresFromRemoteUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
                
        [199, 201, 400, 500].enumerated().forEach { (index, code) in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = makeGenresJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversNoGenresItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = makeGenresJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_deliversGenresItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let genre1 = makeGenres(id: 1, name: "a genre name")
        let genre2 = makeGenres(id: 2, name: "another genre name")
        
        expect(sut, toCompleteWith: .success([genre1.model, genre2.model]), when: {
            let json = makeGenresJSON([genre1.json, genre2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteGenresLoader? = RemoteGenresLoader(url: url, client: client)
        
        var capturedResults: [RemoteGenresLoader.Result] = []
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeGenresJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "http://a-url.com")!,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (loader: RemoteGenresLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteGenresLoader(url: url, client: client)
        
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteGenresLoader.Error) -> RemoteGenresLoader.Result {
        return .failure(error)
    }
    
    private func makeGenres(id: Int, name: String) -> (model: Genre, json: [String: Any]) {
        let genre = Genre(id: id, name: name)
        let json = [
            "id": id,
            "name": name
        ] as [String: Any]
        
        return (genre, json)
    }
    
    private func makeGenresJSON(_ genres: [[String: Any]]) -> Data {
        let json = ["genres": genres]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemoteGenresLoader,
                        toCompleteWith expectedResult: RemoteGenresLoader.Result,
                        when action: () -> Void,
                        file: StaticString = #file,
                        line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedGenres), .success(expectedGenres)):
                XCTAssertEqual(receivedGenres, expectedGenres, file: file, line: line)
                
            case let (.failure(receivedError as RemoteGenresLoader.Error), .failure(expectedError as RemoteGenresLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    final class HTTPClientSpy: HTTPClient {
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
