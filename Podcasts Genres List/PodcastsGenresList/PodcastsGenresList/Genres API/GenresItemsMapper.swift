// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

struct RemoteGenre: Decodable {
    let id: Int
    let name: String
}

final class GenresItemsMapper {
    
    private struct Root: Decodable {
        let genres: [RemoteGenre]
    }
    
    private static var OK_200: Int { return 200 }
        
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteGenre] {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteGenresLoader.Error.invalidData
        }
        
        return root.genres
    }
}
