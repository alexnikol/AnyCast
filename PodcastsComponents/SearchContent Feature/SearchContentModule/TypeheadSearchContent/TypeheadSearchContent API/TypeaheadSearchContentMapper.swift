// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import MapperLibrary
import PodcastsGenresList

public enum TypeaheadSearchContentMapper {
    typealias Mapper = GenericAPIMapper<RemoteTypeaheadSearchContentResult, TypeaheadSearchContentResult>
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> TypeaheadSearchContentResult {
        return try Mapper.map(data, from: response, domainMapper: RemoteTypeaheadSearchContentResult.toDomainModel)
    }
}

private extension RemoteTypeaheadSearchContentResult {
    static func toDomainModel(remoteModel: RemoteTypeaheadSearchContentResult) -> TypeaheadSearchContentResult {
        TypeaheadSearchContentResult(
            terms: remoteModel.terms,
            genres: remoteModel.genres.map(RemoteGenre.toDomainModel),
            podcasts: remoteModel.podcasts.map { $0.toDomainModel() }
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
