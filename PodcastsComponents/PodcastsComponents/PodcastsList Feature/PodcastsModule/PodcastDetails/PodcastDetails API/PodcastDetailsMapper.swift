// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public final class PodcastDetailsMapper {
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private static var OK_200: Int { return 200 }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> PodcastDetails {
        guard response.statusCode == OK_200,
              let remotePodcastDetails = try? JSONDecoder().decode(RemotePodcastDetails.self, from: data) else {
            throw Error.invalidData
        }
        
        return remotePodcastDetails.toModel()
    }
}

private extension RemotePodcastDetails {
    func toModel() -> PodcastDetails {
        return PodcastDetails(
            id: id,
            title: title,
            publisher: publisher,
            language: language,
            type: type.toModel(),
            image: image,
            episodes: episodes.toModels(),
            description: description,
            totalEpisodes: totalEpisodes
        )
    }
}

private extension Array where Element == RemoteEpisode {
    func toModels() -> [Episode] {
        return map {
            Episode(
                id: $0.id,
                title: $0.title,
                description: $0.description,
                thumbnail: $0.thumbnail,
                audio: $0.audio,
                audioLengthInSeconds: $0.audioLengthInSeconds,
                containsExplicitContent: $0.containsExplicitContent,
                publishDateInMiliseconds: $0.publishDateInMiliseconds
            )
        }
    }
}
