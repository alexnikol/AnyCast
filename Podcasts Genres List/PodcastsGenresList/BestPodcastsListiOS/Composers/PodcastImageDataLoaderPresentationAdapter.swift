// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import LoadResourcePresenter
import BestPodcastsList

final class PodcastImageDataLoaderPresentationAdapter: PodcastCellControllerDelegate {
    private let model: Podcast
    private let imageLoader: PodcastImageDataLoader
    var presenter: LoadResourcePresenter<Data, WeakRefVirtualProxy<PodcastCellController>>?
    var task: PodcastImageDataLoaderTask?
    
    init(model: Podcast, imageLoader: PodcastImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartLoading()
        
        task = imageLoader.loadImageData(from: model.image, completion: { [weak self] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoading(with: data)
                
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        })
    }
    
    func didCancelImageLoad() {
        task?.cancel()
    }
}
