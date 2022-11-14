// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public enum GenresEndpoint {
    case getGenres
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .getGenres:
            return build(fromBaseURL: baseURL, path: "/api/v2/genres").url!
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
