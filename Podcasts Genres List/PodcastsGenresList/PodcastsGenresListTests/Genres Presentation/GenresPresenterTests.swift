// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest

class GenresPresenter {
    init(view: Any) {
    }
}

class GenresPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()
        
        _ = GenresPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: - Helpers
    
    private class ViewSpy {
        let messages: [Any] = []
    }
}
