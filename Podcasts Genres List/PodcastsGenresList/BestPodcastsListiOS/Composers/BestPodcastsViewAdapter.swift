// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import LoadResourcePresenter
import BestPodcastsList

final class BestPodcastsViewAdapter: ResourceView {
    typealias ResourceViewModel = BestPodcastsPresenterViewModel
    
    private let imageLoader: PodcastImageDataLoader
    weak var controller: BestPodcastsListViewController?
    
    init(controller: BestPodcastsListViewController, imageLoader: PodcastImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: BestPodcastsPresenterViewModel) {
        controller?.display(viewModel.podcasts.map { model in
            let adapter = PodcastImageDataLoaderPresentationAdapter(
                model: model,
                imageLoader: imageLoader
            )
            let cellController = PodcastCellController(model: model, delegete: adapter)
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(cellController),
                loadingView: WeakRefVirtualProxy(cellController),
                mapper: { data in
                    PodcastImageViewModel(image: UIImage(data: data))
                }
            )
            return cellController
        })
        controller?.title = viewModel.title
    }
}
