// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

final class GenresItemsMapper {
    
    private struct Root: Decodable {
        let genres: [Item]
    }

    private struct Item: Decodable {
        let id: Int
        let name: String
        
        var item: Genre {
            return .init(id: id, name: name)
        }
    }
    
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [Genre] {
        guard response.statusCode == OK_200 else {
            throw RemoteGenresLoader.Error.invalidData
        }
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.genres.map { $0.item }
    }
}
