// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
@testable import Podcats

class RootTabBarControllerLocalizationTests: XCTestCase, LocalizationTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Main"
        let presentationBundle = Bundle(for: RootTabBarPresenter.self)

        checkForMissingLocalizationInAllSupportedLanguages(bundle: presentationBundle, table: table)
    }
}
