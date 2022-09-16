//
//  GenresActiveColorProviderTests.swift
//  PodcastsGenresListiOSTests
//
//  Created by Alexander Nikolaychuk on 16.09.2022.
//  Copyright © 2022 Almost Engineer. All rights reserved.
//

import XCTest

class GenresActiveColorProvider {
    
    var colors: [String] = []
    
    func getColor(by index: Int) -> UIColor? {
        return .green
    }
    
    func setColors(_ colors: [String]) throws {
        self.colors = colors
    }
}

final class GenresActiveColorProviderTests: XCTestCase {
    
    func test_onGetColorByIndex_shouldReturnColorByIndex() {
        let sut = makeSUT()
        let index = 0
        
        let color = sut.getColor(by: index)
        
        XCTAssertNotNil(color)
    }
    
    func test_onSetColorsList_shouldSaveProvidedColorsList() {
        let sut = makeSUT()
        let colors = uniqueColors()
        
        do {
            try sut.setColors(colors)
            XCTAssertEqual(sut.colors, colors)
        } catch {
            XCTFail("Expected successful set colors operation")
        }
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
    
    private func uniqueColors() -> [String] {
        return ["#e6194b", "#3cb44b"]
    }
}
