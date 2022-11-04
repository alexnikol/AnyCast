// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList

extension FailableDeleteGenresStoreSpecs where Self: XCTestCase {
    
    func assertThatDeleteDeliversErrorOnDeletionError(on sut: GenresStore, file: StaticString = #file, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: GenresStore, file: StaticString = #file, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
}
