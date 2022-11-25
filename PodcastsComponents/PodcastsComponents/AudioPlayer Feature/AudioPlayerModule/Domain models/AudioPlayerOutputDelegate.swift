// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol AudioPlayerOutputDelegate {
    func didUpdateState(with state: PlayerState)
}
