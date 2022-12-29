// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public enum LocalEpisodeDuration: Equatable {
    case notDefined
    case valueInSeconds(Int)
}

// MARK: - LocalEpisodeDuration mapping helper

extension LocalEpisodeDuration {
    func toModel() -> EpisodeDuration {
        switch self {
        case .notDefined:
            return .notDefined
            
        case .valueInSeconds(let value):
            return .valueInSeconds(value)
        }
    }
}
