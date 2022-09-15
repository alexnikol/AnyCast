// Copyright © 2022 Almost Engineer. All rights reserved.

import PodcastsGenresList

public final class GenresUIComposer {
    
    private init() {}
    
    public static func genresComposedWith(loader: GenresLoader) -> GenresListViewController {
        let genresPresenter = GenresPresenter(genresLoader: loader)
        let refreshController = GenresRefreshViewController(presenter: genresPresenter)
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
    func display(isLoading: Bool) {
        object?.display(isLoading: isLoading)
    }
}

private final class GenresViewAdapter: GenresView {
    private weak var controller: GenresListViewController?
    
    init(controller: GenresListViewController) {
        self.controller = controller
    }
    
    func display(genres: [Genre]) {
        controller?.collectionModel = genres.map { model in
            GenreCellController(model: model)
        }
    }
}
