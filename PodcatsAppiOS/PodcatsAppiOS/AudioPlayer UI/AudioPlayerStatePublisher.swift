// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import AudioPlayerModule

final class AudioPlayerStatePublisherService {
    private init() {}
    
    static let shared = AudioPlayerStatePublisher()
}
