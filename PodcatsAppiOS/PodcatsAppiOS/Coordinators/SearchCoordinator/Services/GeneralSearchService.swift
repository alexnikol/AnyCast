// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import HTTPClient
import SearchContentModule

final class GeneralSearchService {
    private let baseURL: URL
    private let httpClient: HTTPClient
    
    init(baseURL: URL, httpClient: HTTPClient) {
        self.baseURL = baseURL
        self.httpClient = httpClient
    }
    
    func makeRemoteGeneralSearchLoader(from url: URL) -> AnyPublisher<GeneralSearchContentResult, Error> {
        let requestURL = URL(string: "https://anyurl")!
        return httpClient
            .loadPublisher(from: requestURL)
            .tryMap(GeneralSearchContentMapper.map)
            .eraseToAnyPublisher()
    }
}
