// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import HTTPClient

public class RemoteImageDataLoader: PodcastImageDataLoader {        
    public typealias Result = Swift.Result<Data, Swift.Error>
    
    public enum Error: Swift.Error {
        case invalidData
        case connectivity
    }
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> PodcastImageDataLoaderTask {
        let task = HTTPTaskWrapper(completion)
        task.wrapped = client.get(from: url, completion: { [weak self] result in
            guard self != nil else { return }
            
            task.complete(with: Self.map(result: result))
        })
        return task
    }
    
    private static func map(result: HTTPClientResult) -> RemoteImageDataLoader.Result {
        result
            .mapError { _ in Error.connectivity }
            .flatMap { (data, response) in
                let isValidResponse = response.isOK && !data.isEmpty
                return isValidResponse ? .success(data) : .failure(Error.invalidData)
            }
    }
}
