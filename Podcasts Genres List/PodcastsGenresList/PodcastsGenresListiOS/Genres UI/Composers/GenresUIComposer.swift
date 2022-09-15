// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList

public final class GenresUIComposer {
    
    private init() {}
    
    public static func genresComposedWith(loader: GenresLoader) -> GenresListViewController {
        let refreshController = GenresRefreshViewController(genresLoader: loader)
        let genresController = GenresListViewController(collectionViewLayout: UICollectionViewFlowLayout(), refreshController: refreshController)
        refreshController.onRefresh = adaptGenresToCellControllers(forwardingTo: genresController)
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
