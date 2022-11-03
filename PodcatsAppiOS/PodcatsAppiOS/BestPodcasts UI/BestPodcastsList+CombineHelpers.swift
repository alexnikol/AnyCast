// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import BestPodcastsList

extension LocalPodcastsImageDataLoader {
    typealias Publisher = AnyPublisher<Data, Swift.Error>
    
    func loadPublisher(from url: URL) -> Publisher {
        var task: PodcastImageDataLoaderTask?
        return Deferred {
            Future { completion in
                return task = self.loadImageData(from: url, completion: completion)
            }
            .handleEvents(receiveCancel: {
                task?.cancel()
            })
        }.eraseToAnyPublisher()
    }
}
