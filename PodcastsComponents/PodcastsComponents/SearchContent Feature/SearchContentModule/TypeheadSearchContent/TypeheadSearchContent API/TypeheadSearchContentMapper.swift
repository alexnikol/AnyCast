// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import MapperLibrary
import PodcastsGenresList

public final class TypeheadSearchContentMapper {
    typealias Mapper = GenericAPIMapper<RemoteTypeheadSearchContentResult, TypeheadSearchContentResult>
    
    private init() {}
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> TypeheadSearchContentResult {
        return try Mapper.map(data, from: response, domainMapper: RemoteTypeheadSearchContentResult.toDomainModel)
    }
}

private extension RemoteTypeheadSearchContentResult {
    static func toDomainModel(remoteModel: RemoteTypeheadSearchContentResult) -> TypeheadSearchContentResult {
        TypeheadSearchContentResult(
            terms: remoteModel.terms,
            genres: remoteModel.genres.map(RemoteGenre.toDomainModel),
            podcasts: remoteModel.podcasts.map(RemoteSearchResultPodcast.toDomainModel)
        )
    }
}

private extension RemoteGenre {
    static func toDomainModel(remoteModel: RemoteGenre) -> Genre {
        Genre(
            id: remoteModel.id,
            name: remoteModel.name
        )
    }
}

private extension RemoteSearchResultPodcast {
    static func toDomainModel(remoteModel: RemoteSearchResultPodcast) -> SearchResultPodcast {
        SearchResultPodcast(
            id: remoteModel.id,
            titleOriginal: remoteModel.titleOriginal,
            publisherOriginal: remoteModel.publisherOriginal,
            image: remoteModel.image,
            thumbnail: remoteModel.thumbnail
        )
    }
}
