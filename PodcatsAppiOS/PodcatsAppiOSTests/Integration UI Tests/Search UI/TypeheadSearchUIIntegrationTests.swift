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
    }
}
