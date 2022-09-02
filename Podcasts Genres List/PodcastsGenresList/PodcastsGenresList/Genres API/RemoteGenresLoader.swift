// Copyright © 2022 Almost Engineer. All rights reserved. 

import Foundation

public typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteGenresLoader {
    public typealias Result = Swift.Result<[Genre], Error>
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url, completion: { result in
            switch result {
            case let .success((data, response)):
                do {
                    let items = try GenresItemsMapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        })
    }
}

private class GenresItemsMapper {
    
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
    
    static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [Genre] {
        guard response.statusCode == OK_200 else {
            throw RemoteGenresLoader.Error.invalidData
        }
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.genres.map { $0.item }
    }
}
