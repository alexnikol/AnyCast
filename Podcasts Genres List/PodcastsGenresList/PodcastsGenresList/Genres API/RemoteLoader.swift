// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import HTTPClient

public final class RemoteLoader<Resource> {
    
    public typealias Result = Swift.Result<Resource, Error>
    public typealias Mapper = (Data, HTTPURLResponse) throws -> Resource
    public let mapper: Mapper
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private let url: URL
    private let client: HTTPClient
    
    public init(mapper: @escaping Mapper, url: URL, client: HTTPClient) {
        self.mapper = mapper
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success((data, response)):
                do {
                    let resource = try self.mapper(data, response)
                    completion(.success(resource))
                } catch {
                    completion(.failure(Error.invalidData))
                }
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        })
    }
}
