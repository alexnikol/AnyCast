// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct SpeedPlaybackViewModel: Equatable {
    public let items: [SpeedPlaybackItemViewModel]
}

public struct SpeedPlaybackItemViewModel: Equatable {
    public let displayTitle: String
    public let isSelected: Bool
    
    public init(displayTitle: String, isSelected: Bool) {
        self.displayTitle = displayTitle
        self.isSelected = isSelected
    }
}
