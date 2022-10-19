// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import HTTPClient

public class RemoteImageDataLoader: ImageDataLoader {
    private class HTTPTaskWrapper: ImageDataLoaderTask {
        private var completion: ((RemoteImageDataLoader.Result) -> Void)?
        var wrapped: HTTPClientTask?
        
        init(_ completion: @escaping (RemoteImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }
        
        func complete(with result: RemoteImageDataLoader.Result) {
            completion?(result)
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    public typealias Result = Swift.Result<Data, Swift.Error>
    
    public enum Error: Swift.Error {
        case invalidData
        case connectivity
    }
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    private static var OK_200: Int { return 200 }
    
    public func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> ImageDataLoaderTask {
        let task = HTTPTaskWrapper(completion)
        task.wrapped = client.get(from: url, completion: { [weak self] result in
            guard self != nil else { return }
            
            task.complete(
                with: result
                    .mapError { _ in Error.connectivity }
                    .flatMap { (data, response) in
                        let isValidResponse = response.statusCode == 200 && !data.isEmpty
                        return isValidResponse ? .success(data) : .failure(Error.invalidData)
                    }
            )
        })
        return task
    }
}
