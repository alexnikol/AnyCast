// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

final class BestPodastsItemsMapper {
    
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> RemoteBestPodcastsList {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(RemoteBestPodcastsList.self, from: data) else {
            throw RemoteBestPodcastsLoader.Error.invalidData
        }
        
        return root
    }
}
