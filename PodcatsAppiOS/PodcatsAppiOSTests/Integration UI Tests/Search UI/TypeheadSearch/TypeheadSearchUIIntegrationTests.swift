// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import Combine
import SharedTestHelpersLibrary
import SearchContentModule
import SearchContentModuleiOS
@testable import Podcats

final class TypeheadSearchUIIntegrationTests: XCTestCase {
    
    func test_loadTypeheadSearchResultActions_requestTypeheadSearchOnTextChange() {
        let (sut, searchController, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected a no loading request once view is loaded")
        
        searchController.simulateUserInitiatedTyping(with: "any search term")
        XCTAssertEqual(loader.loadCallCount, 1, "Expected loading request on text change")
        
        searchController.simulateUserInitiatedTyping(with: "another search term")
        XCTAssertEqual(loader.loadCallCount, 2, "Expected 2 loading requests on text change")
    }
    
    func test_loadTypeheadSearchResultCompletion_rendersSuccessfullyLoadedTerms() {
        let (sut, searchController, loader) = makeSUT()
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        searchController.simulateUserInitiatedTyping(with: "any search term")
        assertThat(sut, isRendering: [])
        
        loader.completeRequest(with: .init(terms: ["result 1"], genres: [], podcasts: []), atIndex: 0)
        assertThat(sut, isRendering: ["result 1"])
        
        searchController.simulateUserInitiatedTyping(with: "any search term 2")
        assertThat(sut, isRendering: ["result 1"])
        
        loader.completeRequest(with: .init(terms: ["result 2", "result 3"], genres: [], podcasts: []), atIndex: 1)
        assertThat(sut, isRendering: ["result 2", "result 3"])
    }
    
    func test_loadTypeheadSearchResultCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let (sut, searchController, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        searchController.simulateUserInitiatedTyping(with: "any search term")
        loader.completeRequest(with: .init(terms: ["result 1"], genres: [], podcasts: []), atIndex: 0)
        assertThat(sut, isRendering: ["result 1"])
        
        searchController.simulateUserInitiatedTyping(with: "any search term 2")
        loader.completeRequestWitError(atIndex: 1)
        assertThat(sut, isRendering: ["result 1"])
    }
    
    func test_loadTypeheadSearchResultCancel_cancelsPreviousRequestBeforeNewRequest() {
        let (sut, searchController, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let searchTerm0 = "any search term"
        searchController.simulateUserInitiatedTyping(with: searchTerm0)
        XCTAssertEqual(loader.cancelledTerms, [])
        
        let searchTerm1 = "any search term 2"
        searchController.simulateUserInitiatedTyping(with: searchTerm1)
        XCTAssertEqual(loader.cancelledTerms, [searchTerm0])
        
        let searchTerm2 = "any search term 3"
        searchController.simulateUserInitiatedTyping(with: searchTerm2)
        XCTAssertEqual(loader.cancelledTerms, [searchTerm0, searchTerm1])
    }
    
    func test_onTermSelection_deliversSelectedTerm() {
        var receivedResult: [String] = []
        let exp = expectation(description: "Wait on term selection")
        let (sut, searchController, loader) = makeSUT(onTermSelect: {
            exp.fulfill()
            receivedResult.append($0)
        })
        sut.loadViewIfNeeded()
        let result = ["any search 1", "any search 2"]
        searchController.simulateUserInitiatedTyping(with: "any search term")
        loader.completeRequest(with: .init(terms: result, genres: [], podcasts: []), atIndex: 0)
        
        sut.simulateUserInitiatedTermSelection(at: 1)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedResult, ["any search 2"])
    }
    
    func test_loadTypeheadSearchResultCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, searchController, loader) = makeSUT()
        sut.loadViewIfNeeded()
        searchController.simulateUserInitiatedTyping(with: "any search term")
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeRequest(with: .init(terms: ["any term"], genres: [], podcasts: []), atIndex: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        onTermSelect: @escaping (String) -> Void = { _ in },
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: TypeheadListViewController, searchController: UISearchController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = TypeheadSearchUIComposer.searchComposedWith(
            searchLoader: loader.loadPublisher,
            onTermSelect: onTermSelect
        )
        let searchController = UISearchController(searchResultsController: sut)
        searchController.searchBar.delegate = sut
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(searchController, file: file, line: line)
        return (sut, searchController, loader)
    }
    
    private func assertThat(_ sut: TypeheadListViewController, isRendering terms: [String], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedSearchTermViews() == terms.count else {
            return XCTFail("Expected \(terms.count) rendered terms, got \(sut.numberOfRenderedSearchTermViews()) rendered views instead")
        }
        
        terms.enumerated().forEach { index, term in
            assertThat(sut, hasViewConfiguredFor: term, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(
        _ sut: TypeheadListViewController,
        hasViewConfiguredFor term: String,
        at index: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let termViewModel = TypeheadSearchContentPresenter.map(term)
        let view = sut.searchTermView(at: index)
        XCTAssertNotNil(view, file: file, line: line)
        XCTAssertEqual(view?.termText, termViewModel, "Wrong title at index \(index)", file: file, line: line)
    }
    
    private class LoaderSpy {
        typealias Publsiher = AnyPublisher<TypeheadSearchContentResult, Error>
        
        private var requests = [PassthroughSubject<TypeheadSearchContentResult, Error>]()
        private(set) var cancelledTerms = [String]()
        
        var loadCallCount: Int {
            return requests.count
        }
        
        func loadPublisher(for searchTerm: String) -> Publsiher {
            let publisher = PassthroughSubject<TypeheadSearchContentResult, Error>()
            
            let cancelPublisher = publisher.handleEvents(receiveCancel: { [weak self] in
                self?.cancelledTerms.append(searchTerm)
            })
            
            requests.append(publisher)
            return cancelPublisher.eraseToAnyPublisher()
        }
        
        func completeRequest(with result: TypeheadSearchContentResult, atIndex index: Int) {
            requests[index].send(result)
        }
        
        func completeRequestWitError(atIndex index: Int) {
            requests[index].send(completion: .failure(anyNSError()))
        }
    }
}
