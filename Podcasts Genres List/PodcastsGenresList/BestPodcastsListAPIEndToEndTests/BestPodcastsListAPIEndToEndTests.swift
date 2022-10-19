// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import URLSessionHTTPClient
import BestPodcastsList

class BestPodcastsListAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETBestPodcastsResult_matchesFixedTestBestPodcastsData() {
        switch getBestPodcastsListResult() {
        case let .success(bestPodcastsList):
            XCTAssertEqual(bestPodcastsList.podcasts .count, 3, "Expected 3 items in the test best podcasts list")
            XCTAssertEqual(bestPodcastsList.podcasts[0], expectedPodcast(at: 0))
            XCTAssertEqual(bestPodcastsList.podcasts[1], expectedPodcast(at: 1))
            XCTAssertEqual(bestPodcastsList.podcasts[2], expectedPodcast(at: 2))
            
        case let .failure(error):
            XCTFail("Expected successful podcasts list, but got \(error) instead")
        default:
            XCTFail("Expected successful podcasts list, but got no result instead")
        }
    }
    
    // MARK: - Heplers
    
    private typealias Result = Swift.Result<BestPodcastsList, Error>
    
    private func getBestPodcastsListResult(file: StaticString = #file, line: UInt = #line) -> Result? {
        let testServerURL = URL(string:
                                    "https://firebasestorage.googleapis.com/v0/b/anycast-ae.appspot.com/o/Podcasts%2FGET-best-podcasts-by-genre.json?alt=media&token=b4e828cd-b5b3-47d1-803f-0bd93c05204b")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        trackForMemoryLeaks(client, file: file, line: line)
        var receivedResult: Result?
        let exp = expectation(description: "Wait for load completion")
        
        client.get(from: testServerURL) { result in
            receivedResult = result.flatMap { (data, response) in
                do {
                    return .success(try BestPodastsItemsMapper.map(data, from: response))
                } catch {
                    return .failure(error)
                }
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3.0)
        return receivedResult
    }
    
    private func expectedPodcast(at index: Int) -> Podcast {
        return Podcast(
            id: id(at: index),
            title: title(at: index),
            image: image(at: index)
        )
    }
    
    private func id(at index: Int) -> String {
        return [
            "5f237b79824e4dfb8355f6dff9b1c542",
            "34beae8ad8fd4b299196f413b8270a30",
            "28ba59be5b8346589e910e24d4b3eed7"
        ][index]
    }
    
    private func title(at index: Int) -> String {
        return [
            "The Indicator from Planet Money",
            "WorkLife with Adam Grant",
            "The Pulte Podcast"
        ][index]
    }
    
    private func image(at index: Int) -> URL {
        let baseURL = URL(string: "https://production.listennotes.com/podcasts")!
        return [
            baseURL.appendingPathComponent("the-indicator-from-planet-money-npr-fw5ISgUVsYh-G2EDjFO-TLA.1400x1400.jpg"),
            baseURL.appendingPathComponent("worklife-with-adam-grant-ted-KgaXjFPEoVc.1400x1400.jpg"),
            baseURL.appendingPathComponent("the-pulte-podcast-8PvlfCgcR_X-xBWa8_-4MTR.1400x1400.jpg")
        ][index]
    }
}
