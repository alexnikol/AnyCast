// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

extension RemotePodcastType {
    func toModel() -> PodcastType {
        switch self {
        case .serial:
            return .serial
        case .episodic:
            return .episodic
        }
    }
}
