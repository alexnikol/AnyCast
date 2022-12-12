// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import AudioPlayerModule
import PodcastsModule

protocol StickyAudioPlayerView {}

class StickyPlayerPresenter {
    init(resourceView: StickyAudioPlayerView) {
        
    }
}

class StickyPlayerPresentationTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: StickyPlayerPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let presenter = StickyPlayerPresenter(resourceView: view)
        trackForMemoryLeaks(presenter)
        trackForMemoryLeaks(view)
        return (presenter, view)
    }
    
    private class ViewSpy: StickyAudioPlayerView {
        enum Message {}
        private(set) var messages: [Message] = []
    }
}
