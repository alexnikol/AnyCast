// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public final class GeneralSearchContentResult: Equatable {
    public let result: [GeneralSearchContentResultItem]
    
    public init(result: [GeneralSearchContentResultItem]) {
        self.result = result
    }
    
    public static func == (lhs: GeneralSearchContentResult, rhs: GeneralSearchContentResult) -> Bool {
        return lhs.result == rhs.result
    }
}
