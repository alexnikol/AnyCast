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
    
    func test_genresContent() {
        let sut = makeSUT()
        
        sut.display(genresContent())

        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "GENRES_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "GENRES_WITH_CONTENT_dark")
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
    
    private func genresContent() -> [GenreCellController] {
        return [
            GenreCellController(model: GenreCellViewModel(name: "Genre 1", color: .red)),
            GenreCellController(model: GenreCellViewModel(name: "Genre 2", color: .green)),
            GenreCellController(model: GenreCellViewModel(name: "Genre 3", color: .blue)),
            GenreCellController(model: GenreCellViewModel(name: "Genre 4", color: .orange)),
            GenreCellController(model: GenreCellViewModel(name: "Genre 5", color: .yellow))
        ]
    }
    
    private class GenresRefreshSpyDelegate: GenresRefreshViewControllerDelegate {
        func didRequestLoadingGenres() {}
    }
}
