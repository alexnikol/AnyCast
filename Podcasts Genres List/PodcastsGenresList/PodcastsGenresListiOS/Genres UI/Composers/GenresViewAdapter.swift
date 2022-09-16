// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList

final class GenresViewAdapter: GenresView {
    private weak var controller: GenresListViewController?
    
    init(controller: GenresListViewController) {
        self.controller = controller
    }

    func display(_ viewModel: GenresViewModel) {
        controller?.collectionModel = viewModel.genres.enumerated().map { (index, model) in
            let cellModel = GenreCellViewModel(name: model.name, color: .green)
            return GenreCellController(model: cellModel)
        }
    }
}
