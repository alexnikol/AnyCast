// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import PodcastsGenresList

final class GenresPresenterTests: XCTestCase, LocalizationTestCase {
    
    func test_title_isLocalized() {
        XCTAssertEqual(GenresPresenter.title, localized("GENRES_VIEW_TITLE", bundle: bundle, table: tableName))
    }
    
    func test_map_createsViewModel() {
        let genres = uniqueGenres().models
        
        let viewModel = GenresPresenter.map(genres)
        
        XCTAssertEqual(genres, viewModel.genres)
    }
        
    // MARK: - Helpers
    
    private var tableName: String {
        "Genres"
    }
    
    private var bundle: Bundle {
        Bundle(for: GenresPresenter.self)
    }
}
