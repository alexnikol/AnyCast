// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import Combine
import SharedTestHelpersLibrary
import SharedComponentsiOSModule
import SearchContentModule
import SearchContentModuleiOS
@testable import Podcats

final class GeneralSearchUIIntegrationTests: XCTestCase {
    
    func test_loadGeneralSearchResultActions_requestGeneralSearchOnTermChange() {
        let (sut, sourceDelegate, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected a no loading request once view is loaded")
        
        sourceDelegate.didUpdateSearchTerm("any search term")
        XCTAssertEqual(loader.loadCallCount, 1, "Expected loading request on text change")
        
        sourceDelegate.didUpdateSearchTerm("another search term")
        XCTAssertEqual(loader.loadCallCount, 2, "Expected 2 loading requests on text change")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: ListViewController, sourceDelegate: GeneralSearchSourceDelegate, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let searchResultController = SearchResultViewControllerNullObject()
        let (sut, sourceDelegate) = GeneralSearchUIComposer
            .searchComposedWith(
                searchResultController: searchResultController,
                searchLoader: loader.loadPublisher
            )
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, sourceDelegate, loader)
    }
    
    private class LoaderSpy {
        typealias Publsiher = AnyPublisher<GeneralSearchContentResult, Error>
        
        private var requests = [PassthroughSubject<GeneralSearchContentResult, Error>]()
        private(set) var cancelledTerms = [String]()
        
        var loadCallCount: Int {
            return requests.count
        }
        
        func loadPublisher(for searchTerm: String) -> Publsiher {
            let publisher = PassthroughSubject<GeneralSearchContentResult, Error>()
            
            let cancelPublisher = publisher.handleEvents(receiveCancel: { [weak self] in
                self?.cancelledTerms.append(searchTerm)
            })
            requests.append(publisher)
            return cancelPublisher.eraseToAnyPublisher()
        }
        
        func completeRequest(with result: GeneralSearchContentResult, atIndex index: Int) {
            requests[index].send(result)
        }
        
        func completeRequestWitError(atIndex index: Int) {
            requests[index].send(completion: .failure(anyNSError()))
        }
    }
    
    private final class SearchResultViewControllerNullObject: UIViewController, UISearchBarDelegate {
        
    }
}
