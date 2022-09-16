// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol GenresLoadingView {
    func display(_ viewModel: GenresLoadingViewModel)
}

public struct GenresLoadingViewModel {
    public let isLoading: Bool
    
    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }
}
