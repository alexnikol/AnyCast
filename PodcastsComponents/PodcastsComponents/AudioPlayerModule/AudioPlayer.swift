// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol AudioPlayer {
    var delegate: AudioPlayerOutputDelegate? { get set }
}
