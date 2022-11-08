// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public final class BestPodastsItemsMapper {
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private static var OK_200: Int { return 200 }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> BestPodcastsList {
        guard response.statusCode == OK_200,
              let remoteBestPocdastsList = try? JSONDecoder().decode(RemoteBestPodcastsList.self, from: data) else {
            throw Error.invalidData
        }

        return remoteBestPocdastsList.toModel()
    }
}

private extension RemoteBestPodcastsList {
    func toModel() -> BestPodcastsList {
        return BestPodcastsList(genreId: genreId, genreName: genreName, podcasts: podcasts.toModels())
    }
}

private extension Array where Element == RemotePodcast {
    func toModels() -> [Podcast] {
        return map {
            Podcast(id: $0.id, title: $0.title, publisher: $0.publisher, language: $0.language, type: $0.type.toModel(), image: $0.image)
        }
    }
}
