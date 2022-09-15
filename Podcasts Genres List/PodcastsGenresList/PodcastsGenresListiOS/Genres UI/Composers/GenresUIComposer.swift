// Copyright © 2022 Almost Engineer. All rights reserved.

import PodcastsGenresList

public final class GenresUIComposer {
    
    private init() {}
    
    public static func genresComposedWith(loader: GenresLoader) -> GenresListViewController {
        let genresPresenter = GenresPresenter()
        let presentationAdapter = GenresLoaderPresentationAdapter(genresLoader: loader, presenter: genresPresenter)
        let refreshController = GenresRefreshViewController(load: presentationAdapter.loadGenres)
        let genresController = GenresListViewController(refreshController: refreshController)
        genresPresenter.loadingView = WeakRefVirtualProxy(refreshController)
        genresPresenter.genresView = GenresViewAdapter(controller: genresController)
        return genresController
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


private final class GenresLoaderPresentationAdapter {
    private let genresLoader: GenresLoader
    private let presenter: GenresPresenter
    
    init(genresLoader: GenresLoader, presenter: GenresPresenter) {
        self.genresLoader = genresLoader
        self.presenter = presenter
    }
    
    func loadGenres() {
        presenter.didStartLoadingGenres()
        genresLoader.load { [weak self] result in
            switch result {
            case let .success(genres):
                self?.presenter.didFinishLoadingGenres(with: genres)
                
            case let .failure(error):
                self?.presenter.didFinishLoading(with: error)
            }
        }
    }
}
