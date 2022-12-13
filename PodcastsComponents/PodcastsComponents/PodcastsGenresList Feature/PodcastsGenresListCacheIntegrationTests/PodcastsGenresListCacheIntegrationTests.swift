// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import PodcastsGenresList

class PodcastsGenresListCacheIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_load_deliversNoItemsOnEmptyCache() {
        let sut = makeSUT()

        expect(sut, toLoad: [])
    }
    
    func test_load_deliversItemsSavedOnASeparateInstance() {
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let genres = uniqueGenres().models
        
        save(genres, with: sutToPerformSave)
        
        expect(sutToPerformLoad, toLoad: genres)
    }
    
    func test_load_overridesItemsSavedOnASeparateInstance() {
        let sutToPerformFirstSave = makeSUT()
        let sutToPerformSecondSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let firstGenres = uniqueGenres().models
        let latestGenres = uniqueGenres().models
        
        save(firstGenres, with: sutToPerformFirstSave)
        save(latestGenres, with: sutToPerformSecondSave)
        
        expect(sutToPerformLoad, toLoad: latestGenres)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> LocalGenresLoader {
        let storeURL = specificTestStoreURL()
        let store = try! CoreDataGenresStore(storeURL: storeURL)
        let sut = LocalGenresLoader(store: store, currentDate: Date.init)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: LocalGenresLoader,
                        toLoad expectedGenres: [Genre],
                        file: StaticString = #file,
                        line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case let .success(loadedGenres):
                XCTAssertEqual(loadedGenres, expectedGenres, file: file, line: line)
                
            case let .failure(error):
                XCTFail("Expected successful genre result, got \(error) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func save(_ genres: [Genre],
                      with sut: LocalGenresLoader,
                      file: StaticString = #file,
                      line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        sut.save(genres) { saveResult in
            XCTAssertNil(saveResult, "Expected to save genres successfully", file: file, line: line)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    private func specificTestStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }

    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: specificTestStoreURL())
    }
}
