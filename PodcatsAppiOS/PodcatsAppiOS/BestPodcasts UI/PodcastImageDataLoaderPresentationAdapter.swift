// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import LoadResourcePresenter
import BestPodcastsList
import BestPodcastsListiOS

final class PodcastImageDataLoaderPresentationAdapter: PodcastCellControllerDelegate {
    private let model: PodcastImageViewModel
    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
    var presenter: LoadResourcePresenter<Data, WeakRefVirtualProxy<PodcastCellController>>?
    var cancellable: AnyCancellable?
    
    init(model: PodcastImageViewModel, imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartLoading()
        
        cancellable = imageLoader(model.image)
            .dispatchOnMainQueue()
            .sink(receiveCompletion: { [weak self] completion in
                
                switch completion {
                case .finished: break
                    
                case let .failure(error):
                    self?.presenter?.didFinishLoading(with: error)
                }
                
            }, receiveValue: { [weak self] data in
                self?.presenter?.didFinishLoading(with: data)
            })
    }
    
    func didCancelImageLoad() {
        cancellable?.cancel()
    }
}
