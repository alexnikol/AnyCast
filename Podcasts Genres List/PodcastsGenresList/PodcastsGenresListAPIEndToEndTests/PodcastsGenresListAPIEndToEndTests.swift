// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList

class PodcastsGenresListAPIEndToEndTests: XCTestCase {
    
    func test_endToEndTestServerGETGenresResult_matchesFixedTestGenresData() {
        switch getGenresListResult() {
        case let .success(items):
            XCTAssertEqual(items.count, 3, "Expected 3 items in the test genres list")
            XCTAssertEqual(items[0], expectedItem(at: 0))
            XCTAssertEqual(items[1], expectedItem(at: 1))
            XCTAssertEqual(items[2], expectedItem(at: 2))
    
        case let .failure(error):
            XCTFail("Expected successful genres list, but got \(error) instead")
        default:
            XCTFail("Expected successful genres list, but got no result instead")
        }
    }
    
    // MARK: - Heplers
    
    private func getGenresListResult(file: StaticString = #file, line: UInt = #line) -> LoadGenresResult? {
        let testServerURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/anycast-ae.appspot.com/o/Genres%2FGET-genres-list.json?alt=media&token=dc1af9d5-fa47-4396-92d8-180f74c9a061")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = RemoteGenresLoader(url: testServerURL, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        var receivedResult: LoadGenresResult?
        let exp = expectation(description: "Wait for load completion")
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3.0)
        return receivedResult
    }
    
    private func expectedItem(at index: Int) -> Genre {
        return Genre(
            id: id(at: index),
            name: name(at: index)
        )
    }
    
    private func id(at index: Int) -> Int {
        return [
            144, 151, 77
        ][index]
    }
    
    private func name(at index: Int) -> String {
        return [
            "Personal Finance",
            "Locally Focused",
            "Sports"
        ][index]
    }
}
