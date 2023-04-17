// Copyright © 2023 Almost Engineer. All rights reserved.

import Foundation

public extension String {
    func repeatTimes(_ times: Int) -> String {
        return String(repeating: self + " ", count: times)
    }
}
