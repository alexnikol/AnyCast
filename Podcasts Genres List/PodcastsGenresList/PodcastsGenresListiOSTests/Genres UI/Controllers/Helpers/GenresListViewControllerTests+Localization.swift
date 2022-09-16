// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresListiOS

extension GenresListViewControllerTests {
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Genres"
        let bundle = Bundle(for: GenresListViewController.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: "Genres")
        
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
