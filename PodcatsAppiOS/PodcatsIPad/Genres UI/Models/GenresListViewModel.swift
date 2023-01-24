// Copyright © 2023 Almost Engineer. All rights reserved.

import SwiftUI
import Combine
import PodcastsGenresList

final class GenresListViewModel: ObservableObject {
    private let loader: () -> AnyPublisher<[Genre], Error>
    private var store = Set<AnyCancellable>()
    private let colorProvider: GenresActiveColorProvider<Color>
    private let selection: (Genre) -> Void
    @Published private(set) var isRefreshing = false
    @Published private(set) var genres: [GenreCellViewData] = []
    
    func load() {
        isRefreshing = true
        loader()
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.isRefreshing = false
                },
                receiveValue: { [weak self] genres in
                    guard let self else { return }
                    
                    self.genres = genres.enumerated().map { index, genre in
                        GenreCellViewData(
                            id: .init(),
                            name: genre.name,
                            color: self.associatedColorByIndex(index),
                            onSelect: { [weak self] in
                                self?.selection(genre)
                            }
                        )
                    }
                }
            )
            .store(in: &store)
    }
    
    init(loader: @escaping () -> AnyPublisher<[Genre], Error>,
        selection: @escaping (Genre) -> Void,
        colorProvider: GenresActiveColorProvider<Color>) {
        self.loader = loader
        self.colorProvider = colorProvider
        self.selection = selection
    }
    
    private func associatedColorByIndex(_ index: Int) -> Color {
        let defaultColor = Color.white
        return (try? colorProvider.getColor(by: index)) ?? defaultColor
    }
}
