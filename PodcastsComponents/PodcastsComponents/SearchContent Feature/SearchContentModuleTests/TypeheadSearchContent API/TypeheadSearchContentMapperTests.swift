// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import SearchContentModule
import PodcastsGenresList

final class TypeheadSearchContentMapperTests: XCTestCase {
    
    func test_map_deliversTypeheadSearchContentResultOn200HTTPResponseWithJSONItems() throws {
        let terms = uniqueTerms()
        let genres = uniqueGenres()
        let podcasts = uniquePodcastSearchResults()
        let validJSON = makeValidJSON(terms: terms, genres: genres, podcasts: podcasts)
        
        let result = try TypeheadSearchContentMapper.map(validJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, TypeheadSearchContentResult(terms: terms, genres: genres, podcasts: podcasts))
    }
    
    // MARK: - Helpers
    private func makeValidJSON(
        terms: [String],
        genres: [Genre],
        podcasts: [PodcastSearchResult]
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

private extension Array where Element == PodcastSearchResult {
    func toJson() -> [[String: Any]] {
        map { podcast in
            let json = [
                "id": podcast.id,
                "image": podcast.image.absoluteString,
                "thumbnail": podcast.thumbnail.absoluteString,
                "title_original": podcast.titleOriginal,
                "publisher_original": podcast.publisherOriginal
            ] as [String: Any]
            
            return json
        }
    }
}
