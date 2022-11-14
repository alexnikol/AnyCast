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
        controller?.display(adaptModelsToCellControllers(podcasts: viewModel.podcasts))
        controller?.title = viewModel.title
    }
    
    private func adaptModelsToCellControllers(podcasts: [Podcast]) -> [CellController] {
        podcasts.map { model in
            let podcastViewModel = BestPodcastsPresenter.map(model)
            
            let adapter = GenericLoaderPresentationAdapter<Data, WeakRefVirtualProxy<PodcastCellController>>(
                loader: {
                    self.imageLoader(model.image)
                }
            )
            
            let cellController = PodcastCellController(
                model: podcastViewModel,
                delegete: adapter,
                selection: { [weak self] in
                    self?.selection(model)
                }
            )
            
            adapter.presenter = makePresenterFor(cellController)
            return cellController
        }
    }
    
    private func makePresenterFor(
        _ cellController: PodcastCellController
    ) -> LoadResourcePresenter<Data, WeakRefVirtualProxy<PodcastCellController>> {
        struct InvalidImageData: Error {}
        
        return LoadResourcePresenter(
            resourceView: WeakRefVirtualProxy(cellController),
            loadingView: WeakRefVirtualProxy(cellController),
            errorView: WeakRefVirtualProxy(cellController),
            mapper: UIImage.trytoMake(with:)
        )
    }
}
