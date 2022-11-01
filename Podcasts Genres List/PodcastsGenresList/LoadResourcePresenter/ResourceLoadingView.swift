// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct ResourceLoadingViewModel {
    public let isLoading: Bool
}

public protocol ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel)
}
