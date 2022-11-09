// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

class BestPodcastsPresenterTests: XCTestCase {
    
    func test_map_createsViewModel() {
        let podcast = makePodcast(title: "Podcast name 1", image: anyURL(), type: .episodic)
        let podcastsList = makeBestPodcastsList(genreId: 1, genreName: "Any Genre Name", podcasts: [podcast])
        let podcast1ViewModel = BestPodcastsPresenter.map(podcast)
        
        let podcastsListViewModel = BestPodcastsPresenter.map(podcastsList)
        XCTAssertEqual(podcastsList.genreName, podcastsListViewModel.title)
        XCTAssertEqual(podcastsList.podcasts[0], podcast)
        
        XCTAssertEqual(podcast.title, podcast1ViewModel.title)
        XCTAssertEqual(podcast.publisher, podcast1ViewModel.publisher)
        XCTAssertEqual(podcast.language, podcast1ViewModel.languageValueLabel)
        XCTAssertEqual(podcast.image, podcast1ViewModel.image)
        XCTAssertEqual(String(describing: podcast.type), podcast1ViewModel.typeValueLabel)
    }
    
    // MARK: - Helpers
    
    private func makePodcast(title: String, image: URL, type: PodcastType) -> Podcast {
        Podcast(id: UUID().uuidString, title: title, publisher: "Any Publisher", language: "English", type: type, image: image)
    }
        
    private func makeBestPodcastsList(genreId: Int = 1, genreName: String = "Any genre name", podcasts: [Podcast]) -> BestPodcastsList {
        BestPodcastsList(genreId: genreId, genreName: genreName, podcasts: podcasts)
    }
    
    func anyURL() -> URL {
        URL(string: "http://a-url.com")!
    }
}
