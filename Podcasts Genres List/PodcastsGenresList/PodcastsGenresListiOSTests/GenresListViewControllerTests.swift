// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest

final class GenresListViewController {
    init(loader: GenresListViewControllerTests.LoaderSpy) {
        
    }
}

final class GenresListViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadGenres() {
        let loader = LoaderSpy()
        _ = GenresListViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: - Helpers
    
    class LoaderSpy {
        private(set) var loadCallCount = 0
    }
}
