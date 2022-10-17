// Copyright © 2022 Almost Engineer. All rights reserved. 

import Foundation
import HTTPClient

public final class RemoteGenresLoader: GenresLoader {
    
    public typealias Result = LoadGenresResult
    
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
    
    public func load(completion: @escaping (LoadGenresResult) -> Void) {
        client.get(from: url, completion: { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(Self.map(data: data, response: response))
            
            case .failure:
                completion(.failure(Error.connectivity))
            }
        })
    }
    
    private static func map(data: Data, response: HTTPURLResponse) -> Result {
        do {
            let items = try GenresItemsMapper.map(data, from: response)
            return .success(items)
        } catch {
            return .failure(Error.invalidData)
        }
    }
}

private extension Array where Element == RemoteGenre {
    func toModels() -> [Genre] {
        return map { Genre(id: $0.id, name: $0.name) }
    }
}
