// Copyright © 2022 Almost Engineer. All rights reserved.

import PodcastsGenresList

final class GenresViewAdapter: GenresView {
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
