// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList
import PodcastsGenresListiOS

class GenresUISnapshotTests: XCTestCase {
    
    func test_emptyGenres() {
        let sut = makeSUT()
        
        sut.display(emptyGenres())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_GENRES_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_GENRES_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> GenresListViewController {
        let genresRefreshDelegate = GenresRefreshSpyDelegate()
        let refreshController = GenresRefreshViewController(delegate: genresRefreshDelegate)
        let controller = GenresListViewController(refreshController: refreshController)
        controller.loadViewIfNeeded()
        return controller
    }
    
    private func emptyGenres() -> [GenreCellController] {
        return []
    }
    
    private class GenresRefreshSpyDelegate: GenresRefreshViewControllerDelegate {
        func didRequestLoadingGenres() {}
    }
}
