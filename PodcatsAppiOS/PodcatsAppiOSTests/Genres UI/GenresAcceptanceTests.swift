// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import UIKit
import PodcastsGenresList
import PodcastsGenresListiOS
@testable import Podcats

class GenresAcceptanceTests: XCTestCase {
    
    func test_onLaunch_displaysRemoteGenresWhenCustomerHasConnectivityAndEmptyCache() {
        let genres = launch(store: InMemoryGenresStore.empty, httpClient: HTTPClientStub.online(response))
        
        XCTAssertEqual(genres.numberOfRenderedGenresViews(), 2)
    }
    
    func test_onLaunch_displaysNoGenresWhenCustomersHasNoConnectivityAndEmptyCache() {
        let genres = launch(store: InMemoryGenresStore.empty, httpClient: HTTPClientStub.offline)
        
        XCTAssertEqual(genres.numberOfRenderedGenresViews(), 0)
    }
    
    func test_onLaunch_displaysCachedGenresWhenCustomerHasConnectivityAndNonExpiredCache() {
        let sharedStore = InMemoryGenresStore.withNonExpiredFeedCache
        let genres = launch(store: sharedStore, httpClient: HTTPClientStub.offline)
        
        XCTAssertNotNil(sharedStore.cache)
        XCTAssertEqual(genres.numberOfRenderedGenresViews(), 1)
    }
    
    func test_onEnteringBackground_deletesExpiredGenresCache() {
        let store = InMemoryGenresStore.withExpiredFeedCache
        
        enterBackground(with: store)
        
        XCTAssertNil(store.cache, "Expected to delete expired cache")
    }
    
    // MARK: - Helpers
    
    private func launch(
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
    
    private func enterBackground(with store: InMemoryGenresStore) {
        let sut = SceneDelegate(httpClient: HTTPClientStub.offline, genresStore: store)
        sut.sceneWillResignActive(UIApplication.shared.connectedScenes.first!)
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
        struct GenresCache {
            let genres: [LocalGenre]
            let timestamp: Date
        }
        
        private(set) var cache: GenresCache?
        
        init(cache: GenresCache? = nil) {
            self.cache = cache
        }
        
        static var empty: InMemoryGenresStore {
            InMemoryGenresStore(cache: nil)
        }
        
        static var withNonExpiredFeedCache: InMemoryGenresStore {
            return InMemoryGenresStore(cache: GenresCache(genres: [LocalGenre(id: 1, name: "Any Genre")], timestamp: Date()))
        }
        
        static var withExpiredFeedCache: InMemoryGenresStore {
            return InMemoryGenresStore(cache: GenresCache(genres: [LocalGenre(id: 1, name: "Any Genre")], timestamp: Date.distantPast))
        }
        
        func deleteCacheGenres(completion: @escaping DeletionCompletion) {
            cache = nil
            completion(nil)
        }
        
        func insert(_ genres: [LocalGenre], timestamp: Date, completion: @escaping InsertionCompletion) {
            cache = GenresCache(genres: genres, timestamp: timestamp)
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
