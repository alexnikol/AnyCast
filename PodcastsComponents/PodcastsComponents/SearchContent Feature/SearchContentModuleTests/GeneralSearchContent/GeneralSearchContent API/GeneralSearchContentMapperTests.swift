// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule
import SearchContentModule

final class GeneralSearchContentMapperTests: XCTestCase {
    
    func test_map_deliversGeneralSearchContentResultOn200HTTPResponseWithJSONItems() throws {
        let episodes = uniqueEpisodeSearchResults()
        let podcasts = uniquePodcastSearchResults()
        let curatedLists = uniqueCuratedListsSearchResults()
        let validJSON = makeValidJSON(episodes: episodes, podcasts: podcasts, curatedLists: curatedLists)
        if let JSONString = String(data: validJSON, encoding: String.Encoding.utf8) {
           print(JSONString)
        }
        let result = try GeneralSearchContentMapper.map(validJSON, from: HTTPURLResponse(statusCode: 200))
        
        let resultEpisodes = episodes.map { GeneralSearchContentResultItem.episode($0) }
        let resultPodcasts = podcasts.map { GeneralSearchContentResultItem.podcast($0) }
        let resultCuratedLists = curatedLists.map { GeneralSearchContentResultItem.curatedList($0) }
        XCTAssertEqual(result, GeneralSearchContentResult(result: resultEpisodes + resultPodcasts + resultCuratedLists))
    }
    
    // MARK: - Helpers
    
    private func makeValidJSON(
        episodes: [Episode],
        podcasts: [SearchResultPodcast],
        curatedLists: [SearchResultCuratedList]
    ) -> Data {
        let episodes = episodes.toJson()
        let podcasts = podcasts.toJson()
        let curatedList = curatedLists.toJson()
        
        let json = [
            "results": episodes + podcasts + curatedList
        ] as [String: Any]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
