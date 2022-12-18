// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

enum RemoteGeneralSearchContentResultItem: Decodable {
    private enum Error: Swift.Error {
        case doesNotMatchAnyExpectedObject
    }
    
    case episode(RemoteSearchResultEpisode)
    case podcast(RemoteSearchResultPodcast)
    case curatedList(RemoteSearchResultCuratedList)
    
    
    private enum CodingKeys: String, CodingKey {
        case nestedPodcastReference = "podcast"
        case curatedPodcastsList = "podcasts"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _ = try container.decodeIfPresent(RemoteSearchResultPodcast.self,
                                                 forKey: CodingKeys.nestedPodcastReference),
           let episode = try? RemoteSearchResultEpisode(from: decoder) {
            self = .episode(episode)
            return
        }
        
        if let _ = try container.decodeIfPresent([RemoteSearchResultPodcast].self,
                                                 forKey: CodingKeys.curatedPodcastsList),
           let curatedList = try? RemoteSearchResultCuratedList(from: decoder) {
            self = .curatedList(curatedList)
            return
        }
        
        if let podcast = try? RemoteSearchResultPodcast(from: decoder) {
            self = .podcast(podcast)
            return
        }
        
        throw Error.doesNotMatchAnyExpectedObject
    }
}
