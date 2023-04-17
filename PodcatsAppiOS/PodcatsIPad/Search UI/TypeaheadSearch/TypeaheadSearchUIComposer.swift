// Copyright © 2023 Almost Engineer. All rights reserved.

import SearchContentModule
import SwiftUI
import Combine

public enum TypeaheadSearchUIComposer {
    
    static func typeheadSearchComposedWith(
        searchLoader: @escaping (String) -> AnyPublisher<TypeaheadSearchContentResult, Error>,
        onTermSelect: @escaping (String) -> Void
    ) -> some View {
        let viewStore = TypeaheadSearchViewStore(
            searchLoader: searchLoader,
            onTermSelect: onTermSelect
        )
        return TypeaheadSearchView(viewStore: viewStore)
    }
}
