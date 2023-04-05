// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public enum SearchEndpoint {
    case getGeneralSearch(term: String)
    case getTypeaheadSearch(term: String)
        
    public func url(baseURL: URL) -> URL {
        switch self {
        case .getGeneralSearch(let term):
            var urlBuilder = build(fromBaseURL: baseURL, path: "/api/v2/search")
            urlBuilder.queryItems = [URLQueryItem(name: "q", value: term)]
            return urlBuilder.url!
            
        case .getTypeaheadSearch(let term):
            var urlBuilder = build(fromBaseURL: baseURL, path: "/api/v2/typeahead")
            urlBuilder.queryItems = [URLQueryItem(name: "q", value: term)]
            return urlBuilder.url!
        }
    }
    
    private func build(fromBaseURL url: URL, path: String) -> URLComponents {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = url.scheme
        urlBuilder.host = url.host
        urlBuilder.path = path
        return urlBuilder
    }
}
