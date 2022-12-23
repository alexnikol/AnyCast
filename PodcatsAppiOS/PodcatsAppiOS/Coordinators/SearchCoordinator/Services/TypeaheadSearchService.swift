// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import HTTPClient
import SearchContentModule

final class TypeaheadSearchService {
    private let baseURL: URL
    private let httpClient: HTTPClient
    
    init(baseURL: URL, httpClient: HTTPClient) {
        self.baseURL = baseURL
        self.httpClient = httpClient
    }
    
    func makeRemoteTypeaheadSearchLoader(term: String) -> AnyPublisher<TypeaheadSearchContentResult, Error> {
        let requestURL = SearchEndpoint.getTypeaheadSearch(term: term).url(baseURL: baseURL)
        return httpClient
            .loadPublisher(from: requestURL)
            .tryMap(TypeaheadSearchContentMapper.map)
            .eraseToAnyPublisher()
    }
}
