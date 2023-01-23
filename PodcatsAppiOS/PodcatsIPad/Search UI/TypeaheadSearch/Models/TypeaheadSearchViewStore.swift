// Copyright © 2023 Almost Engineer. All rights reserved.

import SwiftUI
import Combine
import SearchContentModule

typealias TypeaheadSearchViewModel = String

final class TypeaheadSearchViewStore: ObservableObject {
    private var store = Set<AnyCancellable>()
    private let searchLoader: (String) -> AnyPublisher<TypeaheadSearchContentResult, Error>
    private let onTermSelect: (String) -> Void
    @Published private(set) var searchList: [TypeaheadSearchViewModel] = []
    
    init(searchLoader: @escaping (String) -> AnyPublisher<TypeaheadSearchContentResult, Error>,
         onTermSelect: @escaping (String) -> Void) {
        self.searchLoader = searchLoader
        self.onTermSelect = onTermSelect
    }
    
    func runSearch(_ searchText: String) {
        searchLoader(searchText)
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { result in
                    self.searchList = result.terms
                }
            ).store(in: &store)
    }
    
    func selectCell(_ searchItem: TypeaheadSearchViewModel) {
        onTermSelect(searchItem)
    }
}
