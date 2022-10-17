// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import HTTPClient
import PodcastsGenresList

class LoadGenresFromRemoteUseCaseTests: XCTestCase {
        
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
    
    private func expect(_ sut: RemoteLoader<[Genre]>,
                        toCompleteWith expectedResult: RemoteLoader<[Genre]>.Result,
                        when action: () -> Void,
                        file: StaticString = #file,
                        line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedGenres), .success(expectedGenres)):
                XCTAssertEqual(receivedGenres, expectedGenres, file: file, line: line)
                
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as! RemoteLoader<[Genre]>.Error, expectedError as! RemoteLoader<[Genre]>.Error, file: file, line: line)
            
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
