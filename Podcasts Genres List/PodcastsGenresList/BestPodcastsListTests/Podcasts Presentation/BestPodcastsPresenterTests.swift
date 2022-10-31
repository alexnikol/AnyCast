// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList

class BestPodcastsPresenterTests: XCTestCase {
    
    func test_map_createsViewModel() {
        let podcast1 = makePodcast(title: "Podcast name 1", image: anyURL())
        let podcast2 = makePodcast(title: "Podcast name 1", image: anyURL())
        let podcastsList = makeBestPodcastsList(genreId: 1, genreName: "Any Genre Name", podcasts: [podcast1, podcast2])
        
        let viewModel = BestPodcastsPresenter.map(podcastsList)
        
        XCTAssertEqual(podcastsList.podcasts, viewModel.podcasts)
        XCTAssertEqual(podcastsList.genreName, viewModel.title)
    }
    
    // MARK: - Helpers
    
    private func makePodcast(title: String, image: URL) -> Podcast {
        Podcast(id: UUID().uuidString, title: title, image: image)
    }
    
    private func makeBestPodcastsList(genreId: Int = 1, genreName: String = "Any genre name", podcasts: [Podcast]) -> BestPodcastsList {
        BestPodcastsList(genreId: genreId, genreName: genreName, podcasts: podcasts)
    }
    
    func anyURL() -> URL {
        URL(string: "http://a-url.com")!
    }
}
