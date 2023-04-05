// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SearchContentModule

extension Array where Element == SearchResultEpisode {
    func toJson() -> [[String: Any]] {
        return map { episode in
            let json = [
                "id": episode.id,
                "thumbnail": episode.thumbnail.absoluteString,
                "title_original": episode.title,
                "description_original": episode.description,
                "podcast": [episode.podcast].toJson().first!,
                "audio": episode.audio.absoluteString,
                "audio_length_sec": episode.audioLengthInSeconds,
                "explicit_content": episode.containsExplicitContent,
                "pub_date_ms": episode.publishDateInMiliseconds,
                
            ] as [String: Any]
            
            return json
        }
    }
}
