// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest

protocol LocalizationUITestCase {}

extension LocalizationUITestCase where Self: XCTestCase {
    func localized(_ key: String, bundle: Bundle, table: String, file: StaticString = #file, line: UInt = #line) -> String {
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
