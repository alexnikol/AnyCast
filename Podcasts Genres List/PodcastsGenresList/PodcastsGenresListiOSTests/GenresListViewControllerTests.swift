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
        load()
    }
    
    @objc
    private func load() {
        collectionView.refreshControl?.beginRefreshing()
        loader?.load { [weak self] _ in
            self?.collectionView.refreshControl?.endRefreshing()
        }
    }
}

final class GenresListViewControllerTests: XCTestCase {
        
    func test_loadGenresActions_requestGenresFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedGenresReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a load")
        
        sut.simulateUserInitiatedGenresReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected a third loading request once user initiates a load")
    }
        
    func test_loadGenresIndicator_isVisibleWhileLoadingGenres() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowinLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeGenresLoading(at: 0)
        XCTAssertFalse(sut.isShowinLoadingIndicator, "Expected no loading indicator once loading is complete")
        
        sut.simulateUserInitiatedGenresReload()
        XCTAssertTrue(sut.isShowinLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeGenresLoading(at: 1)
        XCTAssertFalse(sut.isShowinLoadingIndicator, "Expected no loading indicator once user initiated loading is completed")
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
        private var completions = [(LoadGenresResult) -> Void]()
        
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (LoadGenresResult) -> Void) {
            completions.append(completion)
        }
        
        func completeGenresLoading(at index: Int) {
            completions[index](.success([]))
        }
    }
}

private extension GenresListViewController {
    func simulateUserInitiatedGenresReload() {
        collectionView.refreshControl?.simulatePullToRefresh()
    }
    
    var isShowinLoadingIndicator: Bool {
        return collectionView.refreshControl?.isRefreshing == true
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        self.allTargets.forEach { target in
                actions(forTarget: target, forControlEvent: .valueChanged)?
                .forEach { (target as NSObject).perform(Selector($0)) }
        }
    }
}
