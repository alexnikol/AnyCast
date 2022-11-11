// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import PodcastsGenresList

extension GenresUIIntegrationTests {
    class LoaderSpy {
        private var genresRequests = [PassthroughSubject<[Genre], Error>]()
        
        var loadCallCount: Int {
            return genresRequests.count
        }
        
        func loadPublisher() -> AnyPublisher<[Genre], Error> {
            let publisher = PassthroughSubject<[Genre], Error>()
            genresRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeGenresLoading(with genres: [Genre] = [], at index: Int) {
            genresRequests[index].send(genres)
        }
        
        func completeGenresLoadingWithError(at index: Int) {
            let error = NSError(domain: "any error", code: 0)
            genresRequests[index].send(completion: .failure(error))
        }
    }
}
