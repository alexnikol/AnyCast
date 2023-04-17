// Copyright © 2023 Almost Engineer. All rights reserved.

import SearchContentModule
import SwiftUI
import Combine

public protocol GeneralSearchSourceDelegate {
    func didUpdateSearchTerm(_ term: String)
}

public enum GeneralSearchUIComposer {
    
    static func generalSearchComposedWith(
        searchLoader: @escaping (String) -> AnyPublisher<GeneralSearchContentResult, Error>,
        onEpisodeSelect: @escaping (SearchResultEpisode) -> Void,
        onPodcastSelect: @escaping (SearchResultPodcast) -> Void
    ) -> (view: some View, sourceDelegate: GeneralSearchSourceDelegate) {
        let presetnter = GeneralSearchContentPresenter()
        let store = GeneralSearchViewStore(
            presenter: presetnter,
            searchLoader: searchLoader,
            onEpisodeSelect: onEpisodeSelect,
            onPodcastSelect: onPodcastSelect
        )
        return (GeneralSearchView(store: store).navigationTitle("Search result"), store)
    }
}
