// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public func anyURL() -> URL {
    URL(string: "https://a-url.com")!
}

public func anotherURL() -> URL {
    URL(string: "https://another-url.com")!
}

public func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

public func anyData() -> Data {
    Data("anyData".utf8)
}
