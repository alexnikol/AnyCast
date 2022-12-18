// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

class BestPodcastsMapperTests: XCTestCase {
            
    func test_map_deliversPodcastsItemsOn200HTTPResponseWithJSONItems() throws {
        let anyGenreId = 1
        let anyGenreName = "Any Genre"
        
        let podcast1 = makePodcast(id: UUID().uuidString,
                                   title: "Any Podcast",
                                   publisher: "Any Publisher",
                                   language: "English",
                                   type: .serial,
                                   image: URL(string: "https://any-url")!)
        
        let podcast2 = makePodcast(id: UUID().uuidString,
                                   title: "Another Podcast",
                                   publisher: "Another Publisher",
                                   language: "Ukrainian",
                                   type: .episodic,
                                   image: URL(string: "https://another-url")!)
        
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
        
    private func makePodcast(id: String, title: String, publisher: String, language: String, type: PodcastType, image: URL) -> (model: Podcast, json: [String: Any]) {
        let podcast = Podcast(id: id, title: title, publisher: publisher, language: language, type: type, image: image)
        let json = [
            "id": id,
            "title": title,
            "publisher": publisher,
            "language": language,
            "type": String(describing: type),
            "image": image.absoluteString,
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
