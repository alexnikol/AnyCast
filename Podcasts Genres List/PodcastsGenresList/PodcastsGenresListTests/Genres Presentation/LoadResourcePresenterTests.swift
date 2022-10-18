// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList

class LoadResourcePresenterTests: XCTestCase {
        
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingGenres_displaysLoadingMessage() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingGenres()
        
        XCTAssertEqual(view.messages, [.display(isLoading: true)])
    }
    
    func test_didFinishLoadingGenresWithError_stopsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoading(with: anyNSError())
        
        XCTAssertEqual(view.messages, [.display(isLoading: false)])
    }
    
    func test_didFinishLoadingGenres_displaysGenresAndStopsLoading() {
        let (sut, view) = makeSUT()
        let uniqueGenres = uniqueGenres().models
        
        sut.didFinishLoadingGenres(with: uniqueGenres)
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: false),
            .display(genres: uniqueGenres)
        ])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LoadResourcePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = LoadResourcePresenter(genresView: view, loadingView: view)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
        
    private class ViewSpy: GenresLoadingView, GenresView {
        enum Message: Hashable {
            case display(isLoading: Bool)
            case display(genres: [Genre])
        }
        
        private(set) var messages: Set<Message> = []
        
        func display(_ viewModel: GenresLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: GenresViewModel) {
            messages.insert(.display(genres: viewModel.genres))
        }
    }
}
