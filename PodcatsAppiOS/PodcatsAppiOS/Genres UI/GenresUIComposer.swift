// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import PodcastsGenresList
import PodcastsGenresListiOS

final class GenresUIComposer {
    
    private init() {}
    
    static func genresComposedWith(loader: @escaping () -> AnyPublisher<[Genre], Error>) -> GenresListViewController {        
        let presentationAdapter = GenresLoaderPresentationAdapter(genresLoader: loader)
        let refreshController = GenresRefreshViewController(delegate: presentationAdapter)
        let genresController = GenresListViewController(refreshController: refreshController)
        genresController.title = GenresPresenter.title
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: GenresViewAdapter(
                controller: genresController,
                genresColorProvider: makeGenresColorProvider()
            ),
            loadingView: WeakRefVirtualProxy(refreshController),
            mapper: GenresPresenter.map
        )
        return genresController
    }
    
    private static func makeGenresColorProvider() -> GenresActiveColorProvider<UIColor> {
        let genresActiveColorProvider = GenresActiveColorProvider(colorConverted: { UIColor(hexString: $0) })
        do {
            try genresActiveColorProvider.setColors(
                ["#e6194b", "#3cb44b", "#ffe119", "#4363d8",
                 "#f58231", "#911eb4", "#46f0f0", "#f032e6",
                 "#bcf60c", "#fabebe", "#008080", "#e6beff",
                 "#9a6324", "#fffac8", "#800000", "#aaffc3",
                 "#808000", "#ffd8b1", "#000075", "#808080",
                 "#E574BC", "#EF94D5", "#F9B4ED", "#EABAF6",
                 "#DABFFF", "#C4C7FF", "#ADCFFF", "#96D7FF",
                 "#7FDEFF", "#FFC8DD", "#FF70A5", "#BDE0FE",
                 "#99CEFF", "#FFC8DD", "#FFAFCC", "#BDE0FE",
                 "#A2D2FF", "#EA84C9"]
            )
        } catch {
            fatalError("Unexpected colors set with error \(error)")
        }
        return genresActiveColorProvider
    }
}
