// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import SearchContentModule
import PodcastsGenresList

final class TypeaheadSearchContentMapperTests: XCTestCase {
    
    func test_map_deliversTypeaheadSearchContentResultOn200HTTPResponseWithJSONItems() throws {
        let terms = uniqueTerms()
        let genres = uniqueGenres()
        let podcasts = uniquePodcastSearchResults()
        let validJSON = makeValidJSON(terms: terms, genres: genres, podcasts: podcasts)
        
        let result = try TypeaheadSearchContentMapper.map(validJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, TypeaheadSearchContentResult(terms: terms, genres: genres, podcasts: podcasts))
    }
    
    // MARK: - Helpers
    
    private func makeValidJSON(
        terms: [String],
        genres: [Genre],
        podcasts: [SearchResultPodcast]
    ) -> Data {
        let json = [
            "terms": terms,
            "genres": genres.toJson(),
            "podcasts": podcasts.toJson()
        ] as [String: Any]
        
        return try! JSONSerialization.data(withJSONObject: json)
    }
}

private extension Array where Element == Genre {
    func toJson() -> [[String: Any]] {
        map { genre in
            let json = [
                "id": genre.id,
                "name": genre.name
            ] as [String: Any]
            
            return json
        }
    }
}
