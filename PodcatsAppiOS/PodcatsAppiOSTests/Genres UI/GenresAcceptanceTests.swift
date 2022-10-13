// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import UIKit
import PodcastsGenresList
import PodcastsGenresListiOS
@testable import Podcats

class GenresAcceptanceTests: XCTestCase {
    
    func test_onLaunch_displaysRemoteGenresWhenCustomerHasConnectivityAndEmptyCache() {
        let genres = makeSUT(store: InMemoryGenresStore(), httpClient: HTTPClientStub.online(response))
        
        XCTAssertEqual(genres.numberOfRenderedGenresViews(), 2)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        store: GenresStore,
        httpClient: HTTPClient,
        file: StaticString = #file,
        line: UInt = #line
    ) -> GenresListViewController {
        let sut = SceneDelegate(httpClient: httpClient, genresStore: store)
        sut.window = UIWindow()
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        let genres = nav?.topViewController as! GenresListViewController
        return genres
    }
    
    private class HTTPClientStub: HTTPClient {
        private let stub: (URL) -> HTTPClientResult
        
        init(stub: @escaping (URL) -> HTTPClientResult) {
            self.stub = stub
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            completion(stub(url))
        }
        
        static var offline: HTTPClientStub {
            HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
        }
        
        static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
            HTTPClientStub { url in .success(stub(url)) }
        }
    }
    
    private class InMemoryGenresStore: GenresStore {
        typealias GenresCache = (genres: [LocalGenre], timestamp: Date)
        
        private(set) var cache: GenresCache?
        
        init(cache: GenresCache? = nil) {
            self.cache = cache
        }
        
        func deleteCacheGenres(completion: @escaping DeletionCompletion) {
            cache = nil
            completion(nil)
        }
        
        func insert(_ genres: [LocalGenre], timestamp: Date, completion: @escaping InsertionCompletion) {
            cache = (genres, timestamp)
            completion(nil)
        }
        
        func retrieve(completion: @escaping RetrievalCompletion) {
            if let cache = cache {
                completion(.found(genres: cache.genres, timestamp: cache.timestamp))
            } else {
                completion(.empty)
            }
        }
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        let baseURL = "https://listen-api-test.listennotes.com"
        switch url.absoluteString {
        case "\(baseURL)/api/v2/genres":
            return makeGenresData()
            
        default:
            return Data()
        }
    }
            
    private func makeGenresData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["genres": [
            ["id": 1, "name": "Any Genre 1"],
            ["id": 2, "name": "Any Genre 2"]
        ]])
    }
}
