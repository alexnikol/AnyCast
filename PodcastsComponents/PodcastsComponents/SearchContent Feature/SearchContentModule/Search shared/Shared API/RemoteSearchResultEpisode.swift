// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

struct RemoteSearchResultEpisode: Decodable {
    let id: String
    let audio: URL
    let image: URL
    let thumbnail: URL
    let titleOriginal: String
    let descriptionOriginal: String
    let audioLengthInSeconds: Int
    let containsExplicitContent: Bool
    let publishDateInMiliseconds: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, image, thumbnail, audio
        case titleOriginal = "title_original"
        case descriptionOriginal = "description_original"
        case audioLengthInSeconds = "audio_length_sec"
        case containsExplicitContent = "explicit_content"
        case publishDateInMiliseconds = "pub_date_ms"
    }
}

extension RemoteSearchResultEpisode {
    func toDomainModel() -> SearchResultEpisode {
        SearchResultEpisode(
            id: id,
            titleOriginal: titleOriginal,
            descriptionOriginal: descriptionOriginal,
            image: image,
            thumbnail: thumbnail,
            audio: audio,
            audioLengthInSeconds: audioLengthInSeconds,
            containsExplicitContent: containsExplicitContent,
            publishDateInMiliseconds: publishDateInMiliseconds
        )
    }
}
