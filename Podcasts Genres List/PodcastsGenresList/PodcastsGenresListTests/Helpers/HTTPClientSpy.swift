// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import HTTPClient

final class HTTPClientSpy: HTTPClient {
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        messages.append((url, completion))
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
