// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct LocalPocastImageData: Equatable {
    public let data: Data
    
    public init(data: Data) {
        self.data = data
    }
}
