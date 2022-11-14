// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public enum PodcastsEndpoint {
    case get(podcastID: String)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get(let podcastID):
            var urlBuilder = URLComponents()
            urlBuilder.scheme = baseURL.scheme
            urlBuilder.host = baseURL.host
            urlBuilder.path = "/api/v2/podcasts/\(podcastID)"
            return urlBuilder.url!
        }
    }
}
