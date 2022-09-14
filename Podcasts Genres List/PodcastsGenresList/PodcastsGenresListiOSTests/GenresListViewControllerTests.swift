// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import UIKit
import PodcastsGenresList

final class GenresListViewController: UIViewController {
    private var loader: GenresLoader?
    
    convenience init(loader: GenresLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load { _ in }
    }
}

final class GenresListViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadGenres() {
        let loader = LoaderSpy()
        _ = GenresListViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsGenres() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: GenresListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = GenresListViewController(loader: loader)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: GenresLoader {
        private(set) var loadCallCount = 0
        
        func load(completion: @escaping (LoadGenresResult) -> Void) {
            loadCallCount += 1
        }
    }
}
