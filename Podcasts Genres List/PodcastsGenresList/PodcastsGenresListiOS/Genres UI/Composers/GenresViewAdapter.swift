// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList

final class GenresViewAdapter: GenresView {
    private weak var controller: GenresListViewController?
    private let genresColorProvider: GenresActiveColorProvider
    
    init(controller: GenresListViewController, genresColorProvider: GenresActiveColorProvider) {
        self.controller = controller
        self.genresColorProvider = genresColorProvider
    }

    func display(_ viewModel: GenresViewModel) {
        controller?.collectionModel = viewModel.genres.enumerated().map { (index, model) in
            let cellModel = GenreCellViewModel(name: model.name, color: associatedColorByIndex(index))
            return GenreCellController(model: cellModel)
        }
    }
    
    private func associatedColorByIndex(_ index: Int) -> UIColor {
        let defaultColor = UIColor.white
        return (try? genresColorProvider.getColor(by: index)) ?? defaultColor
    }
}
