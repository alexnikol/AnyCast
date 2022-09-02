// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

final class GenresItemsMapper {
    
    private struct Root: Decodable {
        let genres: [Item]
        
        var list: [Genre] {
            return genres.map { $0.item }
        }
    }

    private struct Item: Decodable {
        let id: Int
        let name: String
        
        var item: Genre {
            return .init(id: id, name: name)
        }
    }
    
    private static var OK_200: Int { return 200 }
        
    static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteGenresLoader.Result {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(.invalidData)
        }
        
        return .success(root.list)
    }
}
