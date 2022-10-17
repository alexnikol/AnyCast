// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

public class RemoteBestPodcastsLoader {
    
    public typealias Result = BestPodcastsLoader.Result
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private let client: HTTPClient
    private let url: URL
    
    public init(genreID: Int, url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (BestPodcastsLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .failure:
                completion(.failure(Error.connectivity))
                
            case let .success((data, response)):
                completion(Self.map(data: data, response: response))
            }
        }
    }
    
    private static func map(data: Data, response: HTTPURLResponse) -> Result {
        do {
            let remoteList = try BestPodastsItemsMapper.map(data, from: response)
            return .success(remoteList.toModel())
        } catch {
            return .failure(error)
        }
    }
}

extension RemoteBestPodcastsList {
    func toModel() -> BestPodcastsList {
        return BestPodcastsList(genreId: genreId, genreName: genreName, podcasts: podcasts.toModels())
    }
}

extension Array where Element == RemotePodcast {
    func toModels() -> [Podcast] {
        return map {
            Podcast(id: $0.id, title: $0.title, image: $0.image)
        }
    }
}
