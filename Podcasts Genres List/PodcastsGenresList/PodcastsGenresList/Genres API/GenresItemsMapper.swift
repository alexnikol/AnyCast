// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public final class GenresItemsMapper {
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private struct Root: Decodable {
        let genres: [RemoteGenre]
    }
    
    private static var OK_200: Int { return 200 }
        
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Genre] {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.genres.toModels()
    }
}

private extension Array where Element == RemoteGenre {
    func toModels() -> [Genre] {
        return map { Genre(id: $0.id, name: $0.name) }
    }
}
