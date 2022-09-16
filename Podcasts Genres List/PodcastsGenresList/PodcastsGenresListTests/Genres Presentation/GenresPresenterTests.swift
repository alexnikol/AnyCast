// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList

struct GenresLoadingViewModel {
    let isLoading: Bool
}

protocol GenresLoadingView {
    func display(_ viewModel: GenresLoadingViewModel)
}

struct GenresViewModel: Hashable {
    let genres: [Genre]
}

protocol GenresView {
    func display(_ viewModel: GenresViewModel)
}

class GenresPresenter {
    let genresView: GenresView
    let loadingView: GenresLoadingView
    
    init(loadingView: GenresLoadingView, genresView: GenresView) {
        self.loadingView = loadingView
        self.genresView = genresView
    }
    
    func didStartLoadingGenres() {
        loadingView.display(.init(isLoading: true))
    }
    
    func didFinishLoading(with error: Error) {
        loadingView.display(.init(isLoading: false))
    }
    
    func didFinishLoadingGenres(with genres: [Genre]) {
        genresView.display(.init(genres: genres))
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
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: GenresPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = GenresPresenter(loadingView: view, genresView: view)
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
