// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList

class ExampleTestTarget: XCTestCase {
    
    func test_init_presenter() {
        let title = GenresPresenter.title
        
        XCTAssertEqual(title, "Explore")
    }
}
