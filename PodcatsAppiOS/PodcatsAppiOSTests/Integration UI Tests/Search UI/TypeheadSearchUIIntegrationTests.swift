// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import Combine
import SharedTestHelpersLibrary
import SearchContentModule
import SearchContentModuleiOS
@testable import Podcats

class TypeheadSearchUIIntegrationTests: XCTestCase {
    
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
    
    // MARK: - Helpers
    
    private func makeSUT(
        podcastID: String = UUID().uuidString,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: TypeheadListViewController, searchController: UISearchController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = TypeheadSearchUIComposer.searchComposedWith(
            searchLoader: loader.loadPublisher,
            onTermSelect: { _ in }
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
        private var requests = [PassthroughSubject<TypeheadSearchContentResult, Error>]()
        
        var loadCallCount: Int {
            return requests.count
        }
        
        func loadPublisher(for searchTerm: String) -> AnyPublisher<TypeheadSearchContentResult, Error> {
            let publisher = PassthroughSubject<TypeheadSearchContentResult, Error>()
            requests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeRequest(with result: TypeheadSearchContentResult, atIndex index: Int) {
            let request = requests[index]
            request.send(result)
        }
        
        func completeRequestWitError(atIndex index: Int) {
            let request = requests[index]
            request.send(completion: .failure(anyNSError()))
        }
    }
}
