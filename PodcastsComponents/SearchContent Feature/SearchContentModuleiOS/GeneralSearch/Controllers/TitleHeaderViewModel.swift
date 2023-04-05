// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct TitleHeaderViewModel {
    public let title: String
    public let description: String?
    
    public init(title: String, description: String? = nil) {
        self.title = title
        self.description = description
    }
}
