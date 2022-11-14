// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import LoadResourcePresenter
import SharedHelpersiOSModule
import PodcastsModule
import PodcastsModuleiOS

final class PodcastDetailsLoaderPresentationAdapter: RefreshViewControllerDelegate {
    private let podcastID: String
    private let loader: (String) -> AnyPublisher<PodcastDetails, Error>
    private var cancellable: AnyCancellable?
    var presenter: LoadResourcePresenter<PodcastDetails, PodcastDetailsViewAdapter>?
    
    init(podcastID: String, loader: @escaping (String) -> AnyPublisher<PodcastDetails, Error>) {
        self.podcastID = podcastID
        self.loader = loader
    }
    
    func didRequestLoading() {
        presenter?.didStartLoading()
        
        cancellable = loader(podcastID)
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] result in
                    switch result {
                    case .finished: break
                        
                    case let .failure(error):
                        self?.presenter?.didFinishLoading(with: error)
                    }
                },
                receiveValue: { [weak self] data in
                    self?.presenter?.didFinishLoading(with: data)
                }
            )
    }
}
