// Copyright © 2023 Almost Engineer. All rights reserved.

import SwiftUI
import SearchContentModule

struct GeneralSearchView: View {
    
    private enum Defaults {
        static let space = 16.0
    }
    
    @ObservedObject var store: GeneralSearchViewStore
    
    var columns: [GridItem] = [
        .init(.flexible(minimum: 100, maximum: .infinity), spacing: Defaults.space, alignment: .leading),
        .init(.flexible(minimum: 100, maximum: .infinity), spacing: Defaults.space, alignment: .leading)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: Defaults.space) {
                ForEach(store.episodes, id: \.title) { episode in
                    EpisodeCellView(model: episode)
                }
            }
            .padding(
                EdgeInsets(
                    top: 0,
                    leading: Defaults.space,
                    bottom: 0,
                    trailing: Defaults.space
                )
            )
        }
    }
}
//
//struct GeneralSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        //        GeneralSearchView(store: GeneralSearchViewStore()
//        Text()
//    }
//}
