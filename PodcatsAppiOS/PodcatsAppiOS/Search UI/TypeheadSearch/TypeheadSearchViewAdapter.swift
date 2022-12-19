// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import LoadResourcePresenter
import SearchContentModule

//final class TypeheadSearchViewAdapter: ResourceView {
//    typealias ResourceViewModel = TypeheadSearchResultPodcastViewModel
//    
//    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
//    private var cancellable: AnyCancellable?
//    private var selection: (Podcast) -> Void
//    weak var controller: ListViewController?
//    
//    init(controller: ListViewController,
//         imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>,
//         selection: @escaping (Podcast) -> Void) {
//        self.controller = controller
//        self.imageLoader = imageLoader
//        self.selection = selection
//    }
//    
//    func display(_ viewModel: BestPodcastsListViewModel) {
//        controller?.display(adaptModelsToCellControllers(podcasts: viewModel.podcasts))
//        controller?.title = viewModel.title
//    }
//    
//    private func adaptModelsToCellControllers(podcasts: [Podcast]) -> [SectionController] {
//        let podcastCellControllers = podcasts.map { model -> PodcastCellController in
//            configurePodcastCellController(for: model)
//        }
//        return [DefaultSectionWithNoHeaderAndFooter(cellControllers: podcastCellControllers)]
//    }
//    
//    private func configurePodcastCellController(for model: Podcast) -> PodcastCellController {
//        let podcastViewModel = BestPodcastsPresenter.map(model)
//
//        let cellController = PodcastCellController(
//            model: podcastViewModel,
//            thumbnailViewController: ThumbnailUIComposer.composeThumbnailWithImageLoader(
//                thumbnailURL: model.image,
//                imageLoader: imageLoader
//            ),
//            selection: { [weak self] in
//                self?.selection(model)
//            }
//        )
//        return cellController
//    }
//}
