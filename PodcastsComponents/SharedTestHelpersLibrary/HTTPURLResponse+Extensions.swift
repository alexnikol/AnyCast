// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        let anyURL = URL(string: "https://a-url.com")!
        self.init(url: anyURL, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
