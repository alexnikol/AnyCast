// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import LoadResourcePresenter
import PodcastsModule
import PodcastsModuleiOS

final class BestPodcastsViewAdapter: ResourceView {
    typealias ResourceViewModel = BestPodcastsListViewModel
    
    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
    private var cancellable: AnyCancellable?
    private var selection: (Podcast) -> Void
    weak var controller: ListViewController?
    
    init(controller: ListViewController,
         imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>,
         selection: @escaping (Podcast) -> Void) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ viewModel: BestPodcastsListViewModel) {
        controller?.display(viewModel.podcasts.map { model in
            let podcastViewModel = BestPodcastsPresenter.map(model)
            let adapter = PodcastImageDataLoaderPresentationAdapter(
                model: podcastViewModel,
                imageLoader: imageLoader
            )
            let cellController = PodcastCellController(
                model: podcastViewModel,
                delegete: adapter,
                selection: { [weak self] in
                    self?.selection(model)
                }
            )
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(cellController),
                loadingView: WeakRefVirtualProxy(cellController),
                errorView: WeakRefVirtualProxy(cellController),
                mapper: { data in
                    guard let image = UIImage(data: data) else {
                        throw InvalidImageData()
                    }
                    return image
                }
            )
            return cellController
        })
        controller?.title = viewModel.title
    }
    
    private struct InvalidImageData: Error {}
}
