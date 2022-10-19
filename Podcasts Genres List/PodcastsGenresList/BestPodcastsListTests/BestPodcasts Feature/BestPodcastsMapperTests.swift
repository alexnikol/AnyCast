// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import HTTPClient
import BestPodcastsList

class BestPodcastsMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPURLResponse() throws {
        let validJSON = makePodcastsListJSON(podcasts: [])
        
        try [199, 201, 400, 500].forEach { code in
            XCTAssertThrowsError(
                try BestPodastsItemsMapper.map(validJSON, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try BestPodastsItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoPodcastsItemsOn200HTTPResponseWithNonJSONAndEmptyPocastsList() throws {
        let anyGenreId = 1
        let anyGenreName = "Any Genre"
        let validJSON = makePodcastsListJSON(genreId: anyGenreId, genreName: anyGenreName, podcasts: [])

        let result = try BestPodastsItemsMapper.map(validJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, BestPodcastsList(genreId: anyGenreId, genreName: anyGenreName, podcasts: []))
    }
    
    func test_map_deliversPodcastsItemsOn200HTTPResponseWithJSONItems() throws {
        let anyGenreId = 1
        let anyGenreName = "Any Genre"
        
        let podcast1 = makePodcast(
            id: UUID().uuidString,
            title: "Any Podcast",
            image: URL(string: "https://any-url")!
        )
        
        let podcast2 = makePodcast(
            id: UUID().uuidString,
            title: "Another Podcast",
            image: URL(string: "https://another-url")!
        )
        
        let validJSON = makePodcastsListJSON(
            genreId: anyGenreId,
            genreName: anyGenreName,
            podcasts: [podcast1.json, podcast2.json]
        )
        
        let result = try BestPodastsItemsMapper.map(validJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(
            result, BestPodcastsList(genreId: anyGenreId, genreName: anyGenreName, podcasts: [podcast1.model, podcast2.model])
        )
    }
    
    // MARK: - Helpers
        
    private func makePodcast(id: String, title: String, image: URL) -> (model: Podcast, json: [String: Any]) {
        let podcast = Podcast(id: id, title: title, image: image)
        let json = [
            "id": id,
            "title": title,
            "image": image.absoluteString
        ] as [String: Any]
        
        return (podcast, json)
    }
    
    private func makePodcastsListJSON(
        genreId: Int = 1,
        genreName: String = "Any Genre",
        podcasts: [[String: Any]]
    ) -> Data {
        let json = [
            "id": genreId,
            "name": genreName,
            "podcasts": podcasts
        ] as [String: Any]
        
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
