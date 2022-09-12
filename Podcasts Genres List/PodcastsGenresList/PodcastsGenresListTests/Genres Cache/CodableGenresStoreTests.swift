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
    
    private let storeURL: URL

    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    func retrieve(completion: @escaping GenresStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        
        do {
            let decoder = JSONDecoder()
            let cache = try decoder.decode(Cache.self, from: data)
            completion(.found(genres: cache.localGenres, timestamp: cache.timestamp))
        } catch {
            completion(.failure(error))
        }
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
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
        
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let genres = uniqueGenres().local
        let timestamp = Date()
        
        insert((genres, timestamp), to: sut)
        
        expect(sut, toRetrieve: .found(genres: genres, timestamp: timestamp))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let genres = uniqueGenres().local
        let timestamp = Date()
        
        insert((genres, timestamp), to: sut)
        
        expect(sut, toRetrieveTwice: .found(genres: genres, timestamp: timestamp))
    }
    
    func test_retrieve_deliverFailureOnRetrievalError() {
        let sut = makeSUT()
        
        try! "invalid data".write(to: testSpecificStoreURL(), atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CodableGenresStore {
        let sut = CodableGenresStore(storeURL: testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func insert(_ cache: (genres: [LocalGenre], timestamp: Date),
                        to sut: CodableGenresStore,
                        file: StaticString = #file,
                        line: UInt = #line) {
        let exp = expectation(description: "Wait for cache insertion")
        sut.insert(cache.genres, timestamp: cache.timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected no insertion error", file: file, line: line)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(_ sut: CodableGenresStore,
                        toRetrieveTwice expectedResult: RetrieveCacheGenresResult,
                        file: StaticString = #file,
                        line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(_ sut: CodableGenresStore,
                        toRetrieve expectedResult: RetrieveCacheGenresResult,
                        file: StaticString = #file,
                        line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty),
                (.failure, .failure):
                break
                
            case let (.found(expectedGenres, expectedTimestamp), .found(retrievedGenres, retrievedTimestamp)):
                XCTAssertEqual(expectedGenres, retrievedGenres, file: file, line: line)
                XCTAssertEqual(expectedTimestamp, retrievedTimestamp, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
        
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func testSpecificStoreURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }
    
    private func setupEmptyStoreState() {
        deleteStireArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStireArtifacts()
    }
    
    private func deleteStireArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
}
