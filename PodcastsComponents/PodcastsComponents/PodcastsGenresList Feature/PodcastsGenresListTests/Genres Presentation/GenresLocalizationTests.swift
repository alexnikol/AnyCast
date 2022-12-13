// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList

final class GenresLocalizationTests: XCTestCase, LocalizationTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Genres"
        let presentationBundle = Bundle(for: GenresPresenter.self)

        checkForMissingLocalizationInAllSupportedLanguages(bundle: presentationBundle, table: table)
    }
}
