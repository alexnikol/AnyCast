// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import MapperLibrary

public final class BestPodastsItemsMapper {
    typealias Mapper = GenericAPIMapper<RemoteBestPodcastsList, BestPodcastsList>
    
    private init() {}
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> BestPodcastsList {
        return try Mapper.map(data, from: response, domainMapper: RemoteBestPodcastsList.toDomainModel)
    }
}

private extension RemoteBestPodcastsList {
    static func toDomainModel(remoteModel: RemoteBestPodcastsList) -> BestPodcastsList {
        return BestPodcastsList(genreId: remoteModel.genreId, genreName: remoteModel.genreName, podcasts: remoteModel.podcasts.toDomainModels())
    }
}

private extension Array where Element == RemotePodcast {
    func toDomainModels() -> [Podcast] {
        return map {
            Podcast(id: $0.id, title: $0.title, publisher: $0.publisher, language: $0.language, type: $0.type.toModel(), image: $0.image)
        }
    }
}
