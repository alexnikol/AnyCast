// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import MapperLibrary

public final class GenresItemsMapper {
    
    typealias Mapper = GenericAPIMapper<RemoteGenresList, [Genre]>
    
    private init() {}
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Genre] {
        return try Mapper.map(data, from: response, domainMapper: RemoteGenresList.toDomainModels)
    }
}

private extension RemoteGenresList {
    static func toDomainModels(remoteModel: RemoteGenresList) -> [Genre] {
        return remoteModel.genres.toModels()
    }
}

private extension Array where Element == RemoteGenre {
    func toModels() -> [Genre] {
        return map { Genre(id: $0.id, name: $0.name) }
    }
}
