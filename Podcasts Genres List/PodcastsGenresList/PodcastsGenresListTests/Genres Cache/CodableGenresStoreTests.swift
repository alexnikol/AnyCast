// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList

class CodableGenresStore {
    
    private struct Cache: Codable {
        let genres: [CodableGenre]
        let timestamp: Date
        
        var localGenres: [LocalGenre] {
            genres.map { $0.local }
        }
    }
    
    private struct CodableGenre: Codable {
        let id: Int
        let name: String
        
        init(_ genre: LocalGenre) {
            id = genre.id
            name = genre.name
        }
        
        var local: LocalGenre {
            return .init(id: id, name: name)
        }
    }
    
    private let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("genres-list.store")
    
    func retrieve(completion: @escaping GenresStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(genres: cache.localGenres, timestamp: cache.timestamp))
    }
    
    func insert(_ genres: [LocalGenre], timestamp: Date, completion: @escaping GenresStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let codableGenres = genres.map(CodableGenre.init)
        let cache = Cache(genres: codableGenres, timestamp: timestamp)
        let encoded = try! encoder.encode(cache)
        try! encoded.write(to: storeURL)
        completion(nil)
    }
}

class CodableGenresStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("genres-list.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    override func tearDown() {
        super.tearDown()
        
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("genres-list.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        
        var receivedResult: RetrieveCacheFeedResult?
        sut.retrieve { result in
            switch result {
            case .empty:
                receivedResult = result
                
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }
        
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertNotNil(receivedResult)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                    
                default:
                    XCTFail("Expected retrieving twice from empty cache to deliver same result, got \(firstResult) and \(secondResult) instead")
                }
            
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieveAfterInsertingToEmptyCache_deliversInsrtedValues() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        let genres = uniqueGenres().local
        let timestamp = Date()
        
        sut.insert(genres, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected no insertion error")
            
            sut.retrieve { retrievedResult in
                switch retrievedResult {
                case let .found(retrievedGenres, retrievedTimestamp):
                    XCTAssertEqual(retrievedGenres, genres)
                    XCTAssertEqual(retrievedTimestamp, timestamp)
                    
                default:
                    XCTFail("Expected found result with \(genres) and timestamp \(timestamp), got \(retrievedResult) instead")
                }
            
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> CodableGenresStore {
        let sut = CodableGenresStore()
        return sut
    }
}
