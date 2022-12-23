// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import HTTPClient
import SearchContentModule

final class TypeheadSearchService {
    private let baseURL: URL
    private let httpClient: HTTPClient
    
    init(baseURL: URL, httpClient: HTTPClient) {
        self.baseURL = baseURL
        self.httpClient = httpClient
    }
    
    func makeRemoteTypeheadSearchLoader(term: String) -> AnyPublisher<TypeheadSearchContentResult, Error> {
        let requestURL = SearchEndpoint.getTypeheadSearch(term: term).url(baseURL: baseURL)
        return httpClient
            .loadPublisher(from: requestURL)
            .tryMap(TypeheadSearchContentMapper.map)
            .eraseToAnyPublisher()
    }
}
