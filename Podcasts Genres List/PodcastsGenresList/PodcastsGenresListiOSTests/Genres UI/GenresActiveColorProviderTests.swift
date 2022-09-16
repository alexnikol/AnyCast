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
        try colors.forEach { try validate($0) }
        self.colors = colors
    }
    
    private func validate(_ color: String) throws -> Void {
        let isColorsStringValid = color.filter(\.isHexDigit).count == color.count
        if isColorsStringValid {
            return
        }
        throw NSError(domain: "", code: 0)
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
        let colors = validColors()
        
        do {
            try sut.setColors(colors)
            XCTAssertEqual(sut.colors, colors)
        } catch {
            XCTFail("Expected successful set colors operation")
        }
    }
    
    func test_validateColors_deliversErrorIfAnyOfProvidedColorsAreNotValidHexString() {
        let sut = makeSUT()
        let invalidColor = "mmmmmm"
        let colors = [invalidColor] + validColors()
        
        XCTAssertThrowsError(try sut.setColors(colors), "Expected failed operation since provided list of colors has an invalid color")
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
    
    private func validColors() -> [String] {
        return ["e6194b", "3cb44b"]
    }
}
