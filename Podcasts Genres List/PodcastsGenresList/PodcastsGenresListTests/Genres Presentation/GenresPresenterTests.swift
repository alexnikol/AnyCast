// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest

struct GenresLoadingViewModel {
    let isLoading: Bool
}

protocol GenresLoadingView {
    func display(_ viewModel: GenresLoadingViewModel)
}

class GenresPresenter {
    let loadingView: GenresLoadingView
    
    init(loadingView: GenresLoadingView) {
        self.loadingView = loadingView
    }
    
    func didStartLoadingGenres() {
        loadingView.display(.init(isLoading: true))
    }
    
    func didFinishLoading() {
        loadingView.display(.init(isLoading: false))
    }
}

class GenresPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingGenres_displaysLoadingMessage() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingGenres()
        
        XCTAssertEqual(view.messages, [.display(isLoading: true)])
    }
    
    func test_didFinishLoadingGenresWithError_hideLoadingMessage() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoading()
        
        XCTAssertEqual(view.messages, [.display(isLoading: false)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: GenresPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = GenresPresenter(loadingView: view)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: GenresLoadingView {
        enum Message: Equatable {
            case display(isLoading: Bool)
        }
        
        private(set) var messages: [Message] = []
        
        func display(_ viewModel: GenresLoadingViewModel) {
            messages.append(.display(isLoading: viewModel.isLoading))
        }
    }
}
