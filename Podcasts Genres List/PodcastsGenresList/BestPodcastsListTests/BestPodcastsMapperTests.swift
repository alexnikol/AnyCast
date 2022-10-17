// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import HTTPClient
import BestPodcastsList

class BestPodcastsMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPURLResponse() throws {
        let validJSON = makePodcastsListJSON(podcasts: [])
        
        try [199, 201, 400, 500].forEach { code in
            XCTAssertThrowsError(
                try BestPodastsItemsMapper.map(validJSON, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try BestPodastsItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoPodcastsItemsOn200HTTPResponseWithNonJSONAndEmptyPocastsList() throws {
        let anyGenreId = 1
        let anyGenreName = "Any Genre"
        let validJSON = makePodcastsListJSON(genreId: anyGenreId, genreName: anyGenreName, podcasts: [])

        let result = try BestPodastsItemsMapper.map(validJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, BestPodcastsList(genreId: anyGenreId, genreName: anyGenreName, podcasts: []))
    }
    
    func test_map_deliversPodcastsItemsOn200HTTPResponseWithJSONItems() throws {
        let anyGenreId = 1
        let anyGenreName = "Any Genre"
        
        let podcast1 = makePodcast(
            id: UUID().uuidString,
            title: "Any Podcast",
            image: URL(string: "https://any-url")!
        )
        
        let podcast2 = makePodcast(
            id: UUID().uuidString,
            title: "Another Podcast",
            image: URL(string: "https://another-url")!
        )
        
        let validJSON = makePodcastsListJSON(
            genreId: anyGenreId,
            genreName: anyGenreName,
            podcasts: [podcast1.json, podcast2.json]
        )
        
        let result = try BestPodastsItemsMapper.map(validJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(
            result, BestPodcastsList(genreId: anyGenreId, genreName: anyGenreName, podcasts: [podcast1.model, podcast2.model])
        )
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "http://a-url.com")!,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (loader: RemoteBestPodcastsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteBestPodcastsLoader(url: url, client: client)
        
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteBestPodcastsLoader,
                        toCompleteWith expectedResult: RemoteBestPodcastsLoader.Result,
                        when action: () -> Void,
                        file: StaticString = #file,
                        line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedPodcasts), .success(expectedPodcasts)):
                XCTAssertEqual(receivedPodcasts, expectedPodcasts, file: file, line: line)
                
            case let (.failure(receivedError as RemoteBestPodcastsLoader.Error), .failure(expectedError as RemoteBestPodcastsLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func failure(_ error: RemoteBestPodcastsLoader.Error) -> RemoteBestPodcastsLoader.Result {
        return .failure(error)
    }
    
    private func makePodcast(id: String, title: String, image: URL) -> (model: Podcast, json: [String: Any]) {
        let podcast = Podcast(id: id, title: title, image: image)
        let json = [
            "id": id,
            "title": title,
            "image": image.absoluteString
        ] as [String: Any]
        
        return (podcast, json)
    }
    
    private func makePodcastsListJSON(
        genreId: Int = 1,
        genreName: String = "Any Genre",
        podcasts: [[String: Any]]
    ) -> Data {
        let json = [
            "id": genreId,
            "name": genreName,
            "podcasts": podcasts
        ] as [String: Any]
        
        return try! JSONSerialization.data(withJSONObject: json)
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
                
private extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        let anyURL = URL(string: "http://a-url.com")!
        self.init(url: anyURL, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
