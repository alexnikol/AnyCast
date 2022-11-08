// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

class PodcastDetailsAPIEndToEndTests: XCTestCase, EphemeralClientHelpers {
        
    func test_endToEndTestServerGETPodcastDetails_matchesFixedTestPodcastDetailsData() {
        switch getPodcastDetailsResult() {
        case let .success(podcastDetails):
            XCTAssertEqual(podcastDetails.id, "4d3fe717742d4963a85562e9f84d8c79")
            XCTAssertEqual(podcastDetails.title, "Star Wars 7x7: The Daily Star Wars Podcast")
            XCTAssertEqual(podcastDetails.publisher, "Star Wars 7x7")
            XCTAssertEqual(podcastDetails.language, "English")
            XCTAssertEqual(podcastDetails.type, .serial)
            XCTAssertEqual(podcastDetails.image, expectedPodcastImage())
            XCTAssertEqual(podcastDetails.description, expectedPodcastDescription())
            XCTAssertEqual(podcastDetails.totalEpisodes, 3078)
            XCTAssertEqual(podcastDetails.episodes .count, 3, "Expected 3 episodes in the test podcast details data")
            XCTAssertEqual(podcastDetails.episodes[0], expectedEpisode(at: 0))
            XCTAssertEqual(podcastDetails.episodes[1], expectedEpisode(at: 1))
            XCTAssertEqual(podcastDetails.episodes[2], expectedEpisode(at: 2))
            
        case let .failure(error):
            XCTFail("Expected successful podcast details, but got \(error) instead")
        default:
            XCTFail("Expected successful podcast details, but got no result instead")
        }
    }
    
    // MARK: - Heplers
    
    private typealias Result = Swift.Result<PodcastDetails, Error>
    
    private func getPodcastDetailsResult(file: StaticString = #file, line: UInt = #line) -> Result? {
        let testServerURL = URL(string:
                                    "https://firebasestorage.googleapis.com/v0/b/anycast-ae.appspot.com/o/Podcasts%2FGET-podcast-details-by-id.json?alt=media&token=b392ea30-f57d-445f-a83c-2b9ec3f6445a")!
        var receivedResult: Result?
        let exp = expectation(description: "Wait for load completion")
        
        ephemeralClient().get(from: testServerURL) { result in
            receivedResult = result.flatMap { (data, response) in
                do {
                    return .success(try PodcastDetailsMapper.map(data, from: response))
                } catch {
                    return .failure(error)
                }
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        return receivedResult
    }
    
    private func expectedPodcastDescription() -> String {
        "The Star Wars 7x7 Podcast is Rebel-rousing fun for everyday Jedi"
    }
    
    private func expectedPodcastImage() -> URL {
        URL(string: "https://production.listennotes.com/podcasts/star-wars-7x7-the-daily-star-wars-podcast-HN08OoDE7pc-AIg3cZVKCsL.1400x1400.jpg")!
    }
    
    private func expectedEpisode(at index: Int) -> Episode {
        return Episode(
            id: id(at: index),
            title: title(at: index),
            description: description(at: index),
            thumbnail: thumbnail(at: index),
            audio: audio(at: index),
            audioLengthInSeconds: audioLengthInSeconds(at: index),
            containsExplicitContent: containsExplicitContent(at: index)
        )
    }

    private func id(at index: Int) -> String {
        return [
            "4e7c59e10e4640b98f2f3cb1777dbb43",
            "9ae0e2e49a9c477191263df90adf7f3e",
            "98bcfa3fd1b44727913385938788bcc5"
        ][index]
    }
    
    private func title(at index: Int) -> String {
        return [
            "864: Part 2 of My (New) Conversation With Bobby Roberts",
            "863: A (New) Conversation With Bobby Roberts, Part 1",
            "862: \"Assassin\" - Clone Wars Briefing, Season 3, Episode 7"
        ][index]
    }
    
    private func description(at index: Int) -> String {
        return [
            "The second half of my latest conversation with Bobby Roberts, Podcast Emeritus from Full of Sith",
            "An in-depth conversation about the Star Wars \"Story\" movies and so much more, featuring Bobby Roberts",
            "The beginnings of the true power of the Force, revealed in \"Assassin,\" season 3, episode 7 of the Star Wars: The Clone Wars cartoon series."
        ][index]
    }
    
    private func thumbnail(at index: Int) -> URL {
        let baseURL = URL(string: "https://production.listennotes.com/podcasts")!
        return [
            baseURL.appendingPathComponent("star-wars-7x7-the/864-part-2-of-my-new-yqjrzNDEXaS-2WVsxtU0f3m.300x157.jpg"),
            baseURL.appendingPathComponent("star-wars-7x7-the/863-a-new-conversation-with-lcQsDS5uvYb-0YRBTlgiVeU.300x157.jpg"),
            baseURL.appendingPathComponent("star-wars-7x7-the/862-assassin-clone-wars-Uh3E0GwOQRX-jEcMAdTntzs.300x157.jpg")
        ][index]
    }
    
    private func audio(at index: Int) -> URL {
        let baseURL = URL(string: "https://www.listennotes.com/e/p/")!
        return [
            baseURL.appendingPathComponent("4e7c59e10e4640b98f2f3cb1777dbb43/"),
            baseURL.appendingPathComponent("9ae0e2e49a9c477191263df90adf7f3e/"),
            baseURL.appendingPathComponent("98bcfa3fd1b44727913385938788bcc5/")
        ][index]
    }
    
    private func audioLengthInSeconds(at index: Int) -> Int {
        return [
            2447,
            2916,
            636
        ][index]
    }
    
    private func containsExplicitContent(at index: Int) -> Bool {
        return [
            false,
            true,
            false
        ][index]
    }
}
