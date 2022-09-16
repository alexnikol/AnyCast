// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

extension GenresListViewControllerTests {
    class LoaderSpy: GenresLoader {
        private var completions = [(LoadGenresResult) -> Void]()
        
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (LoadGenresResult) -> Void) {
            completions.append(completion)
        }
        
        func completeGenresLoading(with genres: [Genre] = [], at index: Int) {
            completions[index](.success(genres))
        }
        
        func completeGenresLoadingWithError(at index: Int) {
            let error = NSError(domain: "any error", code: 0)
            completions[index](.failure(error))
        }
    }
}
