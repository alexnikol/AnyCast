// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import HTTPClient
import SearchContentModule

import PodcastsModule

final class GeneralSearchService {
    private let baseURL: URL
    private let httpClient: HTTPClient
    
    init(baseURL: URL, httpClient: HTTPClient) {
        self.baseURL = baseURL
        self.httpClient = httpClient
    }
    
    func makeRemoteGeneralSearchLoader(term: String) -> AnyPublisher<GeneralSearchContentResult, Error> {
        let requestURL = SearchEndpoint.getGeneralSearch(term: term).url(baseURL: baseURL)
        return httpClient
            .loadPublisher(from: requestURL)
            .tryMap(GeneralSearchContentMapper.map)
            .eraseToAnyPublisher()
    }
}
