// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import LoadResourcePresenter
import SharedComponentsiOSModule
import SearchContentModule

public enum GeneralSearchUIComposer {
    
    public typealias SearchResultController = UIViewController & UISearchBarDelegate
    
    public static func searchComposedWith(
        searchResultController: SearchResultController,
        searchLoader: @escaping (String) -> AnyPublisher<GeneralSearchContentResult, Error>,
        onEpisodeSelect: @escaping (SearchResultEpisode) -> Void,
        onPodcastSelect: @escaping (SearchResultPodcast) -> Void
    ) -> (controller: ListViewController, sourceDelegate: GeneralSearchSourceDelegate) {
        let generalSearchPresenter = GeneralSearchContentPresenter()
        let presentationAdapter = GeneralSearchPresentationAdapter(loader: searchLoader)
        let controller = ListViewController(refreshController: nil)
        controller.title = "Search"
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = searchResultController
        controller.navigationItem.searchController = searchController
        let nullObjectPresenterStateView = NullObjectStateResourceView()
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: GeneralSearchViewAdapter(
                controller: controller,
                generalSearchPresenter: generalSearchPresenter,
                onEpisodeSelect: onEpisodeSelect,
                onPodcastSelect: onPodcastSelect
            ),
            loadingView: nullObjectPresenterStateView,
            errorView: nullObjectPresenterStateView,
            mapper: generalSearchPresenter.map
        )
        return (controller, presentationAdapter)
    }
}
