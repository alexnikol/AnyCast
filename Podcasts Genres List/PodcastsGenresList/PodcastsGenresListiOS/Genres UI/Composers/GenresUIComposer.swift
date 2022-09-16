// Copyright © 2022 Almost Engineer. All rights reserved.

import PodcastsGenresList
import Foundation

public final class GenresUIComposer {
    
    private init() {}
    
    public static func genresComposedWith(loader: GenresLoader) -> GenresListViewController {
        let presentationAdapter = GenresLoaderPresentationAdapter(genresLoader: MainQueueDisaptchDecorator(loader))
        let refreshController = GenresRefreshViewController(delegate: presentationAdapter)
        let genresController = GenresListViewController(refreshController: refreshController)
        genresController.title = GenresPresenter.title
        
        presentationAdapter.presenter = GenresPresenter(
            genresView: GenresViewAdapter(controller: genresController),
            loadingView: WeakRefVirtualProxy(refreshController)
        )
        return genresController
    }
}

private final class MainQueueDisaptchDecorator<T> {
    private let decoratee: T
    
    init(_ decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        completion()
    }
}

extension MainQueueDisaptchDecorator: GenresLoader where T == GenresLoader {
    func load(completion: @escaping (LoadGenresResult) -> Void) {
        self.decoratee.load { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}

private final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: GenresLoadingView where T: GenresLoadingView {
    func display(_ viewModel: GenresLoadingViewModel) {
        object?.display(viewModel)
    }
}

private final class GenresViewAdapter: GenresView {
    private weak var controller: GenresListViewController?
    
    init(controller: GenresListViewController) {
        self.controller = controller
    }

    func display(_ viewModel: GenresViewModel) {
        controller?.collectionModel = viewModel.genres.map { model in
            GenreCellController(model: model)
        }
    }
}


private final class GenresLoaderPresentationAdapter: GenresRefreshViewControllerDelegate {
    private let genresLoader: GenresLoader
    var presenter: GenresPresenter?
    
    init(genresLoader: GenresLoader) {
        self.genresLoader = genresLoader
    }
    
    func didRequestLoadingGenres() {
        presenter?.didStartLoadingGenres()
        genresLoader.load { [weak self] result in
            switch result {
            case let .success(genres):
                self?.presenter?.didFinishLoadingGenres(with: genres)
                
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }
    }
}
