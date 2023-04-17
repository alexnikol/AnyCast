// Copyright © 2023 Almost Engineer. All rights reserved.

import SwiftUI
import Combine

struct GenresListView: View {
    
    private enum Defaults {
        static let space = 16.0
    }
    
    @ObservedObject var viewModel: GenresListViewModel
    @State var pushed = false
    
    private var columns: [GridItem] = [
        .init(.flexible(minimum: 100, maximum: .infinity), spacing: Defaults.space, alignment: .center),
        .init(.flexible(minimum: 100, maximum: .infinity), spacing: Defaults.space, alignment: .center)
    ]
    
    var body: some View {
        ScrollView {
            if viewModel.isRefreshing {
                ProgressView()
                    .frame(width: 50.0, height: 50.0)
            }
            LazyVGrid(columns: columns) {
                ForEach(viewModel.genres) { genreModel in
                    GenreCellView(model: genreModel)
                        .frame(height: 100)
                        .padding(
                            EdgeInsets(
                                top: 0,
                                leading: 0,
                                bottom: Defaults.space,
                                trailing: 0
                            )
                        ).onTapGesture {
                            genreModel.onSelect()
                        }
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
        .onLoad {
            viewModel.load()
        }
    }
    
    init(viewModel: GenresListViewModel) {
        self.viewModel = viewModel
    }
}

struct GenresListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GenresListView(viewModel: GenresListViewModel(loader: {
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }, selection: { _ in }, colorProvider: GenresUIComposer.makeGenresColorProvider()))
            .preferredColorScheme(.light)
            
            GenresListView(viewModel: GenresListViewModel(loader: {
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }, selection: { _ in }, colorProvider: GenresUIComposer.makeGenresColorProvider()))
            .preferredColorScheme(.dark)
        }
    }
}
