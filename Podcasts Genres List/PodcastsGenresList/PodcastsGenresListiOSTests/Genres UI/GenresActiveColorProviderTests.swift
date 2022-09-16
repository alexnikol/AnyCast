//
//  GenresActiveColorProviderTests.swift
//  PodcastsGenresListiOSTests
//
//  Created by Alexander Nikolaychuk on 16.09.2022.
//  Copyright © 2022 Almost Engineer. All rights reserved.
//

import XCTest

class GenresActiveColorProvider {
    
    func getColor(by index: Int) -> UIColor? {
        return .green
    }
}

final class GenresActiveColorProviderTests: XCTestCase {
    
    func test_onGetColorByIndex_shouldReturnColorByIndex() {
        let provider = makeSUT()
        let index = 0
        
        let color = provider.getColor(by: index)
        
        XCTAssertNotNil(color)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> GenresActiveColorProvider {
        let sut = GenresActiveColorProvider()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
