// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import UIKit
import PodcastsGenresList

final class GenresListViewController: UICollectionViewController {
    private var loader: GenresLoader?
    
    convenience init(collectionViewLayout layout: UICollectionViewLayout, loader: GenresLoader) {
        self.init(collectionViewLayout: layout)
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(load), for: .valueChanged)
        refreshControl.beginRefreshing()
        
        load()
    }
    
    @objc
    private func load() {
        loader?.load { _ in }
    }
}

final class GenresListViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadGenres() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsGenres() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    func test_pullToRefresh_loadsGenres() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.collectionView.refreshControl?.simulatePullToRefresh()
        
        XCTAssertEqual(loader.loadCallCount, 2)
        
        sut.collectionView.refreshControl?.simulatePullToRefresh()
        
        XCTAssertEqual(loader.loadCallCount, 3)
    }
    
    func test_viewDidLoad_showsLoadingIndicator() {
        let (sut, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.collectionView.refreshControl?.isRefreshing, true)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: GenresListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let flowLayout = UICollectionViewFlowLayout()
        let sut = GenresListViewController(collectionViewLayout: flowLayout, loader: loader)
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

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        self.allTargets.forEach { target in
                actions(forTarget: target, forControlEvent: .valueChanged)?
                .forEach {
                    (target as NSObject).perform(Selector($0))
            }
        }
    }
}
