// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import UIKit
import PodcastsGenresList
import PodcastsGenresListiOS
@testable import Podcats

class GenresAcceptanceTests: XCTestCase {
    
    func test_onLaunch_displaysRemoteGenresWhenCustomerHasConnectivityAndEmptyCache() {
        let httpClient = HTTPClientStub.online(response)
        let sut = SceneDelegate(httpClient: httpClient)
        sut.window = UIWindow()
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        let genresView = nav?.topViewController as! GenresListViewController
        
        XCTAssertEqual(genresView.numberOfRenderedGenresViews(), 2)
    }
    
    // MARK: - Helpers
    
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
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        let baseURL = "https://listen-api-test.listennotes.com"
        switch url.absoluteString {
        case "\(baseURL)/api/v2/genres":
            return makeGenresData()
            
        default:
            return Data()
        }
    }
            
    private func makeGenresData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["genres": [
            ["id": 1, "name": "Genre 1"],
            ["id": 2, "name": "Genre 2"]
        ]])
    }
}
