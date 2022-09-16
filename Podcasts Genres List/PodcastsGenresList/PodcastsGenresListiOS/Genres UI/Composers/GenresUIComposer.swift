// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

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
