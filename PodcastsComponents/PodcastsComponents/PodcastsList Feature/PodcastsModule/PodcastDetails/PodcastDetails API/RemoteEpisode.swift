// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

struct RemoteEpisode: Decodable {
    let id: String
    let title: String
    let description: String
    let thumbnail: URL
    let audio: URL
    let audioLengthInSeconds: Int
    let containsExplicitContent: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id, title, description, thumbnail, audio
        case audioLengthInSeconds = "audio_length_sec"
        case containsExplicitContent = "explicit_content"
    }
}
