// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import HTTPClient

final class HTTPClientSpy: HTTPClient {
    private class Task: HTTPClientTask {
        private let cancelCallback: () -> Void
        
        init(cancelCallback: @escaping () -> Void) {
            self.cancelCallback = cancelCallback
        }
        
        func cancel() {
            cancelCallback()
        }
    }
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    var cancelledURLs: [URL] = []
    
    private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) -> HTTPClientTask {
        messages.append((url, completion))
        return Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: messages[index].url,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        messages[index].completion(.success((data, response)))
    }
}
