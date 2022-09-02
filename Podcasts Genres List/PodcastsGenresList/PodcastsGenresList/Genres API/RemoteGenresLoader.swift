// Copyright © 2022 Almost Engineer. All rights reserved. 

import Foundation

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
                completion(GenresItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        })
    }
}
