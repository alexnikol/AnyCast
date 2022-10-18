// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import URLSessionHTTPClient
import PodcastsGenresList

class PodcastsGenresListAPIEndToEndTests: XCTestCase {
    
    func test_endToEndTestServerGETGenresResult_matchesFixedTestGenresData() {
        switch getGenresListResult() {
        case let .success(genres):
            XCTAssertEqual(genres.count, 3, "Expected 3 items in the test genres list")
            XCTAssertEqual(genres[0], expectedGenre(at: 0))
            XCTAssertEqual(genres[1], expectedGenre(at: 1))
            XCTAssertEqual(genres[2], expectedGenre(at: 2))
            
        case let .failure(error):
            XCTFail("Expected successful genres list, but got \(error) instead")
        default:
            XCTFail("Expected successful genres list, but got no result instead")
        }
    }
    
    // MARK: - Heplers
    
    private func getGenresListResult(file: StaticString = #file, line: UInt = #line) -> Swift.Result<[Genre], Error>? {
        let testServerURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/anycast-ae.appspot.com/o/Genres%2FGET-genres-list.json?alt=media&token=dc1af9d5-fa47-4396-92d8-180f74c9a061")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        trackForMemoryLeaks(client, file: file, line: line)
        var receivedResult: Swift.Result<[Genre], Error>?
        let exp = expectation(description: "Wait for load completion")
        
        client.get(from: testServerURL) { result in
            receivedResult = result.flatMap { (data, response) in
                do {
                    return .success(try GenresItemsMapper.map(data, from: response))
                } catch {
                    return .failure(error)
                }
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3.0)
        return receivedResult
    }
    
    private func expectedGenre(at index: Int) -> Genre {
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
