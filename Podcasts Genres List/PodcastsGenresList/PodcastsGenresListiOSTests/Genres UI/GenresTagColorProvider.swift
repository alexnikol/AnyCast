//
//  GenresTagColorProvider.swift
//  PodcastsGenresListiOSTests
//
//  Created by Alexander Nikolaychuk on 16.09.2022.
//  Copyright © 2022 Almost Engineer. All rights reserved.
//

import XCTest

class GenresTagColorProvider {
    
    func getColor(by index: Int) -> UIColor? {
        return .green
    }
}

final class GenresTagColorProviderTests: XCTestCase {
    
    func test_onGetColorByIndex_shouldReturnColorByIndex() {
        let provider = GenresTagColorProvider()
        let index = 0
        
        let color = provider.getColor(by: index)
        
        XCTAssertNotNil(color)
    }
}
