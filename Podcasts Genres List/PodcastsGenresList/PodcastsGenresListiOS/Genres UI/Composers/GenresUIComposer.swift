// Copyright © 2022 Almost Engineer. All rights reserved.

import PodcastsGenresList

public final class GenresUIComposer {
    
    private init() {}
    
    public static func genresComposedWith(loader: GenresLoader) -> GenresListViewController {
        let genresViewModel = GenresViewModel(genresLoader: loader)
        let refreshController = GenresRefreshViewController(viewModel: genresViewModel)
        let genresController = GenresListViewController(refreshController: refreshController)
        genresViewModel.onGenresLoad = adaptGenresToCellControllers(forwardingTo: genresController)
        return genresController
    }
    
    private static func adaptGenresToCellControllers(forwardingTo controller: GenresListViewController) -> ([Genre]) -> Void {
        return { [weak controller] genres in
            controller?.collectionModel = genres.map { model in
                GenreCellController(model: model)
            }
        }
    }
}
