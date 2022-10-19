// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import HTTPClient

public protocol ImageDataLoaderTask {
    func cancel()
}

public class RemoteImageDataLoader {
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
    }
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    private static var OK_200: Int { return 200 }
    
    @discardableResult
    public func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> ImageDataLoaderTask {
        let task = HTTPTaskWrapper(completion)
        task.wrapped = client.get(from: url, completion: { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                if response.statusCode == Self.OK_200 && !data.isEmpty {
                    task.complete(with: .success(data))
                } else {
                    task.complete(with: .failure(Error.invalidData))
                }
                
            case let .failure(error):
                task.complete(with: .failure(error))
            }
        })
        return task
    }
}
