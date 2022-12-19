// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import MapperLibrary

public enum PodcastDetailsMapper {
    typealias Mapper = GenericAPIMapper<RemotePodcastDetails, PodcastDetails>
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> PodcastDetails {
        return try Mapper.map(data, from: response, domainMapper: RemotePodcastDetails.toDomainModel)
    }
}

private extension RemotePodcastDetails {
    static func toDomainModel(remoteModel: RemotePodcastDetails) -> PodcastDetails {
        return PodcastDetails(
            id: remoteModel.id,
            title: remoteModel.title,
            publisher: remoteModel.publisher,
            language: remoteModel.language,
            type: remoteModel.type.toModel(),
            image: remoteModel.image,
            episodes: remoteModel.episodes.toModels(),
            description: remoteModel.description,
            totalEpisodes: remoteModel.totalEpisodes
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
