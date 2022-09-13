// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList

extension FailableInsertGenresStoreSpecs where Self: XCTestCase {
    
    func assertThatInsertDeliversErrorOnInsertionError(on sut: GenresStore, file: StaticString = #file, line: UInt = #line) {
        let genres = uniqueGenres().local
        let timestamp = Date()
        
        let insertionError = insert((genres, timestamp), to: sut)

        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }
    
    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: GenresStore, file: StaticString = #file, line: UInt = #line) {
        let genres = uniqueGenres().local
        let timestamp = Date()
        
        insert((genres, timestamp), to: sut)

        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
}
