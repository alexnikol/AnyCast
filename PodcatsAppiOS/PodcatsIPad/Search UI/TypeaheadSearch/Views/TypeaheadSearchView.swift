// Copyright © 2023 Almost Engineer. All rights reserved.

import SwiftUI
import Combine
import SearchContentModule

struct TypeaheadSearchView: View {
    @ObservedObject var viewStore: TypeaheadSearchViewStore
    @State var searchText: String = ""
    
    var body: some View {
        List {
            ForEach(viewStore.searchList, id: \.self) { item in
                Text(item)
                    .onTapGesture {
                        viewStore.selectCell(item)
                    }
            }
        }
        .searchable(
            text: $searchText,
            placement: .toolbar,
            prompt: "Search"
        )
        .searchSuggestions(.visible, for: .menu)
        .onChange(of: searchText, perform: { _ in
            viewStore.runSearch(searchText)
        })
    }
}

struct TypeaheadSearchView_Previews: PreviewProvider {
    static var previews: some View {
        let result = TypeaheadSearchContentResult(terms: ["Term 1", "Term 2"], genres: [], podcasts: [])
        let viewStore = TypeaheadSearchViewStore(
            searchLoader: { _ in Just(result) .setFailureType(to: Error.self).eraseToAnyPublisher() },
            onTermSelect: { _ in }
        )
        NavigationView {
            TypeaheadSearchView(viewStore: viewStore)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
