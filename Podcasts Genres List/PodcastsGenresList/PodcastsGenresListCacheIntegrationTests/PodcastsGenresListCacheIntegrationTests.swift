// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
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

        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case .success(let genres):
                XCTAssertEqual(genres, [], "Expected empty genres")

            case .failure(let error):
                XCTFail("Expected successful genres result, got \(error) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
    
    func test_load_deliversItemsSavedOnASeparateInstance() {
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let genres = uniqueGenres().models
        
        let saveExp = expectation(description: "Wait for save completion")
        sutToPerformSave.save(genres) { saveResult in
            XCTAssertNil(saveResult, "Expected to save genres successfully")
            saveExp.fulfill()
        }
        wait(for: [saveExp], timeout: 1.0)
        
        let loadExp = expectation(description: "Wait for load completion")
        sutToPerformLoad.load { loadResult in
            switch loadResult {
            case let .success(receivedGenres):
                XCTAssertEqual(genres, receivedGenres)
            
            case let .failure(error):
                XCTFail("Expected successfull genre result, got \(error) instead")
            }
            
            loadExp.fulfill()
        }
        wait(for: [loadExp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> LocalGenresLoader {
        let storeBundle = Bundle(for: CoreDataGenresStore.self)
        let storeURL = specificTestStoreURL()
        let store = try! CoreDataGenresStore(storeURL: storeURL, bundle: storeBundle)
        let sut = LocalGenresLoader(store: store, currentDate: Date.init)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
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
