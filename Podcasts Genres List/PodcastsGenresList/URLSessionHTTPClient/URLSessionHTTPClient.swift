// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import HTTPClient

public final class URLSessionHTTPClient: HTTPClient {
    private class URLSessionTaskWrapper: HTTPClientTask {
        private let wrapped: URLSessionDataTask
        
        init(wrapped: URLSessionDataTask) {
            self.wrapped = wrapped
        }
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    struct UnexpectedValuesRepresentation: Error {}
    
    @discardableResult
    public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}
