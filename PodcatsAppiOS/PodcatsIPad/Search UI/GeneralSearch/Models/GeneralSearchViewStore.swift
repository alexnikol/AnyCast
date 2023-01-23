// Copyright © 2023 Almost Engineer. All rights reserved.

import SwiftUI
import Combine
import SearchContentModule

final class GeneralSearchViewStore: ObservableObject {
    private var store = Set<AnyCancellable>()
    private let searchLoader: (String) -> AnyPublisher<GeneralSearchContentResult, Error>
    private let onEpisodeSelect: (SearchResultEpisode) -> Void
    private let onPodcastSelect: (SearchResultPodcast) -> Void
    private let presenter: GeneralSearchContentPresenter
    @Published private(set) var episodes: [SearchResultEpisodeViewModel] = []
    
    init(presenter: GeneralSearchContentPresenter,
         searchLoader: @escaping (String) -> AnyPublisher<GeneralSearchContentResult, Error>,
         onEpisodeSelect: @escaping (SearchResultEpisode) -> Void,
         onPodcastSelect: @escaping (SearchResultPodcast) -> Void) {
        self.presenter = presenter
        self.searchLoader = searchLoader
        self.onEpisodeSelect = onEpisodeSelect
        self.onPodcastSelect = onPodcastSelect
    }
    
    private func runSearch(_ searchText: String) {
        searchLoader(searchText)
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] result in
                    guard let self else { return }
                    
                    let searchViewModel = self.presenter.map(result)
                    self.episodes = searchViewModel.episodes.map { self.presenter.map($0) }
                }
            ).store(in: &store)
    }
}

extension GeneralSearchViewStore: GeneralSearchSourceDelegate {
    
    func didUpdateSearchTerm(_ term: String) {
        runSearch(term)
    }
}
