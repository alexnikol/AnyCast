// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public enum PodcastsEndpoint {
    case getPodcastDetails(podcastID: String)
    case getBestPodcasts(genreID: Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .getPodcastDetails(let podcastID):
            return build(fromBaseURL: baseURL, path: "/api/v2/podcasts/\(podcastID)").url!
            
        case .getBestPodcasts(let genreID):
            var urlBuilder = build(fromBaseURL: baseURL, path: "/api/v2/best_podcasts")
            urlBuilder.queryItems = [URLQueryItem(name: "genre_id", value: String(genreID))]
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
