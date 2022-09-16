// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest

class GenresPresenter {
    init(view: Any) {
    }
}

class GenresPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: GenresPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = GenresPresenter(view: view)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy {
        let messages: [Any] = []
    }
}
