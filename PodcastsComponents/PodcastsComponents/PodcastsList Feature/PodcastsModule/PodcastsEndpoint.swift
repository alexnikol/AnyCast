// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public enum PodcastsEndpoint {
    case getPodcastDetails(podcastID: String)
    case getBestPodcasts(genreID: Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .getPodcastDetails(let podcastID):
            var urlBuilder = URLComponents()
            urlBuilder.scheme = baseURL.scheme
            urlBuilder.host = baseURL.host
            urlBuilder.path = "/api/v2/podcasts/\(podcastID)"
            return urlBuilder.url!
            
        case .getBestPodcasts(let genreID):
            var urlBuilder = URLComponents()
            urlBuilder.scheme = baseURL.scheme
            urlBuilder.host = baseURL.host
            urlBuilder.path = "/api/v2/best_podcasts"
            urlBuilder.queryItems = [URLQueryItem(name: "genre_id", value: String(genreID))]
            return urlBuilder.url!
        }
    }
}
