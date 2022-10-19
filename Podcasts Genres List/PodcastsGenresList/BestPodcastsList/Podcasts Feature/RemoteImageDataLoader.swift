// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import HTTPClient

public protocol ImageDataLoaderTask {
    func cancel()
}

public class RemoteImageDataLoader {
    private struct HTTPTaskWrapper: ImageDataLoaderTask {
        let wrapped: HTTPClientTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    public typealias Result = Swift.Result<Data, Swift.Error>
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    private static var OK_200: Int { return 200 }
    
    @discardableResult
    public func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> ImageDataLoaderTask {
        let httpTask = client.get(from: url, completion: { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                if response.statusCode == Self.OK_200 && !data.isEmpty {
                    completion(.success(data))
                } else {
                    completion(.failure(Error.invalidData))
                }
                
            case let .failure(error):
                completion(.failure(error))
            }
        })
        return HTTPTaskWrapper(wrapped: httpTask)
    }
}
