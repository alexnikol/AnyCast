// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList
import PodcastsGenresList

struct RemoteBestPodcastsList: Decodable {
    let genreId: String
    let genreName: String
    let podcasts: [RemotePodcast]
    
    private enum CodingKeys : String, CodingKey {
        case genreId = "id"
        case genreName = "name"
        case podcasts
    }
}

struct RemotePodcast: Decodable {
    let id: String
    let title: String
    let image: URL
}

final class BestPodastsItemsMapper {
    
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> RemoteBestPodcastsList {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(RemoteBestPodcastsList.self, from: data) else {
            throw RemoteBestPodcastsLoader.Error.invalidData
        }
        
        return root
    }
}

class RemoteBestPodcastsLoader {
    
    typealias Result = BestPodcastsLoader.Result
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private let client: HTTPClient
    private let url: URL
    
    init(genreID: Int, url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    func load(completion: @escaping (BestPodcastsLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .failure:
                completion(.failure(Error.connectivity))
                
            case let .success((data, response)):
                completion(Self.map(data: data, response: response))
            }
        }
    }
    
    private static func map(data: Data, response: HTTPURLResponse) -> Result {
        do {
            let remoteList = try BestPodastsItemsMapper.map(data, from: response)
            return .success(remoteList.toModel())
        } catch {
            return .failure(error)
        }
    }
}

extension RemoteBestPodcastsList {
    func toModel() -> BestPodcastsList {
        return BestPodcastsList(genreId: genreId, genreName: genreName, podcasts: podcasts.toModels())
    }
}

extension Array where Element == RemotePodcast {
    func toModels() -> [Podcast] {
        return map {
            Podcast(id: $0.id, title: $0.title, image: $0.image)
        }
    }
}

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
