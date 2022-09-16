// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol GenresView {
    func display(_ viewModel: GenresViewModel)
}


public struct GenresViewModel: Hashable {
    public let genres: [Genre]
    
    public init(genres: [Genre]) {
        self.genres = genres
    }
}
