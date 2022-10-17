// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList
import PodcastsGenresList

class LoadBestPodcastsFromRemoteUseCaseTests: LoadGenresFromRemoteUseCaseTests {
    
    override func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    override func test_load_requestsDataFromURL() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    override func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    override func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    override func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        [199, 201, 400, 500].enumerated().forEach { (index, code) in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = makePodcastsListJSON(podcasts: [])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    override func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversNoPodcastsItemsOn200HTTPResponseWithNonJSONAndEmptyPocastsList() {
        let (sut, client) = makeSUT()

        let anyGenreId = 1
        let anyGenreName = "Any Genre"
        expect(sut, toCompleteWith: .success(BestPodcastsList(genreId: anyGenreId, genreName: anyGenreName, podcasts: [])), when: {
            let emptyJSON = makePodcastsListJSON(genreId: anyGenreId, genreName: anyGenreName, podcasts: [])
            client.complete(withStatusCode: 200, data: emptyJSON)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "http://a-url.com")!,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (loader: RemoteBestPodcastsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let anyGenreID = 1
        let sut = RemoteBestPodcastsLoader(genreID: anyGenreID, url: url, client: client)
        
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
}
