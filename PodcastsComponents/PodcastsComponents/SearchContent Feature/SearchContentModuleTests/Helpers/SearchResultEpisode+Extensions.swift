// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsModule
import SearchContentModule

extension Array where Element == Episode {
    func toJson() -> [[String: Any]] {
        let podcast = uniquePodcastSearchResults().toJson()[0]
        return map { episode in
            let json = [
                "id": episode.id,
                "thumbnail": episode.thumbnail.absoluteString,
                "title_original": episode.title,
                "description_original": episode.description,
                "podcast": podcast,
                "audio": episode.audio.absoluteString,
                "audio_length_sec": episode.audioLengthInSeconds,
                "explicit_content": episode.containsExplicitContent,
                "pub_date_ms": episode.publishDateInMiliseconds,
                
            ] as [String: Any]
            
            return json
        }
    }
}
