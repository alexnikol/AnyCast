// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import BestPodcastsList
import LoadResourcePresenter

public final class BestPodcastsUIComposer {
    private init() {}
    
    public static func bestPodcastComposed(
        genreID: Int,
        podcastsLoader: BestPodcastsLoader,
        imageLoader: PodcastImageDataLoader
    ) -> BestPodcastsListViewController {
        let presentationAdapter = BestPodcastsLoaderPresentationAdapter(
            genreID: genreID,
            loader: MainQueueDispatchDecorator(decoratee: podcastsLoader)
        )
        let refreshController = BestPodcastsListRefreshViewController(delegate: presentationAdapter)
        let controller = BestPodcastsListViewController(refreshController: refreshController)
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: BestPodcastsViewAdapter(
                controller: controller,
                imageLoader: imageLoader
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

final class PodcastImageDataLoaderPresentationAdapter: PodcastCellControllerDelegate {
    private let model: Podcast
    private let imageLoader: PodcastImageDataLoader
    var presenter: LoadResourcePresenter<Data, WeakRefVirtualProxy<PodcastCellController>>?
    
    init(model: Podcast, imageLoader: PodcastImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartLoading()
        
        _ = imageLoader.loadImageData(from: model.image, completion: { [weak self] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoading(with: data)
                
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        })
    }
}

public struct PodcastImageViewModel {
    let image: UIImage?
}

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: ResourceView where T: ResourceView, T.ResourceViewModel == PodcastImageViewModel {
    func display(_ viewModel: PodcastImageViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: ResourceLoadingView where T: ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: PodcastImageDataLoader where T: PodcastImageDataLoader {
    class NullObjectTask: PodcastImageDataLoaderTask {
        func cancel() {}
    }
    
    func loadImageData(from url: URL, completion: @escaping (PodcastImageDataLoader.Result) -> Void) -> PodcastImageDataLoaderTask {
        return object?.loadImageData(from: url, completion: completion) ?? NullObjectTask()
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
