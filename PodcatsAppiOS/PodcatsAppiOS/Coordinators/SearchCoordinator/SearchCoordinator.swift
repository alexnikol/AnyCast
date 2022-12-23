// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import HTTPClient
import SearchContentModule
import SearchContentModuleiOS

final class SearchCoordinator {
    private let navigationController: UINavigationController
    private let baseURL: URL
    private let httpClient: HTTPClient
    
    init(navigationController: UINavigationController,
         baseURL: URL,
         httpClient: HTTPClient) {
        self.navigationController = navigationController
        self.baseURL = baseURL
        self.httpClient = httpClient
    }
    
    func start() {
        navigationController.setViewControllers([createSearchScreen()], animated: false)
    }
    
    private func show(screen: UIViewController) {
        self.navigationController.pushViewController(screen, animated: true)
    }
    
    private func present(screen: UIViewController) {
        self.navigationController.showDetailViewController(screen, sender: self)
    }
    
    private func createSearchScreen() -> UIViewController {
        var searchSourceDelegate: GeneralSearchSourceDelegate?
        let typeaheadSearch = createTypeaheadSearch { selectedTerm in
            searchSourceDelegate?.didUpdateSearchTerm(selectedTerm)
        }
        let (generalSearch, generalSearchSourceDelegate) = createGeneralSearch(typeaheadController: typeaheadSearch)
        searchSourceDelegate = generalSearchSourceDelegate
        return generalSearch
    }
    
    private func createGeneralSearch(typeaheadController: GeneralSearchUIComposer.SearchResultController) -> (UIViewController, GeneralSearchSourceDelegate) {
        let service = GeneralSearchService(baseURL: baseURL, httpClient: httpClient)
        let (generalSearch, generalSearchSourceDelegate) = GeneralSearchUIComposer.searchComposedWith(
            searchResultController: typeaheadController,
            searchLoader: service.makeRemoteGeneralSearchLoader,
            onEpisodeSelect: { _ in },
            onPodcastSelect: { _ in }
        )
        return (generalSearch, generalSearchSourceDelegate)
    }
    
    private func createTypeaheadSearch(onTermSelect: @escaping (String) -> Void) -> TypeaheadListViewController {
        let service = TypeaheadSearchService(baseURL: baseURL, httpClient: httpClient)
        return TypeaheadSearchUIComposer.searchComposedWith(
            searchLoader: service.makeRemoteTypeaheadSearchLoader,
            onTermSelect: onTermSelect
        )
    }
}
