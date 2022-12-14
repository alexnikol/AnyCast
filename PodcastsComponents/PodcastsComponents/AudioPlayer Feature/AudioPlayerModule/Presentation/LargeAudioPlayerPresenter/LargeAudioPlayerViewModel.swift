// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct LargeAudioPlayerViewModel {    
    public let titleLabel: String
    public let descriptionLabel: String
    public let updates: [UpdatesViewModel]
    
    public init(
        titleLabel: String,
        descriptionLabel: String,
        updates: [UpdatesViewModel]
    ) {
        self.titleLabel = titleLabel
        self.descriptionLabel = descriptionLabel
        self.updates = updates
    }
}
