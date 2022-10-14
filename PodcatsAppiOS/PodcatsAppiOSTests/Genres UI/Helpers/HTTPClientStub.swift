// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

class HTTPClientStub: HTTPClient {
    private let stub: (URL) -> HTTPClientResult
    
    init(stub: @escaping (URL) -> HTTPClientResult) {
        self.stub = stub
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        completion(stub(url))
    }
    
    static var offline: HTTPClientStub {
        HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
    }
    
    static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
        HTTPClientStub { url in .success(stub(url)) }
    }
}
