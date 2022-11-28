// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import PodcastsModule
import PodcastsModuleiOS
import LoadResourcePresenter
import UIKit

final class PodcastDetailsViewAdapter: ResourceView {
    typealias ResourceViewModel = PodcastDetailsViewModel
    
    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
    private var cancellable: AnyCancellable?
    private let episodesPresenter = EpisodesPresenter()
    weak var controller: ListViewController?
    private var selection: (Episode) -> Void
    
    init(
        controller: ListViewController,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>,
        selection: @escaping (Episode) -> Void
    ) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ viewModel: PodcastDetailsViewModel) {
        let episodeCellControllers = viewModel.episodes.map({ episode -> EpisodeCellController in
            let episodeViewModel = episodesPresenter.map(episode)
            return EpisodeCellController(
                viewModel: episodeViewModel,
                selection: { [weak self] in
                    self?.selection(episode)
                }
            )
        })
        
        let adapter = GenericLoaderPresentationAdapter<Data, WeakRefVirtualProxy<PodcastHeaderCellController>>(
            loader: {
                self.imageLoader(viewModel.image)
            }
        )
        
        let profileSection = PodcastHeaderCellController(
            cellControllers: episodeCellControllers,
            viewModel: viewModel,
            imageLoaderDelegate: adapter
        )
        
        adapter.presenter = LoadResourcePresenter(
            resourceView: WeakRefVirtualProxy(profileSection),
            loadingView: WeakRefVirtualProxy(profileSection),
            errorView: WeakRefVirtualProxy(profileSection),
            mapper: UIImage.trytoMake(with:))
        
        controller?.display([profileSection])
        controller?.title = viewModel.title
    }
}
