// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import UIKit
import PodcastsGenresList
import PodcastsGenresListiOS

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
    
    func test_loadGenresCompletion_rendersSuccessfullyLoadedGenres() {
        let genre0 = makeGenre(id: 1, name: "any name")
        let genre1 = makeGenre(id: 2, name: "another name")
        let genre2 = makeGenre(id: 3, name: "long name")
        let genre3 = makeGenre(id: 4, name: "some name")
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeGenresLoading(with: [genre0], at: 0)
        assertThat(sut, isRendering: [genre0])
        
        sut.simulateUserInitiatedGenresReload()
        loader.completeGenresLoading(with: [genre0, genre1, genre2, genre3], at: 1)
        assertThat(sut, isRendering: [genre0, genre1, genre2, genre3])
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
    
    private func assertThat(_ sut: GenresListViewController, isRendering genres: [Genre], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedGenresViews() == genres.count else {
            return XCTFail("Expected \(genres.count) rendered genres, got \(sut.numberOfRenderedGenresViews()) rendered views instead")
        }
        
        genres.enumerated().forEach { index, genre in
            assertThat(sut, hasViewConfiguredFor: genre, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(
        _ sut: GenresListViewController,
        hasViewConfiguredFor genre: Genre,
        at index: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let view = sut.genreView(at: index) as? GenreCell
        XCTAssertNotNil(view, file: file, line: line)
        XCTAssertEqual(view?.nameText, genre.name, "Wrong name at index \(index)", file: file, line: line)
    }
    
    private func makeGenre(id: Int, name: String) -> Genre {
        return Genre(id: id, name: name)
    }
    
    class LoaderSpy: GenresLoader {
        private var completions = [(LoadGenresResult) -> Void]()
        
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (LoadGenresResult) -> Void) {
            completions.append(completion)
        }
        
        func completeGenresLoading(with genres: [Genre] = [], at index: Int) {
            completions[index](.success(genres))
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
    
    private var genresSection: Int {
        return 0
    }
    
    func numberOfRenderedGenresViews() -> Int {
        return collectionView.numberOfItems(inSection: genresSection)
    }
    
    func genreView(at row: Int) -> UICollectionViewCell? {
        let ds = collectionView.dataSource
        let index = IndexPath(row: row, section: genresSection)
        return ds?.collectionView(collectionView, cellForItemAt: index)
    }
}

private extension GenreCell {
    var nameText: String? {
        return nameLabel.text
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
