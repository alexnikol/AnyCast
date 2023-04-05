// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import SearchContentModule

final class GeneralSearchLocalizationTests: XCTestCase, LocalizationTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "GeneralSearch"
        let presentationBundle = Bundle(for: GeneralSearchContentPresenter.self)

        checkForMissingLocalizationInAllSupportedLanguages(bundle: presentationBundle, table: table)
    }
}
