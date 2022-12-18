// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import PodcastsModule

class PodcastDetailsMapperTests: XCTestCase {
        
    func test_map_deliversPodcastsDetailsOn200HTTPResponse() throws {
        let episodes = makeUniqueEpisodes()
        let validPodcastDetails = makePodcastDetails(episodes: episodes)
        
        let result = try PodcastDetailsMapper.map(validPodcastDetails.data, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, validPodcastDetails.model)
    }
    
    // MARK: - Helpers
    
    private func makeEpisode(
        id: String,
        title: String,
        description: String,
        thumbnail: URL,
        audio: URL,
        audioLengthInSeconds: Int,
        containsExplicitContent: Bool,
        publishDateInMiliseconds: Int
    ) -> (model: Episode, json: [String: Any]) {
        let episode = Episode(
            id: id,
            title: title,
            description: description,
            thumbnail: thumbnail,
            audio: audio,
            audioLengthInSeconds: audioLengthInSeconds,
            containsExplicitContent: containsExplicitContent,
            publishDateInMiliseconds: publishDateInMiliseconds
        )
        let json = [
            "id": id,
            "title": title,
            "description": description,
            "thumbnail": thumbnail.absoluteString,
            "audio": audio.absoluteString,
            "audio_length_sec": audioLengthInSeconds,
            "explicit_content": containsExplicitContent,
            "pub_date_ms": publishDateInMiliseconds
        ] as [String: Any]
        
        return (episode, json)
    }
    
    private func makeUniqueEpisodes() -> [(model: Episode, json: [String: Any])] {
        let episode1 = makeEpisode(
            id: UUID().uuidString,
            title: "Any Title 1",
            description: "Any Description 1",
            thumbnail: anyURL(),
            audio: anyURL(),
            audioLengthInSeconds: Int.random(in: 1...1000),
            containsExplicitContent: Bool.random(),
            publishDateInMiliseconds: Int.random(in: 1479110301853...1479110401853)
        )
        
        let episode2 = makeEpisode(
            id: UUID().uuidString,
            title: "Any Title 2",
            description: "Any Description 2",
            thumbnail: anyURL(),
            audio: anyURL(),
            audioLengthInSeconds: Int.random(in: 1...1000),
            containsExplicitContent: Bool.random(),
            publishDateInMiliseconds: Int.random(in: 1479110302015...1479110402015)
        )
        return [episode1, episode2]
    }
    
    private func makePodcastDetails(
        episodes: [(model: Episode, json: [String: Any])]
    ) -> (model: PodcastDetails, data: Data) {
        let id = "Any ID".withRandomSuffix()
        let title = "Any Title".withRandomSuffix()
        let publisher = "Any Publisher".withRandomSuffix()
        let language = "Any ID".withRandomSuffix()
        let type = "episodic"
        let image = anyURL()
        let description = "Any Description".withRandomSuffix()
        let totalEpisodes = Int.random(in: 1...1000)
        
        let json = [
            "id": id,
            "title": title,
            "publisher": publisher,
            "language": language,
            "type": type,
            "image": image.absoluteString,
            "episodes": episodes.map { $0.json },
            "description": description,
            "total_episodes": totalEpisodes
        ] as [String: Any]
        
        let model = PodcastDetails(
            id: id,
            title: title,
            publisher: publisher,
            language: language,
            type: .episodic,
            image: image,
            episodes: episodes.map { $0.model },
            description: description,
            totalEpisodes: totalEpisodes
        )
        return (model, try! JSONSerialization.data(withJSONObject: json))
    }
}

private extension String {
    func withRandomSuffix() -> String {
        return self + " " + UUID().uuidString
    }
}
