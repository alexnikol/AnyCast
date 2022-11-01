// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import BestPodcastsList
import LoadResourcePresenter

public final class BestPodcastsUIComposer {
    private init() {}
    
    public static func bestPodcastComposed(genreID: Int, loader: BestPodcastsLoader) -> BestPodcastsListViewController {
        let presentationAdapter = BestPodcastsLoaderPresentationAdapter(
            genreID: genreID,
            loader: MainQueueDispatchDecorator(decoratee: loader)
        )
        let refreshController = BestPodcastsListRefreshViewController(delegate: presentationAdapter)
        let controller = BestPodcastsListViewController(refreshController: refreshController)
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: BestPodcastsViewAdapter(
                controller: controller
            ),
            loadingView: WeakRefVirtualProxy(refreshController),
            mapper: BestPodcastsPresenter.map
        )
        return controller
    }
}

final class BestPodcastsLoaderPresentationAdapter: BestPodcastsListRefreshViewControllerDelegate {
    private let genreID: Int
    private let loader: BestPodcastsLoader
    var presenter: LoadResourcePresenter<BestPodcastsList, BestPodcastsViewAdapter>?
    
    init(genreID: Int, loader: BestPodcastsLoader) {
        self.genreID = genreID
        self.loader = loader
    }
     
    func didRequestLoadingPodcasts() {
        presenter?.didStartLoading()
        loader.load(by: genreID) { [weak self] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoading(with: data)
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }
    }
}

final class BestPodcastsViewAdapter: ResourceView {
    typealias ResourceViewModel = BestPodcastsPresenterViewModel
    
    weak var controller: BestPodcastsListViewController?
    
    init(controller: BestPodcastsListViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: BestPodcastsPresenterViewModel) {
        controller?.display(viewModel.podcasts.map {
            PodcastCellController(model: $0)
        })
        controller?.title = viewModel.title
    }
}

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: ResourceLoadingView where T: ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: BestPodcastsLoader where T == BestPodcastsLoader {
    func load(by genreID: Int, completion: @escaping (BestPodcastsLoader.Result) -> Void) {
        decoratee.load(by: genreID, completion: { [weak self] result in
            self?.dispatch { completion(result) }
        })
    }
}
